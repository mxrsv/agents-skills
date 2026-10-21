---
name: probe
description: Measure what a lint rule or plugin would report on a repo before enabling it — unscoped versus scoped, across linter versions, with a positive control — and turn the numbers into tiers and named exemptions.
---

# Probe — measure before you enable

A rule enabled blind either drowns the tree in false errors or gets switched to `warn`, where
a `--quiet` hook never shows it. Measure first; the table decides the scope.

## Steps

1. **Baseline.** Whole-tree lint with the current config: error and warning counts.
2. **Candidate config in scratch.** Write the new rules into a config outside the repo (the
   session scratchpad). `jsPlugins` resolve relative to the config file, so install any new
   package into that scratch folder, never into the repo, until the dependency is approved.
3. **Unscoped run.** `node scripts/probe.mjs --config <scratch config> --group <name>=<path
   prefix> … -- <paths>` prints hits per rule per group. Group by what will get a different
   tier: generated primitives, legacy controls, callers, gallery, tests.
4. **Read the false positives.** Open a few hits per rule and group. Typical: primitives
   tripping their own restyle checks, legacy class names read as utilities, runtime values
   flagged as static. Each pattern becomes a tier boundary or a named exemption.
5. **Scoped run.** Same command with the tiered config. What remains should be real.
6. **Versions.** If the plugin documents a minimum linter version, run the current and the
   minimum (or latest) binaries on the same files and compare totals and new rule names.
7. **Positive control.** One temporary file per tier with a known violation per rule, so a
   silent 0 cannot mean "the rule never ran". Delete it.

## Output

A table, for the handoff or the `gates` module:

| Rule | Group | Unscoped | Scoped | Pattern of false positives | Decision |
| --- | --- | --- | --- | --- | --- |

plus the exemption list (file and reason) and the linter version chosen. Add any new pattern
to `../../references/lessons.md` with the date.
