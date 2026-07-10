---
name: architecture
description: Phase 2 (bootstrap) of the adk ADR-first pipeline. Turn architecture decisions into a batch of architecture ADRs, then render ARCHITECTURE.md (single source of truth) from the active ADR set, with UX-DESIGN.md as a CONDITIONAL derived doc (only when UI is complex). Fires ONLY when the user types /adk:architecture and PIPELINE.lock phase == architecture.
when_to_use: After /adk:product rendered PRD and BUSINESS-FLOW. Trigger only on explicit /adk:architecture. Blocked unless phase == architecture.
argument-hint: ""
arguments: none
---

# /adk:architecture — Phase 2 (bootstrap)

**Mục đích:** chốt kiến trúc trên nền ADR product đã ghi → chùm **ADR `architecture`** → render `ARCHITECTURE.md`. UX là **doc dẫn xuất CÓ ĐIỀU KIỆN** — KHÔNG phải một phase riêng.

Đọc trước: `../../references/pipeline-lock-schema.md` · `../../references/adr-protocol.md` · `../../references/render-protocol.md` · `../../references/elicitation-contract.md`.

## Trigger & gate-guard

- Chỉ fire khi user gõ `/adk:architecture`.
- Kiểm `lock_version == 2` trước mọi thứ khác.
- **Gate-guard `phase == architecture`** (PRD + BUSINESS-FLOW đã render). Sai phase → chặn + báo.

## Elicitation (🟠 vừa–cao)

- **Wiring cứng:** TRƯỚC khi trình chùm ADR để chốt, invoke skill `adk:grill-docs` qua Skill tool trên bản nháp ARCHITECTURE — vắt vật liệu từ ADR `product` active, thách thức phương án.
- **"2-3 approaches" inline** cho các quyết định kiến trúc lớn.
- Engine chỉ trả text; architecture ghi file.

## Input đọc

`PRINCIPLES` · `PRD` · `BUSINESS-FLOW` (+ ADR active `principle`/`product`) · `CONTEXT`. **Brownfield**: `CONTEXT` có **bucket C** (component/layer/data-flow từ code) — dùng làm current-state baseline.

**Hỏi tường minh: "UI phức tạp không?"** — câu trả lời là **1 ADR** (`kind: architecture`), có `## Context`/`## Consequences` giải thích, không phải rubric khách quan (chấp nhận subjective — SPEC v2 §11 Minor A).

## Output ghi

- **Chùm ADR `kind: architecture`** (stack, boundary, data-flow, ADR "UI phức tạp?"). `affects` default = `[ARCHITECTURE, UX-DESIGN, REQUIREMENTS]`; ADR UI-phức-tạp thêm `UX-DESIGN` vào `affects` một cách tường minh nếu quyết là "có".
- **Render `ARCHITECTURE.md`** (single source of truth kiến trúc hiện tại) — luôn render, kể cả backend thuần.
- **UI phức tạp = có** → render thêm `UX-DESIGN.md`.
- **Backend thuần** → KHÔNG bỏ qua bước hỏi; ghi rõ trong `CONTEXT.md` + dồn surface (API/CLI/contract bề mặt) vào `ARCHITECTURE.md`.

## Gate (duyệt chùm ADR + render)

1. Sanity-check máy móc chùm nháp (mâu thuẫn nội bộ + với ADR active `principle`/`product`).
2. Trình từng ADR — **DỪNG THẬT** (SPEC v2 §8.2).
3. Ghi ADR đã duyệt (`kind: architecture`).
4. **Render `ARCHITECTURE.md`** (+ `UX-DESIGN.md` nếu ADR quyết included) theo `render-protocol` §2 — file tạm → diff → confirm riêng từng doc.

## ADR đổi-kiến-trúc ghi ngoài bootstrap (sau `phase → done`)

Sau khi bootstrap xong, một ADR `architecture` mới bất kỳ lúc nào đi qua `/adk:adr` (không qua skill này nữa) — `/adk:adr` tự chạy sanity-check + consistency-check + đề nghị render lại `ARCHITECTURE.md`/`UX-DESIGN.md`/`REQUIREMENTS.md` theo `affects`. Không còn khái niệm `pending_arch_sync` chặn lệnh kế (v1) — mọi thứ chạy qua so-tập-hợp deterministic (`render-protocol` §3).

## Side-effect `PIPELINE.lock`

- Thêm entry `docs[]` cho `ARCHITECTURE` (+ `UX-DESIGN` nếu render).
- **`phase → requirements`**.

## Post-phase

- Compact `CONTEXT.md` (archive-not-delete).
- Gợi ý bước kế: `/adk:requirements`.
