---
name: pivot
description: Anytime escape-hatch in the docs-bootstrap pipeline. When a PRIOR phase's premise is WRONG (root reframe, not a local gap), archive the current doc + downstream to docs/archive/vN/, write a pivot-ADR, rewind the PIPELINE.lock pointer to the target phase, and let downstream go STALE for re-derivation. Exposing a root reframe is a SUCCESS, never penalized. Fires ONLY when the user types /pivot <target-phase>.
when_to_use: A prior phase's premise is wrong (reframe root), not a surgical gap (that is /reconcile). Trigger only on explicit /pivot <target-phase>. Late-phase grill is licensed to raise /pivot.
argument-hint: "<kickoff|product|architecture|requirements>"
arguments: target_phase
---

# /pivot `<phase-đích>` — anytime (escape-hatch)

**Mục đích:** tiền đề phase trước **SAI** (reframe gốc, không phải gap cục bộ) → lật + rewind. Tách bạch với `/reconcile` bằng **ngữ nghĩa**: reconcile = sửa phẫu thuật; pivot = tiền đề sai.

> **Framing chống-trừng-phạt (fix 3.2 ②):** phơi reframe gốc = hệ thống **THÀNH CÔNG**, KHÔNG phạt. Giá redo là thật nhưng bounded + recorded + rẻ hơn phát hiện sau build. **Không có framing này thì cơ chế vô dụng.**

Đọc trước: `../../references/hash-cascade.md` · `../../references/pipeline-lock-schema.md` · `../../references/freeze-protocol.md` · `../../references/elicitation-contract.md`.

## Trigger

- `/pivot <phase-đích>`, bất kỳ lúc nào.
- **grill phase muộn được cấp phép raise `/pivot`** (challenge frozen doc read-only → đề xuất pivot).

## Elicitation

- **Thừa hưởng elicitation mode của phase đích** (xem bảng cường độ trong `elicitation-contract`).

## Input đọc

doc hiện tại + phase-đích + CONTEXT.

## Process

1. **Archive** doc hiện tại (+ downstream) → `docs/archive/v{N}/`.
2. **pivot-ADR** (vì sao lật) → `docs/decisions/NNNN-<slug>.md` (append-only, qua cơ chế `/adr`).
3. **Rewind con trỏ** `PIPELINE.lock` `phase = phase-đích`; mở lại (unfreeze từ phase-đích trở đi).
4. Downstream tự **STALE** (máy hash `hash-cascade`) → re-derive theo pipeline từ phase đích.

## Gate

- raise pivot = **không phạt**, không gate.
- re-derive chạy gate pipeline **bình thường** từ phase-đích (mỗi phase completeness-check + người freeze).

## Side-effect `PIPELINE.lock`

- **rewind `phase = phase-đích`**.
- `archive_versions += [vN]` (đóng version contract m10).
- `docs[].status` downstream → `absent` / `stale`.
- `adr_manifest[pivot-ADR] = sha256(body)`.
- Nếu REQUIREMENTS bị lật/redo → `requirements_version += 1` + FR-ID list (`hash-cascade` § version).
