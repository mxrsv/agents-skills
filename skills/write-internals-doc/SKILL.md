---
name: write-internals-doc
description: Write or tighten an architecture/internals page that records decisions, cross-module constraints and traps — only what a maintainer would otherwise get wrong. Use when a change leaves behind a reason that is not visible in the code, when an internals or traps page is edited, or when a doc has grown into a file catalog. Not for user guides, runbooks, specs or plans.
---

# write-internals-doc — decisions and traps, not a tour

An internals page earns its place by preventing a mistake. If a reader could learn it by opening
the file, it does not belong.

## 1. The gate question

Before adding a paragraph: **what would a maintainer get wrong without it?** No concrete answer,
no paragraph. Write the answer down as the first sentence of the entry.

## 2. Entry shape

For each decision or trap, in this order:

1. **Claim** in bold, one sentence, in present tense ("A Tailwind utility loses to any plain rule on the same element").
2. **Mechanism**: why it is true, with the smallest fact that proves it.
3. **Consequence for the reader**: what to do or not do.
4. **Link** to the code, test or spec that holds it (relative, resolving).

Keep a trap entry under ~8 lines. If it needs more, it is a design: move it to a spec and link.

## 3. Page shape

- Opens with the "for maintainers" callout if the repo uses one, then a 3-line scope.
- Sections group by area a reader is about to edit, so `AGENTS.md` can link to one section.
- A table only for lookups ("surface → page"), never for narrative.

## 4. Do not write

- File catalogs, field or method lists, control-flow retellings, PR summaries.
- A second account of a changed decision: rewrite or delete the old text.
- Planned work or "gaps" in a living doc; those live in a plan.
- The names of studied outside projects, if the repo forbids it.

## 5. Keep it true

After editing, run the repo's anchor/compliance checks and grep for the symbols the page cites.
Removing or renaming a module means editing its page in the same change.

## 6. Split of homes

User task help → user guide; reason or constraint → this page; setup/release steps → runbook;
requirement or acceptance → spec; progress → plan.
