---
name: log-wiki
description: Capture knowledge into the Tolaria wiki from the lastLoggedAt mark — cook memory prompts (Claude/Codex/Cursor + git), ask the narrator, draft the entry, get approval, then write via record-capture.js. Use when the user says "log-wiki", "ghi wiki", "capture wiki", "tổng kết knowledge wiki", or invokes /log-wiki.
---

# Log wiki — capture knowledge into the vault

This is a HUMAN-IN-THE-LOOP process, not a one-shot script that emits a result.
**The machine does NOT generate lessons / knowledge on its own and write them.** Memory prompts are only prompts —
the entry content MUST come from the writer's own account; the agent only reshapes that account; the writer
MUST approve before anything is written to the vault.

Complements, does not replace, `/activity` (log-day): `/activity` = lessons about how work went;
`log-wiki` = knowledge vault (facts, decisions, notes found wrong/missing, open questions).

## Hard warnings

- An empty/thin collect **≠** nothing to tell — still ask the writer.
- Do **not** use `/insights` or `usage-data` (frozen).
- Complements `/activity`, does not replace it; do not re-ask the log-day style "what did you struggle with today" angle.
- Do **not** patch the target Tolaria note yourself — only suggest `[[note]]`; after approval,
  `record-capture.js` appends the monthly note + updates `lastLoggedAt`.
- Do **not** dump secrets, full prompts, tool stdout, or sensitive transcript content.

## Codex / Cursor

- The skill source is `~/.claude/skills/log-wiki/` (git); `~/.agents/skills/log-wiki` is a symlink
  to it, so Claude Code, Codex and Cursor read the same copy. Codex invokes it as `$log-wiki`.
- `~/.codex/AGENTS.md` is a generated file — do not edit it by hand. Edit the source in
  `~/.claude/CLAUDE.md` / `~/.claude/templates/codex-extra.md`, then run
  `~/.claude/scripts/render-agent-rules.sh` to sync. If not synced yet:
  rely on the Cursor Automation (gap reminder) + invoke this skill manually.

## Step 1 — Resolve the vault

1. If the `WIKI_VAULT` environment variable is set and is an existing absolute path → use it.
2. Otherwise fall back to:
   `/Users/kyantran/Documents/Development/Vault/mxrsv-wiki`
   and **warn** that the fallback is in use.
3. Every `node scripts/log-wiki/...` command runs from that vault root.

## Step 2 — Read the `lastLoggedAt` mark

Read the frontmatter of `wiki-capture-state.md` at the vault root.

- `lastLoggedAt` present as a local `YYYY-MM-DD` → that is `from` (start of the local day →
  bound datetime when collecting; the script handles the conversion if implemented).
- **Missing** → ask the writer for the initial mark once (e.g. today, or the date they want
  capture to start from). Do not derive `from` from the note's `git log` alone.

## Step 3 — Cook the memory prompts

```bash
node scripts/log-wiki/collect.js --from=<ISO-or-date> [--to=<ISO>] [--repo=<path>]*
```

- Half-open range `[from, to)`; `to` defaults to now if the script supports it.
- Stdout is JSON: `from`, `to`, `sessions[]`, `repos[]`, `gitByRepo`, `coverage`.
- Do **not** print / paste the raw JSON, which may contain sensitive prompts, into a long chat.
  Summarize the structure only: coverage per source, orphan count, a few repos + git headlines.

## Step 4 — Explain in the active Output Style's language, then ASK

A short summary (a few sentences): time range, Claude/Codex/Cursor sessions (counts),
repos + notable commits. Mention if the collect is thin/empty.

Then ask from the **knowledge wiki** angle, along the lines of:

> "Từ lần capture trước tới giờ, có knowledge nào đáng ghi vào wiki không —
> fact mới, quyết định, chỗ note đang sai/thiếu, câu hỏi còn mở?"

**Wait for the writer's answer.** Do not invent lessons from the transcript.

## Step 5 — Draft

From the writer's account (adding concrete details from the memory prompts if they speak in general terms), draft:

- **headline**: one sentence for the capture period, in the active Output Style's language.
- **3–8 bullets** in the active Output Style's language.
- **Suggested** related `[[note]]` (if any) — suggestion only, do not edit that file.

Show the draft to the writer. **Do not write any file at this step.**

## Step 6 — Ask for explicit approval

Ask: "Ghi vậy được không, hay sửa gì?" Proceed only on an explicit confirmation
(such as "được", "ghi đi", "ok").

## Step 7 — Write via `record-capture.js`

Pipe JSON in exactly the shape the script expects (see the usage / tests of
`scripts/log-wiki/record-capture.js`) — at minimum the time range, headline,
bullets, suggestions. In spirit:

```bash
echo '<JSON>' | node scripts/log-wiki/record-capture.js
```

- The skill does **not** hand-edit `lastLoggedAt` or append the monthly note by hand.
- The script appends `wiki-capture-YYYY-MM.md` + updates the state.

Report the files touched and the new `lastLoggedAt` when the script succeeds.

## Errors / common situations

- `collect.js` / `record-capture.js` missing → stop, say the scripts are not there yet (another agent
  is on it); you can still ask the narrator and keep the draft pending.
- `lastLoggedAt` missing → ask for the initial mark, do not guess silently.
- Empty collect → still ask; the writer's memory is the entry's source of truth.
