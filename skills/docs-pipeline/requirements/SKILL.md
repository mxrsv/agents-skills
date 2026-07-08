---
name: requirements
description: Phase 3 (terminal) of the docs-bootstrap pipeline. Distill atomic numbered FR/NFR + acceptance criteria into REQUIREMENTS.md — the frozen contract handed off to superpowers:writing-plans. Distilling a clean REQUIREMENTS IS the terminal freeze. Fires ONLY when the user types /requirements, phase == requirements, and pending_arch_sync == false.
when_to_use: After /architecture froze ARCHITECTURE. Trigger only on explicit /requirements. Blocked unless phase == requirements AND flags.pending_arch_sync == false.
argument-hint: ""
arguments: none
---

# /requirements — Phase 3 (terminal)

**Mục đích:** distill FR/NFR **atomic** + acceptance → `REQUIREMENTS.md` — **contract terminal** handoff sang `superpowers:writing-plans`.

Đọc trước: `../references/pipeline-lock-schema.md` · `../references/freeze-protocol.md` · `../references/hash-cascade.md` · `../references/elicitation-contract.md`.

## Trigger & gate-guard

- Chỉ fire khi user gõ `/requirements`.
- **Gate-guard `phase == requirements`** (ARCHITECTURE frozen) **VÀ** `flags.pending_arch_sync == false`. Cờ bật → chặn, route `/reconcile ARCHITECTURE` trước.
- Gate cross-check TOÀN BỘ frozen upstream.

## Elicitation (🟡 thấp tương tác / cao verify)

- **`grill-with-docs`** soi **gap / consistency** trên toàn bộ frozen docs.
- Engine chỉ trả text; skill này ghi file.

## Input đọc

Toàn bộ frozen upstream: PRINCIPLES · PRD · BUSINESS-FLOW · ARCHITECTURE · UX-DESIGN (nếu có) · CONTEXT.

## Output ghi — `REQUIREMENTS.md`

- FR/NFR **atomic, đánh số** (`FR-xxx` / `NFR-xxx`), **mỗi dòng link acceptance criteria** = đơn vị nguyên tử của contract (fix 4.1).
- `epic` (nhóm product-area) / `story` (nhóm feature-slice) = **NHÃN traceability/tổ chức**, **KHÔNG** phải đơn vị implementation. **KHÔNG** per-story context doc (out-of-scope b).
- `writing-plans` sở hữu toàn bộ FR→task; contract KHÔNG plan gì.

## Gặp GAP → DỪNG

Phân loại gap → **DỪNG + báo**, route:
- intent gap → `/reconcile PRD`
- state/rule gap → `/reconcile BUSINESS-FLOW`
- tiền đề sai (reframe gốc) → `/pivot`

**KHÔNG tự sửa frozen doc.**

## Gate — freeze terminal

Cột gate "—" = **KHÔNG có freeze-ceremony giữa pipeline riêng**; distill REQUIREMENTS sạch **CHÍNH LÀ** cú freeze cuối + handoff.
- completeness-check vẫn chạy (mọi FR phủ đủ + khớp upstream).
- Freeze: frontmatter `frozen: true` + `version: 1` + `from_hash =` mọi upstream. **Người confirm.**

## Side-effect `PIPELINE.lock`

- `docs[REQUIREMENTS].status = active`.
- `requirements_version = 1`.
- **`phase → done`**.
- Nếu còn `stale-deferred` bất kỳ → giữ cờ để handoff `writing-plans` cảnh báo.

## Handoff

Kết pipeline. `REQUIREMENTS.md` frozen = input cho `superpowers:writing-plans`. Nếu có `stale-deferred` → nêu rõ trong handoff.
