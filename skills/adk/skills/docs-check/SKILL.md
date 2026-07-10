---
name: docs-check
description: New v2 anytime skill in the adk ADR-first pipeline. Compares the active ADR set against each derived doc's derived_from frontmatter using a deterministic set-comparison rule (no topo-order, no hash, no cascade), reports which docs are out of sync and why, and offers to re-render just the ones the user picks. Also supports --force to repair a doc whose view/body is broken even though its derived_from still matches the active set. Recommended before superpowers:writing-plans / /planning. Fires ONLY when the user types /adk:docs-check.
when_to_use: To check whether PRD/BUSINESS-FLOW/ARCHITECTURE/UX-DESIGN/REQUIREMENTS/PRINCIPLES are still in sync with the active ADR set, or to repair a doc whose rendered body is broken. Trigger only on explicit /adk:docs-check [DOC] [--force]. Read-only unless the user confirms a specific re-render.
argument-hint: "[DOC] [--force]"
arguments: doc_and_flags
---

# /adk:docs-check `[DOC] [--force]` — anytime (skill MỚI v2)

**Mục đích:** thay cơ chế "stale-by-hash + cascade topo-order" của v1 cho đúng một câu hỏi: **tập quyết định đã render vào doc này có còn đúng không?** Dùng so sánh tập hợp deterministic, không cần state máy riêng.

Đọc trước: `../../references/render-protocol.md` (đặc biệt §3, §6) · `../../references/adr-protocol.md` · `../../references/pipeline-lock-schema.md`.

## Trigger

- Kiểm `lock_version == 2` trước khi đọc/ghi gì (guard, xem `pipeline-lock-schema`); v1/lạ → DỪNG, không đoán/mutate.
- `/adk:docs-check` (không đối số) → quét **decision-set drift** trên toàn bộ doc dẫn xuất đang tồn tại (đọc `docs[]` trong `PIPELINE.lock` để biết danh sách).
- `/adk:docs-check <DOC>` → chỉ quét doc đó.
- `/adk:docs-check <DOC> --force` → **forced view/body repair** (xem dưới), bỏ qua nhánh quét thường.
- Khuyến nghị chạy trước `superpowers:writing-plans` / `/planning` để chắc `REQUIREMENTS.md` không LỆCH.

## Quy tắc so tập hợp (đơn giản, đọc-và-áp-dụng, không phải verifier tool riêng)

Với mỗi doc D cần quét, đọc `derived_from` từ frontmatter D + quét toàn bộ `docs/decisions/` để có active-set. D **LỆCH** khi:

- `∃ ADR active A: D ∈ A.affects ∧ A.id ∉ D.derived_from` (có quyết định mới/mở rộng chưa render vào D), **HOẶC**
- `∃ id ∈ D.derived_from: id ∉ active-set` (D render trên một quyết định đã bị supersede).

Không cần topo order, không cần 3-way arbitration, không cần re-scan nhiều vòng — mỗi doc tự đứng độc lập theo 2 điều kiện trên.

## Nhánh thường (quét, không đối số hoặc `<DOC>`)

1. Với mỗi doc trong phạm vi, áp quy tắc trên → phân loại **khớp** hoặc **LỆCH (kèm id ADR cụ thể gây lệch)**.
2. **Output = bảng** `doc ↔ lý do lệch (id ADR)` cho mọi doc LỆCH. Doc khớp thì báo ngắn "khớp".
3. **Đề nghị render lại** — user chọn (có thể chọn nhiều, hoặc 0). Với mỗi doc user chọn: chạy render theo `render-protocol` §2 (file tạm → diff → confirm → ghi). Doc không chọn: để nguyên, không tự động render.
4. **KHÔNG tự-render, KHÔNG ghi `PIPELINE.lock`** khi chỉ chạy quét (chỉ ghi khi user confirm render một doc cụ thể ở bước 3).

## Nhánh `--force` (forced view/body repair)

Dùng khi `derived_from` của DOC **vẫn khớp** active-set (không LỆCH theo quy tắc trên) nhưng nội dung/format của doc bị hỏng (sửa tay lỗi, format vỡ, không khớp ADR dù ID đúng):

1. Đọc DOC hiện tại → **xác nhận với user** đây thật là lỗi view/body, **không phải** một quyết định mới cần ADR riêng.
   - Là quyết định mới → **DỪNG**, route `/adk:adr` trước (không dùng `--force` để lách qua ADR).
2. Render lại từ **đúng active-set hiện có** (không đổi tập ADR dùng, không đổi `derived_from`) → file tạm → diff → **DỪNG THẬT** (SPEC v2 §8.2) → ghi file đích.
3. Với `REQUIREMENTS.md`: chỉ bump `version` nếu nội dung FR/NFR thực sự đổi (không bump nếu chỉ sửa lỗi format/trình bày — `render-protocol` §6).

## Giới hạn (nói rõ, không overclaim)

- **Không phát hiện body bị sửa tay mà `derived_from` vẫn "hợp lý"** (ví dụ ai đó tay chỉnh một câu trong ARCHITECTURE.md mà không đổi tập ADR dùng) — công cụ này chỉ so tập id, không hash/diff nội dung. Backstop cho trường hợp đó là `git diff` + review người, không phải `docs-check`.
- Đây là **workflow discipline**, không phải security verifier.

## Side-effect `PIPELINE.lock`

- Nhánh quét: không đụng lock trừ khi user confirm render một doc **lần đầu tồn tại** (thêm entry `docs[]`).
- Nhánh `--force`: không đụng lock (doc đã tồn tại, chỉ sửa nội dung).
- Không đụng `phase` trong cả hai nhánh.
