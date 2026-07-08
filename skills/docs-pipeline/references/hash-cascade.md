# Reference — `hash-cascade`

STALE detection + cascade arbitration khi một frozen doc đổi hash (`/reconcile` re-freeze hoặc `/pivot`). Cặp với `freeze-protocol` (§ gate cross-check (d)) và `pipeline-lock-schema`.

## Topological order (root → sink)

```
PRINCIPLES → {PRD, BUSINESS-FLOW} → {ARCHITECTURE, UX-DESIGN} → REQUIREMENTS
```

`PRINCIPLES` = root (trong `from_hash` của MỌI doc). `REQUIREMENTS` = sink (không doc nào derive từ nó).

## STALE detection

Doc `D` **STALE** ⟺ ∃ upstream `U ∈ D.from_hash` mà `current_hash(U) ≠ D.from_hash[U]`.

- Suy-ra-được từ hash; **KHÔNG lưu** state STALE thô vào lock.
- Chỉ **quyết-định-người** `defer` mới ghi `docs[D].status = stale-deferred`.

## Cascade arbitration

Kích bởi: `/reconcile` re-freeze một doc, hoặc `/pivot`. Sau khi 1 doc đổi hash → duyệt downstream **theo topological order (upstream trước)**, ép người phân xử **TỪNG** STALE doc — 3 lối (option c: người-phân-xử-có-ghi-lại):

| Lối | Hành động | Kết quả |
| --- | --- | --- |
| **re-gate now** | distill lại từ upstream mới → completeness-check → freeze lại (hash MỚI) | + **re-scan downstream** (xem dưới) |
| **mark reviewed-valid** | người khẳng định nội dung không đụng → re-stamp `from_hash` = hash upstream hiện tại + **ghi note auditable** | hết STALE; `hash` GIỮ NGUYÊN (frontmatter đổi không tính vào hash) |
| **defer** | để nguyên STALE, không chặn pipeline | `docs[D].status = stale-deferred`; handoff `writing-plans` cảnh báo |

## Quy tắc bịt lỗ

### Re-scan sau MỖI re-gate
Re-gate một doc tầng giữa làm **hash nó đổi** → phải quét lại STALE cho tầng dưới nó.
Chuỗi `PRD → ARCHITECTURE → REQUIREMENTS`: nếu phân xử REQUIREMENTS *trước khi* ARCHITECTURE re-gate, cú hai-bước lọt. **Topological order + re-scan-sau-mỗi-re-gate** đóng lỗ này (fix review-2 G4).

### Version REQUIREMENTS ở MỌI re-freeze
Bất kỳ lần REQUIREMENTS re-freeze nào — qua `/reconcile` cascade **HAY** `/pivot`:
- `requirements_version += 1` (trong `PIPELINE.lock`);
- ghi **danh sách FR-ID vừa đổi** (vào frontmatter/note REQUIREMENTS).

→ handoff diff được "N FR này vừa đổi" cho code đã build trên bản trước. Đóng m10 cho **cả** đường reconcile, không chỉ pivot.

### Bound loop
Mỗi STALE doc kết ở đúng 1/3 trạng thái (re-gate / reviewed-valid / defer) → cascade **không lặp vô hạn**.

## Trường hợp đặc biệt

- **`/reconcile PRINCIPLES`** → PRINCIPLES là root → cascade **toàn bộ** downstream.
- **`/pivot`** → dùng chung máy này: archive doc bị lật, rewind `phase`, downstream tự STALE (hash) → re-derive theo pipeline từ phase đích.
