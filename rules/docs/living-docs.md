---
paths:
  - "docs/**"
  - "**/AGENTS.md"
  - "**/README.md"
  - "**/CHANGELOG.md"
---

# Living docs: rules while editing docs

Loaded when touching `docs/**`, `AGENTS.md`, `README.md` or `CHANGELOG.md`. The main docs rules for the same paths live in [docs.md](../core/docs.md).

## Links

- Behavior claims in living docs need resolving markdown links relative to the containing file; `docs-anchors.sh` scans these surfaces.
  - ✅ in `AGENTS.md`: `[move_pane_ownership](electron/coordinator.ts)`
- Specs and plans are outside that scan: verify links in active records, including plan-to-spec links, tell planned files from existing ones, and keep task references reachable.
- Frozen records describe their recorded revision, not current behavior. The historical marker on a completed plan is a lifecycle marker, not a task tracker.

## Before writing

- Before creating a new doc, check whether a doc on the same topic already exists; update it instead of duplicating.
- Living-doc language follows the repo's `AGENTS.md`; if not declared, follow existing docs. Specs and plans, handoff included, are in English.

## Checklist when writing docs

- [ ] Requirements in `docs/specs/`, execution in `docs/plans/`, with links instead of copied requirements; reviews in chat or an explicitly requested PR; no duplicate checklist?
- [ ] Living docs in the right reader tier, specs and plans in their own directories?
- [ ] Active content updated in place, frozen history preserved, applicable links checked?
