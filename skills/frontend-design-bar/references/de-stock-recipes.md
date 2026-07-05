# De-stock recipes — bend the cliché off its default skin

Keep the recognizable base; bend ONE+ axis (motion / color / shadow / blur / edge /
composition / how SVG-icon-image-video combine). Concrete recipes proven in the
Fluxion/Aura prototype.

## Square grid background → drafting field

Stock 4-layer `linear-gradient` square grid = "quốc dân". Instead:

- **Crosshair ticks** at each node (tiny `+` via an inline SVG data-URI pattern),
  not full square lines → CAD/instrument feel.
- One set of hairline major rules underneath (very low alpha).
- **Radial/horizontal mask** so it fades at edges (vignette, not wallpaper).
- Slow **drift** of `background-position` (~26s) so it breathes.
- A faint **accent light sweep** (`::after`, diagonal gradient, `background-position`
  animation ~8.5s) crossing the field like a plotter pass.
- A soft **accent bloom** radial near the focal artifact (ties bg to the accent).

## Flat button → signature CTA

- Ink at rest; on hover an **accent wipe** crosses on a **slanted edge**
  (`::before`, `translateX(-110%) skewX(-14deg)` → `translateX(0) skewX(0)`,
  `z-index:-1` + `isolation:isolate` so the label stays on top).
- Arrow slides (`translateX`), micro lift, shadow tinted in the accent.

## Generic card → engineered card

- **Corner ticks** (registration marks) at TR/BR.
- On hover: an **accent top-rule draws in** (`::before` `scaleX(0)→1`), lift +
  shadow, border fades to transparent.

## Logo wall → engineered trust strip

- Chains/partners as **mono labels** with a **crosshair tick** separator (the motif),
  not a row of logos.

## Static line / connector / route → living diagram

- **Smooth bezier** path (no stiff polyline angles).
- Layer: soft **glow underlay** (blurred duplicate) → solid line that **draws in**
  (`pathLength=1` + `stroke-dashoffset`) → a **flowing comet** (`stroke-dasharray`
  in normalized units + animated `stroke-dashoffset`).
- A **packet** travels via `offset-path` with a glow + **halo** + ring; **node
  ripple** (`r`+opacity keyframe) where it lands.
- Gotcha: gradient-clip text can't be SplitType'd — reveal as one unit.

## Default nav link → underline scaleX

- `::after` 1px accent line, `transform: scaleX(0)→1` from `left` on hover.

## Plain stat row → ledger

- Oversized display-serif numbers, **accent unit** (`fps`/`%`/`B`), hairline
  dividers, mono uppercase labels.

## Browser scroll jump → designed scroll

- Smooth scroll (Lenis) + **reveal-on-scroll** (IntersectionObserver adds `.is-in`
  → CSS transition translateY+opacity, stagger via `--i`) + bg drift/parallax.

> Every recipe MUST honor `prefers-reduced-motion` (freeze kinetics, keep the
> end-state resolved). See `motion.md`.
