---
name: explain
description: Explain concepts, bugs, or design decisions in a deliberately chosen teaching style. Use when user types `/explain`, says "explain"/"giải thích", or wants to understand *why* (not just a fix). Honors flags `--story` (Journey + Analogy for bugs), `--why` (First principles + Counterfactual for design decisions), `--diff` (Compare + Layered onion for X vs Y). Auto-picks style if no flag. Output in Vietnamese, code identifiers in English.
effort: medium
---

# Explain

Teach **understanding**, not just deliver facts. Pick style by flag; if no flag, auto-pick and announce it on line 1.

## Style flags

### `--story` → Journey + Analogy

**Use for**: bugs, debugging sessions, anything with a "moment of discovery".

**Flow**: initial observation → dig deeper → "aha" moment → runtime consequence → real-world analogy → takeaway lesson.

**Avoid**: bullet lists, leaky analogies (metaphor breaks on a load-bearing detail).

### `--why` → First principles + Counterfactual

**Use for**: design decisions, trade-offs, recurring class of bugs.

**Flow**: strip to fundamental constraint → enumerate 2-3 options the designer could have picked → trace the chosen path → counterfactual ("if they had chosen differently...") → implication for related bugs.

**Avoid**: getting stuck in the specific code (the point is the _principle_).

### `--diff` → Compare & contrast + Layered onion

**Use for**: migration guides, "X vs Y", bugs with multiple causal layers.

**Flow (compare side)**: use a table when ≥3 dimensions; bullet pairs when 1-2. Same axes for both sides.

**Flow (onion side)**: layer 1 symptom → layer 2 mechanism → layer 3 API design → layer 4 philosophy. Drop layers the bug doesn't have.

**Avoid**: comparing things the reader doesn't know on either side (use `--story` instead).

## Default (no flag)

Auto-pick and announce on line 1: `**Style: --story** (short reason)`.

Pick rules:

- Bug / debugging → `--story`
- Design choice / trade-off / "why did they do it this way" → `--why`
- "X vs Y" / migration / multi-layer bug → `--diff`
- Ambiguous → `--story` (most accessible)

## Output rules

- **Concise by default**: shortest answer that fully teaches the concept. No filler, no recap, no "next steps" section. Each section earns its place — drop steps the topic doesn't need.
- Vietnamese narrative; English for code identifiers, file paths, CLI commands
- Headings `##` / `###` only (never `#`)
- Code blocks always tagged with language
- Length matches topic — don't pad. Simple gotcha: 3-5 short paragraphs. Deep design analysis: longer only if every paragraph adds insight.
- Semantic emoji (🔍 💡 ⚠️ 🐛 🔧) at section transitions or "aha" moments — sparingly
- End with a one-sentence takeaway (📝 or 💡)

## Modifier flags

- `--brief` → ≤6 sentences, skip section headers
- `--deep` → full structure, no shortcuts
- Two style flags at once → pick dominant by topic, mention which one is being skipped
