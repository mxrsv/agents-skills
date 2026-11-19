# UI process rules (UP-rules)

How agents build UI across several pages or surfaces. They sit beside `ux.md` (what a UI must mean)
and `ui.md` (code-level UI quality). Origin: Reins design session 2026-11-06, where five pages were
built in parallel and broke the owner's visual system. The repo's `AGENTS.md` and spec win where
they say otherwise.

- **UP1. One system, layouts differ by arrangement only.** In a multi-page UI that has an approved
  reference page or kit, a page's own CSS sets layout only (grid, flex, gap, region sizes,
  overflow, position). A page never restyles a block and adds no border, colour, font size, radius,
  shadow, gradient, looping animation or native control. A need the blocks cannot express gets a
  one-paragraph block spec (name, sizes on the grid, fill layer, states, the block it extends and why
  none fits), a specimen in the kit sheet, and the owner's eye approval before any page uses it.
  Escape: the owner explicitly asks for a new block. Tier: script in a mock kit (`check-page.sh`),
  policy test in an app (a style-boundary test); doc only elsewhere.
- **UP2. A decision belongs to the surface it was approved on.** Write the page or surface in the
  ledger line ("layout C, for Skills"). Never reuse a layout, form or component choice on another
  surface unless the owner says so. Why: "layout C looks good" was approved for one inventory page and
  cloned onto gauges, a live feed and settings. Doc only.
- **UP3. Brief by composition.** A UI brief gives the kit and block-catalogue paths, the forbidden list
  of UP1, `ux.md`, and the element sheet (question, kind, lead figure, form per element). It never says
  "do not copy another page's layout": agents then invent blocks instead of reusing them. Doc only.
- **UP4. Show the arrangement before building.** For two or more pages the owner picks each page's
  arrangement from wireframes (ASCII or one rendered sample) before any page is built; then ONE page is
  built as a test and approved before the rest run in parallel. Why: five pages were built from a list of
  words and none matched the owner's system. Doc only.
- **UP5. Run the conformance check before reporting.** The agent runs the page check (zero hits on
  forbidden properties in page CSS) and compares crops of the shared blocks (row, band, header, pane head)
  with the reference page, and pastes both results. "Looks right" is not evidence. Tier: script.
- **UP6. Verify product facts before briefing.** Facts a UI depends on (what a CLI supports, which fields
  exist) are checked against docs or real files first; unknowns are marked "unverified" in the brief and
  in the UI. Every figure or column a mock draws names the API it reads before the spec. Why: Codex hooks
  and subagent tools were assumed wrong in three briefs; a Compressed column was drawn and specified before
  anyone found macOS refuses to read it (TinySift DS79). See W13 and W23. Doc only.
- **UP7. Leave the repo and the screen clean.** Browser-tool output goes outside the repo (for example
  `/tmp`); stop dev servers before finishing; `git status` is clean of tool artefacts; mock-only controls
  (theme, accent, variant switches) never sit over the app's interactive areas. Why: `.playwright-mcp`
  landed in the repo several times and a mock panel covered the Undo button. Doc only; ignoring
  `.playwright-mcp` in the global gitignore would make it a tool-level fix.
- **UP8. A mock with anything to choose uses the one shell.** An HTML mock that offers options, states
  or themes is a copy of `~/.claude/templates/mock-shell.html` with only its two `MOCK` blocks edited,
  so every control sits in the same right-hand rail. Why: each mock put its switches somewhere else
  and the owner relearned every one. Escape: a still with nothing to switch
  (an OG card, a spec sheet); another chrome when the owner asks. Tier: script, run
  `~/.claude/scripts/check-mock-shell.sh <mock.html>` before reporting the mock.
