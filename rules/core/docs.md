# Docs, specifications and task plans (D-rules)

## Separate requirements from execution

- **D0.** The conversation is where the user sets goals and approves decisions. Specifications in `docs/specs/` own requirements, scope, product/design decisions and acceptance criteria. Implementation plans in `docs/plans/` own technical approach, tasks, progress, verification evidence and handoff; link to the relevant spec instead of copying its requirements. A newer user decision updates the owning document and any affected plan. Small, clear work can stay in the conversation. Use an external tracker only when the user explicitly asks for it in that task.
- Create a spec when explicitly requested or when material requirements need a durable record; create a plan only under W2. Neither document automatically requires the other. Keep one canonical spec per scope and one execution checklist per task, not duplicate specs, checkpoints, daily logs or journals. Existing combined records and historical files may remain until an explicit split is requested; when splitting, move requirements into the spec and replace them with a link in the plan. Older tracker records remain historical references; do not fetch, migrate or edit them automatically.

## Living documentation and task history

- **D1.** Living = `AGENTS.md`, `README.md`, `CHANGELOG.md` at the root; `docs/README.md`, `docs/DESIGN-LANGUAGE.md` and every file under `docs/{user,internals,operations}/`. Rewrite or delete outdated passages in place. Specs and plans are design/execution records, not claims of shipped behavior: update active records in place across sessions and PRs. After acceptance criteria and required approvals are met, mark the plan historical with a completion date and relevant implementation commits/PR links when available; freeze the spec only when its full scope is accepted or explicitly superseded. Retain both in git; do not delete them in the closing PR or maintain them as descriptions of current behavior. Extract durable knowledge into living docs (D9). Raw logs, experiments and intermediate artifacts stay in scratchpad.
- **D2.** A repo with `PIPELINE.lock` follows that pipeline's convention: D3, D4 and D6 are waived. D5 is not waived. A pipeline does not imply permission to use external services.

## Location and naming

- **D3.** Valid `docs/` subdirectories: `user/` (using the product), `internals/` (architecture, constraints and traps), `operations/` (maintainer runbooks), `specs/` (requirements and acceptance criteria), and `plans/` (implementation records). The only root-level `.md` files in `docs/` are `README.md` and, when applicable, `DESIGN-LANGUAGE.md`. Add living docs only when the reader would otherwise get something wrong. Need another directory → ask. Do not create `docs/review/`, `docs/superpowers/` or `.planning/`.
- **D4.** Use `docs/specs/YYYY-MM-DD-<slug>.md` for a spec and `docs/plans/YYYY-MM-DD-<slug>.md` for a plan, dated when each record starts; keep paths when resuming. Search both directories first, including older issue-keyed names, and update the owning record instead of duplicating it. A plan links to its spec and maps tasks/checks to the relevant acceptance criteria; if no spec is needed, reference the agreed conversation requirements with a brief scope summary. Specs and plans use English body/headings independent of Output Style. Reviews are returned in chat by default, or posted to a specific PR when requested; do not auto-create report files or post externally. Record actionable review outcomes in the owning spec or plan when revisions are authorized, without changing a read-only review into an edit. Evidence files stay in scratchpad or a user-requested artifact destination. For cross-repo work, use one owning spec where needed and one owning plan with explicit repo/checkout paths unless the user requests separate plans; do not keep duplicate requirements or checklists.
- **D5.** Every repo needs `AGENTS.md`. Claude Code (v2.1.277+) and Codex/Cursor read it directly, so do NOT add a `CLAUDE.md` that only imports it. Add `CLAUDE.md` only for Claude-specific rules; it then takes precedence and `AGENTS.md` is skipped unless it starts with `@AGENTS.md`. A `CLAUDE.md` in a parent directory also hides `AGENTS.md`. Architecture and constraints belong in `docs/internals/` (entry: `docs/internals/overview.md`). Task progress belongs in the plan, not a separate architecture/context journal.

## Preventing drift

- **D7.** Fix in-scope drift in living docs when found; raise out-of-scope findings in conversation with `file:line` evidence, without filing an external issue. Active specs must reflect approved requirements; linked plans must reflect those requirements and actual progress. Planned work is not a claim of current behavior. Frozen historical specs and plans are excluded from current-code drift maintenance. Do not keep a drift backlog inside living docs.
- **D8.** Removing/renaming a module or feature requires updating its living-doc anchors in the same task.
- **D9.** Document architectural decisions, cross-module constraints or traps in `docs/internals/`; usage changes in `docs/user/`; runbook changes in `docs/operations/`. Only write what a reader would otherwise get wrong. Do not create file catalogs, control-flow retellings or duplicate PR summaries.

## Approval and completion

- **D10.** Approve unclear requirements and material design decisions before implementing them. The conversation's existing decisions count; do not ask for duplicate approval because they were written into a plan. When a plan is needed, present its concrete approach before implementation unless that approach is already approved. Routine in-scope implementation choices remain the agent's responsibility.
- **D12.** A change in public behavior (API, CLI, UI flow) requires updating existing `README.md`/`CHANGELOG.md` where relevant.
- **D13.** Use absolute dates `YYYY-MM-DD`, not relative dates.

## While editing docs

- D6, D11, D15 and the writing checklist live in `~/.claude/rules/docs/living-docs.md`.
