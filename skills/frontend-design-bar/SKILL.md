---
name: frontend-design-bar
description: Use when building, reshaping, or reviewing any web UI (landing page, hero, dashboard, component, marketing site) and it must look designed, not generated. Triggers — a UI that reads flat, generic, templated, or static; calling UI "done" from code/build/TypeScript without looking at a screenshot; deciding whether a design is good enough to ship; prototyping a new template or hero.
origin: user
---

# Frontend Design Bar

The non-negotiable quality bar a UI must clear before it counts as "done".

**Core principle:** Beauty does NOT come from basic generated code. It comes from
**assembly** — motion, supporting libraries, rhythm, contrast, depth, overall feel —
and it is **judged by eye, not by code**. A compiler cannot tell whether a UI is
beautiful; a green build proves nothing about design.

**Violating the letter of this bar is violating the spirit of it.** A
structurally-correct landing made of stacked correct sections still fails if it
reads as generated.

## Clarify First — Hard Gate

<HARD-GATE>
Do NOT write code, scaffold, generate a skeleton, or apply any treatment until BOTH
are locked: (1) the DIRECTION/intent (idea — what/why), and (2) the DEMO SURFACE the
user will review on. If either is missing or ambiguous, STOP and ask — never infer
silently. Exception: edits with no design/behavior ambiguity and no new review surface
needed (typo, copy string, an already-specified value changed per explicit user
instruction) may proceed directly.
</HARD-GATE>

**Ask whenever ambiguous — one question at a time.** Mirror the `brainstorming`
discipline: one focused question per message, prefer multiple-choice, don't overwhelm.
Keep asking until intent + demo surface are unambiguous; only then start building. "This
looks obvious, I'll just start" is the exact rationalization this gate exists to stop.

_Ambiguous_ = an adjective-only brief ("modern / clean / bold") with no concrete
reference or compositional thesis — see `references/pipeline.md` Phase 0 gate. This text
Q&A locks WHAT (intent) and WHERE (demo surface); it is SEPARATE from Phase 0's Gu Offer
(`references/pipeline.md`), which resolves HOW-IT-LOOKS via generated specimens when no
reference exists — don't conflate the two.

**Always present the demo-surface options and let the USER pick** (never choose silently):

| Option              | What it is                                                                                                                                                                                   | Best when                                                                                        |
| ------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------ |
| **HTML demo**       | Standalone static HTML/CSS mockup, throwaway                                                                                                                                                 | Fast look-and-feel exploration, greybox, or a Phase-0 direction specimen — medium-free artifacts |
| **Page-route demo** | A route on the dedicated **demo server** — same stack/framework as production (e.g. React), but a server SEPARATE from the production app; see `references/pipeline.md` "The review surface" | Reviewing Treatment / Motion / Final — in-stack so you judge the artifact that actually ships    |

Reconcile with Rule 0 + "The review surface" (`references/pipeline.md`): an HTML demo of
a React app is a DIFFERENT artifact — fine for greybox / direction specimens, but
Treatment / Motion / Final MUST be reviewed in-stack on the demo server (separate from
production, promote-then-clear), else you judge the wrong thing.

## When to Use

- Building or reshaping any web UI that needs to feel intentional, not templated.
- Reviewing whether a design is good enough to ship.
- Prototyping a new template, hero, or signature screen.
- The UI works but reads flat / generic / static / one-note.

**Use alongside** `frontend-design-direction` (pick the direction) — this skill is
the gate the result must pass. Project-specific gate docs (e.g. a `PRODUCTION-BAR`)
implement this bar locally; this is the portable standard.

## The Bar (check by eye on a rendered screenshot, not by reading code)

**Concept & focal**

- [ ] ONE signature concept, statable in a single sentence. Can't? Direction is still blurry — stop and sharpen it.
- [ ] Clear focal artifact in the hero (3D/canvas/art/chart/product), not text on an empty void. If the hero looks like every other hero, it fails.
- [ ] Swap-test: swapping text + color must NOT turn it into a generic, interchangeable template. If it does, the design is too weak.

**Assembly & craft (the non-negotiable layer)**

- [ ] Real craft assembled — motion library + custom/generated assets + smooth scroll + kinetic/magnetic interaction. NOT hand-rolled basic CSS.
- [ ] Layered depth: background → blocks → detail → interaction → motion. Background carries emotion, not just a fill.
- [ ] Motion with restraint: the _right_ effect, right place, right rhythm — not many effects. ≥1 moment that makes the viewer stop.

**De-stock — no element ships in its default skin**

- [ ] Every common element (grid, card, button, input, divider, badge, section) is CUSTOMIZED so it reads as authored, not framework/Dribbble default. A stock square grid, a flat default button, a plain card = unfinished.
- [ ] Customize across the full toolbox, not one axis: animation, non-default color/gradient, shadow, blur, border/edge treatment, composition, and how SVG/icon/image/video are combined.
- [ ] Take the cliché and bend it: square grid → crosshair-tick / scan / masked field; flat button → fill-sweep + arrow slide + micro-shadow; generic card → layered depth + signature hover. The recognizable base is fine; shipping it unbent is not.
- [ ] Scroll is a design surface: smooth scroll, parallax at differing speeds, reveal-on-scroll — not the browser default jump.

**Rhythm & hierarchy**

- [ ] Visual rhythm connects sections; every section earns its place (no filler, no `Feature One` / lorem / zeros).
- [ ] CTA pops within a 3-second glance: one primary CTA + one dominant headline, the rest recedes.
- [ ] Typography has personality + clear hierarchy (no safe defaults). Spacing is intentional, not machine-even. Accent used as a system (2–3 meaningful spots + consistent states).

**States & responsive**

- [ ] Mobile is its own design, not a squished desktop. Hover / focus / responsive states are part of the design, not extras.

## Workflow

The full build process is the canonical pipeline (Direction → Tokens → Skeleton →
Treatment → Motion → Harden, with **Rule 0 — the eye-review gate** governing every
phase). Read `references/pipeline.md` before building — don't work from memory.

## Red Flags — STOP

- **Starting to build while direction OR demo surface is still ambiguous** — STOP and ask (one question at a time), never infer. Only a typo / copy string / pre-specified value skips the gate. See "Clarify First — Hard Gate".
- About to call UI "done" without looking at a screenshot/recording.
- Hand-rolling basic CSS instead of assembling motion lib + custom assets.
- Can't describe the standout point in one sentence.
- Hero is text on a void; everything centred, flat, one-note.
- Shipping a stock element (square grid, default button, plain card) in its default skin.
- **Committing a generic skeleton** (centred hero, 3-col grid, stacked sections) because composition got deferred to "treatment" — composition is STRUCTURE committed at generate-time, and Treatment can't un-generic it. Set it in Phase 2a (offer 2-3 divergent greyboxes, USER picks) before content. See `references/pipeline.md` Phase 2a + `references/composition-recipes.md`.
- **Accepting the median/default on any lever** (tracking, leading, pure-black text, default radius) — set each on purpose. See `references/treatment-levers.md`.
- **Applying a design/treatment as final without the user's eye-review** — an LLM can't judge beauty; render is for review, not for declaring done. See `references/pipeline.md` Rule 0.
- **Reviewing in a lower-fidelity medium than ships** (an HTML mockup of a React app) — you'd judge the wrong artifact. Eye-review Treatment / Motion / Final in-stack; only a greybox is medium-free; a spike is ported back + re-reviewed in-stack. See `references/pipeline.md` Rule 0 + "The review surface".
- **Clearing a variant from the demo server before promoting the pick** into the real artifact — the demo surface is ephemeral; promote first, then delete, else the decision is lost. See `references/pipeline.md` "The review surface".
- Mobile is just the desktop squished.

## Rationalizations → Reality

| Excuse                                                                | Reality                                                                                                                                                                                                                                                                                                                                                                                                                     |
| --------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| "TypeScript/build passes, so it's done"                               | Compilers can't see beauty. Not done until a full-page screenshot is attractive.                                                                                                                                                                                                                                                                                                                                            |
| "It's structurally correct"                                           | Structurally-correct ≠ designed. Stacked correct sections still read as generated.                                                                                                                                                                                                                                                                                                                                          |
| "Static CSS mockup is fine for now"                                   | Static CSS-blob mockups are 'temporary/generic' — assemble the real craft layer before calling it the design.                                                                                                                                                                                                                                                                                                               |
| "I'll add motion/assets later"                                        | Motion + assembly ARE the design, not a finishing polish. Prototype rich + live first.                                                                                                                                                                                                                                                                                                                                      |
| "Looks fine in the code/diff"                                         | Judge by eye on a rendered screenshot, never by reading code.                                                                                                                                                                                                                                                                                                                                                               |
| "One big hero headline is enough"                                     | If the hero looks like every other hero, it fails. Needs a focal artifact + signature concept.                                                                                                                                                                                                                                                                                                                              |
| "A standard grid / button / card is fine"                             | If an element looks like the framework or Dribbble default, it's not done. De-stock it with animation, color, shadow, blur, composition, or media — give it its own line.                                                                                                                                                                                                                                                   |
| "I'll set the tracking/leading/opacity to a sensible default"         | The default IS the median that reads as generic. Each lever is a deliberate decision; surface the value as a treatment spec and let the user steer it.                                                                                                                                                                                                                                                                      |
| "I applied the change, here's the result"                             | Applying then declaring done skips the eye-review gate. You can't judge beauty. Propose → user steers → apply → render → the user reviews. Never the agent's call.                                                                                                                                                                                                                                                          |
| "The skeleton is just structure; I'll make it look good in treatment" | Composition IS the macro aesthetic lever and is committed at generate-time — Treatment only decorates elements, it can't un-generic a centred-stack skeleton. Commit composition in Phase 2a (offer divergent greyboxes, user picks) before content.                                                                                                                                                                        |
| "I'll mock it up in HTML to preview, then build the React version"    | An HTML mockup of a React app is a DIFFERENT artifact — you'd review the wrong thing. Exceptions are medium-free: a greybox, and a **Phase-0 gu/direction specimen** (the generated cousin of a reference / mood-board) — both are fine in static HTML even for a React target. Spikes iterate standalone then port back + re-review in-stack; Treatment / Motion / Final are reviewed in-stack on a dedicated demo server. |
| "The direction is probably X, I'll just start"                        | Ambiguity means STOP and ask — one question at a time until intent + demo surface are locked. Never infer silently; only a typo / copy string / pre-specified value skips the gate.                                                                                                                                                                                                                                         |

## Reference files (read on demand)

This SKILL.md is the lean gate. The depth lives in `references/` — read the file
that matches what you're doing; don't work from memory:

| When                                                            | Read                                       |
| --------------------------------------------------------------- | ------------------------------------------ |
| The build process + the eye-review gate (READ FIRST)            | `references/pipeline.md`                   |
| Treating type/buttons; fonts; lever values; "looks unprocessed" | `references/treatment-levers.md`           |
| An element looks stock (grid/button/card/nav/scroll)            | `references/de-stock-recipes.md`           |
| Adding motion, scroll, kinetic text                             | `references/motion.md`                     |
| Palette, accent system, depth                                   | `references/color.md`                      |
| Composing the page; layout has gravity / rhythm / responsive    | `references/layout.md`                     |
| Picking a composition archetype; skeleton reads generic         | `references/composition-recipes.md`        |
| Picking a lib for an effect                                     | `references/libraries.md`                  |
| Logging / reading reference examples                            | `references/gallery.md` (+ `screenshots/`) |

The user's personal taste fingerprint lives in the project memory
`frontend-taste-profile.md` — load it and design against it. When new references
arrive, distil the through-line into that memory and append entries to
`references/gallery.md`.
