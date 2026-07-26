# Tạo file & cấu trúc (F-rules)

Luật khi tạo BẤT KỲ file mới nào, áp cho mọi loại repo.

- **F1.** TRƯỚC KHI tạo file mới → tìm file cùng chức năng đã tồn tại (Glob/Grep). Đã có → sửa file đó, KHÔNG tạo bản mới.
- **F2.** TRƯỚC KHI tạo file mới → xác định vị trí theo `AGENTS.md` của repo, hoặc `~/.claude/templates/project-structure.md`. Không chắc vị trí → HỎI, không đoán.
- **F3.** NEVER tạo file tên dạng `.bak`, `.old`, `.orig`, `-v2`, `-v3`, `-final`, `-copy` — sửa trực tiếp file gốc, git giữ lịch sử.
  - ❌ `auth-v2.ts`, `page.tsx.bak` → ✅ sửa thẳng `auth.ts`, `page.tsx`
- **F4.** File tạm / thí nghiệm / debug / output trung gian → scratchpad của session, NEVER nằm trong repo.
- **F5.** NEVER tạo mới file tên chung chung `utils.*`, `helpers.*`, `misc.*` — đặt tên theo chức năng.
  - ❌ `utils.ts` → ✅ `format-date.ts`, `parse-url-params.ts`
- **F6.** Tên file: kebab-case. Repo có convention khác (PascalCase component, snake_case Python) → theo repo.
- **F7.** File mới MUST được import/tham chiếu bởi ít nhất một chỗ ngay trong cùng task — không để file mồ côi.
- **F8.** Kích thước: 200–400 dòng điển hình, 800 max. Chạm ngưỡng → tách module theo rules của ngôn ngữ tương ứng.
- **F9.** Một file một trách nhiệm — nội dung không thuộc trách nhiệm đó thì sang file khác.

## Checklist trước khi tạo file

- [ ] Đã tìm file cùng chức năng chưa? (F1)
- [ ] Vị trí đúng theo AGENTS.md / project-structure chưa? (F2)
- [ ] Tên không dính pattern cấm, không chung chung? (F3, F5, F6)
- [ ] Là file tạm? → scratchpad (F4)
- [ ] Có nơi import/tham chiếu nó chưa? (F7)
