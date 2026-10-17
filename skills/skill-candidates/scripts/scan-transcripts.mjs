#!/usr/bin/env node
// Scan Claude Code transcripts for work that recurs ACROSS sessions — the evidence behind a skill
// candidate. Reads ~/.claude/projects/*/*.jsonl (top-level sessions only; subagent transcripts
// live in <session>/subagents/ and are skipped). Prints a report; writes nothing.
// Headless runs (`claude -p`, SDK: entrypoint sdk-*) are evals and pipelines, not the owner's work;
// they are skipped unless --headless yes.
// Usage: node scan-transcripts.mjs [--days 14] [--min-sessions 3] [--project <substr>] [--top 15] [--headless yes]
import { createReadStream, readdirSync, statSync } from "node:fs";
import { createInterface } from "node:readline";
import { homedir } from "node:os";
import { basename, join } from "node:path";

const DEFAULTS = { days: 14, "min-sessions": 3, project: "", top: 15, headless: "no" };
const ROOT = join(homedir(), ".claude", "projects");
const NGRAM = 3;
// Read-only or ubiquitous commands: they appear in every procedure and say nothing about it.
const TRIVIAL = new Set(
  "cd ls cat head tail sed grep rg find echo wc pwd sort uniq jq awk printf true false test [ sleep which stat du diff tr cut xargs mkdir rm cp mv touch date env export set source . git-status git-diff git-log git-show git-rev-parse git-branch git-check-ignore git-ls-files".split(
    " ",
  ),
);
// Shell and script keywords that a multi-line command or a heredoc body leaves behind.
const KEYWORDS = new Set(
  "for do done while until if then else elif fi case esac function break continue return const let var await async import export from def print EOF } { ) (".split(
    " ",
  ),
);
const HEREDOC = /<<-?\s*['"]?(\w+)['"]?[\s\S]*?\n\1(?=\s|$)/g;
// Tools whose first argument names the actual action.
const WITH_SUBCOMMAND = new Set("git gh npm npx pnpm yarn bun node bash sh python3 docker vercel wrangler codex claude supabase".split(" "));

function parseArgs(argv) {
  const opts = { ...DEFAULTS };
  for (let i = 0; i < argv.length; i += 2) {
    const key = argv[i]?.replace(/^--/, "");
    if (!(key in DEFAULTS) || argv[i + 1] === undefined) {
      console.error(`Unknown or incomplete option: ${argv[i]}\nUsage: --days N --min-sessions N --project S --top N`);
      process.exit(2);
    }
    opts[key] = typeof DEFAULTS[key] === "number" ? Number(argv[i + 1]) : argv[i + 1];
    if (Number.isNaN(opts[key])) {
      console.error(`--${key} needs a number`);
      process.exit(2);
    }
  }
  return opts;
}

// "git -C x worktree add ../p -b y" → "git worktree"; "npm run release:cut" → "npm run release:cut"
function commandShape(segment) {
  const tokens = segment
    .trim()
    .replace(/^(\w+=\S*\s+)+/, "")
    .split(/\s+/)
    .filter((t) => t && !t.startsWith("-") && !/^["'$(]/.test(t));
  if (tokens.length === 0) return null;
  const tool = basename(tokens[0]);
  if (KEYWORDS.has(tool) || !/^[a-z][\w.:-]*$/.test(tool)) return null;
  if (!WITH_SUBCOMMAND.has(tool)) return tool;
  const rest = tokens.slice(1).filter((t) => !t.startsWith("<") && !(tool === "git" && t.includes("/")));
  const sub = rest[0] ? basename(rest[0]) : "";
  const third = (tool === "npm" || tool === "pnpm") && sub === "run" && rest[1] ? ` ${rest[1]}` : "";
  return `${tool} ${sub}${third}`.trim();
}

function shapesOf(command) {
  return command
    .replace(HEREDOC, "")
    .split(/&&|\|\||;|\||\n/)
    .map(commandShape)
    .filter((s) => s && !TRIVIAL.has(s.replace(" ", "-")) && !TRIVIAL.has(s));
}

function normalizePrompt(text) {
  return text
    .toLowerCase()
    .replace(/https?:\/\/\S+/g, "<url>")
    .replace(/\S*\/\S+/g, "<path>")
    .replace(/\d+/g, "<n>")
    .replace(/\s+/g, " ")
    .trim()
    .slice(0, 90);
}

function userText(content) {
  if (typeof content === "string") return content;
  if (!Array.isArray(content) || content.some((b) => b.type === "tool_result")) return "";
  return content
    .filter((b) => b.type === "text")
    .map((b) => b.text)
    .join(" ");
}

// Text Claude Code itself puts in the user turn: compaction summaries, interrupts.
const SYNTHETIC_PROMPT = /^(\[request interrupted|this session is being continued|another claude session sent a message)/i;

async function scanSession(file) {
  const session = { cwd: "", entrypoint: "", shapes: [], prompts: new Set(), commands: new Set() };
  const lines = createInterface({ input: createReadStream(file), crlfDelay: Infinity });
  for await (const line of lines) {
    if (!line.includes('"type":"user"') && !line.includes('"type":"assistant"')) continue;
    let entry;
    try {
      entry = JSON.parse(line);
    } catch {
      continue; // a torn last line while a session is still writing
    }
    if (entry.isSidechain) continue;
    session.cwd ||= entry.cwd ?? "";
    session.entrypoint ||= entry.entrypoint ?? "";
    const content = entry.message?.content;
    if (entry.type === "assistant" && Array.isArray(content)) {
      for (const block of content) {
        if (block.type === "tool_use" && block.name === "Bash" && block.input?.command) {
          session.shapes.push(...shapesOf(block.input.command));
        }
        if (block.type === "tool_use" && block.name === "Skill" && block.input?.skill) {
          session.commands.add(`skill:${block.input.skill}`);
        }
      }
    }
    if (entry.type === "user" && !entry.isMeta) {
      const text = userText(content);
      const slash = text.match(/<command-name>\/?([^<]+)<\/command-name>/);
      if (slash) session.commands.add(`/${slash[1]}`);
      else if (text && !text.startsWith("<") && !SYNTHETIC_PROMPT.test(text) && text.split(/\s+/).length >= 3) session.prompts.add(normalizePrompt(text));
    }
  }
  return session;
}

function ngrams(shapes) {
  const compact = shapes.filter((s, i) => s !== shapes[i - 1]);
  const grams = new Set();
  for (let i = 0; i + NGRAM <= compact.length; i++) {
    const gram = compact.slice(i, i + NGRAM);
    if (new Set(gram).size > 1) grams.add(gram.join(" → "));
  }
  return grams;
}

function tally(map, key, sessionId, project) {
  const row = map.get(key) ?? { sessions: new Set(), projects: new Set() };
  row.sessions.add(sessionId);
  row.projects.add(project);
  map.set(key, row);
}

function recentSessionFiles(days, projectFilter) {
  const cutoff = Date.now() - days * 86_400_000;
  const files = [];
  for (const dir of readdirSync(ROOT)) {
    if (projectFilter && !dir.includes(projectFilter)) continue;
    let names;
    try {
      names = readdirSync(join(ROOT, dir));
    } catch {
      continue; // a stray file at the top level
    }
    for (const name of names) {
      const path = join(ROOT, dir, name);
      if (name.endsWith(".jsonl") && statSync(path).mtimeMs >= cutoff) files.push(path);
    }
  }
  return files;
}

function printSection(title, map, min, top, format) {
  const rows = [...map.entries()]
    .filter(([, row]) => row.sessions.size >= min)
    .sort((a, b) => b[1].sessions.size - a[1].sessions.size)
    .slice(0, top);
  console.log(`\n## ${title}${rows.length ? "" : "\n(none)"}`);
  for (const [key, row] of rows) console.log(format(key, row));
}

async function main() {
  const opts = parseArgs(process.argv.slice(2));
  const files = recentSessionFiles(opts.days, opts.project);
  const sequences = new Map();
  const prompts = new Map();
  const commands = new Map();
  let skipped = 0;
  for (const file of files) {
    const id = basename(file, ".jsonl").slice(0, 8);
    const session = await scanSession(file);
    if (opts.headless !== "yes" && session.entrypoint.startsWith("sdk")) {
      skipped += 1;
      continue;
    }
    const project = basename(session.cwd) || "?";
    for (const gram of ngrams(session.shapes)) tally(sequences, gram, id, project);
    for (const prompt of session.prompts) tally(prompts, prompt, id, project);
    for (const command of session.commands) tally(commands, command, id, project);
  }
  const where = (row) => `[${[...row.projects].join(", ")}] e.g. ${[...row.sessions].slice(0, 3).join(" ")}`;
  console.log(`Scanned ${files.length - skipped} sessions (${skipped} headless skipped), last ${opts.days} days, min ${opts["min-sessions"]} sessions per row.`);
  printSection("Recurring command sequences", sequences, opts["min-sessions"], opts.top, (k, r) => `${r.sessions.size}× ${k}  ${where(r)}`);
  printSection("Recurring requests (normalized)", prompts, opts["min-sessions"], opts.top, (k, r) => `${r.sessions.size}× "${k}"  ${where(r)}`);
  printSection("Skills and slash commands used", commands, 1, opts.top * 2, (k, r) => `${r.sessions.size}× ${k}`);
}

main().catch((error) => {
  console.error(`scan-transcripts failed: ${error.message}`);
  process.exit(1);
});
