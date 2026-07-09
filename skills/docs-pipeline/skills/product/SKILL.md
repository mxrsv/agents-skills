---
name: product
description: Phase 1 of the docs-bootstrap pipeline. Extract product intent into PRD.md (intent/journey/scope) and BUSINESS-FLOW.md (state/rule/invariant), then freeze both. Heaviest elicitation phase. Fires ONLY when the user types /product and PIPELINE.lock phase == product.
when_to_use: After /kickoff froze PRINCIPLES. Trigger only on explicit /product. Blocked unless phase == product.
argument-hint: ""
arguments: none
---

# /product — Phase 1

**Mục đích:** MOI intent → `PRD.md` (intent · journey · scope) + `BUSINESS-FLOW.md` (state · rule · invariant).

Đọc trước: `../../references/pipeline-lock-schema.md` · `../../references/freeze-protocol.md` · `../../references/elicitation-contract.md`.

## Trigger & gate-guard

- Chỉ fire khi user gõ `/product`.
- **Gate-guard `phase == product`** (PRINCIPLES đã frozen). Sai phase → **chặn + báo** phase hiện tại.
- Gate cross-check PRINCIPLES (freeze-protocol § cross-check): tồn tại · frozen · integrity.

## Elicitation (🔴 nặng nhất)

- **`interview-me`** (engine chính) — moi intent, "hỏi liên tục" đúng nghĩa.
- `grill-with-docs` nháp (đã có PRINCIPLES frozen làm nền → bắt đầu vắt được).
- **"2-3 approaches" inline** cho các lựa chọn product lớn (KHÔNG kéo skill brainstorming).
- Engine chỉ trả text; skill này ghi `CONTEXT.md` từ đề-xuất grill (parent-writes).

## Input đọc

`PRINCIPLES.md` (frozen — nền cho completeness-check + grill) · `CONTEXT.md`.

## Output ghi

- **`PRD.md`** — intent · journey · scope. FR/NFR viết **narrative** ở đây (atomic để dành `/requirements` — rule 8, **KHÔNG** sync 2 list).
- **`BUSINESS-FLOW.md`** — state · rule · invariant.
- Update `CONTEXT.md` (parent ghi từ grill-đề-xuất).

## Gate (freeze CẢ HAI)

Completeness-check **từng doc** (rule 4):
- PRD có **intent + journey + scope**?
- BUSINESS-FLOW có **state + rule + invariant**?
- **VÀ** khớp PRINCIPLES (không chỉ đủ mục — đúng ràng buộc repo)?

Đạt → **người freeze CẢ HAI**. Mỗi doc stamp `from_hash = { PRINCIPLES: <hash> }`.

## Side-effect `PIPELINE.lock`

Sau freeze:
- `docs[PRD].status = active`, `docs[BUSINESS-FLOW].status = active` (thêm entry nếu chưa có).
- **`phase → architecture`**.

## Post-phase (rule 6)

- compact `CONTEXT.md` (archive-not-delete).
- nhắc `/adr` nếu có quyết định lớn.
- gợi ý bước kế: `/architecture`.
