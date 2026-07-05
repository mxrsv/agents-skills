---
name: review
description: Use for structured review of specs, plans, or code changes. Findings-first for code review, with clear severity, file references, and human-facing decision points.
---

# Review

Use this skill whenever an artifact needs an explicit quality gate.

## Review Types

- `spec`
- `plan`
- `code`

## Workflow

1. Read the artifact and the minimum upstream context required to judge it.
2. Review with the correct lens:
   - spec: completeness, ambiguity, feasibility, edge cases
   - plan: ordering, executable steps, verification path, missing files or dependencies
   - code: correctness, regressions, security, tests, maintainability
3. Report findings before proposing fixes.
4. Wait for the user's direction if fixes are non-trivial.

## Code Review Output

- Order findings by severity.
- Include file references.
- Focus on bugs, regressions, and missing tests before style.
- If there are no findings, say that explicitly and mention residual risk.

## Rules

- Do not self-congratulate or bury findings under summary.
- Do not fix issues while still in pure review mode unless the user asks.
- For code review, read surrounding code and call sites, not only the diff.
