---
paths:
  - "docs/**"
  - "**/AGENTS.md"
  - "**/README.md"
  - "**/CHANGELOG.md"
---

# Docs, specifications and task plans

## Separate requirements from execution

- The conversation is where the user sets goals and approves decisions. A newer user decision updates the owning document and any affected plan.
- Specs in `docs/specs/` own requirements, scope, product and design decisions, and acceptance criteria.
- Plans in `docs/plans/` own technical approach, tasks, progress, verification evidence and handoff; they link the spec instead of copying its requirements.
- Small, clear work can stay in the conversation. Use an external tracker only when the user explicitly asks for it in that task.
- Create a spec when explicitly requested or when material requirements need a durable record; create a plan only under the workflow rule for plans. Neither requires the other.
- Keep one canonical spec per scope and one execution checklist per task: no duplicate specs, checkpoints, daily logs or journals.
- Existing combined records and historical files may stay until a split is requested; when splitting, move requirements into the spec and replace them with a link in the plan.

## Living documentation and task history

- Living docs are `AGENTS.md`, `README.md` and `CHANGELOG.md` at the root, `docs/README.md`, `docs/DESIGN-LANGUAGE.md`, and every file under `docs/{user,internals,operations}/`. Rewrite or delete outdated passages in place.
- Specs and plans are design and execution records, not claims of shipped behavior: update active records in place across sessions and PRs.
- After acceptance criteria and required approvals are met, mark the plan historical with a completion date and the implementation commits or PR links. Freeze the spec only when its full scope is accepted or explicitly superseded.
- Keep finished specs and plans in git; do not delete them in the closing PR or maintain them as descriptions of current behavior. Extract durable knowledge into living docs.
- Raw logs, experiments and intermediate artifacts stay in the scratchpad.
- A repo with `PIPELINE.lock` follows that pipeline's convention, which replaces the directory, naming and spec/plan rules here; it still needs `AGENTS.md`. A pipeline does not imply permission to use external services.

## Location and naming

- Valid `docs/` subdirectories: `user/` (using the product), `internals/` (architecture, constraints and traps), `operations/` (maintainer runbooks), `specs/` (requirements and acceptance criteria) and `plans/` (implementation records).
- The only root-level `.md` files in `docs/` are `README.md` and, when applicable, `DESIGN-LANGUAGE.md`. Add living docs only when the reader would otherwise get something wrong.
- Another directory → ask. Do not create `docs/review/`, `docs/superpowers/` or `.planning/`.
- Use `docs/specs/YYYY-MM-DD-<slug>.md` for a spec and `docs/plans/YYYY-MM-DD-<slug>.md` for a plan, dated when each record starts; keep paths when resuming. Search both directories first and update the owning record.
- A plan links its spec and maps tasks and checks to its acceptance criteria; with no spec, it references the agreed conversation requirements with a brief scope summary.
- Specs and plans use English body and headings, independent of the output style.
- Reviews are returned in chat by default, or posted to a specific PR when requested; do not auto-create report files or post externally.
- Record actionable review outcomes in the owning spec or plan when revisions are authorized, without turning a read-only review into an edit. Evidence files stay in the scratchpad or a user-requested destination.
- Cross-repo work uses one owning spec where needed and one owning plan with explicit repo and checkout paths, unless the user asks for separate plans.
- Owner eye approval goes in one final task, never between tasks; the only earlier stops are picking a mock direction before code and a dev-switch cut-over (skill `kyant-ui-rules`).
- End every new plan file with a ready-to-paste `/goal` line built from its acceptance criteria.

## AGENTS.md and CLAUDE.md

- Every repo needs `AGENTS.md`. Claude Code (v2.1.277+) and Codex/Cursor read it directly, so do not add a `CLAUDE.md` that only imports it.
- Add `CLAUDE.md` only for Claude-specific rules; it then takes precedence and `AGENTS.md` is skipped unless it starts with `@AGENTS.md`. A `CLAUDE.md` in a parent directory also hides `AGENTS.md`.
- Architecture and constraints belong in `docs/internals/` (entry: `docs/internals/overview.md`). Task progress belongs in the plan, not a separate architecture or context journal.

## Preventing drift

- Fix in-scope drift in living docs when found; raise out-of-scope findings in conversation with `file:line` evidence, without filing an external issue.
- Active specs reflect approved requirements; linked plans reflect those requirements and actual progress. Planned work is not a claim of current behavior.
- Frozen specs and plans are excluded from current-code drift maintenance. Do not keep a drift backlog inside living docs.
- Removing or renaming a module or feature updates its living-doc anchors in the same task.
- Architectural decisions, cross-module constraints and traps go in `docs/internals/`; usage changes in `docs/user/`; runbook changes in `docs/operations/`.
- Write only what a reader would otherwise get wrong: no file catalogs, control-flow retellings or duplicate PR summaries.

## Approval and completion

- Ask for approval only when requirements are unclear in a way that leads to materially different, hard-to-reverse outcomes, or before an irreversible or outward-facing action; otherwise pick the recommended option, state it and continue.
- Decisions already made in the conversation count; do not ask for duplicate approval because they were written into a plan.
- When a plan is needed, present its concrete approach before implementation unless that approach is already approved. Routine in-scope implementation choices stay the agent's call.
- A change in public behavior (API, CLI, UI flow) updates the existing `README.md` and `CHANGELOG.md` where relevant.
- Use absolute dates `YYYY-MM-DD`, not relative dates.

## While editing docs

- Link checks, duplicate checks, doc language and the writing checklist live in [living-docs.md](../docs/living-docs.md).
