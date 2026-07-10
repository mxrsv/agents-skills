# Reference — `pipeline-lock-schema` (v2)

Schema của `PIPELINE.lock` — con trỏ **bootstrap** (chạy 1 lần) + registry path của doc dẫn xuất. **Không còn state-machine 8-trường của v1** — nguồn chân lý thật giờ là `docs/decisions/` (xem `adr-protocol`); lock chỉ còn hai việc: (1) biết bootstrap đang ở đâu, (2) biết doc nào tồn tại ở path nào.

> **Compatibility guard bắt buộc:** mọi skill đọc file này phải kiểm `lock_version` TRƯỚC khi làm gì khác. Gặp `lock_version: 1` hoặc field lạ không nhận ra → **DỪNG**, không đoán/không mutate. Báo user: "lock này là v1 (freeze-gated) hoặc không rõ version, adk hiện tại chạy v2 (ADR-first) — cần migrate/re-bootstrap có backup trước khi tiếp tục." v2 **không** tự động chuyển frozen doc v1 thành ADR — đó là quyết định ngữ nghĩa chỉ người mới quyết được.

## Vị trí

`<repo-đích>/PIPELINE.lock` — ghi vào **repo mà user đang đứng** khi chạy skill.

## Schema

```yaml
lock_version: 2

phase: kickoff # kickoff | product | architecture | requirements | done
# CHỈ có ý nghĩa cho BOOTSTRAP (chạy 1 lần, 4 phase tuyến tính).
# Sau "done", phase KHÔNG đổi nữa — vòng đời tiếp theo là /adk:adr + /adk:docs-check + /adk:pivot, không "chạy lại phase".

project_type: greenfield # greenfield | brownfield — set 1 lần ở /adk:kickoff, immutable. Giữ để codebase-recon dùng.

docs: # registry — CHỈ id + path. derived_from/version đọc từ frontmatter doc, KHÔNG nhân đôi ở đây.
  - { id: PRINCIPLES, path: docs/PRINCIPLES.md }
  - { id: PRD, path: docs/PRD.md }
  - { id: BUSINESS-FLOW, path: docs/BUSINESS-FLOW.md }
  - { id: ARCHITECTURE, path: docs/ARCHITECTURE.md }
  # { id: UX-DESIGN, path: docs/UX-DESIGN.md }        — chỉ thêm nếu ADR kiến trúc quyết included
  # { id: REQUIREMENTS, path: docs/REQUIREMENTS.md }  — chỉ thêm sau /adk:requirements
```

## Từng field

| Field          | Kiểu | Ai ghi                                 | Ý nghĩa                                                                                                         |
| -------------- | ---- | -------------------------------------- | --------------------------------------------------------------------------------------------------------------- |
| `lock_version` | int  | init ở `/adk:kickoff`                  | version schema của chính lock. Guard bắt buộc — xem trên.                                                       |
| `phase`        | enum | phase skill (advance khi render xong)  | con trỏ **bootstrap**. `/adk:adr`, `/adk:docs-check`, `/adk:pivot` **KHÔNG** rewind/đổi field này sau `done`.   |
| `project_type` | enum | init ở `/adk:kickoff` (immutable)      | `greenfield` \| `brownfield` — dùng bởi `codebase-recon`.                                                       |
| `docs[]`       | list | phase skill lúc render lần đầu tạo doc | registry `id` + `path`. KHÔNG có `status` (không còn active/stale/stale-deferred — hết khái niệm STALE ở lock). |

## Đã BỎ so với v1 (và vì sao)

| Field v1                  | Vì sao bỏ                                                                                                                                                    |
| ------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `decisions.ux`            | Suy trực tiếp từ có/không ADR kiến trúc quyết `UX-DESIGN` ∈ `affects` + doc đó có tồn tại trong registry chưa.                                               |
| `flags.pending_arch_sync` | Không còn "hai nguồn ARCHITECTURE↔ADR" — ADR LÀ chân lý; ARCHITECTURE chỉ là view. Không có gì để "sync-pending".                                            |
| `docs[].status`           | Hết khái niệm STALE lưu-trạng-thái — LỆCH được suy trực tiếp từ so-tập-hợp `derived_from` ↔ active-set mỗi lần cần biết (`render-protocol` §3), không cache. |
| `requirements_version`    | Chuyển vào frontmatter `REQUIREMENTS.md` (`version:`) — single-source, đọc ở đúng file nó thuộc về.                                                          |
| `adr_manifest`            | Không còn hash tự quản. Đảm bảo mục tiêu = hook best-effort (`adr-protocol` §8) + `git diff`/history + review người — không phải state máy tự tính.          |
| `archive_versions`        | Không còn `docs/archive/vN/` — lịch sử = git + ADR log; doc dẫn xuất tái sinh được nên không cần bảo tồn bản cũ.                                             |

## Quy tắc dùng lock (mọi skill)

1. **Kiểm `lock_version` đầu tiên, luôn luôn** — xem compatibility guard ở đầu file.
2. Đọc `phase` để biết bootstrap đang ở đâu (chỉ liên quan trong lúc bootstrap chạy; sau `done` field này bất động).
3. Đọc `docs[]` để biết path của doc dẫn xuất — nhưng **muốn biết doc có LỆCH không, phải đọc frontmatter `derived_from` của chính doc đó + quét `docs/decisions/`** (`render-protocol` §3), không suy từ lock.
4. Ghi lock: chỉ phase skill lúc bootstrap (advance `phase`, thêm entry `docs[]` khi tạo doc mới lần đầu). `adk:adr`/`adk:docs-check`/`adk:pivot`/`adk:router` **không đụng `phase`**; `adk:docs-check`/`adk:pivot` có thể thêm entry `docs[]` nếu render sinh doc mới (ví dụ `UX-DESIGN` lần đầu).
5. **`adk:grill` / `adk:grill-docs` / `adk:interview` / `adk:router` CẤM ghi file này** — read-only tuyệt đối với lock.
