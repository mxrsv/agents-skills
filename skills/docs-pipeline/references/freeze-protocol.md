# Reference — `freeze-protocol`

Frontmatter của frozen doc + thủ tục **freeze** + **gate cross-check**. Dùng chung bởi cả 8 skill. Cặp với `pipeline-lock-schema` (state) và `hash-cascade` (STALE downstream).

> **Nguyên tắc:** state (lock) suy-ra-được + cross-check qua hash artifact thật → không còn "block chữ" SPOF dễ hỏng. Lock nói *cái gì active*; frontmatter hash chứng minh *nó còn valid*.

## Frontmatter mỗi frozen doc

```yaml
---
frozen: true
hash: <sha256 của BODY markdown, KHÔNG tính frontmatter>   # integrity của chính doc
from_hash:                       # MAP id→hash mọi nguồn upstream đã distill ra
  PRINCIPLES: <sha256>
  PRD: <sha256>
  # … mọi upstream trong topological order dẫn tới doc này
version: 1                       # CHỈ REQUIREMENTS (+ doc versioned) dùng; doc khác bỏ field này
---
<body markdown — phần được hash>
```

### `hash`
- = `sha256(body)` — body = **mọi byte SAU dòng `---` đóng frontmatter** (kể cả newline cuối). Byte-range cố định này để hash tái lập y hệt mỗi lần.
- **Không tính frontmatter** → re-stamp `from_hash` (đường `reviewed-valid`, xem `hash-cascade`) **KHÔNG** đổi `hash`. Đúng: nội dung không đụng ⇒ integrity giữ nguyên.
- **BẮT BUỘC tính bằng TOOL — KHÔNG "tính bằng đầu"** (H1). LLM không băm sha256 được; bịa hash ⇒ toàn bộ integrity + cascade thành rác. Tách body rồi hash bằng Bash, vd:
  ```bash
  # body = mọi dòng sau dòng '---' thứ 2 (đóng frontmatter), rồi sha256
  awk 'NR==1&&/^---$/{fm=1;next} fm&&/^---$/{fm=0;b=1;next} b' doc.md | shasum -a 256 | cut -d' ' -f1
  ```
  Tương đương: `git hash-object --stdin` trên body. Điểm cốt: **deterministic + tool-computed**.

### `from_hash` (map)
- id → hash hiện tại của **mọi** nguồn upstream mà doc này distill ra, snapshot tại lúc freeze.
- Là **map** (không phải 1 giá trị) → xử lý cascade **bắc cầu + đa nguồn** (xem `hash-cascade`).
- `PRINCIPLES` nằm trong `from_hash` của **MỌI** derived doc (rule 10) → nó là **root hash-graph**.

### `version`
- Chỉ REQUIREMENTS (và doc versioned) dùng. Bump ở mọi lần REQUIREMENTS re-freeze (xem `hash-cascade`). Doc khác: bỏ qua field này.

## Freeze operation (6 bước)

Chạy khi phase skill kết một artifact:

1. **Completeness-check pass** (gate rule 4): (a) đủ section cấu trúc **VÀ** (b) khớp `PRINCIPLES.md`. Chưa đạt → **KHÔNG mời freeze**.
2. **Người confirm** "freeze?" — không auto-freeze.
3. **Compute `hash`** = sha256(body) **bằng tool** (§ `hash` — tách body sau frontmatter rồi `shasum -a 256` / `git hash-object`). KHÔNG tự bịa hash.
4. **Snapshot `from_hash`** = map hash hiện tại của mọi upstream (đọc frontmatter `hash` của từng upstream).
5. **Ghi frontmatter** vào doc (`frozen: true`, `hash`, `from_hash`, `version` nếu áp dụng).
6. **Update lock**: `docs[<id>].status = active`; advance `phase` (nếu là phase skill).

## Gate cross-check (mọi command TRƯỚC khi hành động)

Đọc `PIPELINE.lock`. Với **mỗi doc phải-frozen** ở phase hiện tại:

| Kiểm | Câu hỏi | Fail ⇒ |
| --- | --- | --- |
| (a) tồn tại | file `docs[].path` có không? | thiếu doc → chặn, báo |
| (b) frozen | frontmatter `frozen: true`? | chưa freeze → chặn |
| (c) integrity | recompute `sha256(body)` **bằng tool, cùng byte-range** == frontmatter `hash`? | body bị sửa ngoài luồng → cảnh báo tamper |
| (d) upstream valid | mỗi `from_hash[U]` == `hash` hiện tại của `U`? | **STALE** (upstream đổi → xem `hash-cascade`) |

- **(d) fail = STALE** — không tự sửa; route theo `hash-cascade` (re-gate / reviewed-valid / defer).
- Cross-check này là lý do state không cần "block chữ": mọi thứ suy-ra-được từ hash + lock.

## Manifest cross-check ADR (M2 — bắt buộc từ khi grill chạy inline)

Cùng lúc gate cross-check trên, **mọi command trước khi hành động** verify `decisions/` bất biến:

- Với mỗi `id` trong `adr_manifest` (`PIPELINE.lock`): recompute `sha256(body ADR)` **bằng tool** == giá trị đã lưu?
- Lệch ⇒ một ADR cũ bị sửa lén (vi phạm append-only) → **chặn + báo**. Chỉ được **append id MỚI**, không đổi id cũ.
- Đây là backstop chính cho `decisions/` khi grill chạy **inline** (không còn tool-sandbox) — xem `elicitation-contract` § safety net.

## Ghi chú

- Freeze doc = ghi frontmatter + update lock; **không** đụng doc khác.
- Chỉ `/reconcile` **hoặc** `/pivot` được **mở** (unfreeze/sửa) một frozen doc (invariant 3).
- `grill-with-docs` không bao giờ tự freeze/ghi frontmatter — nó chỉ đề-xuất text; phase skill cha thực thi freeze.
