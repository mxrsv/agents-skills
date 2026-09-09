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

- **D6.** Claim hành vi trong `AGENTS.md`, `README.md`, `CHANGELOG.md` MUST neo bằng markdown link **tương đối từ chính file chứa link**, kèm nhãn ý định ngay sau: `current` / `decided` / `building` / `deprecated`. Trang dưới `docs/{user,internals,operations}/` và `docs/README.md` chỉ cần link còn sống (`docs-anchors.sh` quét cả hai nhóm), không bắt buộc nhãn.
  - ✅ trong `AGENTS.md`: `[move_pane_ownership](src-tauri/src/coordinator.rs#L77-L88) \`current\``
- **D11.** TRƯỚC KHI tạo doc mới → kiểm tra doc cùng chủ đề đã tồn tại; cập nhật thay vì nhân bản.
- **D15.** Ngôn ngữ docs theo `AGENTS.md` của repo; chưa khai → theo ngôn ngữ chủ đạo của docs hiện có.

## Checklist khi viết doc

- [ ] Spec/plan/review vào issue Linear, không vào `docs/`? (D0/D4)
- [ ] Đúng tầng `user/` · `internals/` · `operations/`, và "maintainer sẽ làm sai nếu thiếu"? (D3/D9)
- [ ] Viết lại thay vì nối thêm; link còn sống, `AGENTS.md` có nhãn ý định? (D1/D6)
- [ ] Đã hỏi trước khi commit? (D14)
