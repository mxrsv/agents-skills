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

- **D6.** Behavior claims in living docs (D1) MUST have resolving markdown links relative to the containing file; `docs-anchors.sh` scans these surfaces. Plans are execution records, outside that living-doc scan: verify active-plan paths against the checkout, distinguish planned files from existing ones, and keep task references reachable. Frozen plans describe their recorded revision, not current behavior. The intent labels `current`/`decided`/`building`/`deprecated` remain retired for living docs; the historical marker on a completed plan is a lifecycle marker, not a separate task tracker.
  - ✅ in `AGENTS.md`: `[move_pane_ownership](electron/coordinator.ts)`
- **D11.** BEFORE creating a new doc → check whether a doc on the same topic already exists; update instead of duplicating.
- **D15.** Living-doc language follows the repo's `AGENTS.md`; if not declared, follow existing docs. Task plans, including requirements and handoff, are English under D4.

## Checklist when writing docs

- [ ] Requirements and execution in one `docs/plans/` file when needed; reviews in chat or an explicitly requested PR; no duplicate checklist? (D0/D4)
- [ ] Living docs in the right reader tier, or one canonical task plan? (D3/D9)
- [ ] Updated active content in place; preserved frozen history; checked applicable links? (D1/D6)
- [ ] Asked before committing? (D14)
