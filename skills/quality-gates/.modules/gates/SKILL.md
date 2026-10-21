---
name: gates
description: Install quality gates in a project — the local oxlint plugin (Q1 suppression reasons, Q2 unreasoned skips, U4 outset focus rings), @shadcn/lint in three scoped tiers, import boundaries, the exemptions test and the AGENTS.md rules that name them.
---

# Gates — install the checks

Goal: every rule the project adopts has a check that fails, the whole tree lints at 0 errors,
and legacy code is exempted by name, not by severity. Read `../../references/lessons.md` first.

## 1. Read the project

- Lint tool and version (`oxlint`, `eslint`), how the pre-push hook and CI call it (`--quiet`?
  changed files only?), and the test runner. Warnings that a hook hides are not a gate.
- Framework: React with the React Compiler, React without it, Preact, Vue, Svelte. Turn off
  rules written for a compiler or runtime the project does not use, with a comment.
- UI stack: Tailwind v4? A preset or registry (`components.json`)? Where the controls live and
  whether legacy controls share that folder. A gallery or playground folder.
- Existing `no-restricted-imports` entries, which every new override must repeat.
- Baseline: whole-tree lint counts and the test suites the hook runs, before any change.

## 2. Choose modules

| Module | Adds | Needs |
| --- | --- | --- |
| core | Q1 `local/require-suppression-reason`, Q2 `local/no-unreasoned-skip` | nothing |
| ui | `@shadcn/lint` tiers, U2 import boundaries, U4 `local/no-outset-state-indicators` | Tailwind v4; oxlint ≥ 1.80 or ESLint ≥ 9.30 |

Adopting `@shadcn/lint` or bumping the linter is a dependency change: confirm it under the
repo's fork rules before installing. Pin exact versions.

## 3. Measure, then wire

1. Run module `probe` on the candidate config: unscoped, then scoped. Its table decides the
   tiers and the named exemptions.
2. Copy `assets/oxlint-plugin/` to `scripts/oxlint-plugin/` (or the repo's tooling folder) and
   rename `meta.name` if `local` clashes. Add it to `jsPlugins`.
3. Write the config from `references/shadcn-tiers.jsonc`: Q1/Q2 repo-wide; primitives get
   only token checks plus their recorded adaptations; callers get restyle, arbitrary values,
   static classes, raw colours and the focus rule; `no-unknown-classes` only on migrated paths.
   Legacy controls in the controls folder go in `settings.shadcn.ignoreImports` and in the
   primitives tier's `excludeFiles`. Each exemption line carries a comment (Q1).
4. Fix the legacy hits the core rules find, with reasons taken from the code or its commit
   (`git blame`, `git log`); never invent one. A directive that suppresses nothing is removed.
5. Copy `assets/oxlint-exemptions.test.ts` beside the repo's other policy tests and set its
   constants.

## 4. Prove it

- The plugin's own tests pass (`lint-fixtures.ts` spawns the real binary, one process per
  rule file).
- **Positive control:** a temporary file in each tier with one violation per rule — a restyle,
  a raw colour, a dynamic class, an arbitrary value, an outset ring, each restricted import,
  an unreasoned suppression — fails exactly as expected; a legacy class on a legacy control
  passes. Delete the file.
- Whole-tree lint: 0 errors, warnings compared with the baseline.
- The hook's suites pass, or each failure is attributed against the base (lessons.md).

## 5. Write the rules

Copy the templates in `references/agents-rules.md` into the repo's `AGENTS.md`, renumbered,
naming only checks that now exist. Add the `review` row if the repo lists skills. Then commit
in this order so the dependency-free part can land alone: linter pin and framework rule
switches → core plugin rules → preset tier and UI rules. Say in the handoff how to land the
first commits without the rest (lockfiles do not cherry-pick).

## Done when

Rules, checks and exemptions agree; the positive control was run; the handoff names the
exemptions each future migration step must remove.
