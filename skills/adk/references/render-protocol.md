# Reference — `render-protocol` (v2)

Cách sinh/tái sinh doc dẫn xuất (`PRINCIPLES.md` · `PRD.md` · `BUSINESS-FLOW.md` · `ARCHITECTURE.md` · `UX-DESIGN.md` điều kiện · `REQUIREMENTS.md`) từ **tập ADR active** (xem `adr-protocol` §3) + `CONTEXT.md`. Dùng chung bởi phase skill (bootstrap), `adk:adr` (§5 consistency-check), `adk:pivot`, `adk:docs-check`.

> **Không khoá, không hash, không freeze.** Đây là điểm khác biệt căn bản với v1: doc dẫn xuất không có ceremony "freeze" — chỉ có "render" (có thể chạy lại bất cứ lúc nào tập ADR active còn đúng).

## 1. Frontmatter doc dẫn xuất

```yaml
---
derived: true
derived_from: [0001, 0002, 0007, 0012] # id ADR active đã dùng để render, snapshot lúc render này
rendered: 2026-07-10
version: 3 # CHỈ REQUIREMENTS.md dùng — xem §4
---
```

- `derived_from` là **bằng chứng quyết định nào đã dùng**, KHÔNG phải hash — không chứng minh body chưa bị ai sửa tay bằng đường khác, không hứa byte-for-byte reproducibility giữa 2 lần render cùng input (prose có thể diễn đạt khác).
- Doc khác REQUIREMENTS không có `version`.

## 2. Render operation (mọi lần, mọi caller)

1. Xác định doc đích D + tập ADR cần dùng = mọi ADR active mà `D ∈ ADR.affects`.
2. Đọc `CONTEXT.md` (living, hỗ trợ diễn đạt/ví dụ — **không phải nguồn quyết định**; nội dung nào có khả năng đổi contract phải đã được nâng thành ADR trước khi vào bước này).
3. Nếu D = `REQUIREMENTS.md`: đọc bản hiện tại (hoặc git history nếu file mất — xem §4) để bảo toàn ID/version/tombstone TRƯỚC khi soạn bản mới.
4. Soạn bản mới, ghi vào **file tạm** (không đụng file đích).
5. Stamp frontmatter `derived_from` = đúng tập ADR active vừa dùng.
6. Sinh **unified diff** giữa file đích hiện tại (nếu có) và file tạm.
7. Trình diff cho người — **DỪNG THẬT** (khối chỉ thị cứng ở SPEC §8.2), chờ input tường minh.
8. Người confirm → thay file đích bằng file tạm. Người từ chối/sửa → lặp lại từ bước phù hợp, không tự quyết thay.
9. Không đụng `PIPELINE.lock` trừ khi đây là bootstrap advance-phase (xem `pipeline-lock-schema`).

## 3. Quy tắc so tập hợp — doc "LỆCH"

Doc D **LỆCH** (cần render lại) khi một trong hai điều kiện đúng:

- `∃ ADR active A: D ∈ A.affects ∧ A.id ∉ D.derived_from` — có quyết định mới/mở rộng chưa được render vào D.
- `∃ id ∈ D.derived_from: id ∉ active-set` — D đang render dựa trên một ADR đã bị supersede (quyết định lật rồi mà view chưa theo).

Đây là **so sánh tập hợp deterministic** — không cần topo order, không cần 3-way arbitration, không cần re-scan nhiều vòng như v1. Dùng bởi `adk:docs-check` (§6 SPEC) và `adk:router` (báo cáo status).

## 4. REQUIREMENTS — versioned + FR/NFR-ID immutable

`REQUIREMENTS.md` là doc dẫn xuất DUY NHẤT có `version` (bump mỗi lần render có FR/NFR đổi — thêm/sửa nội dung một ID) — vì đây là contract terminal handoff sang `superpowers:writing-plans`, cần một con số để downstream biết "có gì mới từ lần trước".

- **FR-xxx / NFR-xxx ID cấp một lần, không đánh số lại, không tái dùng ID đã xoá/gộp.** Muốn bỏ một yêu cầu → giữ ID trong body dưới dạng tombstone (`FR-014: [REMOVED — supersede bởi ADR-0031]`), không xoá khỏi file.
- Render chỉ được:
  - Thêm ID mới (khi có ADR mới thuộc `affects: [REQUIREMENTS]` chưa render).
  - Thay nội dung một ID cũ **khi có ADR bảo chứng cho thay đổi đó** (ADR supersede ADR gốc sinh ra ID đó, hoặc ADR mới đủ cụ thể để sửa nội dung).
- Mọi lần đổi FR/NFR → `version += 1` + ghi rõ danh sách ID vừa đổi (thêm/sửa/tombstone) trong body (section `## Changelog`) và trong diff trình người.
- **Continuity dựa vào bản trước + git history**, không phải state riêng: renderer PHẢI đọc file `REQUIREMENTS.md` hiện tại trước khi soạn bản mới, để giữ đúng ID/version/tombstone đã có.
- **File mất (không đọc được bản hiện tại):**
  1. Thử khôi phục bản gần nhất từ `git log -- docs/REQUIREMENTS.md` / `git show`.
  2. Khôi phục được → dùng bản đó làm continuity baseline, tiếp tục render bình thường.
  3. **Không có history khôi phục được ⇒ DỪNG.** Không âm thầm sinh ID từ đầu (sẽ đụng ID cũ writing-plans/code đã tham chiếu). Báo user, yêu cầu **re-baseline contract tường minh** (user xác nhận "bắt đầu lại từ FR-001" hoặc cung cấp bản cũ từ nơi khác).

## 5. Ai render

- **Phase skill lúc bootstrap** (`adk:kickoff/product/architecture/requirements`) — render doc(s) của chính phase đó sau khi chùm ADR được duyệt.
- **`adk:adr`** (§5 SPEC, bước consistency-check) — đề nghị render lại doc lệch do ADR vừa ghi; user gật cái nào render cái đó.
- **`adk:pivot`** — render lại theo thứ tự phase sau khi pivot batch ADR được duyệt đủ.
- **`adk:docs-check`** — có thể render đúng doc đã báo lệch, **chỉ sau khi user chọn doc đó và confirm diff** (không tự động quét-rồi-render tất cả).

## 6. Forced view/body repair (`--force`)

Trường hợp doc **KHÔNG lệch theo §3** (mọi `derived_from` vẫn khớp active-set) nhưng **body/view đã hỏng** (bị sửa tay lỗi, format vỡ, nội dung không khớp ADR dù ID vẫn đúng) — dùng `adk:docs-check DOC --force`:

1. Đọc doc hiện tại, xác nhận với user đây là lỗi view/body chứ **không phải quyết định mới cần ADR** (nếu là quyết định mới → dừng, route `/adk:adr` trước).
2. Render lại từ **đúng active-set hiện có** (không đổi tập ADR dùng) → file tạm → diff → gate confirm → replace.
3. Không bump `version` của REQUIREMENTS nếu FR/NFR nội dung không đổi (chỉ sửa format/lỗi trình bày) — chỉ bump khi nội dung FR/NFR thực sự đổi.
