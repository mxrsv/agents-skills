---
name: skill-candidates
description: Find work that recurs ACROSS Claude Code sessions — repeated command sequences, repeated requests — and propose it as a new skill or as an edit to an existing one. Use when the owner asks for skill ideas or "skill candidates", or when the SessionStart reminder says the scan is due. Not for repeats inside one session (W15 handles those inline) and not for creating the skill (that needs approval).
argument-hint: "[--days 14] [--min-sessions 3] [--project <substr>]"
---

# Skill candidates — what keeps coming back?

W15 sees one session. The procedures worth a skill recur across sessions, days apart, and no
single session can see that. This skill reads the transcripts and finds them.

Transcripts hold secrets, private paths and client text. The report stays in chat: quote at most
one line from any transcript, never write the output into a repo — `~/.claude` is public.

## 1. Scan

```bash
node ~/.claude/skills/skill-candidates/scripts/scan-transcripts.mjs $ARGUMENTS
```

It prints three lists, each row counted in distinct sessions with example session ids:

- **Recurring command sequences:** three consecutive Bash command shapes (`git fetch → git
  rev-list → git push`). Read-only and shell-syntax noise is already dropped.
- **Recurring requests:** the owner's prompts, normalized. Variants of one ask ("commit push
  đi", "commit push now") land on separate rows — merge them yourself.
- **Skills and slash commands used:** what already gets invoked, so a candidate that an unused
  skill already covers shows up as a trigger problem, not a missing skill.

Headless `claude -p` / SDK sessions are skipped; `--headless yes` includes them.

## 2. Confirm

A count is a lead, not a finding. For each row you would act on, open one or two of the cited
sessions (`ls ~/.claude/projects/*/<id>*.jsonl`, then `grep` for the commands or the prompt)
and check it is the same procedure with the same goal. Label each candidate `verified` (you read
it in at least two sessions) or `inferred` (count only). Drop rows that are coincidence, such as
a lint → typecheck → test run that every code change does.

## 3. Check what exists

List `~/.claude/skills/`, the project's `.claude/skills/`, and plugin skills. If a skill already
covers the candidate, propose the edit that would have made it fire — usually the description's
"Use when" wording or a trigger line in the project's `AGENTS.md` — instead of a new skill.
Also prefer a script, alias, hook or one rule line when it does the job with no judgment step.

## 4. Propose

At most five, ranked by sessions × steps saved. One line each, then its evidence:

`💡 <name> — <trigger> → <what it saves>` · scope `project` (`<repo>/.claude/skills/`) or
`global` (`~/.claude/skills/`, then `scripts/sync-agents-skills.sh`) · sessions, projects, label.

Create nothing. The owner picks; building a skill is a separate, approved task.

## 5. Record the run

```bash
mkdir -p ~/.claude/state && touch ~/.claude/state/skill-candidates-last-run
```

The SessionStart reminder reads that file's age. End the report with `Not checked:` (sessions
that failed to parse, projects filtered out) and `Skill gaps:` (edits this skill needs; suggest
only).
