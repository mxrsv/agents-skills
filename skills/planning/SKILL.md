---
name: planning
description: Turn an approved spec (the Linear issue's description) into an implementation plan — a `## Plan` checklist in the issue for small work, sub-issues for work that spans several commits or sessions. Use after "what to build" is clear. Trigger phrases - "plan this", "break into tasks". Not for vague requests - go back to `brainstorm` first.
argument-hint: [issue-id]
---

# Planning

> **Harness note.** The plan is written with the Linear MCP (`save_issue` — Claude Code tool id `mcp__plugin_linear_linear__save_issue`). In Codex or Cursor without that server, print the finished plan in chat as one fenced markdown block and name the issue it belongs on. **Never write a plan file into the repo** (D4); `docs/plans/` is gone and `file-guard.sh` warns after a write there (PostToolUse — it does not refuse).

## Role

Create a detailed implementation plan: file paths, tasks, verify steps. Runs inline in the main thread — does NOT dispatch a subagent.

## Initial issue (from invocation)

If `$issue-id` is provided (`MXR-12`), that issue is the plan's home. Otherwise derive it from the conversation or ask. `get_issue` + `list_comments` first: the description is the spec (D0), and a decision comment newer than the description wins.

## When to use

- A spec exists in the issue (from `brainstorm`, or written by the user) and the human has approved it in conversation.
- Or the task is clear enough and the user requests a plan directly.

W2: plan only when the work spans several commits or sessions, or the user asks. A one-commit task needs no plan — do it.

DO NOT use if WHAT/WHY is still unclear → go back to `brainstorm` first.

## Workflow

1. **Read context**:
   - `get_issue` the issue → the spec. `list_comments` → decisions that amend it.
   - Search and read related files to verify current state.
2. **Clarify** (only if needed): if the objective is ambiguous AND a wrong interpretation would produce a significantly different plan → state the assumption and ask ONE question.
3. **Choose the shape**, by size:
   - **≤ 6 tasks, one session** → one `## Plan` section in the issue description.
   - **Larger, or several sessions / people** → one sub-issue per task (`save_issue { team, parentId: <issue>, title: "Task N: …", description }`), plus a short `## Plan` in the parent that lists them in order. A sub-issue holds exactly the Task block below.
4. **Write the plan**. Show the full text in chat first (D14), then:
   - Description has no `## Plan` → `save_issue { id, patch: [{ op: "append", text: "\n\n## Plan\n…" }] }`.
   - Description already has `## Plan` → `patch` with `replace_range` from `## Plan` to the next `## ` heading (or `replace` of the whole section). Rewrite in place; never leave two plans in one description.
5. **Self-review inline** (no subagent). `get_issue` again and re-read what Linear holds:
   - **Spec coverage**: every Failure Mode + Done criterion in the spec must map to a task. List gaps if any.
   - **Placeholder scan**: see the "No Placeholders" section below — no red flags allowed.
   - **Type consistency**: function/method/property names used in later tasks must match earlier tasks. `clearLayers()` in Task 3 but `clearAllLayers()` in Task 7 → bug.
   - Fix inline with another `patch`. No re-review needed.
6. **Hard gate**: STOP. Present the issue URL + scope summary. Ask: "Approve this plan?". WAIT for user response — DO NOT auto-advance.
7. After user approves → suggest `→ Next: plan-review` (or `/review <issue-id>`).

## Plan format

### Constraints

- The plan body and section headings MUST be written in **English**, independent of the active Output Style and of the conversation language (LW19 — the plan is Linear content).
- Inside an issue description the plan starts at `## Plan`; its sections are `###`. In a sub-issue the Task block is the whole description and starts at `## Task N: …`.
- NO markdown tables, NO emoji, NO full code (shapes/key interfaces only).
- File paths are plain backticked repo-relative paths (`src/auth/session.ts`) — a Linear description has no repo to resolve a relative link against.
- Each task is 2–10 minutes. A task touching > 3 files or > 2 concerns → split it.
- Checkboxes (`- [ ]`) on tasks, so progress is visible in the issue.

### Template

```markdown
## Plan

**Goal**: {one sentence describing what this plan builds}
**Architecture**: {2-3 sentences on the main technical approach}

### 1. Expected outcomes

{The end state to reach. Every item must be verifiable with a specific test/command/check.}

- {outcome 1} — verify with `{command or test name}`
- {outcome 2} — verify with `{command or test name}`

### 2. Canonical data sources

**Canonical data**: {which data is the source of truth, and where it comes from}

**Taken from**: {allowed sources}

**NOT taken from**: {forbidden sources and a short reason}

### 3. Rules & invariants

- **{Rule name}**: {rule description} — verify with `{how to check}`
- **{Invariant name}**: {technical guarantee} — verify with `{how to check}`

### 4. Scope / Out of scope

**Do**:

- {specific item 1}
- {specific item 2}

**Do NOT**:

- {specific excluded item 1}
- {specific excluded item 2}

<!-- Add section 5 only when there are ≥3 open decisions OR the plan is expected to exceed 500 lines -->

### 5. Risks & open decisions

**Decided with risk**:

- {decision made} — risk: {specific consequence}

**Undecided, must resolve**:

- {question to answer before implementing}

### 6. Tasks

- [ ] **Task 1: {task name}**

  **File(s)**:

  - `path/to/exact-file.ts`
  - `path/to/new-file.ts`

  **Depends on**: Task X (add this field only when there is a real dependency)

  **Decision**: {WHAT was decided — do not write WHY here}

  **Build**:

  - {specific action 1}
  - {specific action 2}

  **Verify**:

  - `{command}` → output `{expected}`
  - test `{test name}` pass

- [ ] **Task 2: …**
```

### Field rules

- `Decision`: WHAT only. WHY belongs in section 5 "Risks & open decisions".
- `Verify`: MUST reference a test name / command output / specific file check — never vague.
- `Depends on`: optional. Add only when the task genuinely depends on another task finishing first. Otherwise omit the field. For sub-issues, also set `blockedBy` on the sub-issue so Linear shows the order.

### No Placeholders

The plan MUST NOT contain any of these patterns — they are plan failures, fix inline before the Hard gate:

- `TBD`, `TODO`, "fill in later", "implement later"
- "Add appropriate error handling" / "add validation" / "handle edge cases" — must specify which error, what to validate
- "Write tests for the above" — no concrete test name
- "Similar to Task N" — repeat the content, the engineer may read tasks out of order
- Vague verify: "test it works", "check output looks right" — must give command + expected output
- Reference to a symbol/function/file not defined by any task in the plan

## While executing

Tick the checkbox of each task as it lands (`patch` `replace` `- [ ] **Task N` → `- [x] **Task N`), or move the sub-issue's state. The issue is the progress record; do not keep a parallel checklist anywhere else.
