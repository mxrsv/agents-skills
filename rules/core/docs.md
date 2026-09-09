# Tài liệu & specs (D-rules)

## Spec của công việc

- **D0.** Spec mặc định nằm trong **issue Linear**: description ghi mục tiêu, phạm vi, quyết định và acceptance criteria. Đọc issue cùng các comment quyết định liên quan trước khi làm; quyết định mới của người dùng thay phần cũ đã bị thay thế. Issue đủ rõ và đã được giao triển khai thì làm, không yêu cầu viết hoặc duyệt lại cùng một spec trong repo.
- Chỉ tạo file spec trong repo khi người dùng yêu cầu rõ. Nếu chưa có issue, có thể soạn nội dung spec trong hội thoại; việc tạo/cập nhật issue theo phạm vi người dùng giao. Tài liệu trong repo chỉ liên kết tới issue khi cần, không giữ hai bản spec song song. Quy tắc này ưu tiên hơn bước bắt buộc ghi file spec trong các skill.
- Không tự tạo checkpoint, daily hoặc nhật ký theo ngày; không dùng hook để ép các bước này. Tài liệu sống vẫn cập nhật theo thay đổi của code; tài liệu lịch sử đã có được giữ nguyên.

## Ba tầng tài liệu

- **D1.** Sống = `AGENTS.md`, `README.md`, `CHANGELOG.md` ở gốc; `docs/README.md`, `docs/DESIGN-LANGUAGE.md` và mọi file dưới `docs/{user,internals,operations}/` → cập nhật tại chỗ: quyết định đổi thì VIẾT LẠI hoặc xoá đoạn cũ, không nối thêm bản kể thứ hai. Việc đang làm (spec, plan, research, review) = issue Linear (D0, D4), không commit vào repo; PR đã merge là bản ghi hiện thực. Tạm = scratchpad → không commit.
- **D2.** Repo có `PIPELINE.lock` → theo convention pipeline đó: miễn **D3, D4, D6**. **KHÔNG miễn D5** — bề mặt luật của agent thì pipeline nào cũng cần.

## Vị trí & tên

- **D3.** Thư mục con hợp lệ trong `docs/` CHỈ có ba tầng theo người đọc: `user/` (dùng sản phẩm), `internals/` (quyết định kiến trúc, constraint xuyên module, trap khó thấy từ code), `operations/` (runbook maintainer: setup, release, debug). File `.md` thẳng trong `docs/` CHỈ có `README.md` (index) và `DESIGN-LANGUAGE.md` khi repo có luật thiết kế số hoá. `internals/` là nơi duy nhất nhận doc mới, và chỉ khi "maintainer sẽ làm sai nếu thiếu đoạn này"; đọc code trả lời được thì bỏ. Cần tên ngoài danh sách → HỎI. NEVER `docs/specs/`, `docs/plans/`, `docs/review/`, `docs/superpowers/`, `.planning/`.
- **D4.** Spec → description của issue Linear (D0). Plan → sub-issue của issue đó, hoặc mục `## Plan` checklist trong description khi nhỏ. Review → comment trên issue hoặc review comment trên PR; ảnh/asset → attachment của issue. Chỉ tạo file trong repo khi người dùng yêu cầu rõ, và khi đó file chỉ liên kết tới issue, không giữ hai bản song song.
- **D5.** Mọi repo MUST có **cặp** `AGENTS.md` + `CLAUDE.md` ở gốc, với `CLAUDE.md` dòng đầu là `@AGENTS.md`. Claude Code KHÔNG tự đọc `AGENTS.md` — phải import; Codex và Cursor đọc trực tiếp. Kiến trúc, quyết định còn hiệu lực và trap → `docs/internals/` (điểm vào: `docs/internals/overview.md`); KHÔNG còn `docs/ARCHITECTURE.md` hay `docs/CONTEXT.md` — trạng thái "đang làm gì" sống trong issue Linear.

## Chống trôi so với code

- **D7.** Drift (doc nói X, code làm Y) phát hiện trong task → sửa đoạn doc đó ngay nếu thuộc scope; ngoài scope → ghi thành issue Linear (hoặc comment trên issue đang làm) kèm `file:line` hai phía. KHÔNG giữ bảng "Chưa khớp thực tế" trong tài liệu — bảng đó là backlog trá hình, đã bỏ 2026-09-07 (MXR-37).
- **D8.** Xoá/đổi tên module, gỡ tính năng → MUST cập nhật anchor trong tài liệu sống ngay trong cùng task.
- **D9.** Task làm đổi kiến trúc, constraint xuyên module hoặc thêm trap → cập nhật trang `docs/internals/` liên quan trong cùng PR; đổi cách dùng → `docs/user/`; đổi runbook → `docs/operations/`. Chỉ khi "maintainer sẽ làm sai nếu thiếu"; PR summary, catalog file, kể lại control-flow → KHÔNG. Thuộc checklist W4.

## Quy trình

- **D10.** Feature qua brainstorm cần spec được duyệt trước khi code; nội dung issue Linear và quyết định đã được người dùng chốt là spec hợp lệ (D0), không cần thêm file hoặc lượt duyệt trùng lặp.
- **D12.** Thay đổi hành vi public (API, CLI, UI flow) → cập nhật `README.md`/`CHANGELOG.md` nếu repo có.
- **D13.** Ngày tuyệt đối `YYYY-MM-DD`, NEVER "hôm nay/tuần trước".
- **D14.** NEVER `git commit` tài liệu (`AGENTS.md`, `docs/**`) trước khi người dùng duyệt nội dung — áp cả khi skill bảo commit trước. Cập nhật issue/document Linear thì trình nội dung trong hội thoại trước khi ghi, trừ khi người dùng đã giao rõ.

## Khi đang sửa doc

- **D6, D11, D15** và checklist viết doc → `~/.claude/rules/docs/living-docs.md`, nạp tự động khi chạm `docs/**`, `AGENTS.md`, `README.md`, `CHANGELOG.md`.
