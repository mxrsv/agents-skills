> Chuẩn global: ~/.claude v{{YYYY-MM-DD}} — stamp ngày của chuẩn global lúc sinh file; cập nhật khi đồng bộ chuẩn mới.

# {{Tên project}}

{{One-liner project làm gì}}. Stack: {{Next.js 15 / Node 22 / Tauri 2 / ...}}.

## Lệnh thường dùng

| Lệnh                 | Tác dụng                 |
| -------------------- | ------------------------ |
| `{{pnpm dev}}`       | {{dev server, port nào}} |
| `{{pnpm test}}`      | {{unit tests}}           |
| `{{pnpm typecheck}}` | {{tsc --noEmit}}         |
| `{{pnpm build}}`     | {{production build}}     |

## Cấu trúc thư mục

```
{{cây thư mục thực tế — chỉ các nhánh agent hay đụng, kèm chú thích 1 dòng/nhánh}}
```

Vị trí khác chuẩn `~/.claude/templates/project-structure.md` (chỉ ghi điểm KHÁC):

- {{loại file}} → `{{đường dẫn}}` — {{lý do 1 dòng}}

## Luật riêng repo (R-rules — chỉ delta so với chuẩn global)

- **R1.** {{luật chỉ áp cho repo này, vd: NEVER chạy `prisma migrate dev` trần — dùng `pnpm migrate:dev`}}
- **R2.** {{...}}

## Bẫy đã biết

- {{bẫy 1 — hiện tượng, nguyên nhân, file/lệnh liên quan}}

## Ngôn ngữ

- Docs/comments: {{Tiếng Việt / English-only}}
- Commit messages: {{English, conventional commits}}

## Chưa khớp thực tế

| Claim | Ý định | Trạng thái | Bằng chứng |
| ----- | ------ | ---------- | ---------- |

{{Rỗng thì ghi rõ "Rỗng". KHÔNG bỏ mục (D7).}}
