# AGENTS.md rule templates

Copy the ones the project enforces into its repo rules, renumber them after the existing
ones, and replace `<…>`. Each names its check; never write a rule whose check does not exist
yet (skill `write-rule`). Keep the global ID (U1, Q1…) in the commit that adds it.

```md
- **R<n>. Every exception says why.** (Q1) A lint or type suppression ends with `-- reason` or
  sits under a comment that gives one; `local/require-suppression-reason` fails without it. An
  override, allowlist entry or exempt path in `.oxlintrc.json` carries a comment naming what it
  protects. A change that adds or widens one says so in its PR, for the owner to accept.
- **R<n>. Tests assert behaviour.** (Q2) Drive the code the way the user or caller would and
  assert what they see. A skipped, focused or `todo` test names its issue on the line above
  (`// skip: #123 <why>`), checked by `local/no-unreasoned-skip`; `skipIf`/`runIf` platform
  gates need none.
- **R<n>. A control owns its look.** (U1) Controls in `<controls>` are the preset's generated
  source; record every adaptation in `<plan or spec>`. A caller picks `variant` and `size`; its
  `className` is layout only. A look one feature needs is that feature's component, composed
  from controls. A new variant is a change to the primitive, with a specimen and the owner's
  eye review. `shadcn/no-restyle` lets sizing such as `h-*` through, so height is left to review.
- **R<n>. Reuse before you add.** (U2) Elsewhere than `<controls>`, import the primitive, never
  its class recipe, `<headless library>` or `<icon package>`; oxlint rejects those imports.
  Do not dress a bare `<button>`, `<input>`, `<select>` or `<textarea>` as a control that
  exists; a raw element is right for a row, tab, resize handle, swatch or editor surface.
- **R<n>. A surface on the preset uses its theme.** (U3, U4) Colours are the preset's semantic
  tokens; values sit on the theme scale and only layout takes an arbitrary value; classes are
  static strings; a focus or selection mark stays inside its element. Global CSS holds only
  what classes cannot say; a static inline `style` is a class. Legacy files exempted by name
  leave the list with their migration (`scripts/oxlint-exemptions.test.ts` keeps names real).
```

Skills table row, if the project lists repo skills:

```md
| `quality-gates` (global, module `review`) | a UI change is about to be committed | findings on changed lines, or `All clear` |
```
