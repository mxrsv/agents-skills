# Treatment levers — where "super UI" actually comes from

**Core truth:** Beauty is **treatment**, not ingredients. The same plain font (Inter)
becomes Linear/Vercel-grade by navigating each element's **parameter space** with
judgment. A "fancier" font without that craft is worse. **Constraint + mastery beats
more ingredients** — great designers self-limit (one font, narrow palette) and go
deep on treatment.

**Why AI stops at "generic":** the custom space is a giant combinatorial set, but only
a tiny fraction of paths are beautiful. Lacking taste, AI picks the **median** of every
lever — default tracking, default leading, pure black text, default radius — so the
output always looks _unprocessed_. The skill IS the processing. **Never accept a default
on any lever.** Set each one on purpose.

## Division of labor (cannot be outsourced)

- The **user decides WHICH treatment** (the taste call). The **LLM executes** it.
- So: **surface treatment values as a spec** (below) for the user to steer; do NOT bake
  taste-level lever values unilaterally, and do NOT declare a design "beautiful/done."
- See `pipeline.md` → **Rule 0, the eye-review gate**: the LLM works in code/text and cannot
  judge beauty; every UI / small design decision passes the user's real eye-review
  before it stands. Render is for review, not for declaring done.

## Typography levers (one font, many decisions)

- **Tracking (letter-spacing)** — the signature of modern SaaS type. Large headings
  tighten **-0.02 to -0.04em**; small text / CAPS loosen **+0.08 to +0.18em**. This one
  lever alone decides "designed" vs not.
- **Optical sizing (opsz)** — use **Inter Display** for headings, **Inter** for body:
  same font, different proportions at large size.
- **Weight contrast** — drama lives in contrast, not size. 800 display against 400 body;
  or 100-300 thin for elegance. Pairing a font with itself by weight already reads
  "intentional" without a second font.
- **Opacity layering** — never pure black/white. Hierarchy via **100 / 70 / 40**. This
  is what separates pro from amateur.
- **OpenType features** — Inter has `tnum` (tabular), slashed zero, stylistic sets
  (`ss01`, `cv**` for single-story a, simple g). Enabling the right feature literally
  customizes the font's character.
- **Leading + measure** — heading **1.0-1.1**, body **1.5-1.7**, line length **45-75
  chars**. This is rhythm.

### Font selection & pairing

- A **display face with character**, not a system default: a confident geometric grotesk
  (Space Grotesk) or an editorial serif (Fraunces / Instrument Serif) — chosen to match
  the user's taste, never a safe default. Pair with a clean body (Inter) and **mono for
  data/labels** (JetBrains Mono). Often one font + weight contrast is enough.
- **One italic accent phrase** per headline; optionally **one gradient-clip line**
  (`background-clip:text`) — but never SplitType a gradient line (it breaks per char →
  invisible; reveal it as one unit). See `motion.md`.
- Self-contained theme carries its own faces via `next/font` CSS variables (e.g.
  `--font-display`, `--font-mono`); a repo-wide single-font lock is only for the shared
  design system, not for self-contained template themes.

## Every element is a parameter space, not a thing

A button is not "a button" — it is the joint decision of: **radius · padding ratio ·
physical shadow · hover transform · easing · border treatment · background
(solid/gradient/glass) · text weight + tracking · icon alignment · hover/active/focus
states.** Dozens of micro-decisions. Super UI = each one deliberate AND coherent, not a
special button library. The same holds for cards, inputs, nav, dividers, badges.

## The treatment-spec practice

Alongside any build, emit the **explicit lever values** so the craft is auditable and
the user can tune individual numbers. A median is an invisible default; a named value is
a decision. Example:

```
Heading   Inter Display · 800 · tracking -0.035em · leading 0.98 · ink @ 96%
Sub       Inter · 400 · tracking 0 · leading 1.6 · ink @ 64% · measure 46ch
Eyebrow   Inter · 500 · CAPS · tracking +0.14em · ink @ 58%
Stats     Inter · tnum + slashed-zero (cv/ss) · unit = accent
Opacity   ramp 100 / 70 / 40   (no pure white/black)
Button    radius 10 · padding 15/24 · easing power3 · hover -2px + accent-glow shadow
```

Flow: **propose spec (text) → user steers the values → apply → render → user eye-review.**
Never skip to "apply + declare done."
