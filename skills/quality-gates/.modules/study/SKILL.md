---
name: study
description: Study how a reference repo keeps UI and code quality — its docs, lint config and custom rules, tests and automated reviewers — and map each mechanism onto the target repo as adopt, adapt or skip.
---

# Study — learn the guardrails, not the visuals

A reference repo's own look is not the lesson; how it stops drift is. This module is a lens on
skill `scout`: use scout's research pipeline (shallow clone into scratch, never install or run
its code, cite `path:line`, mark `verified`/`inferred`) with the questions and table below.

## Questions to ask of the reference

1. Where do its UI rules live, and which are enforced by a tool versus only written down?
2. What does its lint config switch on, scoped to which paths, with which exceptions and why?
3. Which custom lint rules exist, and what past mistake does each encode?
4. What do its tests and policy checks guard (behaviour, coverage, boundaries, flakes)?
5. Is there an automated reviewer (bot instructions, PR checklists), and what is it told to
   ignore?

## Read

- Agent and contributor docs (`AGENTS.md`, `CONTRIBUTING.md`, internals docs on UI).
- Lint config, including the parts embedded in build config; custom plugin rules and their
  tests; overrides and the comments on them.
- Test config (timeouts, retries, environments) and the rules that police tests.
- CI workflows, hooks and the "check changed files" script; PR template; reviewer bot configs.
- Pin everything to one commit: record the SHA and cite `blob/<sha>/path#Lx-Ly` permalinks.

## Filter before mapping

- **Stack-specific rules**: rules that exist for a compiler, runtime or framework the target
  does not use (React Compiler, an effect system, a mobile runtime) are listed as skipped,
  with the reason, not adapted.
- **Visual choices** (their colours, sizes, variants) are not guardrails; leave them out.
- **The target's decisions win**: a chosen preset, a fork rule or an owner decision is a
  constraint the mapping respects, not a candidate for change.

## Output

| Rule (reference, permalink) | Problem it solves | Tier there: doc / lint / test / reviewer | Target today | Adopt / adapt / skip, and how |
| --- | --- | --- | --- | --- |

Then: a minimal rule set in adoption order, the files each step touches, how legacy code is
handled (named exemptions, scoped paths), and how each step is verified. Measure any lint
candidate with module `probe` before recommending its scope.

## Rules

- Ideas, not code: record the license; rewrite any rule you port in your own words and code.
- Follow the target repo's naming rule for references in its docs (some forbid naming the
  studied repo). The report itself stays in scratch, never in the repo.
- Counts in the target are estimates unless a tool produced them; say which.
