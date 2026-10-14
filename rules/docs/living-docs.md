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

- **D6.** Behavior claims in living docs (D1) MUST have resolving markdown links relative to the containing file; `docs-anchors.sh` scans these surfaces. Specs and plans are design/execution records, outside that living-doc scan: verify links in active records, including plan-to-spec links, distinguish planned files from existing ones, and keep task references reachable. Frozen records describe their recorded revision, not current behavior. The historical marker on a completed plan is a lifecycle marker, not a task tracker.
  - ✅ in `AGENTS.md`: `[move_pane_ownership](electron/coordinator.ts)`
- **D11.** BEFORE creating a new doc → check whether a doc on the same topic already exists; update instead of duplicating.
- **D15.** Living-doc language follows the repo's `AGENTS.md`; if not declared, follow existing docs. Specs and implementation plans, including handoff, are English under D4.

## Checklist when writing docs

- [ ] Requirements in `docs/specs/`, execution in `docs/plans/`, with links instead of copied requirements; reviews in chat or an explicitly requested PR; no duplicate checklist? (D0/D4)
- [ ] Living docs in the right reader tier, specs and plans in their own directories? (D3/D9)
- [ ] Updated active content in place; preserved frozen history; checked applicable links? (D1/D6)
