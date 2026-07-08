---
name: reconcile
description: Anytime skill in the docs-bootstrap pipeline. Open ONE frozen doc to fix a LOCAL gap (framing unchanged), re-freeze it, then cascade STALE arbitration downstream in topological order with re-scan after each re-gate. One of the only two paths (with /pivot) that may open a frozen doc. Fires ONLY when the user types /reconcile <target>.
when_to_use: A local gap surfaced in a frozen doc (not a wrong premise — that is /pivot). Trigger only on explicit /reconcile <target>. Also the ARCHITECTURE sync path when pending_arch_sync is set.
argument-hint: "<PRINCIPLES|PRD|BUSINESS-FLOW|ARCHITECTURE|UX-DESIGN>"
arguments: target
---

# /reconcile `<target>` — anytime

**Mục đích:** mở 1 frozen doc sửa **gap cục bộ** (framing giữ nguyên) → re-freeze → cascade STALE downstream. Cùng `/pivot` là **hai đường DUY NHẤT** mở frozen doc.

Đọc trước: `../references/freeze-protocol.md` · `../references/hash-cascade.md` · `../references/pipeline-lock-schema.md`.

## Trigger

- `/reconcile <target>`; `target ∈ {PRINCIPLES, PRD, BUSINESS-FLOW, ARCHITECTURE, UX-DESIGN}`.
- REQUIREMENTS re-freeze **qua cascade**, KHÔNG target trực tiếp (nó là sink).

## Elicitation

- `grill-with-docs` nhắm **đúng gap** (không grill lại toàn bộ).

## Input đọc

target frozen doc + upstream của nó + CONTEXT.

## Process

1. Sửa target (gap cục bộ, giữ framing) → **re-freeze** (hash đổi) — `freeze-protocol` § freeze.
2. Duyệt downstream **topological order** (`hash-cascade` § topo). Với **mỗi STALE doc**, ép người phân xử 1/3 lối:
   - **re-gate now** → freeze lại (hash mới) → **re-scan downstream**.
   - **mark reviewed-valid** → re-stamp `from_hash` + ghi note auditable (hash giữ nguyên).
   - **defer** → `docs[].status = stale-deferred`.
3. **Re-scan sau MỖI re-gate** (bịt cú hai-bước PRD→ARCH→REQ).

## Trường hợp đặc biệt

- **`target == ARCHITECTURE`**: đây là đường **sync snapshot** khi `pending_arch_sync` bật. Sau khi freeze lại → **clear `flags.pending_arch_sync`**.
- **`target == PRINCIPLES`**: root hash-graph → cascade **toàn bộ** downstream (rule 10).

## Gate

- re-freeze target = **người**.
- mỗi downstream STALE = **người phân xử** (re-gate / reviewed-valid+note / defer).

## Side-effect `PIPELINE.lock`

- hash target đổi (frontmatter) → cập nhật `docs[].status` theo phân xử.
- **Version REQUIREMENTS** nếu REQ nằm trong chuỗi re-freeze: `requirements_version += 1` + ghi danh sách FR-ID vừa đổi (`hash-cascade` § version).
- Clear `pending_arch_sync` nếu `target == ARCHITECTURE`.
- **KHÔNG** rewind `phase` (khác `/pivot`).
