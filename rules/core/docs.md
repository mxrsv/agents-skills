# Docs and task plans (D-rules)

## One task, one working record

- **D0.** The conversation is where the user sets goals and approves decisions. For work that needs a plan (W2), keep requirements, scope, decisions, acceptance criteria, implementation tasks, verification and handoff together in one repo plan. A newer user decision supersedes the affected passage; update it in place. Small, clear work can stay in the conversation. Do not require Linear, an issue key, a claim comment or an external status update to start, review or hand off work. Use an external tracker only when the user explicitly asks for it in that task.
- Do not create a separate spec, checkpoint, daily or journal by default. A brainstormed spec is the requirements section of the same plan; planning adds execution detail there. Follow existing task files instead of duplicating them. Older tracker records may remain as historical references; do not fetch, migrate or edit them automatically.

## Living documentation and task history

- **D1.** Living = `AGENTS.md`, `README.md`, `CHANGELOG.md` at the root; `docs/README.md`, `docs/DESIGN-LANGUAGE.md` and every file under `docs/{user,internals,operations}/`. Rewrite or delete outdated passages in place. Plans in `docs/plans/` are task records: update the same file across sessions and PRs. After acceptance criteria and required approvals are met, mark the plan historical with a completion date and relevant implementation commits/PR links when available. Retain it in git; do not delete it in the closing PR or maintain it as a description of current behavior. Extract durable knowledge into living docs (D9). Raw logs, experiments and intermediate artifacts stay in scratchpad.
- **D2.** A repo with `PIPELINE.lock` follows that pipeline's convention: D3, D4 and D6 are waived. D5 is not waived. A pipeline does not imply permission to use external services.

## Location and naming

- **D3.** Valid `docs/` subdirectories: `user/` (using the product), `internals/` (architecture, constraints and traps), `operations/` (maintainer runbooks), and `plans/` (task records). The only root-level `.md` files in `docs/` are `README.md` and, when applicable, `DESIGN-LANGUAGE.md`. Add living docs only when the reader would otherwise get something wrong. Need another directory → ask. Do not create `docs/specs/`, `docs/review/`, `docs/superpowers/` or `.planning/`.
- **D4.** When a plan is needed, use `docs/plans/YYYY-MM-DD-<slug>.md`, dated when the task starts; keep that path when resuming. Search for the existing task plan first, including older issue-keyed names, and update it rather than renaming or duplicating it. One plan holds the task's requirements, decisions, checklist, evidence and latest handoff; its body/headings are English independent of Output Style. Reviews are returned in chat by default, or posted to a specific PR when requested; do not auto-create report files or post externally. Record actionable review outcomes in the existing plan when continuing implementation, without changing a read-only review into an edit. Evidence files stay in scratchpad or a user-requested artifact destination. For cross-repo work, use one owning plan with explicit repo/checkout paths unless the user requests separate plans; do not keep duplicate checklists.
- **D5.** Every repo needs the pair `AGENTS.md` + `CLAUDE.md`, with `@AGENTS.md` as the first line of `CLAUDE.md`. Claude Code imports it; Codex/Cursor read it directly. Architecture and constraints belong in `docs/internals/` (entry: `docs/internals/overview.md`). Task progress belongs in the plan, not a separate architecture/context journal.

## Preventing drift

- **D7.** Fix in-scope drift in living docs when found; raise out-of-scope findings in conversation with `file:line` evidence, without filing an external issue. Active plans must reflect approved decisions and actual progress; planned work is not a claim of current behavior. Frozen historical plans are excluded from current-code drift maintenance. Do not keep a drift backlog inside living docs.
- **D8.** Removing/renaming a module or feature requires updating its living-doc anchors in the same task.
- **D9.** Document architectural decisions, cross-module constraints or traps in `docs/internals/`; usage changes in `docs/user/`; runbook changes in `docs/operations/`. Only write what a reader would otherwise get wrong. Do not create file catalogs, control-flow retellings or duplicate PR summaries.

## Approval and completion

- **D10.** Approve unclear requirements and material design decisions before implementing them. The conversation's existing decisions count; do not ask for duplicate approval because they were written into a plan. When a plan is needed, present its concrete approach before implementation unless that approach is already approved. Routine in-scope implementation choices remain the agent's responsibility.
- **D12.** A change in public behavior (API, CLI, UI flow) requires updating existing `README.md`/`CHANGELOG.md` where relevant.
- **D13.** Use absolute dates `YYYY-MM-DD`, not relative dates.
- **D14.** Do not commit docs (`AGENTS.md`, `docs/**`) before the user approves their content. Approval of a specific plan covers committing it and routine in-scope progress, verification, handoff, PR/commit links and the final historical marker. Material scope, approach or risk changes need renewed approval. This does not approve unrelated living-doc changes, merge, deploy or release. Do not add a separate approval round just to save routine progress in the plan.

## While editing docs

- D6, D11, D15 and the writing checklist live in `~/.claude/rules/docs/living-docs.md`.
