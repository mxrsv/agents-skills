---
name: agent-rules
description: Standalone skill beside the adk ADR-first pipeline (NOT part of the bootstrap sequence). Generate ONE agent code-rules file (CLAUDE.md / AGENTS.md style) at the repo root. Outside docs/, outside the ADR log, does not touch PIPELINE.lock or advance any phase. Fires ONLY when the user types /adk:agent-rules.
when_to_use: Any time you want an agent code-rules file for a repo. Phase-independent. Trigger only on explicit /adk:agent-rules. Does not participate in the ADR log or derived-doc rendering.
argument-hint: "[CLAUDE.md|AGENTS.md]"
arguments: filename
---

# /adk:agent-rules — đứng cạnh (skill luật-code-cho-agent)

**Mục đích:** sinh **1 file luật code cho agent** (kiểu `CLAUDE.md` / `AGENTS.md`), gọi **độc lập** — KHÔNG trong bootstrap tuyến tính, KHÔNG trong ADR log, KHÔNG là doc dẫn xuất.

Đọc trước: `../../references/elicitation-contract.md`.

## Trigger

- `/adk:agent-rules`, bất kỳ lúc nào, **không phụ thuộc phase**.

## Elicitation

- `adk:interview` **nhẹ** — thu convention/luật code user muốn agent tuân.

## Input đọc

`CONTEXT` + doc dẫn xuất nếu pipeline đã chạy (PRINCIPLES / ARCHITECTURE làm nền) + `adk:interview` nhẹ. Không bắt buộc pipeline tồn tại.

## Output ghi

- **1 file ở repo ROOT** (vd `AGENTS.md` / `CLAUDE.md`) — **NGOÀI** `docs/` pipeline.
- Nội dung: luật code / convention / lệnh build-test / ranh giới cho agent.

## Gate

— (không có ceremony riêng; nội dung do user duyệt qua đối thoại `adk:interview`).

## Side-effect `PIPELINE.lock`

**KHÔNG** — đứng cạnh: không đụng `PIPELINE.lock`, không advance phase, không ghi `docs/decisions/`, không render doc nào.
