---
name: review
description: Review the changed lines of a UI diff for what lint cannot see — a raw element dressed as an existing control, a caller overriding a control's height, copied control markup, new global CSS, static inline style, hand-written theme selectors, idle repaint.
---

# Review — a styling guard on changed lines

Not a general review (skill `review-change`) and not a visual judgement (screenshots and the
owner's eye). Read only the changed lines (`git diff` against the commit's base) and answer the
questions below. Do not build, run the app, inspect emitted CSS, trace selector consumers
across the codebase or ask for screenshots. If the diff does not make a violation obvious,
there is no finding.

## Before reading

- Find the repo's rules: its `AGENTS.md` numbering (e.g. "R11 control owns its look") if
  present, else U1–U5 from `~/.claude/rules/quality/ui.md`. Cite the repo's numbers.
- Find the controls folder and any carve-outs the repo lists (native selects over a pill,
  terminal or editor surfaces).
- Run the repo's linter on the changed files. Report its output as it is; do not repeat what
  it already caught.

## 1. Controls come from the controls folder (U1, U2)

- Flag a bare `<button>`, `<input>`, `<select>` or `<textarea>` styled to look like a control
  the folder provides.
- Flag a caller that sets a control's height or size (`h-*`, `size-*`, `min-h-*`): lint lets
  sizing through as layout. A look several places need is a new size on the primitive.
- Do not flag raw elements that are not a control by design: rows, tabs, resize handles,
  swatches, terminal and editor surfaces, and the repo's own carve-outs.

## 2. Styling lives on the component that renders it (U3)

- Flag new rules in a stylesheet that classes on the owning component could express. Global
  CSS is right for generated markup (rendered markdown), third-party hosts (terminal, editor),
  custom elements, keyframes, runtime theme variables and platform integration.
- Flag a new `style={{ … }}` carrying a static value a class covers; runtime values are fine.
- Flag a hand-written `.dark` selector where the theme provides a `dark` variant.

## 3. Compose, do not copy (U1)

- Flag a new component that copies a primitive's markup and classes instead of composing it.
- Flag a long class string that repeats a treatment another call site already uses: the fix
  is a variant on the primitive or a slot on a shared composite.
- Flag a new member of a slot family (banner, row, card) that hand-builds its row, icon
  column or actions instead of using the slots.

## 4. Motion (U5)

- Flag a new infinite animation, `requestAnimationFrame` loop or interval that drives visuals
  while nothing changes, unless it runs only while its state exists and stops under reduced
  motion.

## Reporting

Report only violations the changed lines introduce, one line each: file and line, the rule,
and the primitive or place the code should use instead. Do not comment on untouched legacy
code, class order or taste, and do not ask for cleanup outside the change. With no findings,
the whole report is `All clear`.
