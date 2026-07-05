# Nền tảng chung cho HTML artifact

Chưng cất từ 4 example (`16-implementation-plan`, `13-flowchart-diagram`, `14-research-feature-explainer`, `04-code-understanding`). Mọi artifact mới nên bắt đầu từ đây rồi thêm phần riêng.

## Design tokens

Khối `:root` chuẩn — copy nguyên vào mọi file:

```css
:root {
  --ivory: #faf9f5; /* nền trang */
  --slate: #141413; /* mực đậm nhất: heading, nền code panel */
  --clay: #d97757; /* accent/nhấn: link, border trái, active, số */
  --oat: #e3dacc; /* nền badge trung tính, avatar, nền callout nhạt */
  --olive: #788c5d; /* tích cực: done, "đạt", nhánh success */
  --rust: #b04a3f; /* cảnh báo/tiêu cực: lỗi, rollback, nhánh fail */
  --gray-150: #f0eee6; /* nền phụ: header bảng, prompt box, tab bar */
  --gray-300: #d1cfc5; /* MÀU BORDER chuẩn */
  --gray-500: #87867f; /* chữ phụ, metadata, caption */
  --gray-700: #3d3d3a; /* chữ thân bài */
  --serif: ui-serif, Georgia, "Times New Roman", serif;
  --sans: system-ui, -apple-system, "Segoe UI", Roboto, sans-serif;
  --mono: ui-monospace, "SF Mono", Menlo, Monaco, monospace;
}
```

Ngữ nghĩa màu (theo cách example dùng):

| Token        | Vai trò                 | Ví dụ trong example                                                          |
| ------------ | ----------------------- | ---------------------------------------------------------------------------- |
| `--clay`     | Accent duy nhất để nhấn | link "Trả lời", border-left `.tldr`/`.q`, nút Đăng, số section, nhánh active |
| `--olive`    | Trạng thái tích cực     | milestone `.done`, edge "đạt/ổn", chip ok                                    |
| `--rust`     | Trạng thái tiêu cực/lỗi | node `.bad`, edge "canary lỗi", auto-rollback                                |
| `--oat`      | Nền trung tính ấm       | badge `.num`, avatar, nền `.callout` (kèm alpha)                             |
| `--slate`    | Nhấn tối tối đa         | heading, nền code panel `.code`                                              |
| `--gray-300` | Border cho mọi panel    | luôn `1.5px solid var(--gray-300)`                                           |
| `--gray-500` | Chữ hạng hai            | caption, meta, file path, eyebrow                                            |

Lưu ý sai lệch giữa các file:

- `--rust` chỉ có ở `13` và `04`; `16` và `14` không khai báo. File `16` thay bằng hex inline cho mức nghiêm trọng (`#f3d9cc`/`#8a3b1e` = cao, `#e4e9dc`/`#4b5c39` = thấp). **Luôn khai báo `--rust`** trong file mới cho nhất quán.
- `--white` chỉ `16` khai báo; các file khác viết `#fff` trực tiếp. Dùng `#fff` cho nền panel là đủ, không cần token riêng.
- Không file nào có `gray-100`; thang xám thật là `150/300/500/700`.
- Code panel tối: chữ `#e8e6de`~`#e8e6dc`, syntax accent vàng `#c9b98a`; keyword/str có thể map sang `--clay`/`--olive`. Đây là các hex hiếm được phép nằm ngoài `:root`.

## Skeleton trang chuẩn

```html
<!-- Copyright 2026 Anthropic PBC · SPDX-License-Identifier: Apache-2.0 -->
<!doctype html>
<html lang="vi">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Tiêu đề trang</title>
    <style>
      :root {
        /* ...tokens ở trên... */
      }
      * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
      }
      body {
        background: var(--ivory);
        color: var(--gray-700);
        font-family: var(--sans);
        font-size: 15px;
        line-height: 1.6;
        -webkit-font-smoothing: antialiased;
        padding: 56px 24px 96px;
      }
      .page {
        max-width: 900px;
        margin: 0 auto;
      }
    </style>
  </head>
  <body>
    <div class="page"><!-- nội dung --></div>
  </body>
</html>
```

`.page` = 860–920px cho layout đọc một cột. Layout hai cột (main + sidebar/nav sticky) trong example dùng `grid-template-columns: minmax(0,1fr) 280–300px` và nới wrapper lên 980–1120px — chỉ nới khi thật sự có cột phụ.

## Component patterns

### Panel / card

Khối nội dung nền trắng nổi trên nền ivory. Dùng cho mọi diagram, mockup, bảng, sidebar.

```css
.panel {
  background: #fff;
  border: 1.5px solid var(--gray-300);
  border-radius: 12px;
  padding: 20px;
}
```

```html
<div class="panel">…</div>
```

### Badge / pill trạng thái

Nhãn mono ngắn. Trung tính dùng `--oat`; đổi màu theo trạng thái bằng nền alpha + chữ đậm.

```css
.pill {
  display: inline-block;
  font-family: var(--mono);
  font-size: 11px;
  padding: 3px 9px;
  border-radius: 6px;
  background: var(--oat);
  color: var(--slate);
}
.pill.ok {
  background: rgba(120, 140, 93, 0.15);
  color: var(--olive);
}
.pill.bad {
  background: rgba(176, 74, 63, 0.12);
  color: var(--rust);
}
```

```html
<span class="pill">task_comments_v1</span> <span class="pill bad">CAO</span>
```

### Bảng dữ liệu

Không dùng `<table>` — dựng bằng CSS grid trong panel bo góc. Header nền `--gray-150`, phân dòng bằng border.

```css
.tbl {
  border: 1.5px solid var(--gray-300);
  border-radius: 12px;
  overflow: hidden;
  background: #fff;
}
.tbl .row {
  display: grid;
  grid-template-columns: 1.6fr 90px 1.6fr;
}
.tbl .row + .row {
  border-top: 1.5px solid var(--gray-300);
}
.tbl .cell {
  padding: 14px 18px;
  font-size: 13.5px;
}
.tbl .cell + .cell {
  border-left: 1.5px solid var(--gray-300);
}
.tbl .head {
  background: var(--gray-150);
  font-weight: 600;
  color: var(--slate);
  font-size: 12px;
  text-transform: uppercase;
  letter-spacing: 0.04em;
}
```

```html
<div class="tbl">
  <div class="row">
    <div class="cell head">Rủi ro</div>
    <div class="cell head">Mức</div>
  </div>
  <div class="row">
    <div class="cell">…</div>
    <div class="cell">…</div>
  </div>
</div>
```

Trên mobile (`max-width: 780px`) đổi `grid-template-columns: 1fr` và bỏ `border-left`.

### Callout / ghi chú

Hộp nhấn nhẹ. Hai biến thể: nền oat trung tính, hoặc border-trái clay để "gắn nhãn quan trọng".

```css
.callout {
  display: flex;
  gap: 12px;
  border: 1.5px solid var(--oat);
  background: rgba(227, 218, 204, 0.35);
  border-radius: 10px;
  padding: 14px 16px;
  font-size: 14px;
}
.callout .ico {
  color: var(--clay);
  font-weight: 600;
}
.accent-note {
  /* TL;DR, câu hỏi mở, gotcha */
  border: 1.5px solid var(--gray-300);
  border-left: 3px solid var(--clay);
  border-radius: 10px;
  background: #fff;
  padding: 16px 18px;
}
```

```html
<div class="callout">
  <span class="ico">★</span>
  <div>Mẹo ngắn…</div>
</div>
<div class="accent-note"><b>TL;DR</b> — tóm tắt một câu.</div>
```

### Section header

Kicker mono ở trên, hoặc số thứ tự dạng badge oat cạnh heading serif.

```css
.eyebrow {
  font-family: var(--mono);
  font-size: 11px;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: var(--gray-500);
  margin-bottom: 10px;
}
.sec-head {
  display: flex;
  align-items: baseline;
  gap: 14px;
  margin-bottom: 8px;
}
.sec-head .num {
  font-family: var(--mono);
  font-size: 12px;
  background: var(--oat);
  color: var(--slate);
  padding: 3px 9px;
  border-radius: 8px;
}
.sec-head h2 {
  font-family: var(--serif);
  font-weight: 500;
  font-size: 26px;
  color: var(--slate);
  letter-spacing: -0.01em;
}
```

```html
<div class="eyebrow">Research &amp; Learning · tóm tắt</div>
<div class="sec-head">
  <span class="num">01</span>
  <h2>Mốc triển khai</h2>
</div>
```

### Footer meta

Dòng phụ mono nhỏ, xám — caption dưới diagram, owner, timestamp.

```css
.meta {
  font-family: var(--mono);
  font-size: 11.5px;
  color: var(--gray-500);
  margin-top: 8px;
}
```

```html
<p class="meta">Quyết với · design, trước slice 2</p>
```

## Nguyên tắc typography & hierarchy

- **Serif** (`--serif`, weight **500**, `letter-spacing: -.01em`) cho mọi heading: `h1` 32–38px, `h2` 22–26px, `h3` 19px. Không bao giờ bold 700 — độ nhấn đến từ font family + cỡ, không phải độ đậm.
- **Sans** (`--sans`) cho thân bài, 13–15.5px, `line-height` 1.55–1.65, giới hạn `max-width: 640–720px` để dễ đọc.
- **Mono** (`--mono`) cho mọi metadata phi văn xuôi: kicker/eyebrow, số section, file path, caption, tag, code inline (12–13px). Kicker luôn `text-transform: uppercase` + `letter-spacing: .06–.1em`.
- **Hierarchy không dùng màu**: phân cấp bằng (1) đổi font family serif↔sans↔mono, (2) cỡ chữ, (3) chữ phụ tụt xuống `--gray-500`. Màu accent (`--clay`) chỉ để nhấn tương tác/trạng thái, không dùng để tạo cấp bậc chữ.
- Chữ đậm (`font-weight: 600`) trong thân bài chỉ để in đậm keyword; nâng màu lên `--slate` cho phần cần nổi.
- Code panel tối (nền `--slate`, chữ `#e8e6de`) tạo tương phản mạnh với trang ivory — dùng cho block code dài; code inline thì để mono trên nền trang.
