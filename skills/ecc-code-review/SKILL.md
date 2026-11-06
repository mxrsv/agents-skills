---
name: ecc-code-review
description: Run a severity-ranked code review (CRITICAL / HIGH / MEDIUM / LOW plus APPROVE / WARNING / BLOCK verdict) by dispatching the `code-reviewer` agent. Use when the owner says "ecc-code-review", "review có xếp hạng", "review critical/high", or wants a ranked review of a diff, commit range or PR. For PR inline comments or auto-fix use the built-in /code-review.
---

# ECC code review

Dispatch the `code-reviewer` agent; do not review in this context.

1. Pick the target from the ask: a range or PR (`gh pr diff <n>` saved to the scratchpad), a path, or else the working tree plus staged changes.
2. `Agent({ subagent_type: "code-reviewer", prompt: "<target, e.g. `git diff main...HEAD`>, plus one line on what the change is for" })`.
3. Return its report unchanged: findings, severity table, verdict. Add nothing, drop nothing.
