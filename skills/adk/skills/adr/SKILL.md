---
name: adr
description: Anytime skill in the docs-bootstrap pipeline. Record an architecture/decision record as a new append-only immutable file in docs/decisions/ (auto-numbered). Never edits an existing ADR — change of mind = a new ADR that supersedes. Sets pending_arch_sync when an architecture-changing ADR lands after ARCHITECTURE is frozen. Fires ONLY when the user types /adr.
when_to_use: Any time a decision worth recording is made. Trigger only on explicit /adr <title>. Phase-independent.
argument-hint: "<title>"
arguments: title
---

# /adr `<title>` — anytime

**Mục đích:** ghi quyết định lý-do/lịch-sử, **append-only immutable**. Đổi ý → ADR mới **supersedes**, KHÔNG sửa file cũ.

Đọc trước: `../../references/pipeline-lock-schema.md` · `../../references/elicitation-contract.md`.

## Trigger

- `/adr <title>`, bất kỳ lúc nào, không phụ thuộc phase.

## Elicitation

- `adk:interview` **nhẹ** — làm rõ quyết định + rationale.
- Đọc `CONTEXT` + `PIPELINE.lock` (ARCHITECTURE đã frozen chưa?).

## Output ghi

- **File MỚI** `docs/decisions/NNNN-<slug>.md` (auto-số, 4 chữ số). **KHÔNG** sửa file cũ.
- Nội dung: context · decision · consequences · (supersedes NNNN nếu có).
- Skill **tự phân loại** ADR: đổi-kiến-trúc hay không.

## Gate

— (không freeze). ADR **không** sửa `ARCHITECTURE.md`; `ARCHITECTURE.md` **không** chép rationale (fix 1.4 option A: hai nguồn tách bạch, mỗi cái đọc-ra-chân-lý theo vai của nó).

## Side-effect `PIPELINE.lock`

1. **`adr_manifest[NNNN] = sha256(body)`** — backstop immutability (gate check: không id cũ đổi hash).
2. **Nếu ADR đổi-kiến-trúc VÀ `ARCHITECTURE.md` ĐÃ frozen** →
   - `flags.pending_arch_sync = true` →
   - **CHẶN command kế + gate** cho tới khi `/reconcile ARCHITECTURE` chạy xong.
3. **Guard deadlock:** ARCHITECTURE **CHƯA** frozen (ADR-early, còn ở phase ≤ architecture) → **KHÔNG** set cờ; ADR chỉ feed vào `/architecture` như input. (Tránh cờ chặn một `/reconcile ARCHITECTURE` không thể chạy.)
