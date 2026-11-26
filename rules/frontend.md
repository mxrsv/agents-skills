# Frontend (FE-rules)

Every UI surface: web app, dashboard, landing, desktop native, HTML mock. Written from the owner's
interview and prompt history on 2026-11-19 (spec `~/.claude/docs/specs/2026-11-19-frontend-rules-rewrite.md`).
A product's own colours, fonts and background live in that repo's `DESIGN.md`; this set holds only what
every product shares. The repo's `AGENTS.md` / `DESIGN.md` win where they say otherwise.

- **FE0. Read the rulebook first.** Before drawing a mock, building or changing UI, or reviewing UI, read
  skill `kyant-ui-rules` in full. The lines below are its summary, not a substitute.
- **FE1. Start from a reference.** No direction yet → ask the owner for a reference, then render 2–3
  directions that follow it on a mock with switches. Per screen, write what the eye must hit first and second.
- **FE2. One scale.** Spacing, type size, control height, radius and icon size come from the app's tokens; no
  hand-typed numbers in screens. No scale yet → a specimen sheet the owner approves before any screen. Never
  change letter-spacing, line-height or a size nobody asked for. One fix → fix every site, report "changed N of M".
- **FE3. Few words.** Icon, progress, meter or ring before a label or a sentence. At most two text styles in a
  card. The key figure is larger and brighter than its label.
- **FE4. Colour has a job.** Controls, frames and tabs are neutral. Colour sits on data, on state, and on one
  identity tone per category. State icons are always coloured: green ok, orange warning, red critical.
- **FE5. No stock controls.** Only the repo's own controls, never a library's default skin. One real icon
  library, icons unboxed. No focus ring except a soft one on text inputs. Everything interactive has pointer,
  hover, active, disabled, loading and a full hit area. Decoration without a job is removed.
- **FE6. Stable, airy layout.** Group by background step and space, not divider lines. Regions have fixed or
  bounded sizes: changing data, a warning or a reorder never shifts the layout; transient messages use a toast.
  Every async element or list has pending (at the control that started it), empty, error and done.
- **FE7. Stay in place.** Primary actions are visible where the user acts; hover, tooltip and menu hold only
  secondary ones. Detail opens in place; selecting never jumps page or starts work. Overlays close on outside
  click and Esc. Every write has Undo; a destructive write that cannot be undone confirms, naming target and
  consequence.
- **FE8. Little motion.** Smooth transitions, count-ups, filling bars; at most one big moment; no idle loops; no
  scroll-bound effects unless asked.
- **FE9. Show, check, then ask.** Mocks use `~/.claude/templates/mock-shell.html`, draw or declare every page × state (how much is drawn scales
  with the mock's scope: FE-P2/P2b), take icons from the app's real library, and drop unpicked options after a pick. Before inviting the owner: break-test with
  worst-case data, then screenshot the owner's own runtime beside the mock and report per surface. Open the
  artifact yourself. Change exactly what was named. The owner's eye approval comes before push or merge.
- **FE10. Process rules in the skill.** Redesign (FE-P8), replacing a surface region by region behind a dev-only
  switch (FE-P9), numbers shown to users (FE-D3). Decisions surviving handoffs stay in W20.
