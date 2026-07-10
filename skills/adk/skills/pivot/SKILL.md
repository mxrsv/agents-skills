---
name: pivot
description: Anytime escape-hatch in the adk ADR-first pipeline. When a prior decision's premise is WRONG (root reframe, not a local gap), write an atomic pivot-ADR that supersedes the original premise plus a batch of replacement/retirement ADRs for every active decision invalidated by it, then re-render every affected derived doc in phase order. Exposing a root reframe is a SUCCESS, never penalized. Fires ONLY when the user types /adk:pivot.
when_to_use: A prior decision's premise is wrong (reframe root), not a surgical gap (that is /adk:adr adding a new decision). Trigger only on explicit /adk:pivot. Grill is licensed to raise /adk:pivot.
argument-hint: "<mô tả tiền đề sai / ADR gốc nghi ngờ>"
arguments: description
---

# /adk:pivot — anytime (escape-hatch, bản nhẹ v2)

**Mục đích:** tiền đề của một quyết định trước **SAI** (reframe gốc, không phải gap cục bộ) → lật bằng **pivot batch ADR** + render lại doc ảnh hưởng. Tách bạch với `/adk:adr` thường bằng **ngữ nghĩa**: `/adk:adr` thêm/lật một quyết định đơn lẻ; `/adk:pivot` xử lý khi lật MỘT tiền đề kéo theo NHIỀU quyết định active khác cùng sai theo.

> **Framing chống-trừng-phạt (giữ từ v1):** phơi reframe gốc = hệ thống **THÀNH CÔNG**, KHÔNG phạt. Giá redo là thật nhưng bounded + recorded (mọi thứ vẫn nằm trong ADR log + git) + rẻ hơn phát hiện sau khi build. Không có framing này thì cơ chế vô dụng — người sẽ giấu nghi ngờ thay vì raise pivot.

Đọc trước: `../../references/adr-protocol.md` · `../../references/render-protocol.md` · `../../references/pipeline-lock-schema.md` · `../../references/elicitation-contract.md`.

## Trigger

- `/adk:pivot <mô tả>`, bất kỳ lúc nào.
- Kiểm `lock_version == 2` trước khi đọc/ghi gì (guard, xem `pipeline-lock-schema`); v1/lạ → DỪNG, không đoán/mutate.
- `adk:grill` được cấp phép **raise** pivot (challenge một ADR/doc → đề xuất "tiền đề này có vẻ sai, cần pivot") — nhưng vẫn chỉ là đề xuất, người quyết định gõ `/adk:pivot`.

## Elicitation

- Thừa hưởng elicitation mode của phase gần nhất liên quan tới ADR gốc bị nghi ngờ (xem bảng cường độ `elicitation-contract`).

## Process

1. **Xác định ADR tiền đề gốc** (id cụ thể) + quét active-set tìm mọi ADR active khác **phụ thuộc logic** vào tiền đề đó (đọc `## Context`/`## Decision` của từng ADR active, không chỉ máy móc theo `supersedes` — cần đọc-hiểu).
2. **Soạn pivot batch** (tất cả ở dạng nháp trước khi ghi gì):
   - Một **pivot-ADR** nguyên tử (`kind: pivot`) supersede đúng ADR tiền đề gốc — nêu rõ vì sao tiền đề sai trong `## Context`.
   - Một ADR thay thế/retire **nguyên tử cho từng quyết định active bị kéo theo** — mỗi ADR cũ bị vô hiệu có đúng 1 ADR mới supersede nó (không dồn nhiều supersede vào 1 file — `adr-protocol` §4).
3. **Người duyệt từng ADR trong batch** — **DỪNG THẬT** (SPEC v2 §8.2), không duyệt gộp cả batch một lần. Ghi (append) từng ADR đã duyệt.
4. **Kiểm active-set mới** đã đủ quyết định cần cho render chưa — nếu pivot vừa xoá một quyết định mà chưa có ADR thay thế tương đương (batch thiếu), **DỪNG, không render** ("không render trong trạng thái chỉ vừa xoá chân lý cũ mà chưa có quyết định thay thế").
5. **Render lại doc ảnh hưởng theo thứ tự phase** (`PRINCIPLES → PRD/BUSINESS-FLOW → ARCHITECTURE/UX-DESIGN → REQUIREMENTS`, chỉ những doc thực sự có ADR trong batch nằm trong `affects`) — mỗi doc: file tạm → diff → **người confirm riêng** → ghi file đích (`render-protocol` §2).

## Đã BỎ so với v1

- **Archive `docs/archive/vN/`** — lịch sử = git + ADR log; doc dẫn xuất tái sinh được từ ADR nên không cần bảo tồn bản cũ riêng.
- **Rewind `phase`** — `phase` trong `PIPELINE.lock` chỉ có ý nghĩa lúc bootstrap; pivot chạy sau bootstrap không đụng nó (xem `pipeline-lock-schema`).
- **Unfreeze / STALE machinery** — không còn freeze; LỆCH suy trực tiếp từ so-tập-hợp (`render-protocol` §3), không có state `stale`/`stale-deferred` cần "unfreeze" trước khi sửa.

## Gate

- Raise pivot = không phạt, không gate riêng.
- Duyệt từng ADR trong batch = người, DỪNG THẬT (bước 3).
- Render mỗi doc = người confirm diff riêng (bước 5).

## Side-effect `PIPELINE.lock`

- **Không đổi `phase`, không đổi `project_type`.**
- Thêm entry `docs[]` nếu render sinh doc mới lần đầu (hiếm, ví dụ pivot làm phát sinh `UX-DESIGN` mới).
- Nếu `REQUIREMENTS.md` nằm trong doc render lại và FR/NFR nội dung đổi → bump `version` trong frontmatter của chính file đó (không phải ở lock — `render-protocol` §4), kèm danh sách ID đổi.
