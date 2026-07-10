# Reference — `elicitation-contract` (v2)

Hợp đồng gọi elicitation từ phase skill + `adk:adr` + `adk:pivot`. **Đổi cơ chế so với v1:** `adk:grill` giờ **bắt buộc spawn subagent** fresh-context (khôi phục epistemic independence), thay vì chạy inline như v1 (an toàn ghi không còn là lý do để bỏ subagent — ba lớp quyền ghi v2 dựa vào hook + git diff, không dựa vào việc grill có sandbox hay không).

> **Nguyên tắc giữ nguyên từ v1:** `adk:interview` lấp **KHOẢNG TRỐNG** (đầu, chưa có gì) · `adk:grill-docs` vắt **VẬT LIỆU** (sau, đã có ADR/doc dẫn xuất để challenge). `adk:brainstorm` là **ngoại lệ tường minh** đứng ngoài pipeline, giữ semantics gốc Superpowers (`design → spec → writing-plans`) — không dùng trong elicitation-contract này (SPEC v2 §14.1).

## `adk:grill` — BẮT BUỘC spawn subagent

- **Lý do đổi:** v1 chạy grill inline vì lo ngại subagent phải Write được thì mới "chốt" được gì — nhưng thực ra subagent grill chưa bao giờ cần ghi, nó chỉ cần **phản biện độc lập**. Chạy inline (cùng context với phase skill) làm grill mất epistemic independence — nó "biết" phase skill đang muốn nghe gì, giảm sức bẻ.
- **Cách gọi:** phase skill / `adk:grill-docs` spawn subagent (loại `explore` hoặc `generalPurpose`, **read-only tools**, fresh context — không kế thừa lịch sử hội thoại cha) chạy nội dung `adk:grill/SKILL.md` trên doc/nháp cần thử lửa. Subagent **chỉ trả text** — không có quyền Write/Edit trong invocation này.
- **Không mâu thuẫn với "hook không phải sandbox tuyệt đối" (§8 SPEC):** đây là hai lớp độc lập — subagent read-only là **cấu trúc cứng** (agent framework enforce, không phải instruction), hook trên `docs/decisions/` là **best-effort bổ sung** cho trường hợp ai đó (kể cả con người) ghi qua đường khác.

## `adk:grill-docs` — wrapper, CẤM ghi ADR

- Chạy `adk:grill` (subagent, xem trên) trên doc/nháp cần challenge → nhận text đề xuất + hướng-đã-loại + lý do loại.
- **Parent (phase skill / caller) là bên ghi DUY NHẤT** — nhận text từ `adk:grill-docs`, tự quyết ghi kết luận/hướng-đã-loại vào `CONTEXT.md` (living, prose).
- **CẤM tuyệt đối** `adk:grill-docs` tự ghi `docs/decisions/`, `PIPELINE.lock`, hoặc bất kỳ doc dẫn xuất nào. Phát hiện một quyết định đáng ghi đã kết tinh trong lúc grill → **nhắc user gõ `/adk:adr`**, không tự tạo ADR thay user.

## `adk:interview`

- Output = **confirmed intent trả về** caller (phase skill / `/adk:adr` / `/adk:agent-rules`) để distill. Không tự lưu, không tự route downstream (xem `interview/SKILL.md` § Interaction with Other Skills).
- Không có "save to `docs/intent/`" — tránh đẻ orphan doc. Caller quyết intent đi đâu.

## Phase skill / `adk:adr` / `adk:pivot` (KHÔNG phải engine) SỞ HỮU ghi

- Ghi ADR (qua đường append hook-compliant) · render doc dẫn xuất (qua `render-protocol`) · update `PIPELINE.lock` (chỉ bootstrap advance-phase).
- Engine elicitation (`adk:grill`, `adk:grill-docs`, `adk:interview`) chỉ trả **text**. Không engine nào ghi `docs/decisions/`, doc dẫn xuất, hay lock.

## Cường độ theo phase (giữ nguyên bảng v1, đổi cơ chế chạy)

| Phase                   | Cường độ                       | Engine chính                                   | Bản chất                             |
| ----------------------- | ------------------------------ | ---------------------------------------------- | ------------------------------------ |
| `/adk:kickoff` (0)      | 🟢 nhẹ                         | `adk:interview` _nhẹ_ + grill (capture)        | thu brief + research                 |
| `/adk:product` (1)      | 🔴 **nặng nhất**               | **`adk:interview`** + `adk:grill-docs` nháp    | MOI intent — "hỏi liên tục"          |
| `/adk:architecture` (2) | 🟠 vừa–cao                     | **`adk:grill-docs`** + "2-3 approaches" inline | THÁCH THỨC phương án trên nền có sẵn |
| `/adk:requirements` (3) | 🟡 thấp tương tác / cao verify | **`adk:grill-docs`** soi gap/consistency       | DISTILL + cross-check; gap → DỪNG    |
| `/adk:adr`              | —                              | `adk:interview` nhẹ + sanity-check máy móc     | soạn nháp quyết định                 |
| `/adk:pivot`            | —                              | thừa hưởng mode phase đích                     | —                                    |
| `/adk:agent-rules`      | —                              | `adk:interview` nhẹ                            | —                                    |

**Wiring cứng (không để model "tự nhớ"):** `adk:product` + `adk:architecture` SKILL.md phải chứa chỉ thị nguyên văn _"TRƯỚC khi trình chùm ADR để chốt: invoke skill `adk:grill-docs` qua Skill tool trên bản nháp"_. `adk:kickoff`/`adk:requirements` dùng grill-docs ở mode nhẹ/soi-gap tương ứng bảng trên.

## `adk:grill-docs` inert khi chưa có ≥1 ADR active liên quan

Grill bản chất "challenge against existing model" → inert lúc kickoff / đầu product (chủ yếu capture, chưa có gì để bẻ). Sức challenge scale theo số ADR active đã tích luỹ — càng nhiều quyết định đã chốt, grill càng có vật liệu để tìm mâu thuẫn.

## Checklist mỗi lần một phase skill / `adk:adr` gọi engine

1. Cần challenge → gọi `adk:grill-docs` (which spawns `adk:grill` subagent, xem trên) → nhận text đề xuất + hướng-đã-loại.
2. Caller đọc đề xuất → tự quyết ghi gì vào `CONTEXT.md`.
3. Cần lấp khoảng trống intent → gọi `adk:interview` → nhận confirmed intent (không orphan doc) → distill vào nháp ADR / doc.
4. Không engine nào chạm `PIPELINE.lock` / `docs/decisions/` / doc dẫn xuất — chỉ phase skill / `adk:adr` / `adk:pivot` ghi, và chỉ sau gate DỪNG THẬT (SPEC §8.2).
