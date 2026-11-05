---
paths:
  - "**/*.tsx"
  - "**/*.jsx"
  - "**/*.vue"
  - "**/*.svelte"
  - "**/*.css"
---

# UI quality (U-rules)

Defaults for UI code in any repo; the repo's `AGENTS.md` wins where it says otherwise. The
procedures behind each rule live in skill `quality-gates`; `references/rule-map.md` there says
which check enforces which rule.

- **U1. A shared control owns its look.** A caller picks `variant` and `size`; its `class` /
  `className` is layout only (position, margin, width, flex or grid placement). A look one
  feature needs is that feature's component, composed from controls; a generic look is a new
  variant on the control, added with a specimen and an eye review.
- **U2. Reuse before you add.** Look in the repo's controls directory first. Never borrow a
  control's class recipe or reach its headless library around it. A bare `<button>`,
  `<input>`, `<select>` or `<textarea>` dressed as an existing control is a defect; a raw
  element is right for a row, tab, resize handle, swatch, terminal or editor surface.
- **U3. Style from the theme.** Colours are semantic tokens, never the raw palette; values sit
  on the theme scale and only layout takes an arbitrary value; class strings stay static so
  tools can read them. Global CSS holds only what component classes cannot say; a static
  inline `style` is a class.
- **U4. State marks stay visible.** Focus and selection indicators paint inside their element
  or are proven visible where an ancestor clips. Check a changed indicator on a light and dark
  state sheet, not by reading classes.
- **U5. Nothing repaints while idle.** A looping animation runs only while its state exists,
  stops under reduced motion and pauses while hidden. No `requestAnimationFrame` loop or timer
  that exists only to drive visuals.
- **U6. Every actionable element shows its states.** Anything clicked, toggled or dragged has
  the matching cursor (pointer to click, resize or grab to drag, none when disabled), hover,
  focus-visible, active and disabled (loading when async). Its hit area includes its padding,
  and a control the user needs is visible without hover. Set them once in the shared control
  or the base layer; a raw element allowed by U2 (row, tab, resize handle) sets its own. Why: a
  missing `cursor-pointer` was reported on six separate days. Eye pass in `frontend-design-bar`.
- **U7. A mock is matched by measurement.** For a screen built from a mock or reference, diff the
  computed styles of both per surface (padding, gap, size, radius, hover and focus colours) and
  fix every delta or list it as an accepted difference; side by side per W20, never by eye
  alone or token-only. Doc only.
