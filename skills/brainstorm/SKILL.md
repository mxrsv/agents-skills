---
name: brainstorm
description: Clarify ambiguous requirements or material architecture, data-model and public-contract changes before implementation. Settle decisions in conversation and capture durable requirements in docs/specs/, without plan files. Not for stress-testing an existing decision (use grilling) or for intent extraction before any ask is clear (use interview-me).
argument-hint: "[task description or spec path]"
---

# Brainstorm

Clarify what to build before choosing how. The conversation is the decision surface; a spec in `docs/specs/` records requirements and acceptance criteria, and its `## Status` records progress; there are no plan files. Do not require a tracker, issue key or MCP call.

## When to use

Apply the spec threshold in `rules/core/workflow.md`: ambiguous outcomes, architecture/data-model/public-contract changes, or an explicit request. Do not force brainstorming for small, clear edits. Existing approved decisions are inputs, not questions to reopen.

## Process

1. Read the request, repo instructions, existing spec (and any legacy plan) and relevant code. If a path was supplied, read it; search `docs/specs/` and `docs/plans/` before creating a record.
2. Ask one decision-changing question at a time. Explain meaningful alternatives and tradeoffs when there are several viable approaches. Do not invent ambiguity or insist on alternatives to an already selected approach.
3. Settle the goal, scope/exclusions, user flow or API/CLI behavior as applicable, constraints, error cases and acceptance criteria. Product decisions belong to the user; implementation details are the agent's call.
4. Present the concrete proposed requirements and approach in chat. Ask for approval only where not already provided. Do not begin dependent implementation while material decisions remain open.
5. When a spec is requested or material requirements need a durable record, write `docs/specs/YYYY-MM-DD-<slug>.md`. Include goal, scope/exclusions, approved decisions, behavior/error cases, acceptance criteria, constraints and open questions. Body/headings are English. Progress goes only in a short `## Status`; keep technical task lists out. For small work, keep the decision in chat unless a spec was requested.
6. Re-read the artifact for missing acceptance criteria, contradictions and assumptions. Clearly distinguish approved decisions from unresolved questions. If implementation was authorized, continue and implement; no plan file. Do not require another approval because the requirement moved from chat into a file.

## Boundaries

- Do not create `docs/superpowers/`, `.planning/`, daily journals or duplicate specs. Update the canonical spec in place.
- Do not create issues, fetch remote tracker state or post decisions externally unless the user explicitly requests that action.
- Saving a draft is reversible and does not itself need an extra approval round. Commit, merge, deploy and release follow the task's authorization.
- Keep frontend decisions under the existing frontend gate; this skill does not replace required visual review.
