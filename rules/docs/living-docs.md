---
paths:
  - "docs/**"
  - "**/AGENTS.md"
  - "**/README.md"
  - "**/CHANGELOG.md"
---

# Tài liệu sống — luật khi đang sửa doc (D-rules bổ sung)

Nạp khi chạm `docs/**`, `AGENTS.md`, `README.md`, `CHANGELOG.md`.
Luật D-rules luôn bật nằm ở `~/.claude/rules/core/docs.md`.

- **D6.** Claim hành vi trong `AGENTS.md`, `README.md`, `CHANGELOG.md` và mọi trang dưới `docs/` MUST neo bằng markdown link **tương đối từ chính file chứa link**, và link phải còn sống (`docs-anchors.sh` quét cả hai nhóm). **Nhãn ý định `current`/`decided`/`building`/`deprecated` đã bỏ 2026-09-09** — nhãn đánh dấu trạng thái của spec/plan/CONTEXT, và bộ đó sống trong issue Linear chứ không trong repo; một tài liệu còn trong repo thì mặc định là đang đúng, sai thì sửa chứ không dán nhãn.
  - ✅ trong `AGENTS.md`: `[move_pane_ownership](electron/coordinator.ts)`
- **D11.** TRƯỚC KHI tạo doc mới → kiểm tra doc cùng chủ đề đã tồn tại; cập nhật thay vì nhân bản.
- **D15.** Ngôn ngữ docs theo `AGENTS.md` của repo; chưa khai → theo ngôn ngữ chủ đạo của docs hiện có.

## Checklist khi viết doc

- [ ] Spec/plan/review vào issue Linear, không vào `docs/`? (D0/D4)
- [ ] Đúng tầng `user/` · `internals/` · `operations/`, và "maintainer sẽ làm sai nếu thiếu"? (D3/D9)
- [ ] Viết lại thay vì nối thêm; mọi link còn sống? (D1/D6)
- [ ] Đã hỏi trước khi commit? (D14)
