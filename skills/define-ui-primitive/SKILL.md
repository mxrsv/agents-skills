---
name: define-ui-primitive
description: Decide and document how a shared UI control owns its look — props instead of caller classes, a capped variant set, slot composition for compound pieces, and the check that keeps callers honest. Use when adding or reshaping a shared control (button, field, switch, banner, menu), when a feature restyles a shared component with its own class, or when a new button-like class family is about to be created. Not for one-off layout or page design.
---

# define-ui-primitive — one place owns the look

Controls drift when each feature writes its own class for "a button like that one". The fix is
structural: the control owns its look; callers choose, never restyle.

## 1. Reuse test (before writing anything)

Search the repo's controls folder and stylesheets for something that does the job. Count how
many sites already build this control by hand. If none exists and one feature needs it, keep it
in that feature's component; promote it to the shared folder on the second real use.

## 2. The contract

- **Props pick the look**: `variant`, `size`, state. Callers never pass colour, padding, radius.
- **`class` is for layout only**: position, margin, width, flex/grid placement. If the framework
  allows it, prefer typing the prop away and letting the parent's selector or a wrapper place it.
- **Cap variants up front** (about 4) and sizes (about 2). A shared button that grew to 14
  variants and 15 sizes became the dumping ground for every feature's skin. Past the cap, the
  look is a feature component built from the primitive's parts.
- A new variant is a change to the primitive: add it, add a specimen in the gallery or
  storybook, get it reviewed by eye. If an existing variant almost fits, change the call site.
- Behaviour that is hard to get right (focus return, dismissal, roles, disabled-but-focusable)
  lives in the control, so a page cannot omit it.

## 3. Compound pieces: slots

For a surface with several parts (banner, row, card), export one object of small slots
(`Root`, `Icon`, `Content`, `Actions`). Slots own their classes, take `class`, spread the rest of
their props. Variants and density are props on `Root`. A stack/list component owns only
behaviour (priority, expand, dismiss); consumers are a few lines of slots.

## 4. Raw elements

A bare `<button>`, `<input>`, `<select>` or `<textarea>` dressed as an existing control is a
defect. Raw elements are right for list rows, tabs, resize handles, swatches and editor
surfaces, where behaviour or geometry differs by design.

## 5. Enforcement

Pick the tier with the write-rule skill. With legacy controls, a policy test that counts
button class families (or raw buttons) per file against a committed baseline, allowed only to
fall, beats a lint rule that fails every push touching old code. Do not claim a check in the
docs before it exists.

## 6. Checklist

- [ ] Searched for an existing control; none fit.
- [ ] Look lives in one place; props, not classes, vary it.
- [ ] Variants/sizes within the cap; state and a11y handled inside.
- [ ] Specimen added and eye-reviewed (UI change).
- [ ] Old class family deleted in the same change once nothing uses it.
