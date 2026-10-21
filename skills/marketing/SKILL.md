---
name: marketing
description: Router for 52 marketing skills (coreyhaines31/marketingskills) — copywriting, CRO, SEO/AI SEO, pricing, launch, positioning, emails, ads, analytics and conversion tracking, growth loops, sales enablement, competitor research. Use whenever the task is marketing, growth or go-to-market work; it picks the matching sub-skill and follows it. Not for in-product UI copy such as labels, errors and empty states (use impeccable clarify).
---

# Marketing router

The sub-skills live in `.vendor/skills/<name>/SKILL.md` next to this file, a sparse clone of `coreyhaines31/marketingskills` (`skills/` and `tools/` only). Claude Code only discovers top-level skill folders and Codex skips hidden ones, so only this router costs context; keep the leading dot.

## Route

1. `.vendor/` missing → clone it, then continue:
   `git clone --depth 1 --filter=blob:none --no-checkout https://github.com/coreyhaines31/marketingskills .vendor && git -C .vendor sparse-checkout set --no-cone '/skills/' '/tools/' && git -C .vendor checkout`
2. List the candidates (descriptions are long, so only their heads):
   `grep -H '^description:' .vendor/skills/*/SKILL.md | cut -c1-260`
3. Pick the one sub-skill that fits the request best; a request spanning several gets them in order, one at a time. Name the chosen sub-skill(s) to the user in one line.
4. Read the chosen `SKILL.md` in full and follow it as if it were invoked directly.

## Paths inside a sub-skill

- `references/…`, `assets/…`, `evals/…` → relative to that sub-skill's folder.
- `tools/…` → `.vendor/tools/…`.
- "use the `<x>` skill" / "see `<x>`" → read `.vendor/skills/<x>/SKILL.md`; never invoke `<x>` through the Skill tool, it is not registered.
- `.agents/product-marketing.md` → the user's project, not this folder.

## Guardrails

- `tools/integrations/` includes paid partners of the upstream repo (`partners.json`). Never present one as the default; name it alongside at least one alternative.
- Update: `git -C .vendor pull` (never edit files under `.vendor/`; changes are lost on pull).
