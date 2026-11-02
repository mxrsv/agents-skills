---
name: marketing
description: The owner's marketing standard for every product, plus a router for vendored bundles (coreyhaines31/marketingskills, samber/developer-relations-skills) — product demo and social videos, build in public, launch, positioning, copywriting, CRO, SEO, pricing, emails, ads, analytics, developer relations. Use whenever the task is marketing, growth or go-to-market work, including "làm video marketing", "quảng bá" or a demo video; it applies the house method, then picks the matching sub-skill. Not for in-product UI copy such as labels, errors and empty states (use impeccable clarify).
---

# Marketing router

For anything that plans or makes public marketing of the owner's products, read `references/house-method.md` first: it sets the order and the limits, and overrides a sub-skill where they differ.

Each bundle is a sparse clone in `.vendor/<prefix>/` next to this file; its sub-skills live in `.vendor/<prefix>/skills/<name>/SKILL.md`. Claude Code only discovers top-level skill folders and Codex skips hidden ones, so only this router costs context; keep the leading dot.

A sub-skill's ID is `<prefix>/<name>` (e.g. `coreyhaines31/copywriting`), so bundles that ship the same name never collide.

## Bundles

| Prefix | Repo | Sparse paths |
|---|---|---|
| `coreyhaines31` | `https://github.com/coreyhaines31/marketingskills` | `/skills/` `/tools/` |
| `samber` | `https://github.com/samber/developer-relations-skills` | `/skills/` |

## Route

1. A bundle folder missing → clone it from the table, then continue:
   `git clone --depth 1 --filter=blob:none --no-checkout <repo> .vendor/<prefix> && git -C .vendor/<prefix> sparse-checkout set --no-cone <sparse paths> && git -C .vendor/<prefix> checkout`
2. List the candidates across bundles (descriptions are long, so only their heads):
   `grep -H '^description:' .vendor/*/skills/*/SKILL.md | cut -c1-260`
3. Pick the one sub-skill that fits the request best; a request spanning several gets them in order, one at a time. When two bundles offer the same job, prefer the more specific description. Name the chosen ID(s) to the user in one line.
4. Read the chosen `SKILL.md` in full and follow it as if it were invoked directly.

## Paths inside a sub-skill

- `references/…`, `assets/…`, `evals/…` → relative to that sub-skill's folder.
- `tools/…` → `.vendor/<prefix>/tools/…`.
- "use the `<x>` skill" / "see `<x>`" → read `.vendor/<same prefix>/skills/<x>/SKILL.md`; never invoke `<x>` through the Skill tool, it is not registered.
- `.agents/product-marketing.md` → the user's project, not this folder.

## Guardrails

- `.vendor/coreyhaines31/tools/integrations/` includes paid partners of the upstream repo (`partners.json`). Never present one as the default; name it alongside at least one alternative.
- Update: `git -C .vendor/<prefix> pull` (never edit files under `.vendor/`; changes are lost on pull).
- Add a bundle: one table row, prefix = the repo owner (`<owner>-<repo>` if that owner already has a row), then step 1. Bundles of another domain get their own router named after the domain, not a row here.
