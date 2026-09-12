---
paths:
  - "docs/**"
  - "**/AGENTS.md"
  - "**/README.md"
  - "**/CHANGELOG.md"
---

# Living docs — rules while editing docs (supplementary D-rules)

Loaded when touching `docs/**`, `AGENTS.md`, `README.md`, `CHANGELOG.md`.
The always-on D-rules live in `~/.claude/rules/core/docs.md`.

- **D6.** Behavior claims in `AGENTS.md`, `README.md`, `CHANGELOG.md` and every page under `docs/` MUST be anchored with a markdown link **relative to the file containing the link**, and the link must resolve (`docs-anchors.sh` scans both groups). **The intent labels `current`/`decided`/`building`/`deprecated` were retired on 2026-09-09** — those labels marked the state of a spec/plan/CONTEXT, and that set lives in Linear issues, not in the repo; a document still in the repo is presumed correct by default — if it is wrong, fix it rather than label it.
  - ✅ in `AGENTS.md`: `[move_pane_ownership](electron/coordinator.ts)`
- **D11.** BEFORE creating a new doc → check whether a doc on the same topic already exists; update instead of duplicating.
- **D15.** The language of the docs follows the repo's `AGENTS.md`; if not declared → follow the dominant language of the existing docs.

## Checklist when writing docs

- [ ] Spec/plan/review goes to the Linear issue, not `docs/`? (D0/D4)
- [ ] Right tier `user/` · `internals/` · `operations/`, and "a maintainer would get it wrong without it"? (D3/D9)
- [ ] Rewrote instead of appending; every link resolves? (D1/D6)
- [ ] Asked before committing? (D14)
