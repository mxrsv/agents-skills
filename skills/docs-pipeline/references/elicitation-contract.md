# Reference — `elicitation-contract`

Hợp đồng gọi 2 engine elicitation (`interview-me` + `grill-with-docs`) từ các phase skill. Enforce **bằng cấu trúc, không bằng lời dặn**. Dùng chung bởi cả 8 skill.

> **Nguyên tắc:** `interview-me` lấp **KHOẢNG TRỐNG** (đầu, chưa có gì) · `grill-with-docs` vắt **VẬT LIỆU** (sau, đã có frozen doc).
>
> **`brainstorming` ĐÃ BỎ** (thủ phạm hijack→writing-plans + double-gate + orphan-doc). Chỉ giữ kỹ thuật *"propose 2-3 approaches"* nhét **inline** vào `/product` + `/architecture`. KHÔNG kéo cả skill brainstorming.

## Enforce grill — INLINE propose-only

### `grill-with-docs` = chạy INLINE, chỉ ĐỀ XUẤT
- Grill chạy **trong chính phase skill** (KHÔNG spawn subagent). Chỉ thị cứng: **chỉ trả text đề-xuất; TUYỆT ĐỐI không tự ghi `PIPELINE.lock` / `decisions/` / frozen doc**.
- **Phase-skill là bên DUY NHẤT thực ghi file** — đọc đề-xuất grill → tự quyết ghi gì vào `CONTEXT.md`.
- **Nới NEW-1 có ý thức (2026-07-09):** bỏ tool-sandbox (subagent không Write/Edit) → suppression hạ từ *cấu trúc-cứng* xuống *instruction-mềm*. Đổi lấy đơn giản cho workflow solo (người review mọi lần freeze).
- **Safety net thay sandbox (CRITICAL):** grill giờ *về mặt tool* ghi bậy được → hàng rào thật chuyển sang **hash cross-check (`freeze-protocol` § gate, kiểm (c) integrity) + ADR manifest cross-check (dưới)**. Chúng PHÁT HIỆN sửa lén frozen doc / ADR *sau khi* xảy ra. → grill-inline chỉ an toàn KHI hai cái đó **chạy thật** (hash bằng tool, manifest-check ở gate).

### `interview-me`
- Output = confirmed intent **trả về** phase skill để distill.
- **TẮT** cú optional "save to `docs/intent/`" → khỏi đẻ orphan doc. Phase skill quyết intent đi đâu (→ `CONTEXT.md` → distill vào frozen).

### Backstop ADR immutability
State có hash cross-check bắt tamper; ADR thì không tự nhiên có. Dùng `adr_manifest` trong `PIPELINE.lock`:
- `/adr` append → ghi `adr_manifest[NNNN] = sha256(body)`.
- Gate/CI check: **không id ADR cũ nào đổi hash** (chỉ được append id mới). Bắt trường hợp ai/grill sửa inline một ADR cũ.

### Phase skill (KHÔNG phải engine) SỞ HỮU
- ghi frozen artifact · freeze gate · update `PIPELINE.lock` · stamp hash.
- Engine chỉ trả **text**. Không engine nào vi phạm freeze / three-write-layers.

## Cường độ theo phase

| Phase | Cường độ | Engine chính | Bản chất |
| --- | --- | --- | --- |
| `/kickoff` (0) | 🟢 nhẹ | `interview-me` *nhẹ* + grill (capture) | thu brief + research |
| `/product` (1) | 🔴 **nặng nhất** | **`interview-me`** + grill nháp | MOI intent — "hỏi liên tục" |
| `/architecture` (2) | 🟠 vừa–cao | **`grill-with-docs`** + "2-3 approaches" inline | THÁCH THỨC phương án trên nền frozen |
| `/requirements` (3) | 🟡 thấp tương tác / cao verify | **`grill-with-docs`** soi gap/consistency | DISTILL + cross-check; gap → DỪNG |
| `/reconcile` | — | grill nhắm đúng gap | — |
| `/pivot` | — | thừa hưởng mode phase đích | — |
| `/adr`, `/agent-rules` | — | `interview-me` nhẹ | — |

## `grill-with-docs` inert khi chưa có ≥1 frozen doc

grill bản chất "challenge against existing model" → **inert** lúc kickoff / đầu product (chủ yếu capture). Sức challenge **scale theo vật liệu frozen** — càng nhiều frozen doc, grill càng sắc (fix 5.3).

## Checklist mỗi lần một phase skill gọi engine

1. Chạy `grill-with-docs` **inline** (không subagent) với chỉ thị propose-only → nhận text đề-xuất.
2. Phase skill đọc đề-xuất → tự quyết ghi gì vào `CONTEXT.md` (living).
3. Gọi `interview-me` → nhận confirmed intent (không save orphan) → distill.
4. Không engine nào chạm `PIPELINE.lock` / `decisions/` / frozen doc — chỉ phase skill.
