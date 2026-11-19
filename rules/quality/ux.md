# UX principles (UX-rules)

For any UI work in any repo and any medium (web, SwiftUI, a mock). Visual polish is not
usability: these rules sit under the look. The repo's `AGENTS.md` and `PRODUCT.md` add the
product's own jobs, vocabulary and colour meanings.

- **UX1. Write the brief before drawing.** State the user's jobs in priority order, the
  entities and how each is told apart, the main flow in steps, and which goal wins when two
  collide. A UI decision must name the job it serves. Escape: a pure polish pass on a screen
  whose brief already exists. Why: the Reins mocks (2026-11-06) looked finished and still
  ignored naming, colour meaning and flow. Doc only; put the brief in the spec.
- **UX2. One word, one meaning.** A term names one thing everywhere (labels, tabs, docs,
  code). Never reuse a word for two entities (for example "agent" for both a CLI and a
  subagent); rename the cheaper one and keep a glossary in the repo. Doc only.
- **UX3. One colour, one meaning.** State colours (green, amber, red) mean state only and are
  never used for a category, a brand or a selection. A category, an identity (a CLI) and the
  accent each get a hue family outside them. An icon carries one meaning. Check a new palette
  for hue collisions before building. Doc only; policy test where tokens are enumerable.
- **UX4. Detection and action sit together.** Where the UI shows a problem, the action that
  resolves it is at most one hover or click away, in the same row or panel, not on another
  screen. Every write has Undo; a destructive write that cannot be undone gets a confirmation
  that names the target and the consequence. Doc only.
