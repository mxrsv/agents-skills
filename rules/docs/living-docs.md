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
- Specs are outside that scan: verify links in active specs, tell planned files from existing ones, and keep task references reachable.
- Frozen specs and legacy plans describe their recorded revision, not current behavior.

## Before writing

- Before creating a new doc, check whether a doc on the same topic already exists; update it instead of duplicating.
- Living-doc language follows the repo's `AGENTS.md`; if not declared, follow existing docs. Specs, `## Status` included, are in English.

## Checklist when writing docs

- [ ] Requirements, decisions and status in one spec in `docs/specs/`; no new file in `docs/plans/`; reviews in chat or an explicitly requested PR; no duplicate checklist?
- [ ] Living docs in the right reader tier, specs in `docs/specs/`?
- [ ] Active content updated in place, frozen history preserved, applicable links checked?
