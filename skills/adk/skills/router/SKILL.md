---
name: router
description: New v2 GPS skill for the adk ADR-first pipeline. Reads real state (PIPELINE.lock, docs/decisions/ active set, derived doc frontmatter, CONTEXT.md), classifies the user's free-form question or situation, and proposes the next adk command plus its reasoning — never invokes it, never writes anything. Read-only absolute. Fires ONLY when the user types /adk:router.
when_to_use: The user isn't sure which adk command to run next, what phase/state the pipeline is in, whether something is a local gap vs a wrong premise, or whether a doc is out of sync vs just has a broken view. Trigger only on explicit /adk:router. Never fires implicitly alongside other adk skills.
argument-hint: "[câu hỏi/tình huống tự do]"
arguments: question
---

# /adk:router `[câu hỏi/tình huống tự do]` — anytime (skill MỚI v2, GPS không phải tài xế)

**Vấn đề:** nhiều skill (`kickoff`/`product`/`architecture`/`requirements`/`adr`/`docs-check`/`pivot`/`agent-rules` + vệ tinh `interview`/`brainstorm`/`grill`/`grill-docs`), người dùng không luôn nhớ đang ở đâu trong vòng đời hoặc lệnh nào nên gõ tiếp. `adk:router` là MỘT cửa vào hỏi-gì-cũng-được, nhưng **chỉ trả lời + đề xuất — không bao giờ tự làm**.

## Nguyên tắc thiết kế — GPS, không phải tài xế

Router đọc bản đồ và chỉ đường. Router **không cầm lái**: không invoke skill đích, không ghi file, không tự quyết ngã rẽ ngữ nghĩa thay user. Người đọc lý do rồi **tự gõ lệnh** — người là router cuối.

## Trigger

- `/adk:router [câu hỏi/tình huống tự do]`, anytime, phase-independent. `description` chặt — router và các skill pipeline khác chỉ fire khi user gõ tường minh (không tự đề xuất chạy router thay user).
- `adk:brainstorm` là workflow độc lập giữ semantics gốc Superpowers, **không nằm trong phạm vi router** (SPEC v2 §14.1).

## Input đọc (state THẬT, không đoán từ câu chữ)

- `PIPELINE.lock` — `phase`, `project_type`, `docs[]`. Kiểm `lock_version == 2` trước; gặp v1/lạ → báo thẳng, không đoán tiếp.
- `docs/decisions/` — quét toàn bộ để có active set (`adr-protocol` §3).
- Frontmatter từng doc dẫn xuất đang tồn tại (`derived_from`).
- `CONTEXT.md` nếu cần thêm ngữ cảnh diễn đạt.

## Process

1. **Đọc state** → xác định vị trí vòng đời: đang bootstrap (phase nào) hay đã `done` (vòng đời lặp: adr/docs-check/pivot).
2. **Phân loại ý định** user vào đúng 1 trong các nhánh:
   - **status** — "đang ở đâu / còn thiếu gì" → trả về phase hiện tại + danh sách doc tồn tại + doc nào LỆCH (dùng thuật toán `render-protocol` §3, ở mức BÁO CÁO, không render).
   - **quyết định mới** — user vừa chốt điều gì đó chưa có ADR → đề xuất `/adk:adr <title>`.
   - **gap cục bộ** — thiếu 1 quyết định, framing vẫn đúng → đề xuất `/adk:adr` (bổ sung) rồi render lại doc liên quan.
   - **tiền đề sai** — một quyết định trước giờ hoá ra sai gốc, kéo theo nhiều cái khác → đề xuất `/adk:pivot`.
   - **decision-set lệch** — nghi ngờ doc không khớp ADR active → đề xuất `/adk:docs-check [DOC]`.
   - **view-body bị hỏng** — quyết định vẫn đúng nhưng file render trông sai/hỏng format → đề xuất `/adk:docs-check <DOC> --force`, **không** tạo ADR giả cho lỗi trình bày.
   - **bootstrap tiếp** — chưa `done`, còn phase chưa qua → đề xuất đúng lệnh phase kế (`/adk:kickoff|product|architecture|requirements`).
   - **ngoài phạm vi adk** — câu hỏi không liên quan pipeline/ADR → nói rõ ngoài phạm vi, không ép trả lời.
3. **Mơ hồ giữa 2 nhánh** → hỏi lại **đúng 1 câu** để phân biệt (không đoán, không hỏi nhiều câu một lúc).
4. **Trả về:** vị trí hiện tại (ngắn) + lệnh đề xuất (nguyên văn, copy-paste được) + lý do ngắn (1–3 câu, trỏ tới id ADR/doc cụ thể nếu có).

## Quan hệ với `docs-check`

Router dùng **chung thuật toán so-tập-hợp** (`render-protocol` §3) ở mức **báo cáo trong status** — không tự render. Muốn xử lý lệch → router đề xuất user gõ `/adk:docs-check`, không tự chạy nó.

## CẤM cứng

- **KHÔNG invoke skill đích** — không gọi Skill tool cho lệnh vừa đề xuất, dù chỉ để "xem thử".
- **KHÔNG ghi bất kỳ file nào** — read-only tuyệt đối, không đụng `PIPELINE.lock`, `docs/decisions/`, doc dẫn xuất, `CONTEXT.md`.
- **KHÔNG tự quyết ngã rẽ ngữ nghĩa thay user** khi mơ hồ — hỏi lại, không đoán rồi hành động.

## Không nằm trong phạm vi

Hash-graph (không tồn tại ở v2) · `elicitation-contract` (router không gọi `adk:grill`/`adk:interview`) · lock side-effect (router không có side-effect nào, bất kỳ đường nào).
