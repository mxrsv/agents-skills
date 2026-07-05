---
name: html-artifact
description: Tạo HTML artifact tự chứa (mở trực tiếp bằng browser) theo hệ thiết kế chưng cất từ bộ example "The unreasonable effectiveness of HTML". CHỈ dùng khi người dùng gọi tường minh /html-artifact — không tự kích hoạt cho các yêu cầu UI/frontend thông thường.
---

# HTML Artifact

Tạo một file `.html` tự chứa duy nhất — không build, không CDN, không external request — trình bày nội dung theo đúng hệ thiết kế và chất lượng của bộ example gốc.

## Cách gọi

```
/html-artifact <loại> [mô tả ngữ cảnh]
```

- **Không có tham số hoặc loại không khớp** → hiển thị bảng chọn loại bên dưới và hỏi người dùng, KHÔNG đoán mò.
- Với loại `unknowns`, hỏi thêm biến thể nếu người dùng chưa nêu: `blindspot` / `interview` / `brainstorm` / `quiz` / `pitch`.

## Bảng chọn loại

| Loại                  | Khi nào dùng                                                                                                | Reference                           |
| --------------------- | ----------------------------------------------------------------------------------------------------------- | ----------------------------------- |
| `code-approaches`     | So sánh 2–4 hướng tiếp cận code cho một bài toán, kèm trade-off và khuyến nghị                              | `references/code-approaches.md`     |
| `design-directions`   | Trình bày nhiều hướng thiết kế visual để người xem chọn                                                     | `references/design-directions.md`   |
| `implementation-plan` | Kế hoạch triển khai dạng trang duyệt được: bước, trạng thái, quyết định, rủi ro                             | `references/implementation-plan.md` |
| `unknowns`            | Lộ ra điều chưa biết trước khi quyết định: quét điểm mù, phỏng vấn, brainstorm, quiz trước merge, pitch doc | `references/unknowns-toolkit.md`    |
| `flowchart`           | Sơ đồ luồng/quy trình/kiến trúc bằng SVG                                                                    | `references/flowchart.md`           |
| `concept-explainer`   | Giải thích khái niệm/feature cho người chưa biết                                                            | `references/concept-explainer.md`   |
| `code-understanding`  | Bản đồ hiểu một vùng code: kiến trúc, luồng, file quan trọng                                                | `references/code-understanding.md`  |
| `svg-illustration`    | Minh họa SVG inline (diagram tự do, hình vẽ kỹ thuật)                                                       | `references/svg-illustration.md`    |

## Quy trình (5 bước)

1. **Xác định loại** từ tham số. Không khớp → hỏi lại bằng bảng trên.
2. **Đọc references**: LUÔN đọc `references/foundation.md` (tokens + component chung) TRƯỚC, rồi đọc reference của loại đã chọn. Nếu cần chi tiết vượt quá phần chưng cất, đọc thêm file example gốc theo đường dẫn ghi cuối reference (bỏ qua nếu file không tồn tại).
3. **Thu thập dữ liệu thật** từ ngữ cảnh hội thoại và codebase (đọc code, chạy lệnh khi cần). KHÔNG bịa số liệu/tên file/code snippet. Thiếu thông tin then chốt → hỏi người dùng. Chỗ nào buộc phải để trống → đánh dấu rõ `[CẦN SỐ LIỆU]`.
4. **Viết file HTML** tự chứa vào thư mục làm việc hiện tại (hoặc vị trí người dùng chỉ định), tên file có nghĩa (vd. `flowchart-auth-flow.html`). Bắt đầu từ skeleton trong `foundation.md`, áp cấu trúc trang + pattern đặc thù từ reference của loại.
5. **Kiểm tra checklist** bên dưới + checklist nội dung riêng trong reference, rồi gửi file cho người dùng (SendUserFile, display render).

## Checklist chất lượng chung

- [ ] Tự chứa 100%: không CDN, không font/ảnh/script external, không fetch.
- [ ] Có dòng attribution `<!-- Copyright 2026 Anthropic PBC · SPDX-License-Identifier: Apache-2.0 -->` ở đầu file (skeleton trích từ repo Apache 2.0).
- [ ] `<html lang="vi">`, có `<title>` cụ thể, meta viewport.
- [ ] Dùng đúng design tokens trong `foundation.md` — không tự chế palette mới.
- [ ] Container `.page` max-width + margin auto; bảng/sơ đồ rộng nằm trong khối `overflow-x: auto`, body không scroll ngang.
- [ ] Nội dung tiếng Việt, đầy đủ dấu; code/identifier giữ nguyên gốc.
- [ ] Dữ liệu lấy từ ngữ cảnh thật; không còn placeholder chưa đánh dấu.
- [ ] Nội dung quá rộng cho một trang → cắt phạm vi hoặc tách nhiều artifact (file > ~100KB là dấu hiệu cần tách), hỏi người dùng trước khi tách.

## Thêm loại mới

Thêm 1 file `references/<loại>.md` theo đúng template của các reference hiện có + 1 dòng vào bảng chọn loại ở trên. Không cần sửa gì khác.
