---
description: Brainstorm a new feature into an approved spec via clarify → propose 2-3 approaches → present sections → write file → self-review → hard gate.
when_to_use: Before any new feature, refactor, or significant behavior change. Trigger phrases - "I want to add", "let's build", "design X", "how should we approach Y". MUST run before any code is written.
argument-hint: [topic]
arguments: topic
---

# Brainstorm

## Initial topic (from invocation)

If `$topic` is provided, use it as the `{topic}` slug in the spec filename (`docs/specs/YYYY-MM-DD-$topic.md`) and as the initial title hint. Otherwise, derive from the conversation.

## The Rule

**NO IMPLEMENTATION WITHOUT AN APPROVED SPEC FIRST.**

"I'll just prototype first" is still implementing. "Too simple for a spec" is still skipping.

## Red Flags

| Thought                            | Do instead                                                           |
| ---------------------------------- | -------------------------------------------------------------------- |
| "Too simple for a spec"            | Simple things become complex. Spec takes 10 min, rework takes hours. |
| "I already know how to build this" | You know YOUR approach. User may want different.                     |
| "Let me just start coding"         | Code without spec = building without blueprints.                     |
| "I'll figure it out as I go"       | That's how scope creep and rework happen.                            |
| "The conversation IS the spec"     | Conversations are messy. Write it down.                              |

## Process

1. **Clarify**: "What problem are we solving? What does success look like?" Paraphrase back and confirm.
   - **Scope check**: if the request spans multiple independent subsystems (e.g., "build a platform with chat, file storage, billing, analytics") → STOP. Propose decomposition into sub-projects, each with its own spec → plan → impl. Continue brainstorming with the first sub-project.
2. **Explore context**: Read relevant codebase files, identify patterns/constraints.
3. **Ask questions**: ONE at a time. Not a list of 10.
4. **Propose 2-3 approaches**: NEVER single option. Include pros, cons, "best if" for each.
5. **Present design section by section**: Get feedback per section, not full dump.
   - Bối cảnh → Nguồn dữ liệu chuẩn → Kiến trúc giải pháp → Failure modes → Hoàn thành & Loại trừ → Câu hỏi mở
6. **Write spec document** to file:
   - Path: `docs/specs/YYYY-MM-DD-{topic}.md`
   - Format:

   ```markdown
   # Spec: {Tên feature}

   **Date**: {YYYY-MM-DD}

   ## 1. Bối cảnh

   **Origin**:

   - "{request gốc của user, copy nguyên văn}"

   **Problem**:

   - {2-3 dòng. Không prescribe solution.}

   **Decisions**:

   - {chốt gì, reject gì, lý do ngắn 1 dòng/decision}

   ## 2. Nguồn dữ liệu chuẩn

   **Canonical**:

   - {data/state/contract canonical, từ đâu}

   **KHÔNG phải nguồn chuẩn**:

   - {data/state không được dùng làm canonical}

   ## 3. Kiến trúc giải pháp

   **Components**:

   - **{Component}**: {conceptual responsibility, không phải file list}

   **Data Flow**:

   - {Chỉ thêm khi non-trivial: async, money, auth, signature, multi-boundary, multi-source state}

   ## 4. Failure modes

   - Khi {trigger condition}, hệ thống phải {expected behavior}.
   - Khi {...}, hệ thống phải {...}.

   ## 5. Hoàn thành & Loại trừ

   **Done**:

   - {verifiable acceptance criterion}

   **Not done**:

   - {cụ thể gì không làm}
   - {constraints / soft limits}

   ## 6. Câu hỏi mở

   - **ASSUMPTION**: {...}
   - **QUESTION**: {...}
   - **BLOCKER**: {...}
   ```

   - Commit to git: `git add docs/specs/... && git commit -m "docs: add spec for {feature}"`

7. **Self-review inline** (no subagent). Re-read the spec with fresh eyes:
   - **Placeholder scan**: TBD, TODO, "fill in later", empty sections, vague requirements.
   - **Internal consistency**: any sections contradicting each other? Do Components match Failure Modes / Done?
   - **Scope check**: spec focused enough for one plan, or does it need decomposition into sub-projects?
   - **Ambiguity check**: any requirement that could be interpreted two ways? Pick one and write it explicitly.
   - Fix inline. No re-review needed.
8. **HARD GATE**: STOP. Present spec path + scope summary. "Do you approve this spec?"
9. **After human approves**: Suggest `→ Next: planning`. **ONLY** invoke the `planning` skill — do NOT auto-jump to any other implementation skill (frontend-design, code-review, tdd, etc.).

## Spec language

The spec body and section headings MUST be written in **Vietnamese**. Use English only for: file paths, commands, symbols, framework/library names, and the structural labels in the template (Origin, Problem, Decisions, Canonical, Components, Data Flow, Done, Not done, ASSUMPTION, QUESTION, BLOCKER).

## Examples

```
BAD:  Dump 10 questions at once.
GOOD: One question per message, wait for answer.

BAD:  Present single approach.
GOOD: "Approach A: ... / Approach B: ... Which direction?"

BAD:  (after self-review) "Let me start the implementation plan."
GOOD: (after self-review) "Spec written + self-reviewed. Do you approve this spec?"
```

## Enforcement

- **NEVER** dump all questions at once. One at a time.
- **NEVER** present a single option. Always 2-3 approaches.
- **NEVER** skip writing the spec document.
- **NEVER** proceed after self-review without human approval.
- **ALWAYS** self-review inline (placeholder/consistency/scope/ambiguity) after writing the spec.
- **ALWAYS** suggest `planning` as the next step after approval.

## Shared By

analyst
