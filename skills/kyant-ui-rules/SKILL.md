---
name: kyant-ui-rules
description: The owner's UI rulebook for every product — direction, scale, text, colour, controls, layout, interaction, motion, data display and the mock → build → review process. Read in full before drawing a mock, building or changing any UI (web app, dashboard, landing, desktop native, HTML mock), or reviewing one. Rule FE0 in ~/.claude/rules/frontend.md makes this mandatory. Not for a product's own colours, fonts or background (those live in the repo's DESIGN.md).
---

# kyant-ui-rules

Every rule comes from the owner, on 2026-11-19: the interview (R1–R5) or the analysis of 1,497 UI prompts the
owner typed between 2026-08-01 and 2026-11-19 (A1–A20). Source and the owner's own words sit under each
rule, so a rule can be weighed instead of obeyed blindly. Spec and traceability:
`~/.claude/docs/specs/2026-11-19-frontend-rules-rewrite.md`. A repo's `AGENTS.md` / `DESIGN.md` win where they
say otherwise.

How to use: read it all once per task. While building, check each surface against the section it touches.
Before inviting the owner, walk section 9 (Process) in order. IDs carry the `FE-` prefix so they never
collide with the C-, D- or W-rules. Decisions surviving handoffs (traceability table, "make it like X") stay in
W20 in `~/.claude/rules/core/workflow.md`.

## 1. Direction (S)

- **FE-S1. Reference first, then directions.** No direction yet → ask the owner for a reference (app, screenshot,
  site). Then render 2–3 directions that follow it, differing in layout, not only colour, on a mock with
  switches. Never build from adjectives alone. *R1 "Cả hai"; A12 ~34 lines "trông khá default", "kiểu agent generic".*
- **FE-S2. First glance is written down.** Before drawing a screen, write what the eye must hit first and second.
  That item is the largest or most contrasting thing on the screen. *R4; A5 "phải có tính toán khi user vào app
  nhìn vào đâu đầu tiên".*
- **FE-S3. Product taste stays in the repo.** Brand colour, font, light/dark and background come from the repo's
  `DESIGN.md`. None yet → ask, do not import another product's taste. *R1 "Repo riêng".*

## 2. Scale and spacing (SP)

- **FE-SP1. One scale per app.** Spacing, type size, control height, radius and icon size come from tokens. A screen
  holds no hand-typed number. *R4; A1 ~63 lines, the most repeated complaint: "cứ phải chỉnh từng tí một".*
- **FE-SP2. Lock the scale before screens.** A repo without a scale gets a specimen sheet (type, spacing, controls in
  every state) that the owner approves before any screen is drawn. *R4.*
- **FE-SP3. Fix one, fix all.** When the owner points at one spacing, size or style fault, search the whole app for
  the same fault, fix every site and report "changed N of M", naming each skipped site and why. *R4; was W21.*
- **FE-SP4. Leave defaults alone.** Never change letter-spacing, line-height, font size or weight that nobody asked to
  change. *R4; A13 "giữ nguyên tỉ lệ letter spacing default của text đừng chỉnh sửa khi tôi không yêu cầu".*
- **FE-SP5. Airy, grouped by fill.** One idea per block, generous space. Groups separate by a background step and
  spacing, not divider lines. *R3; activity "không phải cái gì cũng ngăn cách bằng các đường line… ưu tiên các block riêng lẻ".*

## 3. Text (T)

- **FE-T1. Picture before words.** State and figures show as icon, dot, meter, ring or progress first; a word only
  where no icon is clear or a risk must be unmissable. Icon-only controls keep an accessible name and a tooltip.
  *R2; A8 ~43 lines "tại sao bạn luôn thêm những cái dòng text dư thừa này làm gì ?".*
- **FE-T2. Two text styles per card.** One prominent style plus one quiet style. No bolded single number inside a
  quiet line. *R2; A13 "trong 1 card chỉ dùng 2 loại chữ khác nhau thôi".*
- **FE-T3. The figure leads.** The key number (and its unit when the unit is the point) is larger and brighter than
  the label beside it. *R4; A5 "số size lớn hơn nữa đi".*

## 4. Colour (C)

- **FE-C1. Neutral by default.** Buttons, frames, tabs, chips and inactive items are neutral. *R2 + R4; A2 "các tab
  này chỉ khi active mới có màu đó, còn khi không active thì để màu trung tính thôi".*
- **FE-C2. Colour has one of three jobs.** Data, state, or the identity tone of a category (its chip, icon and data
  marks). Never one hue for everything. *R4; A2 "tôi muốn dùng nhiều màu khác nhau nó sẽ dễ nhìn hơn".*
- **FE-C3. State icons are coloured.** Green ok, orange warning, red critical; never a grey state icon. *R2.*
- **FE-C4. Tones sit in one band.** Category tones share lightness and saturation, never collide with the state
  colours, and are not loud: render them side by side on the real background before using them. *R4 option
  text; A2 "màu orange và red có đang bị tươi quá không".*

## 5. Controls and icons (K)

- **FE-K1. Only the repo's controls.** Every button, input, select, toggle comes from the shared control set. No set
  yet → build it first and get specimen approval. *R2; A7 ~45 lines "đang không dùng chung 1 component à ?".*
- **FE-K2. No default skin.** A UI library may be used, but its controls are reshaped (radius, padding, fill,
  structure), not only recoloured. *R2; A12 "các button này trông khá là default ấy, AI".*
- **FE-K3. One real icon library.** One set, one stroke and weight, licence known. No emoji, no ASCII stand-ins
  (`>_`, plain arrows). Entities with a logo (agents, tools, providers) show the logo. A mock draws its icons from that same library and notes the symbol name beside each; a hand-drawn stand-in is labelled as one, so the owner never approves a shape the build cannot ship. *R2; A4 ~51 lines; owner 2026-11-21 "icon bạn để trên đó là đang demo thôi chưa dùng thư viện nào đúng không".*
- **FE-K4. Icons stand alone.** No permanent box or border around an icon; a small soft background appears only on
  hover of that icon. No stacked hover layers. *R5; A14 "không nên bọc icon trong 1 box".*
- **FE-K5. No focus ring.** Buttons, rows and items get no ring; keyboard focus looks like hover. Only text inputs get
  a soft ring. *R5; A19 "ring đang xấu đi các UI của tôi".*
- **FE-K6. Every interactive element shows it.** Pointer cursor, hover, active, disabled, and loading when async. The
  hit area is the whole row, label and padding. Charts show a tooltip on hover. *R2 + R5; A6 "app đang thiếu
  cursor pointer ở nhiều chỗ", "chỉ click được vào checkbox còn click vào text cạnh checkbox thì không được".*
- **FE-K7. Decoration needs a job.** A border, frame, picture, button or label with no job is removed. Borders that
  remain are faint and consistent. *R5; A14 "các đường border… trông chúng rất thô".*

## 6. Emphasis and layout (E, L)

- **FE-E1. Active and primary are obvious.** The active or focused item and the primary action are found at a glance.
  *R4; A5 "workspace đang focus nhìn cũng không được nổi bật".*
- **FE-E2. Secondary stays quiet.** Cancel, secondary actions and inactive items never compete with the primary.
  *R4; A5 "button cancel đang quá nổi bật".*
- **FE-L1. Layout does not move.** Regions have fixed or bounded sizes. Changing data, a long or short name, a
  warning, a reorder or a smaller window never shifts or overflows the layout. Transient messages go in a toast.
  *R5; A10 ~40 lines "phần này nếu hiển thị warning chúng đang làm lệch layout".*
- **FE-L2. Every state exists.** Each async element or list has pending (on the control that started it), empty,
  error, hover and done. *R5; A17 "pending ngay tại icon success check đó luôn".*

## 7. Interaction (I)

- **FE-I1. Primary actions are visible.** Where the user acts, the main actions are on screen; hover, tooltip and
  menus hold only secondary ones. *R5; A6 "action bị giấu, phải hover mới thấy".*
- **FE-I2. Stay in context.** Clicking an item opens its detail in place (popover, sheet); it never jumps to another
  page, reorders the list or starts work on selection. *R5; A6 "bấm vào… bị nhảy sang trang Agents, cái này tôi
  không thích vì UX bị nhảy"; "mỗi lần tôi click vào một item là nó lại thực hiện scan".*
- **FE-I3. Overlays close easily.** Every modal and popover closes on outside click and Esc. *R5.*
- **FE-I4. Every write can be undone.** A change to the user's data offers Undo; a destructive write that cannot
  be undone gets a confirmation that names the target and the consequence. *Owner approval 2026-11-19 (kept from
  the old rule set).*

## 8. Data and motion (D, M)

- **FE-D1. Form follows the question.** Choose each element's display from the question it answers; cards on one
  screen need not share one label + bar + number form. *R3.*
- **FE-D2. Numbers come with a shape.** A figure has a meter, ring or bar beside it; the exact value can live in the
  tooltip. *R3.*
- **FE-D3. A number shown is a number delivered.** A figure on a button or label is derived from the same source as
  the real outcome, in the right direction (used vs remaining, promised vs actual), and checked against real
  data, not a mock. Before a release, compare the shipped features with the build. *R5; A10 "button ghi clean là
  3,4gb mà khi clean xong lại không đạt được mức đó"; was W23.*
- **FE-M1. Little, purposeful motion.** Smooth transitions, count-ups, filling bars; at most one big moment per
  surface; nothing loops while idle; no scroll-bound effect (pin, scrub, parallax) unless asked. *R3; A18 "các
  animation không được quá đà".*

## 9. Process (P)

- **FE-P1. Mock with switches, one shell.** A mock with anything to choose is a copy of
  `~/.claude/templates/mock-shell.html` with only its `MOCK` blocks edited; run
  `~/.claude/scripts/check-mock-shell.sh <mock.html>` before showing it. After the owner picks, remove the options
  not picked. Put this rule in every brief that asks a subagent for a mock. *R3; A3 "phải có một format mockUI riêng"; "clean các option không được chọn".*
- **FE-P2. A mock draws or declares everything; how much it draws scales with its scope.** Whatever the owner approves
  on a mock counts as decided, so no cell may stay silent: every page × state the spec lists is either drawn or listed
  in the mock's "not drawn" list with its intended behaviour. States to cover (FE-L2): pending, empty, error, partial,
  done, plus worst-case data (long names, empty, one and many, huge numbers) and the secondary screens the flow
  reaches. How much is drawn: one feature or one or two screens → draw every state (cheap, and a missing state is a
  large share of it); one area (e.g. all of Smart Clean) → draw the states that change layout, the shared blocks and
  the paths between screens; the whole app → draw fully one representative page per layout kind, draw the main
  state of pages that share a frame, and keep a page × state map (drawn / declared / undecided). Always, at any
  size: icons from the real library (FE-K3), each decision the owner settled traceable to a spec line (W20), lines
  nobody decided in "Inferred, not decided". Motion, hover, focus, keyboard and system dialogs may be declared
  instead of drawn. *R5; A3 "khi tôi grilling sau đó tạo mock thì tôi không cover đến phần này… đây là vấn đề lớn khi vibe coding"; owner 2026-11-21 "còn tuỳ loại mock… mock nhiều feat hoặc ít feat", after asking for the Smart Clean cleaning and scanning screens that the spec already listed.*
- **FE-P2b. A mock is enough when five answers are yes.** (1) Every page × state is drawn or declared. (2) Worst-case data was tried and nothing is cut or shifts. (3) Every visible thing has a real source: library icon, app block or a block marked new, a number the app can compute, illustration marked as such. (4) Every settled decision traces to a spec line and every guess sits in the Inferred list. (5) A fresh agent that did not draw it found no major gap (mock-review). Whole-app mocks add one gate: the real window beside the mock, per page and look (FE-P4).

- **FE-P3. Break it before inviting.** Feed worst-case data to the built UI and fix what breaks before the owner
  looks. *R3.*
- **FE-P4. Check in the owner's runtime.** Stop older instances, run the owner's own dev command on the checkout they
  use (not a stray worktree or preview), screenshot each changed surface, put it beside the mock or reference,
  and report per surface what changed and what did not. *R4 "Bắt buộc"; A9 + A11 ~76 lines "tại sao bạn lại
  chưa build giống mock ?", "đang chạy bản dev tôi không thấy icon update đó"; was W22.*
- **FE-P5. Open it yourself.** A mock, image, PDF or screenshot built for the owner is opened as the last step:
  `.html` or URL → `open <path|url>`, image/PDF → `open -a Preview <path>`. A dev-server URL opens only after the
  port answers. Several files → open the main one. Skip when nobody is at the machine (`claude -p`, subagents,
  night shift): put the path in the result. *R5; A15 ~22 lines "mở mock tôi xem"; was W18.*
- **FE-P6. Change exactly what was named.** Edit the element and the aspect the owner named. When several elements
  match, name the one you will change first. A "redesign" changes structure, not only position or colour.
  *R5; A16 "text này chứ không phải Button", "gần như mới thay đổi vị trí, button vẫn giữ nguyên style".*
- **FE-P7. Eye approval before push.** A UI change is pushed or merged only after the owner has approved it by eye.
  In a plan, the owner picks the direction on a mock once before code, and approves the build in one batch
  after the last task. *R3.*

### FE-P8. Redesign (was W16)

Redesign of a UI surface (replacing its look, not refining it): until the new directions are rendered, read only
product truth (`PRODUCT.md`, the copy as plain text, product limits) and the owner's taste notes; do not open the
old UI's code or screenshots, the visual decisions in its specs, or its `DESIGN.md`. Missing context →
`/kyant-intent`, never filled in from the old page. First ask the owner for a reference image (FE-S1); with one,
draw a single direction scaled to it. Without one, render at least 3 directions that differ in layout and
storytelling; then open the old page once, as a "must differ where" checklist, and drop any direction that keeps
its frame. Once the owner approves a mock, grill intent (which parts work for real, which only show) before the
spec. Exception: parts of the old look the owner names to keep. Why: an agent that reads the old page first
rebuilds its frame (TinySift new look, 2026-11-16).

### FE-P9. Replacing a surface behind a switch (was W17)

Replacing an existing surface or flow (redesign, rebuild, framework migration): build it on the main branch,
region by region, behind a switch that is off outside dev builds, so the old version stays the default and main
stays releasable. Before parallel tracks start, extract the blocks several regions share into one set on main; a
block needed later lands as its own small PR before any region uses it, and no track writes its own copy. A
region cuts over only after the owner approves it by eye against the reference; that same change deletes the old
version and the region's switch. A worktree for this work carries one small PR. Exception: a replacement that fits one
reviewable PR needs no switch; a long-lived branch only when the owner asks for one.
