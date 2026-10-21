#!/usr/bin/env node
// Counts oxlint findings per rule per path group, to choose tiers before enabling rules.
//
//   node probe.mjs --config <oxlintrc> [--oxlint <bin>] [--group name=prefix ...] -- <paths...>
//
// Paths and prefixes are relative to the current directory (the repo root). A finding whose
// file matches no prefix counts under "other". oxlint resolves from the current directory
// unless --oxlint names a binary, so a newer version can be tried from a scratch install.
import { execFileSync } from "node:child_process";
import { createRequire } from "node:module";
import { dirname, join } from "node:path";

function parseArgs(argv) {
  const split = argv.indexOf("--");
  const flags = split === -1 ? argv : argv.slice(0, split);
  const paths = split === -1 ? [] : argv.slice(split + 1);
  const options = { config: undefined, oxlint: undefined, groups: [] };
  for (let i = 0; i < flags.length; i += 2) {
    const [flag, value] = [flags[i], flags[i + 1]];
    if (flag === "--config") options.config = value;
    else if (flag === "--oxlint") options.oxlint = value;
    else if (flag === "--group") {
      const [name, prefix] = value.split("=");
      options.groups.push({ name, prefix });
    } else throw new Error(`unknown flag ${flag}`);
  }
  if (!options.config || paths.length === 0) {
    throw new Error("usage: probe.mjs --config <file> [--group name=prefix] -- <paths...>");
  }
  return { ...options, paths };
}

const { config, oxlint, groups, paths } = parseArgs(process.argv.slice(2));
const binary =
  oxlint ??
  join(
    dirname(createRequire(join(process.cwd(), "noop.js")).resolve("oxlint/package.json")),
    "bin/oxlint",
  );

let stdout;
try {
  stdout = execFileSync(process.execPath, [binary, "-c", config, "-f", "json", ...paths], {
    encoding: "utf8",
    maxBuffer: 256 * 1024 * 1024,
  });
} catch (error) {
  // oxlint exits 1 when it reports errors; the JSON report is complete either way.
  if (!error.stdout) throw error;
  stdout = error.stdout;
}

const { diagnostics } = JSON.parse(stdout);
const groupOf = (file) => groups.find((group) => file.startsWith(group.prefix))?.name ?? "other";
const counts = new Map();
for (const { code, filename, severity } of diagnostics) {
  const key = `${code}\t${groupOf(filename)}\t${severity}`;
  counts.set(key, (counts.get(key) ?? 0) + 1);
}

const rows = [...counts].sort(([a], [b]) => a.localeCompare(b));
console.log("| Rule | Group | Severity | Hits |\n| --- | --- | --- | --- |");
for (const [key, hits] of rows) console.log(`| ${key.split("\t").join(" | ")} | ${hits} |`);
console.log(`\n${diagnostics.length} findings in ${new Set(diagnostics.map((d) => d.filename)).size} files`);
