---
name: requirements
description: Phase 3 (bootstrap, terminal) of the adk ADR-first pipeline. Distill atomic numbered FR/NFR + acceptance criteria into REQUIREMENTS.md — a versioned derived doc (not frozen) handed off to superpowers:writing-plans. Fires ONLY when the user types /adk:requirements and PIPELINE.lock phase == requirements.
when_to_use: After /adk:architecture rendered ARCHITECTURE. Trigger only on explicit /adk:requirements. Blocked unless phase == requirements.
argument-hint: ""
arguments: none
---

# /adk:requirements — Phase 3 (bootstrap, terminal)

**Mục đích:** distill FR/NFR **atomic** + acceptance → render `REQUIREMENTS.md` — **contract terminal versioned** handoff sang `superpowers:writing-plans`. Kết thúc **bootstrap** (không phải kết thúc vòng đời adk — sau đây `/adk:adr` + `/adk:docs-check` + `/adk:pivot` vẫn tiếp tục vô hạn).

Đọc trước: `../../references/pipeline-lock-schema.md` · `../../references/adr-protocol.md` · `../../references/render-protocol.md` (đặc biệt §4 — FR/NFR-ID immutable) · `../../references/elicitation-contract.md`.

## Trigger & gate-guard

- Chỉ fire khi user gõ `/adk:requirements`.
- Kiểm `lock_version == 2` trước mọi thứ khác.
- **Gate-guard `phase == requirements`** (ARCHITECTURE đã render). Sai phase → chặn + báo.
- **Không còn `pending_arch_sync` chặn** (v1) — thay bằng: nếu phát hiện doc upstream LỆCH (`render-protocol` §3) lúc đọc input, **DỪNG**, đề nghị `/adk:docs-check` trước khi tiếp tục.

## Elicitation (🟡 thấp tương tác / cao verify)

- **`adk:grill-docs`** soi **gap / consistency** trên toàn bộ ADR active + doc dẫn xuất hiện có.
- Engine chỉ trả text; requirements ghi file.

## Input đọc

Toàn bộ ADR active (`principle`/`product`/`architecture`) + `PRINCIPLES` · `PRD` · `BUSINESS-FLOW` · `ARCHITECTURE` · `UX-DESIGN` (nếu có) · `CONTEXT`.

## Output ghi — render `REQUIREMENTS.md`

- FR/NFR **atomic, đánh số** (`FR-xxx` / `NFR-xxx`), **mỗi dòng link acceptance criteria**.
- `epic` (nhóm product-area) / `story` (nhóm feature-slice) = **NHÃN traceability**, **KHÔNG** phải đơn vị implementation. Không per-story context doc.
- **Lần render đầu tiên** (`version: 1`) — chưa có bản trước, không cần đọc continuity (`render-protocol` §4).
- `derived_from` = toàn bộ ADR active có `REQUIREMENTS` ∈ `affects`.
- `writing-plans` sở hữu toàn bộ FR→task; contract KHÔNG plan gì.

## Gặp GAP → DỪNG

Phân loại gap → **DỪNG + báo**, route:

- Gap cục bộ (thiếu 1 quyết định, framing vẫn đúng) → `/adk:adr` (ghi ADR mới bổ sung) → render lại → thử `/adk:requirements` lại.
- Tiền đề sai (reframe gốc của một phase trước) → `/adk:pivot`.

**KHÔNG tự chế ADR để lấp gap thay user** — chỉ đề xuất, người gõ `/adk:adr`.

## Gate — render terminal

Không có freeze-ceremony riêng — **render REQUIREMENTS sạch chính là bước chốt cuối cùng của bootstrap**.

1. Completeness-check: mọi FR/NFR phủ đủ nhu cầu + khớp toàn bộ ADR active liên quan.
2. Render vào file tạm → diff → **người confirm** (DỪNG THẬT, SPEC v2 §8.2) → ghi file đích với `version: 1`.

## Side-effect `PIPELINE.lock`

- Thêm entry `docs[]` cho `REQUIREMENTS`.
- **`phase → done`** — bootstrap kết thúc; `phase` bất động từ đây (xem `pipeline-lock-schema`).

## Handoff

`REQUIREMENTS.md` (derived, versioned) = input cho `superpowers:writing-plans`. Khuyến nghị chạy `/adk:docs-check` trước mỗi lần handoff / `/planning` để chắc không doc nào LỆCH so với ADR active mới nhất.
