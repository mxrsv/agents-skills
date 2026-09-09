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

## Documentation

Most code changes need no documentation change; agents and maintainers can read the code.
The index is [docs/README.md](docs/README.md) `current`.

- `docs/internals/` holds architectural decisions and their reasons, constraints that span
  modules, and traps that are hard to discover from the source. Before adding a paragraph,
  ask what a maintainer would get wrong without it. If reading the relevant code answers the
  question, leave it out. It is the one place in the repository that still takes new
  documentation.
- `docs/user/` helps users accomplish tasks, in the voice of the shipped product, with no
  implementation detail and no contributor tooling. Update the feature's section when how to
  use it changes; a UI tweak needs no entry and a new control needs no page.
- `docs/operations/` is the maintainer runbook: setup, release, debugging. Every page under
  `internals/` and `operations/` opens with the "For maintainers" callout.
- Do not write file catalogs, field or method enumerations, control-flow narration, or
  appended PR summaries. Types, tests and code already record the implementation. When a
  documented decision changes, rewrite or remove the text; never append a second account of
  the new behaviour. Keep a local explanation in a code comment; use an internal page only
  when the reasoning crosses boundaries.
- Plans, specs, research notes and review reports are not committed. A merged PR is the
  implementation record, and active work lives in the issue that owns it.

{{Xoá tầng repo không có (repo CLI không có user/ …). Mục này KHÔNG nêu tên tool tracker — chọn tool là việc của người dùng, luật global D0/D4 đã nói.}}

## Luật riêng repo (R-rules — chỉ delta so với chuẩn global)

- **R1.** {{luật chỉ áp cho repo này, vd: NEVER chạy `prisma migrate dev` trần — dùng `pnpm migrate:dev`}}
- **R2.** {{...}}

## Bẫy đã biết

- {{bẫy 1 — hiện tượng, nguyên nhân, file/lệnh liên quan}}

## Ngôn ngữ

- Docs/comments: {{Tiếng Việt / English-only}}
- Commit messages: {{English, conventional commits}}
