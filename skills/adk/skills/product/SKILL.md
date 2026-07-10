---
name: product
description: Phase 1 (bootstrap) of the adk ADR-first pipeline. Extract product intent into a batch of product ADRs, then render PRD.md (intent/journey/scope) and BUSINESS-FLOW.md (state/rule/invariant) from the active ADR set. Heaviest elicitation phase. Fires ONLY when the user types /adk:product and PIPELINE.lock phase == product.
when_to_use: After /adk:kickoff rendered PRINCIPLES. Trigger only on explicit /adk:product. Blocked unless phase == product.
argument-hint: ""
arguments: none
---

# /adk:product — Phase 1 (bootstrap)

**Mục đích:** MOI intent → chùm **ADR `product`** → render `PRD.md` (intent · journey · scope) + `BUSINESS-FLOW.md` (state · rule · invariant).

Đọc trước: `../../references/pipeline-lock-schema.md` · `../../references/adr-protocol.md` · `../../references/render-protocol.md` · `../../references/elicitation-contract.md`.

## Trigger & gate-guard

- Chỉ fire khi user gõ `/adk:product`.
- Kiểm `lock_version == 2` (guard, xem `pipeline-lock-schema`) trước mọi thứ khác.
- **Gate-guard `phase == product`** (PRINCIPLES đã render). Sai phase → chặn + báo phase hiện tại.

## Elicitation (🔴 nặng nhất)

- **`adk:interview`** (engine chính) — moi intent, "hỏi liên tục" đúng nghĩa.
- **Wiring cứng:** TRƯỚC khi trình chùm ADR để chốt, invoke skill `adk:grill-docs` qua Skill tool trên bản nháp PRD/BUSINESS-FLOW — đã có PRINCIPLES làm nền để vắt.
- **"2-3 approaches" inline** cho các lựa chọn product lớn (KHÔNG kéo skill `adk:brainstorm` vào pipeline — đó là ngoại lệ đứng ngoài, SPEC v2 §14.1).
- Engine chỉ trả text; product ghi `CONTEXT.md` từ đề xuất grill (parent-writes).

## Input đọc

`PRINCIPLES.md` + ADR active `kind: principle` · `CONTEXT.md`. **Brownfield**: `CONTEXT.md` có **bucket B** (domain rules/invariant từ code) — dùng để inform BUSINESS-FLOW thay vì moi từ đầu.

## Output ghi

- **Chùm ADR `kind: product`** — mỗi quyết định intent/scope/journey/state-rule lớn một ADR, `affects` default = `[PRD, BUSINESS-FLOW, ARCHITECTURE, UX-DESIGN, REQUIREMENTS]` (thu hẹp phải kèm lý do — `adr-protocol` §5).
- **Render `PRD.md`** — intent · journey · scope. FR/NFR viết **narrative** ở đây (atomic để dành `/adk:requirements` — KHÔNG sync 2 list).
- **Render `BUSINESS-FLOW.md`** — state · rule · invariant.
- Update `CONTEXT.md` (parent ghi từ grill-đề-xuất).

## Gate (duyệt chùm ADR + render CẢ HAI)

1. Sanity-check máy móc chùm nháp (lặp/mâu thuẫn nội bộ + với ADR `principle` active).
2. Trình **từng ADR** — **DỪNG THẬT** (SPEC v2 §8.2), người duyệt/sửa từng trường.
3. Ghi ADR đã duyệt (`kind: product`, đọc lại max ID ngay trước ghi).
4. **Render `PRD.md` + `BUSINESS-FLOW.md`** (`render-protocol` §2) — mỗi doc: file tạm → diff → user confirm riêng → ghi file đích. `derived_from` = ADR active có doc đó trong `affects`.

## Side-effect `PIPELINE.lock`

Sau render xong cả hai:

- Thêm entry `docs[]` cho `PRD` và `BUSINESS-FLOW` (nếu chưa có).
- **`phase → architecture`**.

## Post-phase

- Compact `CONTEXT.md` (archive-not-delete).
- Gợi ý bước kế: `/adk:architecture`.
