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

- The plan body and section headings MUST be written in **Vietnamese**, independent of the active Output Style. Use English only for: file paths, commands, symbols, framework/library names.
- Inside an issue description the plan starts at `## Plan`; its sections are `###`. In a sub-issue the Task block is the whole description and starts at `## Task N: …`.
- NO markdown tables, NO emoji, NO full code (shapes/key interfaces only).
- File paths are plain backticked repo-relative paths (`src/auth/session.ts`) — a Linear description has no repo to resolve a relative link against.
- Each task is 2–10 minutes. A task touching > 3 files or > 2 concerns → split it.
- Checkboxes (`- [ ]`) on tasks, so progress is visible in the issue.

### Template

```markdown
## Plan

**Goal**: {1 câu mô tả plan này build cái gì}
**Architecture**: {2-3 câu về approach kỹ thuật chính}

### 1. Kết quả mong đợi

{Trạng thái cuối cần đạt. Mỗi item phải verifiable bằng test/command/check cụ thể.}

- {outcome 1} — verify bằng `{command hoặc test name}`
- {outcome 2} — verify bằng `{command hoặc test name}`

### 2. Nguồn dữ liệu chuẩn

**Canonical data**: {data nào là nguồn gốc, lấy từ đâu}

**Lấy từ**: {nguồn được phép}

**KHÔNG lấy từ**: {nguồn bị cấm và lý do ngắn gọn}

### 3. Business rules & invariants

- **{Tên rule}**: {mô tả rule} — verify bằng `{cách kiểm tra}`
- **{Tên invariant}**: {guarantee kỹ thuật} — verify bằng `{cách kiểm tra}`

### 4. Phạm vi / Ngoài phạm vi

**Làm**:

- {việc cụ thể 1}
- {việc cụ thể 2}

**KHÔNG làm**:

- {việc cụ thể bị loại trừ 1}
- {việc cụ thể bị loại trừ 2}

<!-- Add section 5 only when there are ≥3 open decisions OR the plan is expected to exceed 500 lines -->

### 5. Rủi ro & Quyết định còn mở

**Đã chốt có rủi ro**:

- {decision đã chốt} — rủi ro: {consequence cụ thể}

**Chưa chốt cần resolve**:

- {câu hỏi cần trả lời trước khi implement}

### 6. Các task

- [ ] **Task 1: {tên task}**

  **File(s)**:

  - `path/to/exact-file.ts`
  - `path/to/new-file.ts`

  **Phụ thuộc**: Task X (chỉ thêm field này khi thực sự có dependency)

  **Decision**: {WHAT đã chốt — không viết WHY ở đây}

  **Build**:

  - {action cụ thể 1}
  - {action cụ thể 2}

  **Verify**:

  - `{command}` → output `{expected}`
  - test `{test name}` pass

- [ ] **Task 2: …**
```

### Field rules

- `Decision`: WHAT only. WHY belongs in section 5 "Rủi ro & Quyết định còn mở".
- `Verify`: MUST reference a test name / command output / specific file check — never vague.
- `Phụ thuộc`: optional. Add only when the task genuinely depends on another task finishing first. Otherwise omit the field. For sub-issues, also set `blockedBy` on the sub-issue so Linear shows the order.

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
