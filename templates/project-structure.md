# Cấu trúc project chuẩn

Tài liệu tham chiếu cho L2/F2: khi plan cấu trúc file mới hoặc không chắc file đặt đâu.
`AGENTS.md` của repo (nếu có) LUÔN thắng tài liệu này.

## 1. Next.js App Router

```
src/
├─ app/                     # routes; mỗi segment một thư mục
│  ├─ (group)/page.tsx      # page theo route group
│  └─ api/<resource>/route.ts
├─ components/
│  ├─ ui/                   # primitives (shadcn) — không sửa tay khi generate được
│  └─ <feature>/            # component theo feature; >400 dòng → folder module (xem rules/react)
├─ lib/                     # pure functions, parsing, API clients
├─ hooks/                   # shared hooks: use-*.ts
└─ types/                   # shared types
e2e/                        # Playwright specs
docs/                       # tài liệu (D-rules)
  ARCHITECTURE.md           #   sống — module, luồng dữ liệu, ranh giới (bắt buộc)
  CONTEXT.md                #   sống — xong gì, đang làm gì, còn treo gì (bắt buộc)
  CODEMAP.md OPERATIONS.md PRODUCT.md DESIGN.md README.md   # sống, tuỳ chọn
  specs/YYYY-MM-DD-<topic>-design.md
  plans/YYYY-MM-DD-<topic>.md
  review/YYYY-MM-DD-<topic>.md      # + assets/ cho ảnh
  mockups/YYYY-MM-DD-<topic>.html
AGENTS.md                   # luật riêng repo — bắt buộc (D5)
CLAUDE.md                   # dòng đầu `@AGENTS.md` — bắt buộc (D5)
```

- Dependency một chiều: `components/ → lib/`; NEVER `lib/ → components/` (kể cả type-only).
- Route handler mỏng — logic nằm ở `lib/` hoặc `services/`.
- Unit test đặt cạnh file: `foo.ts` + `foo.test.ts`.

## 2. Node API service

```
src/
├─ routes/                  # HTTP handlers, mỏng
├─ services/                # business logic
├─ repositories/            # data access (P1/P2 — repository pattern)
├─ lib/                     # pure utilities
└─ types/
prisma/                     # schema + migrations (nếu dùng Prisma)
scripts/                    # CLI / ops scripts, mỗi script một việc
data/                       # seed / fixture data được track
```

- Handler → service → repository; không nhảy tầng (handler không gọi thẳng repository).

## 3. Vite + Tauri desktop

```
src/                        # frontend (TS)
├─ components/
├─ lib/
└─ styles/
src-tauri/
└─ src/                     # Rust backend; command handlers mỏng
scripts/                    # build / pipeline scripts
```

- Logic dùng chung frontend/backend → định nghĩa contract ở một chỗ (types), không copy hai bản.

## Mọi loại project

- File không rõ thuộc đâu → HỎI trước khi tạo (F2), đề xuất vị trí kèm lý do.
- Loại project không nằm trong danh sách trên (Python pipeline, extension, notes…) → theo convention hiện có của repo; repo trống → đề xuất cấu trúc trong plan để duyệt trước.
