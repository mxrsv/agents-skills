# Pipeline — the canonical build process (Direction → Harden)

The single source of truth for HOW to build a UI in this skill. Each gate has an
explicit owner: the **user sets the ceiling & brings taste**, the **agent executes**.
Built from the user's own pipeline (2026-06-26) + the agreed patches.

## Rule 0 — the eye-review gate (governs EVERY phase)

An LLM works in code/text and **cannot judge whether a UI is beautiful**. So:

- **Never rush to apply a design/treatment as final.** Every phase output — and every
  small decision (a treatment, a lever value, a focal swap) — passes the user's **real
  eye-review** before it stands.
- **Taste-level values are the user's call.** Surface them as a **treatment spec**
  (text — see `treatment-levers.md`); don't bake median guesses and move on.
- **Render is for review, not for declaring done.** Show it, let the user look, wait.
- **Loops are allowed, not scope creep.** A failed gate sends you BACK to a prior phase
  (e.g. Treatment reveals the accent is wrong → return to Tokens). Plan for back-edges.
- **Review at production fidelity (with two exceptions).** The render you judge must
  match what SHIPS — an HTML mockup of a React app is a DIFFERENT artifact, so judging it
  judges the wrong thing. Eye-review Treatment / Motion / Final **in-stack** (the real
  framework). Exceptions: a **greybox** (2a) is medium-free (just boxes — use the
  fastest); a **spike** the stack makes painful (WebGL / motion under SSR) may iterate in
  a throwaway isolated surface, then be **ported back + re-reviewed in-stack**. This is
  stack-agnostic; the concrete binding (which server, which route) is the project's call.
- **Run "offer N → pick" gates on the self-cleaning review surface** (below) and
  **promote the pick BEFORE clearing** — never delete a variant until the decision lives
  in the real artifact.

## The review surface — a self-cleaning demo server (every "offer N → pick" gate)

The gates that offer **N variants → USER picks** (Phase 0 gu directions, Phase 2a
composition, 3 treatment, 4 motion) share ONE surface: a **dedicated localhost demo
server, separate from the production app**. Run each round like this:

1. **Render** the round's 2-3 divergent variants onto the demo server — only this round's
   variants live there.
2. **USER picks** by eye.
3. **Promote first, THEN clear.** Promote the picked variant into the real artifact
   (production route / spec) BEFORE deleting anything — the demo server is ephemeral, so
   a pick not promoted is a pick LOST.
4. **Remove** the round's variant code from the demo server, freeing the space for the
   next gate's variants.

Why: the surface stays clean (the eye isn't polluted by dead variants — only the current
comparison shows), decisions accumulate in the real artifact (not the scratch surface),
and the same surface hosts the spikes (focal / motion) the production stack makes painful
to iterate. Fidelity rule (Rule 0) still holds: in-stack for Treatment / Motion / Final,
medium-free for greybox, port-back-and-re-review for spikes.

## Carried from the start (constraints, not a final-phase audit)

- **Budgets** — perf, motion, a11y baseline. Set in Phase 0, only _verified_ in Phase 5.
  A heavy focal / scroll-jack has consequences; don't discover them at harden.
- **Restraint map** — where it may go loud vs must stay quiet (intensity). Gates
  **Treatment (3)** and **Motion (4)**, not only motion.
- **Compositional thesis** — the signature layout move (where the focal sits;
  grid-break / asymmetry / overlap). A SEPARATE artifact from restraint — intensity ≠
  structure. Gates **Skeleton (2a)**, the phase that commits composition. Do NOT let the
  composition map skip the very phase it governs (the old bug: it gated 3 + 4 but not 2).
- **Responsive is design, not harden** — ≥2 breakpoints (mobile + desktop) are part of
  the **Skeleton** and **Treatment** gates, never deferred to Phase 5.

## Phase 0 — Direction (USER)

Curate **3-5 concrete references** + art-direction brief + **restraint map** (loud vs
quiet) + **compositional thesis** (one line: the signature layout move — where the focal
sits, grid-break / asymmetry / overlap; a SEPARATE artifact from restraint) +
voice & key copy + budgets. Set the ceiling before any code.
References-first: different-looking refs are BETTER — the through-line is the taste
signal; extract the **system**, don't clone the skin. Log to memory
`frontend-taste-profile.md` + append to `gallery.md`.

### Phase 0 — Gu offer (AI offers 3-5 divergent gu specimens → USER picks)

When the user has **no reference at hand**, or wants to **explore the aesthetic** before
committing, don't stall on references-first — generate them. The AI OFFERS **3-5 clearly
DIVERGENT "gu" (design-direction) specimens** as runnable **HTML demos** on the review
surface; the **USER picks the lane by eye**. Each specimen is a full hero rendered in a
distinct design language (palette + type + texture + focal style + composition + mood).
Hold the **content identical across all of them** so ONLY the aesthetic varies — a clean
swap-test that isolates taste from copy. This is the aesthetic twin of Phase 2a's "offer
divergent greyboxes": forcing divergence beats self-grading (Rule 0 — an LLM can't judge
"is this generic", but it CAN spread its generative range; the USER's eye is the judge).
No reference still means 3-5 specimens (range substitutes for an anchor).
These specimens are **throwaway DIRECTION artifacts** (the generated cousin of references
/ a mood-board), NOT the shippable build — so the medium (static HTML) is fine here even
for a React target, exactly as a greybox is medium-free. The picked gu then **locks into
Phase 1 tokens** and is rebuilt + re-reviewed **in-stack**; promote the pick (distil the
lane into `frontend-taste-profile.md` / the token draft) BEFORE clearing the losers.
**Gate (USER eye-review, per-breakpoint):** the picked lane is non-interchangeable, the
focal style reads on purpose, and the user can state the through-line in a sentence.

**Gate:** the brief describes concrete **treatment** AND a concrete **compositional
thesis**, not adjectives. "Modern / clean / bold" is not a thesis.

## Phase 1 — Tokens: lock the CONTRACT, draft the VALUES (AI proposes → USER steers)

- **Lock now (contract):** everything routes through **named semantic tokens** (accent,
  surface-0..3, type scale, spacing, elevation, named ease). **Kill raw defaults in the
  toolchain** (lint blocks `indigo-600` / default `ease`). This is the strongest lever —
  keep it early; it stops the toolchain silently filling median values during skeleton.
- **Soft now (values):** the values inside tokens are **DRAFT, expected to change**.
  Structural tokens (spacing / scale / elevation) may firm early; **expressive tokens
  (exact accent OKLCH, easing, texture) stay soft** — they are the most taste-sensitive.
- **Hard-lock + value-lint only AFTER Phase 3** validates them by eye in real context
  (or _ratchet_: lock each token once it's proven). Why: a token only proves right when
  SEEN in treatment, not as a swatch — locking values early ossifies a guess.
  **Gate:** eye-review the contract + the draft palette/scale. Do NOT hard-lock values yet.

## Focal track (PARALLEL — the highest-risk item, start at Phase 0/1)

The signature focal (3D / iridescent object, volumetric light, polished data-viz) has
the **longest lead time + most craft** (esp. WebGL). Spike it **in parallel** with the
skeleton, gate it by **video**, and **define a fallback early** (if it doesn't reach the
bar in N iterations, drop to X). Don't bury it inside "treatment" or "motion", and don't
let it become a black hole that blocks everything.

## Phase 2 — Skeleton (split: 2a Composition → 2b Fill)

Composition is committed at DOM-generate time and Treatment (element-level) can't undo a
generic skeleton — so composition is its OWN gated sub-phase BEFORE content, mirroring
Phase 4's proven "offer variants → USER picks by eye" pattern. **Composition is
STRUCTURE, not polish** — placement, proportion, grid-break, overlap, focal seat are
Skeleton scope; color / texture / type-micro are Treatment (3). (Composition is NOT a
parallel track like the focal — it is BLOCKING-upstream; everything downstream sits on
it, so it gates sequentially before content.)

### Phase 2a — Composition (AI offers 2-3 divergent greyboxes → USER picks)

Greybox = block-level layout only (boxes + focal seat), NO real content, NO style — the
cheapest fidelity at which to commit composition. The AI offers **2-3 clearly DIVERGENT
greyboxes** anchored in the references + `composition-recipes.md` + `layout.md`; the
**USER picks by eye**. Forcing divergence beats self-grading — an LLM can't judge "is
this generic" (Rule 0), but it CAN spread its generative range; the USER's eye is the
judge. No reference? Still offer 2-3 divergent greyboxes (range substitutes for anchor).
**Gate (USER eye-review, per-breakpoint ≥2):** does the bare greybox already read
non-interchangeable? Is the focal seated on purpose? Is it NOT a centred-stack median?
Scale to scope — required for full page / hero, skip for a sub-section element (button,
card). Read `composition-recipes.md` + `layout.md` before offering.

### Phase 2b — Skeleton fill (AI)

Pour **real content** (on-voice, from Phase 0) + **all states** (empty / loading / error /
edge) INTO the approved greybox. No polish, no motion yet.
**Gate:** static screenshot at ≥2 breakpoints; layout holds (composition already
approved in 2a); no lorem / zeros.

## Phase 3 — Treatment (AI per USER's spec, element by element)

Typography (tracking / opsz / weight / opacity / OpenType), button micro-craft,
color/texture — see `treatment-levers.md` and `de-stock-recipes.md`. The AI proposes a
**treatment spec** (explicit values); the USER steers the numbers; THEN apply.
**Gate:** eye-review **each element** against the reference + restraint map, at ≥2
breakpoints. Treatment may push values back to Phase 1 (allowed — see Rule 0 loops).

## Phase 4 — Motion (AI builds timeline → USER directs rhythm)

GSAP / ScrollTrigger / SplitType / Lenis / 3D — **only where the restraint map allows**.
The AI offers **2-3 timing/easing variants as VIDEO**; the USER picks by eye (feel >
numbers). See `motion.md`, `libraries.md`.
**Gate:** a **real video** + reduced-motion + perf budget. Never judge motion from code.

## Phase 5 — Harden + editorial

a11y, perf, cross-device **verify** (not first-discover). Final editorial pass:
_conventional or correct? one unified voice?_ Then productionize into the token/design
system (INVARIANT, Pieces) — never before the eye-approval lands.

## Honest note

AI from-scratch trends to competent-but-generic — beauty is taste, and taste needs an
anchor (references) or many iterations. References + real libs is the FAST path;
per-pixel prompting is the slow path. Push for references early.

## Maps to the assembly-layering contract

Tokens ≈ **Foundation** · Skeleton + Treatment + Motion ≈ **Pieces** · Harden +
Editorial ≈ **Final**. (`[[assembly-layering]]` — Foundation-first, eye-review each tier.)
