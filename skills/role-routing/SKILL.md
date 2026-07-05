---
name: role-routing
description: Use when the user asks for analyst, developer, or code-reviewer style delegation from Claude-style workflows. Maps those roles onto Codex main agent and available subagents such as explorer and worker.
---

# Role Routing

Codex does not support custom subagent definitions in the same way Claude does. Use this skill to translate Claude-style roles into Codex-native execution.

## Role Mapping

- `analyst`
  - Best for research, discovery, architecture reconnaissance, synthesis
  - In Codex: use the main agent for synthesis; use `explorer` for focused codebase questions; use web only when required

- `developer`
  - Best for implementation, debugging, refactoring, test work
  - In Codex: use the main agent for critical-path coding; use `worker` for bounded parallel edits with disjoint ownership

- `code-reviewer`
  - Best for independent review after implementation
  - In Codex: use the main agent in review mode; optionally use `explorer` for sidecar inspection, but findings remain owned by the main agent

## Routing Heuristics

- Use `explorer` for read-only, specific codebase questions
- Use `worker` for bounded implementation tasks with a clear write scope
- Keep urgent critical-path work on the main agent
- Do not spawn agents just for extra verbosity

## Rules

- State the mapping when the user asks for Claude-style agents.
- If a role cannot be reproduced exactly, explain the closest Codex-native equivalent.
- Prefer a small number of well-scoped delegations over many vague ones.
