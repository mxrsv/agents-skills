---
name: brainstorm
description: Clarify ambiguous requirements or material architecture, data-model and public-contract changes before implementation. Settle decisions in conversation and capture them in the requirements section of the task plan when one is needed.
argument-hint: "[task description or plan path]"
---

# Brainstorm

Clarify what to build before choosing how. The conversation is the decision surface; one task plan stores the requirements and later implementation detail. Do not require a tracker, issue key, MCP call or a separate spec file.

## When to use

Apply W1: ambiguous outcomes, architecture/data-model/public-contract changes, or an explicit request. Do not force brainstorming for small, clear edits. Existing approved decisions are inputs, not questions to reopen.

## Process

1. Read the request, repo instructions, existing task plan and relevant code. If a path was supplied, use it; otherwise search before creating a plan.
2. Ask one decision-changing question at a time. Explain meaningful alternatives and tradeoffs when there are several viable approaches. Do not invent ambiguity or insist on alternatives to an already selected approach.
3. Settle the goal, scope/exclusions, user flow or API/CLI behavior as applicable, constraints, error cases and acceptance criteria. Product decisions belong to the user; implementation details can be left to planning.
4. Present the concrete proposed requirements and approach in chat. Ask for approval only where not already provided. Do not begin dependent implementation while material decisions remain open.
5. For work needing a plan under W2, capture these requirements in the same `docs/plans/YYYY-MM-DD-<slug>.md` that will hold implementation tasks, verification and handoff. Use the format in [planning](../planning/SKILL.md); keep incomplete execution sections out until they can be written. Body/headings are English (D4). For small work, keep the decision in chat rather than create paperwork.
6. Re-read the artifact for missing acceptance criteria, contradictions and assumptions. Clearly distinguish approved decisions from unresolved questions. If implementation was authorized, continue: add technical tasks to the same file with `planning` when warranted, otherwise implement directly. Do not require another approval because the requirement moved from chat into a file.

## Boundaries

- Do not create `docs/specs/`, `docs/superpowers/`, `.planning/`, daily journals or duplicate specs.
- Do not create issues, fetch remote tracker state or post decisions externally unless the user explicitly requests that action.
- Saving a draft is reversible and does not itself need an extra approval round. Committing docs follows D14; merge, deploy and release remain separate permissions.
- Keep frontend decisions under the existing frontend gate; this skill does not replace required visual review.
