# Composition recipes — named layout archetypes + the move that bends them

The macro counterpart to `de-stock-recipes.md` (which bends elements). Composition is
committed at DOM-generate time; an LLM left without a named target regresses to the
median — centred hero on a void → 3-col feature grid → stacked equal sections → centred
CTA. This is the MENU to greybox against in **Phase 2a**: pick an archetype on purpose,
then bend it. Keep the recognizable base; the bend is what de-generics it. Pair with
`layout.md` (principles) — this file is the move-set.

> **Phase 2a goal:** offer **2-3 DIVERGENT greyboxes from DIFFERENT archetypes** below,
> let the **USER pick by eye**. Forcing divergence beats self-grading — an LLM can't
> judge "is this generic" (Rule 0), but it CAN spread its range. Don't ship the first
> median that compiles.

## The default to ESCAPE (name it so you can avoid it)

- **Centred-stack median:** centred hero headline on a void → full-width 3-col feature
  grid → stacked equal-weight bands → centred CTA. If your greybox is this, it FAILED
  2a. Every recipe below is an exit from it.

## Hero archetypes

- **Asymmetric split (60/40):** dominant headline + CTA on one side, focal artifact on
  the other (the skill's baseline anti-void move). Bend: let the focal BLEED off-canvas
  or oversize past the column edge so it's not a tidy two-box.
- **Off-canvas focal / margin bleed:** focal pinned to one edge and cropped by the
  viewport; copy floats in the negative space. Reads editorial, not boxed.
- **Diagonal / skewed split:** the hero divide is a slant (clip-path), not a vertical
  gutter — copy and focal sit in angled fields.
- **Single focal + margin notes:** one large artifact framed by small off-axis
  annotation blocks (specs, ticks, labels) so it reads drafted, not "text on void". The
  annotations carry the identity.
- **Stacked-layer depth hero:** focal, copy, and background field on distinct z-layers
  with overlap (copy overlaps the artifact) — depth replaces side-by-side.

## Body / section archetypes

- **Broken / editorial grid:** columns of UNEQUAL width and offset baselines (a magazine
  grid), not N equal cells. Items span different column counts.
- **Swiss / modular grid:** strict VISIBLE grid with hairline rules, oversized index
  numbers, mono labels — the grid itself is the ornament (vs an invisible 3-col).
- **Overlap-layering:** adjacent blocks overlap at the seam (a card pulls up into the
  section above), hairline or shadow marks the overlap — kills the stacked-band rhythm.
- **Horizontal-scroll band:** one section scrolls sideways (gallery / steps / logos)
  against the vertical flow — a rhythm break. Mobile → vertical stack.
- **Asymmetric alternating (zig-zag):** sections alternate weight side-to-side with a
  through-line element (a rule, a path, a running number) tying them — not centred rows.
- **Full-bleed alternating:** alternate inset content sections with full-bleed
  edge-to-edge sections (image / field) for a tension of contained vs released.
- **Sidebar / sticky rail:** a pinned rail (nav, progress, meta) beside a scrolling
  column — asymmetry by structure; common in docs/product, rare in landings.

## The bend (apply to whichever archetype you picked)

Once an archetype is chosen, bend ONE+ macro axis so it's not the textbook diagram:

- **Focal seat:** off-centre, bleeding, oversized, or cropped — not dead-centre.
- **Grid:** unequal columns, offset baselines, spanning items — not N equal cells.
- **Seam:** overlap / slant / hairline registration between sections — not a flat stack.
- **Negative space:** deliberate emptiness as a SHAPE, not even margins everywhere.
- **Through-line:** one element (rule, path, number, running label) crossing sections so
  the page reads as one document, not a pile of bands.

## Responsive is a SEPARATE composition (greybox BOTH breakpoints in 2a)

Mobile is not the desktop squished — re-compose it:

- multi-col grid → single column with a re-thought reading order
- horizontal-scroll band → vertical stack
- side-by-side hero → focal-above-copy, or focal-as-background
- sticky rail → top bar or inline

## Gate (Phase 2a — USER eye-review, per-breakpoint)

- Could this bare greybox be ANY template? → fail; pick / bend harder.
- Is the focal seated on purpose (not dead-centre by default)?
- Is there ONE dominant read, then second, then third?
- Does a through-line connect the sections, or is it a stack of bands?
- Are BOTH breakpoints greyboxed and intentional?

> Scale to scope: required for a full page / hero; skip for a sub-section element
> (single button, single card) — don't tax small tasks with a greybox round-trip.
