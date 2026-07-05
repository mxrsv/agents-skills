---
description: Create or update a plan file at `docs/plans/{YYYY-MM-DD}-{feature}.md` from a spec or available context.
when_to_use: After "what to build" is clear — has a written spec at `docs/specs/`, or the task is well-defined. Trigger phrases - "plan this", "break into tasks", "/planning". NOT for vague requests — go back to `brainstorm` first.
argument-hint: [feature-name]
arguments: feature
---

# Planning

## Role

Create a detailed implementation plan: file paths, tasks, verify steps. Runs inline in the main thread — does NOT dispatch a subagent.

## Initial feature (from invocation)

If `$feature` is provided, use it as the `{feature}` slug in the plan filename (`docs/plans/{YYYY-MM-DD}-$feature.md`) and pre-fill the plan title. Otherwise, derive the slug from the spec or ask the user.

## When to use

- A spec exists from `brainstorm` (`docs/specs/...`) and human has approved it in conversation.
- Or the task is clear enough and the user requests a plan directly.

DO NOT use if WHAT/WHY is still unclear → go back to `brainstorm` first.

## Workflow

1. **Read context**:
   - If a spec exists → `Read` the spec.
   - `Glob`/`Grep`/`Read` related files to verify current state.
2. **Clarify** (only if needed): if the objective is ambiguous AND a wrong interpretation would produce a significantly different plan → state the assumption and ask ONE question.
3. **Write the plan** to `docs/plans/{YYYY-MM-DD}-{feature}.md`. If the file already exists → `Edit` it directly, DO NOT create a new file.
4. **Self-review inline** (no subagent). Re-read the plan with fresh eyes:
   - **Spec coverage**: if a spec exists, every Failure Mode + Done criterion must map to a task. List gaps if any.
   - **Placeholder scan**: see the "No Placeholders" section below — no red flags allowed.
   - **Type consistency**: function/method/property names used in later tasks must match earlier tasks. `clearLayers()` in Task 3 but `clearAllLayers()` in Task 7 → bug.
   - Fix inline. No re-review needed.
5. **Hard gate**: STOP. Present the plan path + scope summary. Ask: "Approve this plan?". WAIT for user response — DO NOT auto-advance.
6. After user approves → suggest `→ Next: plan-review`.

## Plan format

### Constraints

- The plan body and section headings MUST be written in **Vietnamese**. Use English only for: file paths, commands, symbols, framework/library names.
- The first line MUST be a level-1 heading (`# ...`).
- NO markdown tables, NO emoji, NO full code (shapes/key interfaces only).
- File paths MUST always use full markdown links: `[foo.ts](relative/path/to/foo.ts)`.
- Each task is 2–10 minutes. A task touching > 3 files or > 2 concerns → split it.

### Template

```markdown
# {Tiêu đề plan}

**Spec**: [{YYYY-MM-DD}-{topic}](../specs/{YYYY-MM-DD}-{topic}.md)
**Goal**: {1 câu mô tả plan này build cái gì}
**Architecture**: {2-3 câu về approach kỹ thuật chính}

## 1. Kết quả mong đợi

{Trạng thái cuối cần đạt. Mỗi item phải verifiable bằng test/command/check cụ thể.}

- {outcome 1} — verify bằng `{command hoặc test name}`
- {outcome 2} — verify bằng `{command hoặc test name}`

## 2. Nguồn dữ liệu chuẩn

**Canonical data**: {data nào là nguồn gốc, lấy từ đâu}

**Lấy từ**: {nguồn được phép}

**KHÔNG lấy từ**: {nguồn bị cấm và lý do ngắn gọn}

## 3. Business rules & invariants

- **{Tên rule}**: {mô tả rule} — verify bằng `{cách kiểm tra}`
- **{Tên invariant}**: {guarantee kỹ thuật} — verify bằng `{cách kiểm tra}`

## 4. Phạm vi / Ngoài phạm vi

**Làm**:

- {việc cụ thể 1}
- {việc cụ thể 2}

**KHÔNG làm**:

- {việc cụ thể bị loại trừ 1}
- {việc cụ thể bị loại trừ 2}

<!-- Section 5 chỉ thêm khi có ≥3 open decisions HOẶC plan dự kiến >500 dòng -->

## 5. Rủi ro & Quyết định còn mở

**Đã chốt có rủi ro**:

- {decision đã chốt} — rủi ro: {consequence cụ thể}

**Chưa chốt cần resolve**:

- {câu hỏi cần trả lời trước khi implement}

## 6. Các task

### Task 1: {tên task}

**File(s)**:

- [exact-file.ts](path/to/exact-file.ts)
- [new-file.ts](path/to/new-file.ts)

**Phụ thuộc**: Task X (chỉ thêm field này khi thực sự có dependency)

**Decision**: {WHAT đã chốt — không viết WHY ở đây}

**Build**:

- {action cụ thể 1}
- {action cụ thể 2}

**Verify**:

- `{command}` → output `{expected}`
- test `{test name}` pass

---
```

### Field rules

- `Decision`: WHAT only. WHY belongs in section 5 "Rủi ro & Quyết định còn mở".
- `Verify`: MUST reference a test name / command output / specific file check — never vague.
- `Phụ thuộc`: optional. Add only when the task genuinely depends on another task finishing first. Otherwise omit the field.

### No Placeholders

The plan MUST NOT contain any of these patterns — they are plan failures, fix inline before the Hard gate:

- `TBD`, `TODO`, "fill in later", "implement later"
- "Add appropriate error handling" / "add validation" / "handle edge cases" — must specify which error, what to validate
- "Write tests for the above" — no concrete test name
- "Similar to Task N" — repeat the content, the engineer may read tasks out of order
- Vague verify: "test it works", "check output looks right" — must give command + expected output
- Reference to a symbol/function/file not defined by any task in the plan
