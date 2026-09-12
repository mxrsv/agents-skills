# Docs & specs (D-rules)

## The spec for a piece of work

- **D0.** The spec lives in the **Linear issue** by default: the description records the goal, scope, decisions and acceptance criteria. Read the issue and its decision comments before starting; a newer user decision replaces the older part it supersedes. If the issue is clear enough and has been handed over for implementation, do the work — do not ask for the same spec to be rewritten or re-approved in the repo.
- Create a spec file in the repo only when the user explicitly asks. If there is no issue yet, the spec content may be drafted in the conversation; creating/updating the issue follows the scope the user assigned. Repo docs only link to the issue when needed; never keep two parallel copies of a spec. This rule takes precedence over any mandatory "write a spec file" step inside a skill.
- Do not create checkpoints, dailies or per-day journals on your own; do not use hooks to force those steps. Living docs still get updated as the code changes; existing historical docs are left as they are.

## Three tiers of documentation

- **D1.** Living = `AGENTS.md`, `README.md`, `CHANGELOG.md` at the root; `docs/README.md`, `docs/DESIGN-LANGUAGE.md` and every file under `docs/{user,internals,operations}/` → update in place: when a decision changes, REWRITE or delete the old passage, do not append a second telling. Work in progress (spec, plan, research, review) = Linear issue (D0, D4), not committed to the repo; the merged PR is the record of what was actually done. Temporary = scratchpad → never committed.
- **D2.** A repo with `PIPELINE.lock` → follow that pipeline's convention: **D3, D4, D6** are waived. **D5 is NOT waived** — every pipeline still needs the agent rule surface.

## Location & naming

- **D3.** The only valid subdirectories in `docs/` are the three reader tiers: `user/` (using the product), `internals/` (architecture decisions, cross-module constraints, traps hard to see from the code), `operations/` (maintainer runbooks: setup, release, debug). The only `.md` files directly in `docs/` are `README.md` (index) and `DESIGN-LANGUAGE.md` when the repo has codified design rules. `internals/` is the only place that accepts new docs, and only when "a maintainer would get it wrong without this passage"; if reading the code answers the question, drop it. Need a name outside this list → ASK. NEVER `docs/specs/`, `docs/plans/`, `docs/review/`, `docs/superpowers/`, `.planning/`.
- **D4.** Spec → the Linear issue description (D0). Plan → a sub-issue of that issue, or a `## Plan` checklist section in the description when small. Review → a comment on the issue or a review comment on the PR; images/assets → issue attachments. Create a file in the repo only when the user explicitly asks, and then the file only links to the issue — never keep two parallel copies.
- **D5.** Every repo MUST have the **pair** `AGENTS.md` + `CLAUDE.md` at the root, with `@AGENTS.md` as the first line of `CLAUDE.md`. Claude Code does NOT read `AGENTS.md` on its own — it must be imported; Codex and Cursor read it directly. Architecture, decisions still in force and traps → `docs/internals/` (entry point: `docs/internals/overview.md`); `docs/ARCHITECTURE.md` and `docs/CONTEXT.md` no longer exist — "what is being worked on" lives in the Linear issue.

## Preventing drift from the code

- **D7.** Drift (doc says X, code does Y) found during a task → fix that doc passage right away if it is in scope; out of scope → file a Linear issue (or a comment on the issue being worked) with `file:line` on both sides. Do NOT keep a "Chưa khớp thực tế" ("not matching reality") table in the docs — that table is a backlog in disguise, retired 2026-09-07 (MXR-37).
- **D8.** Deleting/renaming a module or removing a feature → MUST update the anchors in the living docs within the same task.
- **D9.** A task that changes architecture, a cross-module constraint or adds a trap → update the related `docs/internals/` page in the same PR; a change in usage → `docs/user/`; a change in a runbook → `docs/operations/`. Only when "a maintainer would get it wrong without it"; PR summaries, file catalogs, control-flow retellings → NO. Part of the W4 checklist.

## Process

- **D10.** A feature that went through brainstorming needs an approved spec before code; the Linear issue content plus the decisions the user has locked in count as a valid spec (D0) — no extra file or duplicate approval round needed.
- **D12.** A change in public behavior (API, CLI, UI flow) → update `README.md`/`CHANGELOG.md` if the repo has them.
- **D13.** Absolute dates `YYYY-MM-DD`, NEVER "today/last week".
- **D14.** NEVER `git commit` docs (`AGENTS.md`, `docs/**`) before the user has approved the content — even when a skill says to commit first. When updating a Linear issue/document, present the content in the conversation before writing it, unless the user has explicitly delegated that.

## While editing docs

- **D6, D11, D15** and the doc-writing checklist → `~/.claude/rules/docs/living-docs.md`, loaded automatically when touching `docs/**`, `AGENTS.md`, `README.md`, `CHANGELOG.md`.
