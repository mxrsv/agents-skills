---
name: create-doc
description: Template-driven document creation (PRD, research report, project brief). Structured elicitation. All outputs are DRAFT requiring human review.
---

# Create Doc

## The Rule

**ALL DOCUMENTS ARE DRAFTS. SEPARATE FACTS FROM INTERPRETATIONS.**

## Red Flags

| Thought | Do instead |
|---|---|
| "I'll write it freeform" | Use template. Templates catch gaps. |
| "This section doesn't apply" | Mark N/A with explanation. Don't silently skip. |
| "I know what user wants" | Elicit. Ask. Confirm. |
| "Facts and analysis are the same" | Facts are sourced. Analysis is interpretation. Label them. |

## Process

1. **Select template**: PRD / Research Report / Project Brief / Analysis / Custom
2. **Elicit**: One section at a time. Use existing codebase as source when available.
3. **Draft**: Write each section. Label: Fact (sourced), Interpretation (prefixed), Assumption (prefixed). Flag gaps: `[GAP: {what's missing}]`
4. **Self-check**: All sections present? No silent gaps? Facts labeled? Assumptions explicit?
5. **Present**:
   ```
   [DRAFT — Requires Human Review]
   # {Title} | Type: {type} | Date: {date}
   {sections}
   ## Assumptions / Open Questions / Gaps
   ```

## Templates

- **PRD**: Problem · Users · Requirements (Must/Should/Could) · Metrics · Scope (in/out) · Questions
- **Research**: Question · Methodology · Findings (sourced) · Analysis (labeled) · Recommendations · Limitations
- **Brief**: Context · Objectives · Constraints · Stakeholders · Timeline · Risks

## Enforcement

- **NEVER** present without `[DRAFT]` label
- **NEVER** skip sections. Mark N/A if not applicable.
- **NEVER** leave silent gaps. Use `[GAP]` tags.
- **ALWAYS** separate facts from interpretations.

## Shared By

analyst
