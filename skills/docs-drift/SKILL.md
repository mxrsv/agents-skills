---
name: docs-drift
description: Đối chiếu tài liệu sống với code thật để tìm chỗ tài liệu mô tả hành vi code không có. Mặc định là scan READ-ONLY, không ghi file nào. Chỉ ghi khi chạy với --apply và sau khi người dùng duyệt diff. Fires ONLY when the user types /docs-drift.
---

# docs-drift — audit tài liệu đối chiếu code

## Hai chế độ, tách hẳn

| Lệnh                  | Quyền                                                                                                                         |
| --------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| `/docs-drift`         | **READ-ONLY TUYỆT ĐỐI.** Không ghi file nào, kể cả ledger. In báo cáo ra màn hình.                                            |
| `/docs-drift --apply` | Đăng ledger thành comment trên issue Linear (hoặc tạo issue mới) + sửa/xoá đoạn doc drift. Trình **diff** cho người dùng duyệt trước. **Không** `git add`, **không** `git commit`. |

Mặc định là scan. Chỉ chuyển sang apply khi người dùng gõ tường minh `--apply`.

Trước khi ghi bất cứ gì ở chế độ apply: chạy `git status --porcelain` và báo nếu worktree đang bẩn — người duyệt cần phân biệt diff nào của skill, diff nào có sẵn.

## Bước 0 — chạy tầng 1 trước

`bash ~/.claude/scripts/docs-anchors.sh <doc-root>` để có danh sách anchor chết. Đó là drift chắc chắn, khỏi verify lại.

## Bước 1 — trích claim kèm ý định

Tài liệu sống = `AGENTS.md`, `README.md`, `CHANGELOG.md` ở gốc + `docs/README.md`, `docs/DESIGN-LANGUAGE.md`, mọi file dưới `docs/{user,internals,operations}/` (+ `docs/*.md` viết HOA legacy còn chưa dọn: `ARCHITECTURE.md`, `CONTEXT.md`, `PRD.md`…). KHÔNG đụng `specs/`, `plans/`, `review/`, `mockups/` — legacy đóng băng, chờ dọn; việc đang làm là issue Linear.

Mỗi claim có **ý định** (nhãn backtick sau anchor; thiếu nhãn → mặc định `current`):

| Nhãn         | Nghĩa                     |
| ------------ | ------------------------- |
| `current`    | mô tả trạng thái hiện tại |
| `decided`    | đã quyết, chưa bắt đầu    |
| `building`   | đang làm                  |
| `deprecated` | đã gỡ, giữ để tham chiếu  |

**CHỈ audit claim `current`.** Claim `decided`/`building` mà code chưa có là **backlog đúng đắn** — KHÔNG đánh dấu drift, KHÔNG đưa vào bảng "Chưa khớp thực tế". Bỏ qua luôn đoạn tự đánh dấu "net-new / gap".

## Bước 2 — xác minh bằng code, không bằng doc khác

1. `grep` / `glob` trong thư mục nguồn.
2. Chạy test liên quan.
3. `git log --all -S'<symbol>' -- ':!docs/'` khi cần biết symbol từng tồn tại chưa.

⚠️ **`-S` tự đầu độc — BẮT BUỘC `-- ':!docs/'`.** Bản audit trước ghi `git log --all -S'FileSidebar'` → 0 commit; chạy lại sau đó → 1 commit, chính commit chứa bản audit. Không loại `docs/` thì mọi kết luận `not-in-history` tự phá sau lần chạy đầu.

## Bước 3 — phân loại

`shipped` · `partial` · `not-in-history` · `removed` · `contradicted` · `unknown`.

- `partial` phải nói rõ phần nào có, phần nào không — KHÔNG gộp thành "có".
- Trước khi kết luận `not-in-history`: chạy `git rev-parse --is-shallow-repository` và tìm squash-merge. Có shallow hoặc squash → hạ xuống `unknown` kèm lý do. `-S` chỉ chứng minh "không thấy trong lịch sử reachable".

## Ràng buộc cứng

- KHÔNG sửa code sản phẩm.
- Chế độ scan: KHÔNG ghi file nào.
- Chế độ apply: chỉ đăng ledger lên Linear + sửa đúng đoạn doc bị drift đã duyệt (D7: sửa hoặc xoá tại chỗ, KHÔNG thêm bảng "Chưa khớp thực tế"). Sửa ngoài các đoạn đó phải hỏi riêng.
- KHÔNG suy từ doc sang doc. Mọi kết luận trỏ được về `file:line` hoặc lệnh git có output.
- Không xác minh được → `unknown` kèm lý do. KHÔNG đoán.
- KHÔNG `git add`, KHÔNG `git commit` (D14).

## Đầu ra khi `--apply`

1. Ledger — comment `save_comment { issueId }` trên issue đang làm (không có → hỏi; người dùng cho phép thì `save_issue { team, title: "docs drift <repo> @<sha7>" }` rồi comment vào đó): claim, tài liệu nguồn, ý định, trạng thái, bằng chứng, HEAD sha lúc audit. Không có Linear MCP → in ledger ra chat, không ghi file.
2. Đoạn doc bị drift trong tài liệu sống: viết lại cho đúng, hoặc xoá — **sau khi diff được duyệt** (D1, D7).
3. Danh sách việc cần người quyết, xếp theo mức rủi ro nếu để nguyên; mỗi việc là một dòng trong comment, người dùng tách issue nếu muốn.
