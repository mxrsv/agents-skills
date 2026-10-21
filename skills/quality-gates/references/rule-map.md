# Rule map

Which check enforces each global rule, and what is left to review. A project instance renumbers
the rules in its own `AGENTS.md` (templates: `.modules/gates/references/agents-rules.md`); keep
the global ID in the project's commit messages or config comments so the two can be traced.

| Rule | Lint / test (installed by `gates`) | Left to review or eye | Modules |
| --- | --- | --- | --- |
| U1 control owns its look | `shadcn/no-restyle` with `allow: ["layout"]`, off inside the controls directory | height and size overrides (`h-*`, `size-*`) pass as layout; copied control markup | `primitive`, `review` |
| U2 reuse before you add | `no-restricted-imports`: `*Variants` recipes, the headless library, the icon package outside the controls directory | a raw element dressed as a control | `primitive`, `review` |
| U3 style from the theme | `shadcn/no-raw-colors`, `shadcn/no-arbitrary-values` (`allow: ["layout"]`), `shadcn/require-static-classes`, `shadcn/no-unknown-classes` on migrated paths | new global CSS, static inline `style`, hand-written `.dark` selectors | `gates`, `review` |
| U4 state marks stay visible | `local/no-outset-state-indicators` | whether the indicator is actually visible: a state sheet | `states`, `gates` |
| U5 nothing repaints while idle | none | loops, timers, `requestAnimationFrame` | `review` |
| Q1 every exception says why | `local/require-suppression-reason`; `oxlint-exemptions.test.ts` keeps named exemptions real | an override comment that names nothing | `gates` |
| Q2 tests assert behaviour | `local/no-unreasoned-skip` | tests that mirror the implementation | `gates`, skill `review-change` |

`local/` is the plugin name the project gives `assets/oxlint-plugin/` (rename `meta.name`).

## Considered and not shipped

Port these when their trigger appears, measured with `probe` first.

| Check | Trigger |
| --- | --- |
| no native `title` tooltip on intrinsic elements | the project has a Tooltip primitive |
| centred scroller needs `scrollbar-gutter` | the project has a ScrollArea primitive or Tailwind scrollers |
| unanchored `:has()` in Tailwind arbitrary variants | the first `[…:has(…)]` variant appears |
| no wall-clock reads or real sleeps in tests | the suite runs on fake timers; tests that drive real processes keep their timeouts |
| report unused disable directives | the existing unused directives are cleaned up first |
