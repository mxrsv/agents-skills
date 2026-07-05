# Motion — language + libraries + patterns

Motion is part of the design, not a finishing polish. Restraint: the _right_ effect,
right place, right rhythm; ≥1 stop-moment; not everything moving at once.

## Smooth scroll — Lenis

```js
const lenis = new Lenis({ lerp: 0.09, wheelMultiplier: 1 });
lenis.on("scroll", () => ScrollTrigger.update());
gsap.ticker.add((t) => lenis.raf(t * 1000));
gsap.ticker.lagSmoothing(0);
```

## Scroll-triggered — GSAP + ScrollTrigger

- Reveals: `gsap.from(el, { y: 40, opacity: 0, scrollTrigger: { trigger: el, start: 'top 88%' } })`.
- Pinned horizontal gallery: `gsap.to(track, { x: () => -dist(), scrollTrigger: { pin: true, scrub: .8, end: ()=> '+='+dist(), invalidateOnRefresh: true } })`.
- Velocity skew marquee: `ScrollTrigger.onUpdate → getVelocity()` → `gsap.to(row,{skewX})`.

## Kinetic text — SplitType (or GSAP SplitText)

- `new SplitType(el,{types:'chars'})` then stagger `yPercent:120, opacity:0`.
- **Gotcha:** never SplitType a gradient line (`background-clip:text` breaks per char
  → invisible). Reveal gradient lines as one unit (`yPercent` on the whole span).

## Custom cursor + magnetic

- Cursor follow: `gsap.quickTo(dot,'x',{duration:.15})`.
- Magnetic: on mousemove over `.magnetic`, translate toward cursor `*0.4`; reset with
  `elastic.out`.

## CSS-only motion (no lib)

- Packet on a path: `offset-path: path(...)` + `offset-distance` keyframe.
- Self-drawing line: `pathLength=1` + `stroke-dasharray:1; stroke-dashoffset:1→0`.
- Flowing comet: normalized `stroke-dasharray: 0.07 0.93` + `stroke-dashoffset:1→0`.
- Drift/breathe: animate `background-position`; conic spin; soft `@keyframes` blink.

## Reveal-on-scroll WITHOUT a lib — IntersectionObserver

```js
const io = new IntersectionObserver(
  (es) =>
    es.forEach((e) => {
      if (e.isIntersecting) {
        e.target.classList.add("is-in");
        io.unobserve(e.target);
      }
    }),
  { threshold: 0.16, rootMargin: "0px 0px -8% 0px" },
);
document.querySelectorAll(".reveal").forEach((el) => io.observe(el));
```

CSS: `.reveal{opacity:0;transform:translateY(28px);transition:.7s} .reveal.is-in{opacity:1;transform:none}`
Stagger with `transition-delay: calc(var(--i) * 90ms)`.

## Reduced motion — ALWAYS

```css
@media (prefers-reduced-motion: reduce) {
  .reveal {
    opacity: 1;
    transform: none;
    transition: none;
  }
  /* freeze packets/flow/sweep; keep drawn lines resolved (dashoffset:0) */
}
```

## CDN (prototype)

- GSAP + ScrollTrigger: `cdn.jsdelivr.net/npm/gsap@3.12.5/dist/{gsap,ScrollTrigger}.min.js`
- Lenis: `cdn.jsdelivr.net/npm/lenis@1.1.14/dist/lenis.min.js`
- SplitType: `unpkg.com/split-type@0.3.4/umd/index.min.js`
