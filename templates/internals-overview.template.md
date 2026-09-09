> Sinh từ `~/.claude/templates/internals-overview.template.md` — tài liệu SỐNG, cập nhật tại chỗ (D1, D9).
> Điểm vào của `docs/internals/` (D5). Chỉ giữ điều "maintainer sẽ làm sai nếu thiếu"; đọc code trả lời được thì bỏ.

> **For maintainers.** Trang này nói về cách hệ thống được xây và tại sao — không phải hướng dẫn dùng.

# {{Tên project}} — tổng quan nội bộ

{{Một câu: hệ thống làm gì, chạy trên nền gì}}

## Module và ranh giới

| Module  | Trách nhiệm | Vào        | Ra         |
| ------- | ----------- | ---------- | ---------- |
| {{tên}} | {{một câu}} | {{ai gọi}} | {{gọi ai}} |

## Luồng dữ liệu chính

1. {{bước}} — [{{hàm}}](../../{{path/to/file.ts}}#L10)

## Quyết định còn hiệu lực và lý do

- {{quyết định}} — {{vì sao, một câu}} — [{{bằng chứng}}](../../{{path}})

## Constraint xuyên module

- {{điều một module phải giữ để module khác không hỏng}}

## Trap khó thấy từ code

- {{hiện tượng → nguyên nhân → file/lệnh liên quan}}

{{Quyết định đổi → VIẾT LẠI đoạn tương ứng, không nối thêm bản kể thứ hai (D1). Việc đang làm và drift → issue Linear (D4, D7).}}
