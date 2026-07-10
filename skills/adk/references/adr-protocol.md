# Reference — `adr-protocol` (v2)

Đơn vị chân lý duy nhất của adk v2. Mọi phase skill + `adk:adr` + `adk:pivot` dùng chung protocol này khi ghi/đọc `docs/decisions/`.

> **Đảo trục so với v1:** v1 coi frozen doc (PRD/ARCHITECTURE/…) là chân lý, ADR chỉ là log rationale phụ. v2 lật lại: **ADR log là chân lý; doc lớn là view dẫn xuất** (xem `render-protocol`). Lý do: chi phí tái sinh doc bằng agent ~0, thứ đắt duy nhất là quyết định của con người — nên bảo vệ đúng chỗ đắt.

## 1. File & vị trí

`<repo-đích>/docs/decisions/NNNN-<slug>.md` — 4 chữ số, auto-tăng, **append-only**. Không bao giờ `Edit` file đã tồn tại qua đường chuẩn (guard ở §4).

## 2. Frontmatter

```yaml
---
id: 0007
title: "Auth dùng session, không dùng JWT"
date: 2026-07-10
kind: principle | product | architecture | requirement | pivot
affects: [PRINCIPLES, PRD, BUSINESS-FLOW, ARCHITECTURE, UX-DESIGN, REQUIREMENTS]
supersedes: [0003] # rỗng [] nếu không lật ai
---
## Context
## Decision
## Consequences
## Options rejected
```

- `kind` = phase gốc sinh ra quyết định (không phải phase nào render — một ADR architecture vẫn có thể `affects: [ARCHITECTURE, REQUIREMENTS]`).
- `id` luôn 4 chữ số string, tăng dần, không tái dùng dù ADR bị supersede.

## 3. Active set

**Active set** = mọi ADR mà `id` của nó **không** xuất hiện trong `supersedes` của bất kỳ ADR nào khác trong `docs/decisions/`.

- Suy ra bằng cách quét toàn bộ file — **không lưu status vào file ADR cũ** (không có trường `superseded_by`, không `status:`). Giữ bất biến tuyệt đối: một khi ghi, nội dung + frontmatter của file đó không đổi bao giờ.
- Muốn biết "ADR X còn active không?" → grep `supersedes` của mọi file khác tìm `X`.

## 4. Nguyên tử tính

- Một ADR = **một quyết định**, có thể supersede toàn phần một ADR cũ khác.
- **Không có partial-supersede.** Muốn lật một phần của quyết định cũ → tách quyết định cũ thành các ADR nhỏ hơn trước (ADR mới cho phần giữ nguyên + ADR mới supersede phần đổi), rồi mới supersede đúng phần cần đổi.
- **Không revive ngầm.** ADR bị supersede không tự "sống lại"; muốn quay lại quyết định cũ → ADR mới lặp lại nội dung đó, supersede ADR đang active.

## 5. `affects` — default máy móc + người duyệt

- **Default:** doc gốc theo `kind` + mọi doc downstream theo thứ tự phase tới `REQUIREMENTS`:
  - `kind: principle` → `[PRINCIPLES, PRD, BUSINESS-FLOW, ARCHITECTURE, UX-DESIGN, REQUIREMENTS]`
  - `kind: product` → `[PRD, BUSINESS-FLOW, ARCHITECTURE, UX-DESIGN, REQUIREMENTS]`
  - `kind: architecture` → `[ARCHITECTURE, UX-DESIGN, REQUIREMENTS]`
  - `kind: requirement` → `[REQUIREMENTS]`
  - `UX-DESIGN` chỉ vào default nếu artifact đó đã tồn tại (`decisions.ux` tương đương suy từ có/không ADR kiến trúc bao gồm UI).
- **Người duyệt lúc confirm ADR** (§8.2 trong SPEC — gate DỪNG THẬT). Được **thu hẹp** `affects` so với default, nhưng **phải ghi lý do ngay trong ADR** (thêm câu vào `## Context` hoặc `## Consequences` giải thích vì sao doc X không bị ảnh hưởng). Không cho thu hẹp âm thầm.
- Mở rộng `affects` ra ngoài default (ví dụ ADR product ảnh hưởng ngược PRINCIPLES) — cho phép, ghi lý do tương tự.

## 6. Ai ghi ADR

- **`adk:adr`** — trigger tường minh, anytime, quy trình đầy đủ (soạn nháp → sanity-check → gate → ghi → consistency-check). Xem SKILL.md.
- **Phase skill lúc bootstrap** — mỗi phase kết thúc bằng soạn **chùm ADR nháp** rồi trình từng cái theo cùng gate (không phải qua `/adk:adr` riêng, nhưng cùng format/cùng gate).
- **`adk:pivot`** — ghi pivot-ADR + batch ADR thay thế (xem `pivot/SKILL.md`).
- **Không ai khác.** `adk:grill` / `adk:grill-docs` / `adk:interview` **CẤM ghi** `docs/decisions/` — chỉ trả text/đề xuất, nhắc user gõ `/adk:adr` nếu phát hiện quyết định đáng ghi.

## 7. Đánh số — race (solo-dev, chấp nhận mức đơn giản)

- Đọc thư mục `docs/decisions/`, lấy `id` lớn nhất hiện có, `+1`, làm **ngay trước khi ghi** (không cache số từ đầu quy trình).
- v2 **không** giải quyết triệt để race đa-session/đa-agent ghi đồng thời — chấp nhận mức "đọc max ngay trước ghi" phù hợp workflow solo. Nếu dùng nhiều agent song song trên cùng repo, người dùng tự tránh ghi ADR đồng thời.

## 8. Guard ghi (bổ sung, không phải toàn bộ đảm bảo)

- PreToolUse hook (template ở `decisions-hook.md`, cài bởi `adk:kickoff`) deny `Edit`/`NotebookEdit` vào `docs/decisions/*`, deny `Write` đè lên path đã tồn tại — best-effort, chặn đường ghi qua tool chuẩn.
- **Không phải security boundary.** Hook không chặn Bash/script ghi trực tiếp hay sửa ngoài Claude Code. Safety net thật = **git diff/history + review người** trước/sau mỗi lần ghi ADR. adk nhắm mức kỷ luật ngang Superpowers, không phải sandbox tuyệt đối.
