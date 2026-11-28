---
paths:
  - "docs/**"
  - "**/AGENTS.md"
  - "**/README.md"
  - "**/CHANGELOG.md"
---

# Docs and specifications

## Specs, no plans

- The conversation is where the user sets goals and approves decisions. A newer user decision updates the owning spec.
- Specs in `docs/specs/` own requirements, scope, product and design decisions, acceptance criteria and a short `## Status` (done, remaining, checkout/branch/PR, checks run with results, blockers).
- No plan files (2026-11-28: owner decision). The technical approach lives in plan mode or the chat; verification evidence goes in the report, PR or commit.
- Small, clear work can stay in the conversation. Use an external tracker only when the user explicitly asks for it in that task.
- Create a spec when explicitly requested or under the workflow rule for specs.
- Keep one canonical spec per scope: no duplicate specs, checkpoints, daily logs or journals.
- Legacy plans in `docs/plans/` stay in git as historical records; an active one moves its status into the spec's `## Status` on the next touch and is marked historical.

## Living documentation and task history

- Living docs are `AGENTS.md`, `README.md` and `CHANGELOG.md` at the root, `docs/README.md`, `docs/DESIGN-LANGUAGE.md`, and every file under `docs/{user,internals,operations}/`. Rewrite or delete outdated passages in place.
- Specs are design records, not claims of shipped behavior: update active specs in place across sessions and PRs.
- After acceptance criteria and required approvals are met, freeze the spec: completion date and implementation commits or PR links in `## Status`. Freeze earlier only when it is explicitly superseded.
- Keep finished specs in git; do not delete them in the closing PR or maintain them as descriptions of current behavior. Extract durable knowledge into living docs.
- Raw logs, experiments and intermediate artifacts stay in the scratchpad.
- A repo with `PIPELINE.lock` follows that pipeline's convention, which replaces the directory, naming and spec rules here; it still needs `AGENTS.md`. A pipeline does not imply permission to use external services.

## Location and naming

- Valid `docs/` subdirectories: `user/` (using the product), `internals/` (architecture, constraints and traps), `operations/` (maintainer runbooks), and `specs/` (requirements, acceptance criteria and status). `plans/` holds legacy records only; create no new files there.
- The only root-level `.md` files in `docs/` are `README.md` and, when applicable, `DESIGN-LANGUAGE.md`. Add living docs only when the reader would otherwise get something wrong.
- Another directory → ask. Do not create `docs/review/`, `docs/superpowers/` or `.planning/`.
- New specs start from `~/.claude/templates/spec.template.md`; delete sections that do not apply instead of leaving them empty.
- Use `docs/specs/YYYY-MM-DD-<slug>.md`, dated when the spec starts; keep the path when resuming. Search `docs/specs/` and legacy `docs/plans/` first and update the owning record.
- Specs use English body and headings, independent of the reply language.
- Reviews are returned in chat by default, or posted to a specific PR when requested; do not auto-create report files or post externally.
- Record actionable review outcomes in the owning spec when revisions are authorized, without turning a read-only review into an edit. Evidence files stay in the scratchpad or a user-requested destination.
- Cross-repo work uses one owning spec with explicit repo and checkout paths in `## Status`, unless the user asks for separate specs.
- Owner eye approval goes in one final step, never between steps; the only earlier stops are picking a mock direction before code and a dev-switch cut-over (skill `kyant-ui-rules`).
- End every new spec with a ready-to-paste `/goal` line built from its acceptance criteria.

## AGENTS.md and CLAUDE.md

- Every repo needs `AGENTS.md`. Claude Code (v2.1.277+) and Codex/Cursor read it directly, so do not add a `CLAUDE.md` that only imports it.
- Add `CLAUDE.md` only for Claude-specific rules; it then takes precedence and `AGENTS.md` is skipped unless it starts with `@AGENTS.md`. A `CLAUDE.md` in a parent directory also hides `AGENTS.md`.
- Architecture and constraints belong in `docs/internals/` (entry: `docs/internals/overview.md`). Task progress belongs in the spec's `## Status`, not a separate architecture or context journal.

## Preventing drift

- Fix in-scope drift in living docs when found; raise out-of-scope findings in conversation with `file:line` evidence, without filing an external issue.
- Active specs reflect approved requirements and, in `## Status`, actual progress. Planned work is not a claim of current behavior.
- Frozen specs and legacy plans are excluded from current-code drift maintenance. Do not keep a drift backlog inside living docs.
- Removing or renaming a module or feature updates its living-doc anchors in the same task.
- Architectural decisions, cross-module constraints and traps go in `docs/internals/`; usage changes in `docs/user/`; runbook changes in `docs/operations/`.
- Write only what a reader would otherwise get wrong: no file catalogs, control-flow retellings or duplicate PR summaries.

## Approval and completion

- Ask for approval only when requirements are unclear in a way that leads to materially different, hard-to-reverse outcomes, or before an irreversible or outward-facing action; otherwise pick the recommended option, state it and continue.
- Decisions already made in the conversation count; do not ask for duplicate approval because they were written into a spec.
- When the approach is hard to undo, present it before implementation unless it is already approved. Routine in-scope implementation choices stay the agent's call.
- A change in public behavior (API, CLI, UI flow) updates the existing `README.md` and `CHANGELOG.md` where relevant.
- Use absolute dates `YYYY-MM-DD`, not relative dates.

## While editing docs

- Link checks, duplicate checks, doc language and the writing checklist live in [living-docs.md](../docs/living-docs.md).
