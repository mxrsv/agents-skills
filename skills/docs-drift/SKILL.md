---
name: docs-drift
description: Cross-check the living docs against the real code to find places where the docs describe behavior the code does not have. Default is a READ-ONLY scan that writes no file. With --apply, fix verified in-scope drift without a separate diff-approval round.
disable-model-invocation: true
---

# docs-drift — audit the docs against the code

## Two modes, strictly separated

| Command               | Permissions                                                                                                                   |
| --------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| `/docs-drift`         | **ABSOLUTELY READ-ONLY.** Writes no file, not even the ledger. Prints the report to the screen.                               |
| `/docs-drift --apply` | Returns the ledger in chat and fixes/deletes verified in-scope drift. Routine corrections need no separate approval; material decisions follow D10. Staging and committing follow the task's authorization. |

The default is scan. Switch to apply only when the user explicitly types `--apply`.

Before writing anything in apply mode: run `git status --porcelain` and report if the worktree is dirty — the reviewer needs to tell which diff is the skill's and which was already there.

## Step 0 — run tier 1 first

`bash ~/.claude/scripts/docs-anchors.sh <doc-root>` to get the list of dead anchors. Those are certain drift, no need to re-verify.

## Step 1 — extract claims

Living docs = `AGENTS.md`, `README.md`, `CHANGELOG.md` at the root + `docs/README.md`, `docs/DESIGN-LANGUAGE.md`, every file under `docs/{user,internals,operations}/` (+ legacy UPPERCASE `docs/*.md` not yet cleaned up: `ARCHITECTURE.md`, `CONTEXT.md`, `PRD.md`…). Do NOT treat `docs/specs/` or `docs/plans/` as living docs: active specs record approved requirements; linked plans are checked against them and code during plan review. Completed records are frozen history (D1/D7). Retired `review/` and `mockups/` also remain outside this scan.

Living docs carry no intent labels (D6): every behavior claim describes current behavior and is audited. Planned work lives in `docs/plans/`, not in living docs; a passage that marks itself net-new or a gap is drift to fix or delete, not backlog.

## Step 2 — verify with code, not with other docs

1. `grep` / `glob` in the source directories.
2. Run the related tests.
3. `git log --all -S'<symbol>' -- ':!docs/'` when you need to know whether the symbol ever existed.

⚠️ **`-S` also matches its own audit output — `-- ':!docs/'` is MANDATORY.** Without excluding `docs/`, a `not-in-history` result flips after the audit is committed.

## Step 3 — classify

`shipped` · `partial` · `not-in-history` · `removed` · `contradicted` · `unknown`.

- `partial` must state which part exists and which does not — do NOT collapse it into "exists".
- Before concluding `not-in-history`: run `git rev-parse --is-shallow-repository` and look for squash merges. Shallow or squash present → downgrade to `unknown` with the reason. `-S` only proves "not seen in reachable history".

## Hard constraints

- Do NOT edit product code.
- Scan mode: write NO file.
- Apply mode: return the ledger in chat and fix verified drift within the task's scope (D7: fix or delete in place, do NOT add a "Chưa khớp thực tế" table). Report out-of-scope findings without editing them (W3); resolve material decisions under D10 before dependent changes.
- Do NOT infer from doc to doc. Every conclusion must point back to a `file:line` or a git command with output.
- Cannot verify → `unknown` with the reason. Do NOT guess.
- Staging and committing follow the task's authorization.

## Output with `--apply`

1. Return the ledger in chat: claim, source doc, status, evidence and HEAD sha at audit time. Do not require an issue id, post externally or write a report file.
2. Drifted passages in the living docs: rewrite verified claims correctly, or delete stale passages within scope (D1, D7). Routine corrections need no separate diff approval.
3. A list of items needing a human decision, ordered by the risk of leaving them as is; each item is one line in the report. Keep follow-up decisions in chat; do not auto-file them.
