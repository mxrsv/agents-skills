---
name: grill-docs
description: Explicit elicitation helper for adk phases (v2). Spawns adk:grill as a fresh-context, read-only subagent to challenge a draft, returns the subagent's text suggestions to the caller, and lets the caller update CONTEXT.md. Never writes ADRs or any pipeline file directly.
disable-model-invocation: true
---

# Grill docs (v2 — wrapper quanh subagent)

Đọc trước `../../references/elicitation-contract.md`.

1. **Spawn `adk:grill` như một subagent riêng** (loại `explore` hoặc `generalPurpose`, **read-only tools**, **fresh context** — không kế thừa lịch sử hội thoại của caller) chạy nội dung `../grill/SKILL.md` trên doc/nháp cần thử lửa. Dùng kỹ thuật làm sắc thuật ngữ của `domain-modeling` khi hữu ích trong prompt cho subagent.
   - **Vì sao bắt buộc subagent (không chạy inline):** grill inline "biết" caller muốn nghe gì → mất epistemic independence. Subagent fresh-context không có lịch sử đó, phản biện thật hơn.
2. Nhận **text đề xuất + hướng-đã-loại + lý do loại** từ subagent → trả nguyên văn (hoặc tóm tắt trung thực) cho caller (phase skill / `adk:adr`).
3. **Caller là bên duy nhất** quyết định nội dung nào được ghi vào `CONTEXT.md`. `grill-docs` bản thân không ghi gì.
4. **CẤM tuyệt đối**: tự ghi `PIPELINE.lock`, bất kỳ doc dẫn xuất nào, hoặc `docs/decisions/`.
5. Phát hiện một quyết định đáng ghi đã kết tinh trong lúc grill → nhắc user gõ `/adk:adr`; không tự tạo ADR thay user.
