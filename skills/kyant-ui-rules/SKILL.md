---
name: kyant-ui-rules
description: The owner's UI rulebook for every product — direction, scale, text, colour, controls, layout, interaction, motion, data display and the mock → build → review process. Read in full before drawing a mock, building or changing any UI (web app, dashboard, landing, desktop native, HTML mock), or reviewing one. `CLAUDE.md` and `~/.claude/rules/frontend.md` make this mandatory. Not for a product's own colours, fonts or background (those live in the repo's DESIGN.md).
---

# kyant-ui-rules

Every rule comes from the owner. The source and the owner's own words for each rule live in
`~/.claude/docs/specs/2026-11-19-frontend-rules-rewrite.md` (section "Rule provenance"). A repo's
`AGENTS.md` / `DESIGN.md` win where they say otherwise.

How to use: read it all once per task. While building, check each surface against the section it touches.
Before inviting the owner, walk section 9 (Process) in order. Decisions surviving handoffs (traceability table, "make it like X") stay in
skill `decision-traceability`.

## 1. Direction (S)

- **Reference first, then directions.** No direction yet → ask the owner for a reference (app, screenshot,
  site). Then render 2–3 directions that follow it, differing in layout, not only colour, on a mock with
  switches. Never build from adjectives alone.
- **First glance is written down.** Before drawing a screen, write what the eye must hit first and second.
  That item is the largest or most contrasting thing on the screen.
- **Product taste stays in the repo.** Brand colour, font, light/dark and background come from the repo's
  `DESIGN.md`. None yet → ask, do not import another product's taste.

## 2. Scale and spacing (SP)

- **One scale per app.** Spacing, type size, control height, radius and icon size come from tokens. A screen
  holds no hand-typed number.
- **Lock the scale before screens.** A repo without a scale gets a specimen sheet (type, spacing, controls in
  every state) that the owner approves before any screen is drawn.
- **Fix one, fix all.** When the owner points at one spacing, size or style fault, search the whole app for
  the same fault, fix every site and report "changed N of M", naming each skipped site and why.
- **Leave defaults alone.** Never change letter-spacing, line-height, font size or weight that nobody asked to
  change.
- **Airy, grouped by fill.** One idea per block, generous space. Groups separate by a background step and
  spacing, not divider lines.

## 3. Text (T)

- **Picture before words.** State and figures show as icon, dot, meter, ring or progress first; a word only
  where no icon is clear or a risk must be unmissable. Icon-only controls keep an accessible name and a tooltip.
- **Two text styles per card.** One prominent style plus one quiet style. No bolded single number inside a
  quiet line.
- **The figure leads.** The key number (and its unit when the unit is the point) is larger and brighter than
  the label beside it.

## 4. Colour (C)

- **Neutral by default.** Buttons, frames, tabs, chips and inactive items are neutral.
- **Colour has one of three jobs.** Data, state, or the identity tone of a category (its chip, icon and data
  marks). Never one hue for everything.
- **State icons are coloured.** Green ok, orange warning, red critical; never a grey state icon.
- **Tones sit in one band.** Category tones share lightness and saturation, never collide with the state
  colours, and are not loud: render them side by side on the real background before using them.

## 5. Controls and icons (K)

- **Only the repo's controls.** Every button, input, select, toggle comes from the shared control set. No set
  yet → build it first and get specimen approval.
- **No default skin.** A UI library may be used, but its controls are reshaped (radius, padding, fill,
  structure), not only recoloured.
- **One real icon library.** One set, one stroke and weight, licence known. No emoji, no ASCII stand-ins
  (`>_`, plain arrows). Entities with a logo (agents, tools, providers) show the logo. A mock draws its icons from that same library and notes the symbol name beside each; a hand-drawn stand-in is labelled as one, so the owner never approves a shape the build cannot ship.
- **Icons stand alone.** No permanent box or border around an icon; a small soft background appears only on
  hover of that icon. No stacked hover layers.
- **No focus ring.** Buttons, rows and items get no ring; keyboard focus looks like hover. Only text inputs get
  a soft ring.
- **Every interactive element shows it.** Pointer cursor, hover, active, disabled, and loading when async. The
  hit area is the whole row, label and padding. Charts show a tooltip on hover.
- **Decoration needs a job.** A border, frame, picture, button or label with no job is removed. Borders that
  remain are faint and consistent.

## 6. Emphasis and layout (E, L)

- **Active and primary are obvious.** The active or focused item and the primary action are found at a glance.
- **Secondary stays quiet.** Cancel, secondary actions and inactive items never compete with the primary.
- **Layout does not move.** Regions have fixed or bounded sizes. Changing data, a long or short name, a
  warning, a reorder or a smaller window never shifts or overflows the layout. Transient messages go in a toast.
- **Every state exists.** Each async element or list has pending (on the control that started it), empty,
  error, hover and done.

## 7. Interaction (I)

- **Primary actions are visible.** Where the user acts, the main actions are on screen; hover, tooltip and
  menus hold only secondary ones.
- **Stay in context.** Clicking an item opens its detail in place (popover, sheet); it never jumps to another
  page, reorders the list or starts work on selection.
- **Overlays close easily.** Every modal and popover closes on outside click and Esc.
- **Every write can be undone.** A change to the user's data offers Undo; a destructive write that cannot
  be undone gets a confirmation that names the target and the consequence.

## 8. Data and motion (D, M)

- **Form follows the question.** Choose each element's display from the question it answers; cards on one
  screen need not share one label + bar + number form.
- **Numbers come with a shape.** A figure has a meter, ring or bar beside it; the exact value can live in the
  tooltip.
- **A number shown is a number delivered.** A figure on a button or label is derived from the same source as
  the real outcome, in the right direction (used vs remaining, promised vs actual), and checked against real
  data, not a mock. Before a release, compare the shipped features with the build.
- **Little, purposeful motion.** Smooth transitions, count-ups, filling bars; at most one big moment per
  surface; nothing loops while idle; no scroll-bound effect (pin, scrub, parallax) unless asked.

## 9. Process (P)

- **Mock with switches, one shell.** A mock with anything to choose is a copy of
  `~/.claude/templates/mock-shell.html` with only its `MOCK` blocks edited; run
  `~/.claude/scripts/check-mock-shell.sh <mock.html>` before showing it. After the owner picks, remove the options
  not picked. Put this rule in every brief that asks a subagent for a mock.
- **A mock draws or declares everything; how much it draws scales with its scope.** Whatever the owner approves
  on a mock counts as decided, so no cell may stay silent: every page × state the spec lists is either drawn or listed
  in the mock's "not drawn" list with its intended behaviour. States to cover ("Every state exists"): pending, empty, error, partial,
  done, plus worst-case data (long names, empty, one and many, huge numbers) and the secondary screens the flow
  reaches. How much is drawn: one feature or one or two screens → draw every state (cheap, and a missing state is a
  large share of it); one area (e.g. all of Smart Clean) → draw the states that change layout, the shared blocks and
  the paths between screens; the whole app → draw fully one representative page per layout kind, draw the main
  state of pages that share a frame, and keep a page × state map (drawn / declared / undecided). Always, at any
  size: icons from the real library ("One real icon library"), each decision the owner settled traceable to a spec line (skill `decision-traceability`), lines
  nobody decided in "Inferred, not decided". Motion, hover, focus, keyboard and system dialogs may be declared
  instead of drawn.
- **A mock is enough when five answers are yes.** (1) Every page × state is drawn or declared. (2) Worst-case data was tried and nothing is cut or shifts. (3) Every visible thing has a real source: library icon, app block or a block marked new, a number the app can compute, illustration marked as such. (4) Every settled decision traces to a spec line and every guess sits in the Inferred list. (5) A fresh agent that did not draw it found no major gap (mock-review). Whole-app mocks add one gate: the real window beside the mock, per page and look ("Check in the owner's runtime").

- **Break it before inviting.** Feed worst-case data to the built UI and fix what breaks before the owner
  looks.
- **Check in the owner's runtime.** Stop older instances, run the owner's own dev command on the checkout they
  use (not a stray worktree or preview), screenshot each changed surface, put it beside the mock or reference,
  and report per surface what changed and what did not. Launch it with the bundled `/run` skill (model-invocable), which
  starts the app and checks the change in the running app; the owner types `/verify` for their own pass. The manual steps
  above stay only where `/run` cannot reach (native windows).
- **Open it yourself.** Every turn that leaves a mock, image, PDF or screenshot for the owner to look at, new
  or changed (by you, a script or a subagent), ends by opening it, after the last edit, with the preset or page to
  look at: `.html` or URL → `open <path|url>`, image/PDF → `open -a Preview <path>`. A dev-server URL opens only
  after the port answers. Several files → open the main one. Skip when nobody is at the machine (`claude -p`,
  subagents, night shift): put the path in the result, and the session talking to the owner opens it.
- **Change exactly what was named.** Edit the element and the aspect the owner named. When several elements
  match, name the one you will change first. A "redesign" changes structure, not only position or colour.
- **Eye approval before push.** A UI change is pushed or merged only after the owner has approved it by eye.
  In a plan, the owner picks the direction on a mock once before code, and approves the build in one batch
  after the last task.

### Redesign

Redesign of a UI surface (replacing its look, not refining it): until the new directions are rendered, read only
product truth (`PRODUCT.md`, the copy as plain text, product limits) and the owner's taste notes; do not open the
old UI's code or screenshots, the visual decisions in its specs, or its `DESIGN.md`. Missing context →
`/kyant-intent`, never filled in from the old page. First ask the owner for a reference image ("Reference first, then directions"); with one,
draw a single direction scaled to it. Without one, render at least 3 directions that differ in layout and
storytelling; then open the old page once, as a "must differ where" checklist, and drop any direction that keeps
its frame. Once the owner approves a mock, grill intent (which parts work for real, which only show) before the
spec. Exception: parts of the old look the owner names to keep. Why: an agent that reads the old page first
rebuilds its frame.

### Replacing a surface behind a switch

Replacing an existing surface or flow (redesign, rebuild, framework migration): build it on the main branch,
region by region, behind a switch that is off outside dev builds, so the old version stays the default and main
stays releasable. Before parallel tracks start, extract the blocks several regions share into one set on main; a
block needed later lands as its own small PR before any region uses it, and no track writes its own copy. A
region cuts over only after the owner approves it by eye against the reference; that same change deletes the old
version and the region's switch. A worktree for this work carries one small PR. Exception: a replacement that fits one
reviewable PR needs no switch; a long-lived branch only when the owner asks for one.
