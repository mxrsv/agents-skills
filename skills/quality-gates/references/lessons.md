# Lessons measured in real repos

Each line was observed, not assumed. Add new ones with the date; delete one that a newer
measurement contradicts.

## Lint tooling

- **`@shadcn/lint` reads Preact `class=` as well as `className=`** (attribute regex
  `/^(class:list|[^:]*class(name)?s?)$/i`). Legacy BEM classes therefore trip
  `no-unknown-classes` by the hundred; scope that rule to migrated paths. (2026-10-22)
- **Unscoped, the five shadcn rules mostly report false errors**: 274 on one preset's copied
  sources (restyle and arbitrary values inside the generated primitives themselves) and 1295 on
  a legacy tree. Scoped in three tiers, 11 real ones remained. (2026-10-22)
- **`allow: ["layout"]` lets sizing through**: `h-12`, `w-48` pass `no-restyle`; `rounded-*`,
  `text-*`, `bg-*`, `p-*` are caught. Height overrides need review or a `contracts` entry with
  `deny` (untested). (2026-10-22)
- **A BEM modifier can read as a utility**: `text-input--small` was flagged by
  `no-raw-colors` as a `text-*` colour. Exempt such files by name. (2026-10-22)
- **`no-inline-styles` also flags runtime values** (a computed `transform`); leave it off and
  keep "static inline style is a class" for review. (2026-10-22)
- **Restricted-import patterns with `importNames` also hit side-effect imports** when the group
  is too wide (`./*` caught `import "./x.css"`). Keep groups to the controls path. (2026-10-22)
- **Recognition of legacy components**: `settings.shadcn.ignoreImports` (regex on the import
  specifier, relative or aliased) stops `no-restyle` treating pre-preset controls in the same
  folder as preset components. (2026-10-22)
- **Every oxlint from 1.80 turns on React Compiler rules** (`react/immutability`, `react/refs`,
  `react/purity`) in the correctness category: 354 errors on a Preact codebase. Turn them off
  for non-React-Compiler stacks, with a comment. `@shadcn/lint` 0.1.5 ran the same on 1.78 but
  documents 1.80+. Pin oxlint exactly: minors add correctness rules. (2026-10-22)
- **An override replaces a rule's options instead of merging.** Repeat every existing entry
  (e.g. a renderer-boundary `no-restricted-imports`) in the override that extends it.
  (2026-10-22)
- **`warn` is not a ratchet when the hook runs `oxlint --quiet`** and CI fails only on errors:
  warnings are invisible in both. Use error level with a shrinking `excludeFiles` list plus a
  test that each named exemption still exists. (2026-10-22)
- **`.oxlintrc.json` accepts whole-line and trailing `//` comments**, and Prettier keeps them,
  so exemption reasons can live beside the entry. (2026-10-22)
- **oxlint JS plugins can be plain objects** (`{ meta, rules: { name: { meta, create } } }`):
  no dependency. `context.sourceCode.getAllComments()`, `getCommentsBefore()`, `node.parent`
  and `context.report({ loc })` all work. Test rules by spawning the real binary on fixtures,
  one process per rule file. (2026-10-22)

## Focus and state styling

- **`ring-inset` alone is not enough on a preset with a translucent ring.** With
  `ring-ring/30`, an inset 2px ring almost vanished on a filled primary Button and on a
  Switch track, light and dark. Inset plus a solid `ring-ring` was visible everywhere. Record
  it as an adaptation of generated source and lint the primitives for it. (2026-10-22)
- **`ring-0` under a state variant removes a ring**; a focus-ring rule must not count width 0.
  (2026-10-22)
- **Programmatic focus shows `:focus-visible` after one keyboard event**: press Tab, then
  `focus()` the target. (2026-10-22)

## Process

- **A strict-port dev server fails quietly when another session holds the port**, and the
  capture then runs against that session's checkout. Killing "whatever listens on the port"
  afterwards stopped a peer's preview server. Check the port first, keep `$!`, verify the
  listener's PID and working directory before capturing, and stop only that PID. (2026-10-22)

- **Pre-push suites that spawn processes flake under load** (load average around 6): a
  different timing test failed on two pushes and all passed on the third, each passing alone.
  Attribute against the base before calling a failure yours; never `--no-verify` a red change.
  (2026-10-22)
- **A rule commit cherry-picks cleanly only if config hunks and the lockfile come with it.**
  Order commits so dependency-independent rules come first, and say how to land them alone.
  (2026-10-22)
