---
name: brainstorm
description: Turn an ambiguous ask into an approved spec written into the Linear issue. Use when the ask is ambiguous, when it changes architecture, data model or a public contract (API, CLI, UI flow), or when the user asks for a spec. Triggers: "I want to add", "let's build", "design X".
argument-hint: [issue-id]
---

# Brainstorm

> **Harness note.** The spec is written with the Linear MCP (`save_issue`, `save_document` — Claude Code tool ids `mcp__plugin_linear_linear__*`). In Codex or Cursor without that server, print the finished spec in chat as one fenced markdown block and name the issue it belongs on. **Never write a spec file into the repo** (D0/D4).

## Initial issue (from invocation)

If `$issue-id` is provided (`MXR-12`), that issue is the spec's home: `get_issue` it and read `list_comments` first — the description and any decision comments are the current state of the spec, and a newer user decision supersedes older text. Otherwise ask which issue the work belongs to; if none exists yet, ask for the team and create one with `save_issue { team, title }` at step 6.

## The Rule

**NO IMPLEMENTATION WITHOUT AN APPROVED SPEC FIRST** — for work above the W1 threshold (ambiguous outcome, architecture / data model / public contract change, or the user asked for a spec). Below it, L7 says do the work; do not run this skill.

"I'll just prototype first" is still implementing. "Too simple for a spec" is still skipping when the threshold was hit.

## Red Flags

| Thought                            | Do instead                                                           |
| ---------------------------------- | -------------------------------------------------------------------- |
| "Too simple for a spec"            | Simple things become complex. Spec takes 10 min, rework takes hours. |
| "I already know how to build this" | You know YOUR approach. User may want different.                     |
| "Let me just start coding"         | Code without spec = building without blueprints.                     |
| "I'll figure it out as I go"       | That's how scope creep and rework happen.                            |
| "The conversation IS the spec"     | Conversations are messy. Write it into the issue.                    |
| "I'll drop a file in docs/ for now" | D4 forbids it, and a second copy of the spec drifts. The issue is the spec. |

## Process

1. **Clarify**: "What problem are we solving? What does success look like?" Paraphrase back and confirm.
   - **Scope check**: if the request spans multiple independent subsystems (e.g., "build a platform with chat, file storage, billing, analytics") → STOP. Propose decomposition into sub-issues, each with its own spec → plan → impl. Continue brainstorming with the first one.
2. **Explore context**: Read relevant codebase files and `docs/internals/`, identify patterns/constraints.
3. **Ask questions**: ONE at a time. Not a list of 10.
4. **Propose 2-3 approaches**: NEVER single option. Include pros, cons, "best if" for each.
5. **Present design section by section**: Get feedback per section, not full dump.
   - Context → Canonical data sources → Solution architecture → Failure modes → Done & Not done → Open questions
6. **Write the spec into the issue**. Show the full text in chat first (D14), then:
   - Issue has no real description yet → `save_issue { id, description }` with the whole spec.
   - Issue already has a description → `save_issue { id, patch: [...] }` — `replace` the sections that changed, `append` new ones. Never paste a second full copy under the old one; the description is one spec, rewritten in place.
   - Spec longer than a screen or shared by several issues → `save_document { issue: <id>, title: "Spec: {feature}", content }` and put a one-line pointer in the description.
   - Format of the spec body:

   ```markdown
   ## Spec

   ### 1. Context

   **Origin**:

   - "{the user's original request, copied verbatim}"

   **Problem**:

   - {2-3 lines. Do not prescribe a solution.}

   **Decisions**:

   - {what was decided, what was rejected, one-line reason per decision}

   ### 2. Canonical data sources

   **Canonical**:

   - {canonical data/state/contract, and where it comes from}

   **NOT a canonical source**:

   - {data/state that must not be treated as canonical}

   ### 3. Solution architecture

   **Components**:

   - **{Component}**: {conceptual responsibility, not a file list}

   **Data Flow**:

   - {Add only when non-trivial: async, money, auth, signature, multi-boundary, multi-source state}

   ### 4. Failure modes

   - When {trigger condition}, the system must {expected behavior}.
   - When {...}, the system must {...}.

   ### 5. Done & Not done

   **Done**:

   - {verifiable acceptance criterion}

   **Not done**:

   - {specifically what is not done}
   - {constraints / soft limits}

   ### 6. Open questions

   - **ASSUMPTION**: {...}
   - **QUESTION**: {...}
   - **BLOCKER**: {...}
   ```

   - No git step. Nothing in the repo changes during a brainstorm.

7. **Self-review inline** (no subagent). Re-read the issue description with fresh eyes (`get_issue` again — read what Linear holds, not what you meant to send):
   - **Placeholder scan**: TBD, TODO, "fill in later", empty sections, vague requirements.
   - **Internal consistency**: any sections contradicting each other? Do Components match Failure Modes / Done?
   - **Scope check**: spec focused enough for one plan, or does it need decomposition into sub-issues?
   - **Ambiguity check**: any requirement that could be interpreted two ways? Pick one and write it explicitly.
   - Fix inline with another `patch`. No re-review needed.
8. **HARD GATE**: STOP. Present the issue URL + scope summary. "Do you approve this spec?"
9. **After human approves**: Suggest `→ Next: planning <issue-id>`. **ONLY** invoke the `planning` skill — do NOT auto-jump to any other implementation skill (frontend-design, code-review, tdd, etc.).

## Spec language

The spec body and section headings MUST be written in **English**, independent of the active Output Style and of the conversation language (LW19 — the spec is Linear content).

## Examples

```
BAD:  Dump 10 questions at once.
GOOD: One question per message, wait for answer.

BAD:  Present single approach.
GOOD: "Approach A: ... / Approach B: ... Which direction?"

BAD:  Write docs/specs/2026-09-07-foo-design.md "so it is in git".
GOOD: save_issue { id: "MXR-12", patch: [...] } — the issue is the spec; git holds code.

BAD:  (after self-review) "Let me start the implementation plan."
GOOD: (after self-review) "Spec written to MXR-12 + self-reviewed. Do you approve this spec?"
```

## Enforcement

- **NEVER** dump all questions at once. One at a time.
- **NEVER** present a single option. Always 2-3 approaches.
- **NEVER** skip writing the spec into the issue (or printing it, without the MCP).
- **NEVER** write the spec to a file in the repo.
- **NEVER** proceed after self-review without human approval.
- **ALWAYS** show the spec text in chat before the `save_issue` / `save_document` call (D14).
- **ALWAYS** self-review inline (placeholder/consistency/scope/ambiguity) after writing the spec.
- **ALWAYS** suggest `planning` as the next step after approval.

## Shared By

analyst
