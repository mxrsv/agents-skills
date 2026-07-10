# Reference — `pipeline-lock-schema`

Schema của `PIPELINE.lock` — **nguồn state DUY NHẤT** của pipeline (con trỏ phase + quyết định + cờ). Machine-readable (YAML). Dùng chung bởi cả 8 skill.

> **Invariant 2 (state một chỗ):** state sống ở `PIPELINE.lock`, **KHÔNG** ở `CONTEXT.md`. `CONTEXT.md` = prose working-memory thuần. Bỏ SPOF "block chữ" dễ bị grill mài mòn (fix 1.1).
>
> **Hash KHÔNG nhân đôi vào đây** — hash sống ở frontmatter mỗi frozen doc (xem `freeze-protocol`). Lock chỉ giữ id/path/status. Single-source: một sự thật, một chỗ.

## Vị trí

`<repo-đích>/PIPELINE.lock` — ghi vào **repo mà user đang đứng** khi chạy skill, KHÔNG phải repo chứa skill.

## Schema

```yaml
lock_version: 1 # schema version của chính lock (bump khi đổi schema này)

phase: kickoff # con trỏ pipeline: kickoff | product | architecture | requirements | done

project_type:
  greenfield # greenfield | brownfield — set 1 LẦN ở /kickoff init, IMMUTABLE.
  # absent ⇒ greenfield (additive back-compat). brownfield ⇒ CONTEXT có recon buckets.

decisions:
  ux: pending # pending | included | skipped   (set ở /architecture)

flags:
  pending_arch_sync:
    false # /adr đổi-kiến-trúc set khi ARCHITECTURE ĐÃ frozen (§ freeze/adr).
    # true ⇒ CHẶN command kế + gate tới khi /reconcile ARCHITECTURE chạy xong.

docs: # registry — chỉ id/path/status; hash KHÔNG ở đây (single-source)
  - id: PRINCIPLES
    path: docs/PRINCIPLES.md
    status: active # absent | active | stale | stale-deferred
  - id: PRD
    path: docs/PRD.md
    status: active
  # … BUSINESS-FLOW / ARCHITECTURE / UX-DESIGN / REQUIREMENTS — thêm entry khi doc tồn tại

requirements_version: 0 # bump +1 MỌI lần REQUIREMENTS re-freeze (reconcile-cascade HAY pivot)

adr_manifest: # backstop immutability — id → hash body ADR lúc append
  "0001": <sha256>
  "0002": <sha256>

archive_versions: [] # [v1, v2, …] do /pivot tạo (snapshot doc bị lật)
```

## Từng field

| Field                     | Kiểu | Ai ghi                                                 | Ý nghĩa                                                                                                                              |
| ------------------------- | ---- | ------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------ |
| `lock_version`            | int  | init ở `/kickoff`                                      | version schema của lock.                                                                                                             |
| `phase`                   | enum | phase skill (advance khi qua gate) · `/pivot` (rewind) | con trỏ pipeline hiện tại. `/reconcile` **KHÔNG** rewind.                                                                            |
| `project_type`            | enum | init ở `/kickoff` (immutable)                          | `greenfield` \| `brownfield` — set 1 lần lúc init, không đổi. brownfield ⇒ CONTEXT có recon buckets; handoff cảnh báo existing-code. |
| `decisions.ux`            | enum | `/architecture`                                        | `included` (sinh UX-DESIGN.md) hoặc `skipped` (backend thuần).                                                                       |
| `flags.pending_arch_sync` | bool | `/adr` set · `/reconcile ARCHITECTURE` clear           | guard two-sources ARCHITECTURE↔ADR. Chỉ set NẾU ARCHITECTURE đã frozen (guard deadlock).                                             |
| `docs[]`                  | list | phase/update skill                                     | registry: `id`, `path`, `status`. Hash KHÔNG ở đây.                                                                                  |
| `docs[].status`           | enum | phase/update skill                                     | `absent` (chưa có) · `active` (frozen, valid) · `stale` (chỉ khi cần ghi rõ) · `stale-deferred` (người quyết để nguyên STALE).       |
| `requirements_version`    | int  | `/requirements` · cascade re-freeze                    | bump MỌI lần REQUIREMENTS re-freeze; kèm danh sách FR-ID vừa đổi (ở frontmatter/note REQUIREMENTS).                                  |
| `adr_manifest`            | map  | `/adr` (append)                                        | `id → sha256(body ADR)`. Gate check: không id cũ nào đổi hash (§ backstop).                                                          |
| `archive_versions`        | list | `/pivot`                                               | các snapshot version `/pivot` đẩy vào `docs/archive/`.                                                                               |

## Quy tắc dùng lock (mọi skill)

1. **Đọc lock để GATE** — trước khi hành động, kiểm `phase`, `flags`, `decisions`, `docs[].status`.
2. **Ghi lock khi QUA GATE** — advance `phase`, set `docs[].status=active`, set `decisions`, v.v.
3. **Cross-check artifact thật qua hash** — lock nói doc `active` chưa đủ; phải recompute body hash + đối chiếu `from_hash` (xem `freeze-protocol` § gate cross-check). Lock + hash = state suy-ra-được, không SPOF.
4. **STALE thô KHÔNG lưu** — STALE suy ra từ hash (xem `hash-cascade`); chỉ **quyết-định-người** (`stale-deferred`) mới ghi vào `docs[].status`.
5. **`CONTEXT.md` KHÔNG chứa state** (fix 1.1).
6. **`adk:grill-docs` CẤM chạm file này** — grill chạy **inline chỉ đề-xuất text** (xem `elicitation-contract`); chỉ phase/update skill ghi lock theo schema. Backstop: grill lỡ ghi frozen doc/ADR → gate hash + manifest cross-check phát hiện (`freeze-protocol`).
