# Tài liệu & specs (D-rules)

- **D1.** Specs → `docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md`. Plans → `docs/superpowers/plans/YYYY-MM-DD-<topic>.md`.
- **D2.** Repo dùng pipeline docs riêng (vd adk, nhận diện qua `PIPELINE.lock`) → theo convention của pipeline đó, bỏ qua D1.
- **D3.** Ngôn ngữ docs/comments: theo mục "Ngôn ngữ" trong `AGENTS.md` của repo; chưa khai → theo ngôn ngữ chủ đạo của docs hiện có.
- **D4.** Feature qua brainstorm MUST có spec được duyệt trước khi code (mặt docs của W1).
- **D5.** Thay đổi hành vi public (API, CLI, UI flow) → cập nhật README/CHANGELOG nếu repo có.
- **D6.** TRƯỚC KHI tạo doc mới → kiểm tra doc cùng chủ đề đã tồn tại (F1 áp cho docs) — cập nhật thay vì nhân bản.
- **D7.** Doc ghi quyết định/sự kiện → dùng ngày tuyệt đối `YYYY-MM-DD`, NEVER "hôm nay/tuần trước".

## Checklist khi viết doc

- [ ] Đúng chỗ, đúng format tên? (D1/D2)
- [ ] Đúng ngôn ngữ của repo? (D3)
- [ ] Ngày tháng tuyệt đối? (D7)
