---
name: write-plan
description: Use after scope is understood and before non-trivial implementation. Produces an execution plan with ordered tasks, affected files, and verification guidance.
---

# Write Plan

Use this skill for multi-step work that benefits from a real execution plan.

## Workflow

1. Read enough of the codebase to ground the plan in real paths and conventions.
2. Break the work into meaningful tasks.
3. For each task, include:
   - objective
   - likely files
   - verification approach
   - dependencies or ordering notes
4. Keep tasks concrete enough that implementation can begin without rediscovery.

## Good Plan Properties

- grounded in actual files and patterns
- ordered by dependency
- includes verification, not just edits
- avoids giant fuzzy tasks

## Rules

- Do not write plans from memory alone when the codebase is available.
- Do not pad with obvious filler.
- If the task is simple, skip the plan and execute directly.
