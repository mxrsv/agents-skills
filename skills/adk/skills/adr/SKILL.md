---
name: adr
description: Anytime skill in the adk ADR-first pipeline — the heart of the system. Records a decision as a new append-only immutable file in docs/decisions/ (auto-numbered), with explicit affects + supersedes fields the user approves. Runs a mechanical sanity-check against the active ADR set, then a post-write consistency-check that lists which derived docs are now out of sync and offers to re-render them. Never edits an existing ADR — change of mind = a new ADR that supersedes. Fires ONLY when the user types /adk:adr.
when_to_use: Any time a decision worth recording is made, at any point in the adk lifecycle (during bootstrap or long after). Trigger only on explicit /adk:adr <title>. Phase-independent.
argument-hint: "<title>"
arguments: title
---

# /adk:adr `<title>` — anytime (trái tim hệ v2)

**Mục đích:** ghi quyết định **append-only immutable** vào `docs/decisions/`. Đây là nguồn chân lý duy nhất của adk v2 — mọi doc dẫn xuất (PRD/ARCHITECTURE/…) chỉ là view render từ tập ADR active. Đổi ý → ADR mới **supersedes**, KHÔNG sửa file cũ.

Đọc trước: `../../references/adr-protocol.md` · `../../references/render-protocol.md` · `../../references/pipeline-lock-schema.md` · `../../references/elicitation-contract.md`.

## Trigger

- `/adk:adr <title>`, bất kỳ lúc nào, không phụ thuộc phase (giữ nguyên v1). Các phase skill + `adk:grill-docs` NHẮC user gõ lệnh này khi phát hiện quyết định vừa chốt chưa có ADR.
- Kiểm `lock_version == 2` trước khi đọc/ghi gì (guard, xem `pipeline-lock-schema`).

## Process

1. **`adk:interview` nhẹ** → soạn nháp ADR (context/decision/consequences/options-rejected) + đề xuất `kind` (`principle|product|architecture|requirement`) + `affects` (default máy móc theo `adr-protocol` §5) + `supersedes` (rỗng nếu không lật ai).
2. **Sanity-check máy móc** (KHÔNG grill, không subagent): quét frontmatter toàn bộ ADR active hiện có, tìm chủ đề trùng/mâu thuẫn với nháp vừa soạn.
   - Thấy khả năng trùng → hỏi tường minh _"quyết định này supersede ADR-NNNN à?"_ — đối chiếu với user, không tự chất vấn/không tự quyết.
   - Không thấy gì → bỏ qua bước này, đi thẳng gate.
3. **Trình bản nháp đầy đủ** (context/decision/consequences/options-rejected + `kind`/`affects`/`supersedes`) → **GATE DỪNG THẬT** (SPEC v2 §8.2):

   > **DỪNG THẬT — đây là câu hỏi cho NGƯỜI DÙNG. Kết thúc turn và chờ input thật. TUYỆT ĐỐI không tự trả lời thay, không coi im lặng là đồng ý. Không có input ⇒ không ghi file.**

   User sửa/duyệt **từng trường**, đặc biệt `affects` (thu hẹp phải kèm lý do — ghi thẳng vào ADR) + `supersedes`.

4. **Ghi file mới** `docs/decisions/NNNN-<slug>.md` — `NNNN` = max id hiện có trong thư mục **đọc lại ngay trước khi ghi** (+1, 4 chữ số — `adr-protocol` §7).
5. **Consistency-check hậu ADR** (`render-protocol` §3): với mỗi doc D sao cho `D ∈ ADR.affects` (vừa ghi) hoặc D có `derived_from` chứa id nào đó nằm trong `supersedes` vừa ghi → D giờ **LỆCH**.
   - Liệt kê bảng "doc lệch ↔ lý do (ADR nào)".
   - **Đề nghị render lại từng doc** — user gật cái nào, render cái đó ngay (theo `render-protocol` §2: file tạm → diff → confirm → ghi). Cái nào user không gật, để nguyên — `/adk:docs-check` sẽ nhắc lại sau nếu chạy.

## Đã BỎ so với v1

- Tự phân loại "đổi-kiến-trúc hay không" — không còn ý nghĩa, `affects` đã tường minh.
- Set/clear `flags.pending_arch_sync` — field này không còn tồn tại (`pipeline-lock-schema`).
- Chặn command kế — `/adk:adr` không khoá gì cả, chỉ đề nghị render, user có thể bỏ qua và làm việc khác.
- Ghi `adr_manifest` — không còn hash tự quản (`adr-protocol` §8).

## Side-effect `PIPELINE.lock`

- **KHÔNG đụng `phase`** — `/adk:adr` chạy phase-independent, không phải một bước bootstrap.
- Nếu render sinh ra một doc **lần đầu tồn tại** (ví dụ `UX-DESIGN.md` từ một ADR architecture về sau) → thêm entry vào `docs[]`.
