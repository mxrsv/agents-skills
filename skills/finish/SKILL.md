---
name: finish
description: Use when implementation is complete and the work needs a clean close-out. Re-runs verification, summarizes state, and presents safe next actions such as keep, commit, review, or ship.
---

# Finish

Use this skill near the end of an implementation task.

## Workflow

1. Re-run the verification that supports the completion claim.
2. Summarize what changed and any remaining risks.
3. Present the real next action based on repository state:
   - keep as-is
   - commit
   - open for review
   - push / PR if explicitly requested and permitted

## Rules

- Do not claim completion without fresh evidence.
- Do not perform destructive cleanup without explicit approval.
- Do not force-push.
- If verification fails, stop and report the real state.
