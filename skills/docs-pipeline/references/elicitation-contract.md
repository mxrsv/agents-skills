# Reference — `elicitation-contract`

Hợp đồng gọi 2 engine elicitation (`interview-me` + `grill-with-docs`) từ các phase skill. Enforce **bằng cấu trúc, không bằng lời dặn**. Dùng chung bởi cả 8 skill.

> **Nguyên tắc:** `interview-me` lấp **KHOẢNG TRỐNG** (đầu, chưa có gì) · `grill-with-docs` vắt **VẬT LIỆU** (sau, đã có frozen doc).
>
> **`brainstorming` ĐÃ BỎ** (thủ phạm hijack→writing-plans + double-gate + orphan-doc). Chỉ giữ kỹ thuật *"propose 2-3 approaches"* nhét **inline** vào `/product` + `/architecture`. KHÔNG kéo cả skill brainstorming.

## Enforce bằng CẤU TRÚC

### `grill-with-docs` = subagent chỉ ĐỀ XUẤT
- Spawn subagent **KHÔNG cấp tool `Write`/`Edit`** (tool-scope, nit review-3 #3) → nó **buộc** trả edit dạng **text**.
- **Phase-skill cha là bên DUY NHẤT thực ghi file.** → grill **không thể** tự tay chạm `PIPELINE.lock` / `decisions/` / frozen doc.
- Suppression-bằng-instruction đơn thuần là mềm (model phải "nghe lời"); tool-scope là cứng.

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

1. Spawn `grill-with-docs` như subagent **không Write/Edit** → nhận text đề-xuất.
2. Phase skill đọc đề-xuất → tự quyết ghi gì vào `CONTEXT.md` (living).
3. Gọi `interview-me` → nhận confirmed intent (không save orphan) → distill.
4. Không engine nào chạm `PIPELINE.lock` / `decisions/` / frozen doc — chỉ phase skill.
