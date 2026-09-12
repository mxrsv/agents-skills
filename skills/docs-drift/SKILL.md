---
name: docs-drift
description: Cross-check the living docs against the real code to find places where the docs describe behavior the code does not have. Default is a READ-ONLY scan that writes no file. Writes only when run with --apply and after the user approves the diff. Fires ONLY when the user types /docs-drift.
---

# docs-drift — audit the docs against the code

## Two modes, strictly separated

| Command               | Permissions                                                                                                                   |
| --------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| `/docs-drift`         | **ABSOLUTELY READ-ONLY.** Writes no file, not even the ledger. Prints the report to the screen.                               |
| `/docs-drift --apply` | Posts the ledger as a comment on the Linear issue (or creates a new issue) + fixes/deletes the drifted doc passages. Presents the **diff** to the user for approval first. **No** `git add`, **no** `git commit`. |

The default is scan. Switch to apply only when the user explicitly types `--apply`.

Before writing anything in apply mode: run `git status --porcelain` and report if the worktree is dirty — the reviewer needs to tell which diff is the skill's and which was already there.

## Step 0 — run tier 1 first

`bash ~/.claude/scripts/docs-anchors.sh <doc-root>` to get the list of dead anchors. Those are certain drift, no need to re-verify.

## Step 1 — extract claims with their intent

Living docs = `AGENTS.md`, `README.md`, `CHANGELOG.md` at the root + `docs/README.md`, `docs/DESIGN-LANGUAGE.md`, every file under `docs/{user,internals,operations}/` (+ legacy UPPERCASE `docs/*.md` not yet cleaned up: `ARCHITECTURE.md`, `CONTEXT.md`, `PRD.md`…). Do NOT touch `specs/`, `plans/`, `review/`, `mockups/` — frozen legacy awaiting cleanup; work in progress is the Linear issue.

Each claim has an **intent** (backticked label after the anchor; missing label → default `current`):

| Label        | Meaning                              |
| ------------ | ------------------------------------ |
| `current`    | describes the current state          |
| `decided`    | decided, not started                 |
| `building`   | in progress                          |
| `deprecated` | removed, kept for reference          |

**Audit ONLY `current` claims.** A `decided`/`building` claim the code does not have yet is **legitimate backlog** — do NOT mark it as drift, do NOT put it in a "Chưa khớp thực tế" table. Skip passages that mark themselves "net-new / gap" as well.

## Step 2 — verify with code, not with other docs

1. `grep` / `glob` in the source directories.
2. Run the related tests.
3. `git log --all -S'<symbol>' -- ':!docs/'` when you need to know whether the symbol ever existed.

⚠️ **`-S` poisons itself — `-- ':!docs/'` is MANDATORY.** A previous audit recorded `git log --all -S'FileSidebar'` → 0 commits; rerun afterwards → 1 commit, the very commit containing the audit. Without excluding `docs/`, every `not-in-history` conclusion breaks itself after the first run.

## Step 3 — classify

`shipped` · `partial` · `not-in-history` · `removed` · `contradicted` · `unknown`.

- `partial` must state which part exists and which does not — do NOT collapse it into "exists".
- Before concluding `not-in-history`: run `git rev-parse --is-shallow-repository` and look for squash merges. Shallow or squash present → downgrade to `unknown` with the reason. `-S` only proves "not seen in reachable history".

## Hard constraints

- Do NOT edit product code.
- Scan mode: write NO file.
- Apply mode: only post the ledger to Linear + fix exactly the approved drifted doc passages (D7: fix or delete in place, do NOT add a "Chưa khớp thực tế" table). Edits outside those passages need a separate question.
- Do NOT infer from doc to doc. Every conclusion must point back to a `file:line` or a git command with output.
- Cannot verify → `unknown` with the reason. Do NOT guess.
- NO `git add`, NO `git commit` (D14).

## Output with `--apply`

1. Ledger — a `save_comment { issueId }` comment on the issue being worked (none → ask; if the user allows, `save_issue { team, title: "docs drift <repo> @<sha7>" }` then comment there): claim, source doc, intent, status, evidence, HEAD sha at audit time. No Linear MCP → print the ledger to chat, write no file.
2. Drifted passages in the living docs: rewrite them correctly, or delete them — **after the diff is approved** (D1, D7).
3. A list of items needing a human decision, ordered by the risk of leaving them as is; each item is one line in the comment, the user splits out issues if they want.
