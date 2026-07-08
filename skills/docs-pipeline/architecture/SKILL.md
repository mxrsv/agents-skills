---
name: architecture
description: Phase 2 of the docs-bootstrap pipeline. Lock the architecture onto frozen product docs into ARCHITECTURE.md (single source of truth), with UX-DESIGN.md as a CONDITIONAL sub-artifact (only when UI is complex). Fires ONLY when the user types /architecture and PIPELINE.lock phase == architecture.
when_to_use: After /product froze PRD and BUSINESS-FLOW. Trigger only on explicit /architecture. Blocked unless phase == architecture.
argument-hint: ""
arguments: none
---

# /architecture — Phase 2

**Mục đích:** chốt kiến trúc trên nền frozen product docs. UX là **sub-artifact CÓ ĐIỀU KIỆN** (rule 7) — KHÔNG phải một phase riêng.

Đọc trước: `../references/pipeline-lock-schema.md` · `../references/freeze-protocol.md` · `../references/hash-cascade.md` · `../references/elicitation-contract.md`.

## Trigger & gate-guard

- Chỉ fire khi user gõ `/architecture`.
- **Gate-guard `phase == architecture`** (PRD + BUSINESS-FLOW frozen). Sai phase → chặn + báo.
- Gate cross-check PRINCIPLES · PRD · BUSINESS-FLOW.

## Elicitation (🟠 vừa–cao)

- **`grill-with-docs`** (engine chính) — vắt vật liệu từ frozen product docs, thách thức phương án.
- **"2-3 approaches" inline** cho các quyết định kiến trúc.
- Engine chỉ trả text; skill này ghi file.

## Input đọc

`PRINCIPLES` · `PRD` · `BUSINESS-FLOW` (frozen) · `CONTEXT`.

**Hỏi tường minh: "UI phức tạp không?"**

## Output ghi

- **UI phức tạp** → sinh `UX-DESIGN.md` → **freeze** (stamp `from_hash = {PRINCIPLES, PRD, BUSINESS-FLOW}`).
- **Backend thuần** → **KHÔNG bỏ phase**: ghi **dòng skip vào `CONTEXT.md`** + dồn surface (API/CLI/contract bề mặt) vào `ARCHITECTURE.md`.
- **Luôn** sinh `ARCHITECTURE.md` (single source of truth kiến trúc hiện tại) → **freeze**.
- ADR sinh trong lúc dựng đi qua `/adr` (append-only).

## ADR-early (guard deadlock)

ADR **đổi-kiến-trúc** ghi *trong* phase này — lúc `ARCHITECTURE.md` **CHƯA frozen** → `/adr` **KHÔNG** set `pending_arch_sync`; ADR đó chỉ **feed vào** `/architecture` như input. (Chỉ set cờ khi ARCHITECTURE đã frozen — xem `/adr`.)

## Gate

Completeness-check `ARCHITECTURE` (+ UX nếu có) khớp PRINCIPLES / PRD / BUSINESS-FLOW (rule 4) → **người freeze**.

## Side-effect `PIPELINE.lock`

- `decisions.ux = included | skipped`.
- Sau freeze → `docs[ARCHITECTURE].status = active` (+ `docs[UX-DESIGN]` nếu có).
- **`phase → requirements`**.

## Post-phase (rule 6)

- compact `CONTEXT.md` (archive-not-delete).
- nhắc `/adr`.
- gợi ý bước kế: `/requirements`.
