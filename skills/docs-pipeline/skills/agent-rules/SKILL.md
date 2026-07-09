---
name: agent-rules
description: Standalone skill beside the docs-bootstrap pipeline (NOT part of the linear pipeline). Generate ONE agent code-rules file (CLAUDE.md / AGENTS.md style) at the repo root. Outside docs/, not in the hash-graph, does not touch PIPELINE.lock or advance any phase. Fires ONLY when the user types /agent-rules.
when_to_use: Any time you want an agent code-rules file for a repo. Phase-independent. Trigger only on explicit /agent-rules. Does not participate in freeze/hash-graph.
argument-hint: "[CLAUDE.md|AGENTS.md]"
arguments: filename
---

# /agent-rules — đứng cạnh (skill luật-code-cho-agent)

**Mục đích:** sinh **1 file luật code cho agent** (kiểu `CLAUDE.md` / `AGENTS.md`), gọi **độc lập** — KHÔNG trong pipeline tuyến tính, KHÔNG trong hash-graph.

Đọc trước: `../../references/elicitation-contract.md`.

## Trigger

- `/agent-rules`, bất kỳ lúc nào, **không phụ thuộc phase**.

## Elicitation

- `interview-me` **nhẹ** — thu convention/luật code user muốn agent tuân.

## Input đọc

`CONTEXT` + frozen docs nếu có (PRINCIPLES / ARCHITECTURE làm nền, khi pipeline đã chạy) + interview-me nhẹ. Không bắt buộc pipeline tồn tại.

## Output ghi

- **1 file ở repo ROOT** (vd `AGENTS.md` / `CLAUDE.md`) — **NGOÀI** `docs/` pipeline.
- Nội dung: luật code / convention / lệnh build-test / ranh giới cho agent.

## Gate

— (không freeze).

## Side-effect `PIPELINE.lock`

**KHÔNG** — đứng cạnh: không đụng `PIPELINE.lock`, không advance phase, không tham gia hash-graph.
