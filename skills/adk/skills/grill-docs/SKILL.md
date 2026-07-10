---
name: grill-docs
description: Explicit elicitation helper for adk phases. Challenges a draft, returns text suggestions, and lets the parent phase update CONTEXT.md. Never writes ADRs directly.
disable-model-invocation: true
---

# Grill docs

Đọc trước `../../references/elicitation-contract.md`.

1. Chạy `adk:grill` trên doc/nháp cần thử lửa; dùng kỹ thuật làm sắc thuật ngữ của `domain-modeling` khi hữu ích.
2. Chỉ trả **text đề xuất** cho phase skill cha. Phase cha là bên duy nhất quyết định nội dung nào được ghi vào `CONTEXT.md`.
3. **CẤM** tự ghi `PIPELINE.lock`, pipeline docs, `docs/decisions/` hoặc bất kỳ ADR nào.
4. Nếu một quyết định đáng ghi đã kết tinh, nhắc user gọi `/adk:adr`; không tạo ADR thay user.
