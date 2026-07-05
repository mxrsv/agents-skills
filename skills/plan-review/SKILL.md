---
name: plan-review
description: Dispatch plan-reviewer agent to verify a plan is executable against current codebase. Use after writing a plan, before implementation.
agent: plan-reviewer
---

# Plan Review

Dispatch `plan-reviewer` agent. Do not self-review.

## 1. Prepare payload

- **OBJECTIVE** — what this plan implements (1-2 sentences)
- **SPEC/UPSTREAM** — approved spec or "no spec attached — skip scope check"
- **PLAN** — full plan text
- **ITERATION** — X/3 (default 1/3)
- **PREVIOUS FINDINGS** — if iteration >1, fixed/outstanding summary

## 2. Dispatch

```
Agent tool:
  subagent_type: "plan-reviewer"
  prompt: |
    OBJECTIVE: {objective}
    UPSTREAM CONTEXT: {spec or "no spec attached — skip scope check"}
    ITERATION: {X}/3
    {if iteration > 1: PREVIOUS FINDINGS: {previous_findings}}

    PLAN:
    {full_plan_text}

    Review this plan. Follow your review process.
```

Do NOT paste codebase contents — agent has Read/Glob/Grep.

## 3. Handle verdict

- **EXECUTABLE: Yes** → present report. Done.
- **EXECUTABLE: Partial** → present report. User decides to proceed or fix.
- **EXECUTABLE: No** → fix HIGH/CRITICAL in plan → re-dispatch (max 3 iterations)
- **3 iterations exhausted** → escalate to human

## Review Criteria

Reviewer agent follows [rules/review-criteria.md](rules/review-criteria.md) for what to check + output format.
