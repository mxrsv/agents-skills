# Tài liệu & specs (D-rules)

## Ba tầng tài liệu

- **D1.** Sống = `VIẾT-HOA.md` ở gốc repo hoặc thẳng trong `docs/`, KHÔNG có ngày → cập nhật tại chỗ. Mốc = `docs/<loại>/YYYY-MM-DD-*` → viết xong đóng băng. Tạm = scratchpad → không commit.
- **D2.** Repo có `PIPELINE.lock` → theo convention pipeline đó: miễn **D3, D4, D6, D7**. **KHÔNG miễn D5** — bề mặt luật của agent thì pipeline nào cũng cần.

## Vị trí & tên

- **D3.** Thư mục con hợp lệ trong `docs/` CHỈ có `specs/`, `plans/`, `review/` (+ `review/assets/`), `mockups/`. File `.md` viết HOA thẳng trong `docs/` CHỈ có `ARCHITECTURE`, `CONTEXT`, `CODEMAP`, `OPERATIONS`, `PRODUCT`, `DESIGN`, `README`. Cần tên ngoài danh sách → HỎI.
- **D4.** Spec → `docs/specs/YYYY-MM-DD-<topic>-design.md`. Plan → `docs/plans/YYYY-MM-DD-<topic>.md`. Review → `docs/review/YYYY-MM-DD-<topic>.md`. NEVER `docs/superpowers/`, NEVER `.planning/`.
- **D5.** Mọi repo MUST có **cặp** `AGENTS.md` + `CLAUDE.md` ở gốc, với `CLAUDE.md` dòng đầu là `@AGENTS.md`. Claude Code KHÔNG tự đọc `AGENTS.md` — phải import; Codex và Cursor đọc trực tiếp. Kèm `docs/ARCHITECTURE.md` và `docs/CONTEXT.md`.

## Chống trôi so với code

- **D6.** Tài liệu sống MUST neo claim hành vi bằng markdown link **tương đối từ chính file chứa link**, kèm nhãn ý định ngay sau: `current` / `decided` / `building` / `deprecated`.
  - ✅ trong `docs/ARCHITECTURE.md`: `[move_pane_ownership](../src-tauri/src/coordinator.rs#L77-L88) \`current\``
- **D7.** Tài liệu sống MUST kết bằng mục "Chưa khớp thực tế" (bảng: claim / ý định / trạng thái / bằng chứng). Rỗng thì ghi rõ rỗng, KHÔNG bỏ mục. Claim `decided`/`building` KHÔNG vào bảng này — chúng là backlog.
- **D8.** Xoá/đổi tên module, gỡ tính năng → MUST cập nhật anchor trong tài liệu sống ngay trong cùng task.
- **D9.** Hoàn thành một plan → MUST cập nhật `docs/CONTEXT.md`; kiến trúc đổi → MUST cập nhật `docs/ARCHITECTURE.md`. Thuộc checklist W4.

## Quy trình

- **D10.** Feature qua brainstorm MUST có spec được duyệt trước khi code.
- **D11.** TRƯỚC KHI tạo doc mới → kiểm tra doc cùng chủ đề đã tồn tại; cập nhật thay vì nhân bản.
- **D12.** Thay đổi hành vi public (API, CLI, UI flow) → cập nhật `README.md`/`CHANGELOG.md` nếu repo có.
- **D13.** Ngày tuyệt đối `YYYY-MM-DD`, NEVER "hôm nay/tuần trước".
- **D14.** NEVER `git commit` tài liệu trước khi người dùng duyệt nội dung — áp cả khi skill bảo commit trước.
- **D15.** Ngôn ngữ docs theo `AGENTS.md` của repo; chưa khai → theo ngôn ngữ chủ đạo của docs hiện có.

## Checklist khi viết doc

- [ ] Đúng thư mục, đúng mẫu tên? (D3/D4)
- [ ] Tài liệu sống: anchor tương đối từ file + nhãn ý định + mục "Chưa khớp thực tế"? (D6/D7)
- [ ] Đã hỏi trước khi commit? (D14)
