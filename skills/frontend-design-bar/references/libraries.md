# Libraries — the assembly toolbox (which lib for what)

Beauty comes from assembling battle-tested pieces, not hand-rolling. Pick the lib
for the job; the user does not need to name it.

| Need                                | Reach for                                           |
| ----------------------------------- | --------------------------------------------------- |
| Smooth scroll                       | **Lenis**                                           |
| Scroll-triggered motion, pin, scrub | **GSAP + ScrollTrigger**                            |
| Split / kinetic text                | **SplitType** (or GSAP **SplitText**)               |
| Reveal-on-scroll (no dep)           | **IntersectionObserver** + CSS transition           |
| Spring / gesture motion (React)     | **Motion / Framer Motion**                          |
| Tween engine (vanilla)              | **GSAP**, or **Motion One** (lightweight)           |
| 3D / WebGL hero                     | **three.js**, **OGL** (tiny), **react-three-fiber** |
| Shader / gradient mesh              | custom GLSL, or a mesh-gradient lib                 |
| Vector animation (designed)         | **Lottie**                                          |
| Particles / flow fields             | tsParticles, or canvas + custom                     |
| Icons                               | **lucide**, or hand-drawn SVG for character         |
| Charts (designed, not stock)        | visx / D3 for control, styled heavily               |

Notes:

- Prototype with CDN builds (jsdelivr/unpkg); productionize with the package + tree
  shaking.
- Heavy libs (three.js) → lazy-load / behind reduced-data + reduced-motion guards.
- Every lib-driven effect still honors `prefers-reduced-motion`.
- Don't add a lib for something a few lines of CSS/IntersectionObserver already do.
