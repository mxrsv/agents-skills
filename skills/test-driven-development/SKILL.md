---
name: test-driven-development
description: Use before implementation when the task is suitable for TDD. Enforces Red-Green-Refactor and requires a failing test before production code when practical.
---

# Test-Driven Development

Use this skill when the problem is testable and the repository has a workable test harness.

## Cycle

1. `Red`
   - write the smallest meaningful failing test
   - run it and confirm it fails for the expected reason
2. `Green`
   - write the minimum code needed to pass
   - rerun the targeted test
3. `Refactor`
   - clean up only after the test passes
   - rerun relevant tests to confirm no regression

## Rules

- Do not write broad implementation before the first failing test when TDD is practical.
- Keep each increment small.
- If the codebase is hostile to strict TDD, state that and use the closest practical version instead of pretending.
- After the targeted test passes, run the broader relevant verification.
