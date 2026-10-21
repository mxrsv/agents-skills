---
name: primitive
description: Decide and document how a shared UI control owns its look — props instead of caller classes, a capped variant set, slot composition for compound pieces, adaptations of generated preset source, and the checks that keep callers honest.
---

# Primitive — one place owns the look

Controls drift when each feature writes its own class for "a button like that one". The fix is
structural: the control owns its look; callers choose, never restyle (U1, U2).

## 1. Reuse test (before writing anything)

Search the repo's controls folder and stylesheets for something that does the job. Count how
many sites already build this control by hand. If none exists and one feature needs it, keep it
in that feature's component; promote it to the shared folder on the second real use.

## 2. The contract

- **Props pick the look**: `variant`, `size`, state. Callers never pass colour, padding, radius.
- **`class` is for layout only**: position, margin, width, flex/grid placement. If the framework
  allows it, prefer typing the prop away and letting the parent's selector or a wrapper place it.
- **Cap variants up front** (about 4) and sizes (about 2) for a hand-built control. A shared
  button that grew to 14 variants and 15 sizes became the dumping ground for every feature's
  skin. Past the cap, the look is a feature component built from the primitive's parts.
- A new variant is a change to the primitive: add it, add a specimen in the gallery or
  storybook, get it reviewed by eye. If an existing variant almost fits, change the call site.
- Behaviour that is hard to get right (focus return, dismissal, roles, disabled-but-focusable)
  lives in the control, so a page cannot omit it.

## 3. Generated from a preset or registry

When controls come from a generator (shadcn preset, a registry), the source is upstream:

- The cap is the upstream variant and size set. Adding one is a recorded decision, not a
  quick edit.
- Pin the generator and dependency versions; when a control is regenerated, diff it against
  the committed source and record upstream drift.
- An **adaptation** (renderer glue such as `forwardRef`, an inset focus ring) is a deliberate
  edit recorded in the project's plan or spec, and linted on the primitives so regeneration
  cannot silently drop it.
- Lint tiers: primitives get token checks only, never restyle or arbitrary-value checks on
  their own classes (module `gates`).

## 4. Compound pieces: slots

For a surface with several parts (banner, row, card), export one object of small slots
(`Root`, `Icon`, `Content`, `Actions`). Slots own their classes, take `class`/`className`,
spread the rest of their props and merge classes with the repo's `cn`. Variants and density are
props on `Root`. A stack/list component owns only behaviour (priority, expand, dismiss);
consumers are a few lines of slots.

## 5. Raw elements

A bare `<button>`, `<input>`, `<select>` or `<textarea>` dressed as an existing control is a
defect. Raw elements are right for list rows, tabs, resize handles, swatches and editor
surfaces, where behaviour or geometry differs by design.

## 6. States

Focus, selection, hover and disabled are part of the contract (U4). Keep indicators inside the
element where an ancestor may clip; prove a change with module `states` on light and dark —
`ring-inset` alone faded to nothing on a filled control with a translucent ring colour
(`../../references/lessons.md`).

## 7. Enforcement

Pick the tier with skill `write-rule`; install with module `gates`. With legacy controls,
exempt them by name in lint config and keep the names honest with the exemptions test, rather
than a warning a quiet hook never prints. Do not claim a check in the docs before it exists.

## 8. Checklist

- [ ] Searched for an existing control; none fit.
- [ ] Look lives in one place; props, not classes, vary it.
- [ ] Variants/sizes within the cap (upstream set for generated controls); a11y handled inside.
- [ ] Adaptations of generated source recorded and linted.
- [ ] Specimen added and eye-reviewed, states included (UI change).
- [ ] Old class family deleted in the same change once nothing uses it.
