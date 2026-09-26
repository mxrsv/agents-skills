---
name: docs-drift
description: Cross-check the living docs against the real code to find places where the docs describe behavior the code does not have. Default is a READ-ONLY scan that writes no file. Writes only when run with --apply and after the user approves the diff. Fires ONLY when the user types /docs-drift.
---

# docs-drift — audit the docs against the code

## Two modes, strictly separated

| Command               | Permissions                                                                                                                   |
| --------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| `/docs-drift`         | **ABSOLUTELY READ-ONLY.** Writes no file, not even the ledger. Prints the report to the screen.                               |
| `/docs-drift --apply` | Returns the ledger in chat and fixes/deletes the approved drifted doc passages. Presents the **diff** to the user for approval first. **No** `git add`, **no** `git commit`. |

The default is scan. Switch to apply only when the user explicitly types `--apply`.

Before writing anything in apply mode: run `git status --porcelain` and report if the worktree is dirty — the reviewer needs to tell which diff is the skill's and which was already there.

## Step 0 — run tier 1 first

`bash ~/.claude/scripts/docs-anchors.sh <doc-root>` to get the list of dead anchors. Those are certain drift, no need to re-verify.

## Step 1 — extract claims

Living docs = `AGENTS.md`, `README.md`, `CHANGELOG.md` at the root + `docs/README.md`, `docs/DESIGN-LANGUAGE.md`, every file under `docs/{user,internals,operations}/` (+ legacy UPPERCASE `docs/*.md` not yet cleaned up: `ARCHITECTURE.md`, `CONTEXT.md`, `PRD.md`…). Do NOT treat `docs/plans/` as living docs: active plans are checked against approved requirements and code during plan review; completed plans are frozen history (D1/D7). Retired `specs/`, `review/`, `mockups/` remain outside this scan.

Living docs carry no intent labels (D6): every behavior claim describes current behavior and is audited. Planned work lives in `docs/plans/`, not in living docs; a passage that marks itself net-new or a gap is drift to fix or delete, not backlog.

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
- Apply mode: return the ledger in chat and fix exactly the approved drifted doc passages (D7: fix or delete in place, do NOT add a "Chưa khớp thực tế" table). Edits outside those passages need a separate question.
- Do NOT infer from doc to doc. Every conclusion must point back to a `file:line` or a git command with output.
- Cannot verify → `unknown` with the reason. Do NOT guess.
- NO `git add`, NO `git commit` (D14).

## Output with `--apply`

1. Return the ledger in chat: claim, source doc, status, evidence and HEAD sha at audit time. Do not require an issue id, post externally or write a report file.
2. Drifted passages in the living docs: rewrite them correctly, or delete them — **after the diff is approved** (D1, D7).
3. A list of items needing a human decision, ordered by the risk of leaving them as is; each item is one line in the report. Keep follow-up decisions in chat; do not auto-file them.
