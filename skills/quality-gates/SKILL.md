---
name: quality-gates
description: Router for UI and code quality gates — study how a reference repo enforces quality, measure a lint rule's noise before enabling it, install lint/test gates (suppression reasons, unreasoned skips, shadcn/Tailwind design-system checks, focus-ring and import boundaries), define a shared UI control that owns its look, capture light/dark state sheets for eye review, and review a UI diff for what lint cannot see. Use when setting up quality checks in a project, adopting a UI preset or registry, adding or reshaping a shared control, a feature restyling a shared component with its own class, changing focus or selection styling, or before committing UI changes. Not for building a screen (use impeccable) or judging visual craft (use frontend-design-bar).
---

# Quality gates

One router, six modules. Modules live in `.modules/<id>/SKILL.md` next to this file: Claude
Code only discovers top-level skill folders and Codex skips hidden ones, so only this router
costs context. Read the chosen module's `SKILL.md` in full and follow it as if it were invoked
directly; paths inside a module (`scripts/…`, `assets/…`, `references/…`) are relative to that
module's folder. Never invoke a module through the Skill tool — it is not registered.

The rules these modules serve are path-scoped and load on their own: U1–U5 in
`~/.claude/rules/quality/ui.md`, Q1–Q2 in `~/.claude/rules/quality/code.md`. Which check
enforces which rule: [`references/rule-map.md`](references/rule-map.md). Traps already measured:
[`references/lessons.md`](references/lessons.md) — read it before configuring anything.

## Modules

| ID | Run it when | It stops at |
| --- | --- | --- |
| `study` | the user wants to learn how another repo keeps UI or code quality | a mapping table: rule → problem → ours → adopt/adapt/skip |
| `probe` | before enabling any lint rule or plugin, or changing its scope | a scope table: hits per rule per path group, plus the allowlist |
| `gates` | a project needs quality gates, or adopts a UI preset/registry | gates wired, whole-tree lint at 0 errors, rules written into `AGENTS.md` |
| `primitive` | a shared control is added or reshaped, or a feature restyles one | the control's contract, specimen and enforcement |
| `states` | focus, hover, selection, disabled or theme styling changes | light/dark before–after sheets for the owner's eye |
| `review` | a UI change (`*.tsx`, `*.jsx`, `*.vue`, `*.svelte`, `*.css`) is about to be committed | findings on changed lines, or `All clear` |

Pick the one module that fits; a request spanning several runs them in the flow order below,
one at a time. Name the chosen module(s) to the user in one line.

## Flows

- **New project or preset adoption:** `study` (optional) → `probe` → `gates`.
- **New or reshaped control:** `primitive` → `states` → `review` → `frontend-design-bar`.
- **A mistake made twice:** skill `write-rule` picks the tier; a lint tier goes `probe` →
  `gates`, and the new check gets a row in `references/rule-map.md`.
- **Before a UI commit:** the repo's lint (installed by `gates`) → `review` → eye approval.

## Outside this bundle

`write-rule` (rule tiers, any domain), `scout` (research pipeline `study` reuses), `impeccable`
(build UI), `frontend-design-bar` (visual acceptance), `review-change` (correctness),
`shadcn` (component docs; vendored, never edited).

## Guardrails

- `~/.claude` is public: assets and references hold no project paths, product names or the
  name of a studied repo. A project's own copies may name its paths.
- Copy assets into a project; never import from `~/.claude` at runtime.
- When a module learns something measured, add it to `references/lessons.md` with the date.
