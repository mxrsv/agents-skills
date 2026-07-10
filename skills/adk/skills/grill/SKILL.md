---
name: grill
description: Grill the user relentlessly about a plan or design. Use when the user wants to stress-test a plan before building, or uses any 'grill' trigger phrases.
---

## Cơ chế BẮT BUỘC khi gọi từ adk (v2)

Khi một skill trong package `adk` (đặc biệt `adk:grill-docs`) cần chạy grill, nó **PHẢI spawn skill này như một subagent riêng** — fresh context (không kế thừa lịch sử hội thoại của caller), read-only tools, chỉ trả text. Xem `../../references/elicitation-contract.md`. **Lý do:** chạy inline (cùng context với caller) làm grill "biết" caller muốn nghe gì → mất epistemic independence, giảm sức bẻ. Subagent nhận nguyên văn doc/nháp cần challenge + chỉ thị "tìm cách BẺ, không tìm cách khen" (nội dung dưới đây là prompt cho subagent đó).

---

Interview me relentlessly about every aspect of this plan until we reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one. For each question, provide your recommended answer.

Ask the questions one at a time, waiting for feedback on each question before continuing. Asking multiple questions at once is bewildering.

Phrase every question in terms of real-world consequences first — what the user or project experiences if the decision goes one way or the other. Lead with the scenario in plain language ("if X fails mid-flow, the user sees Y — is that acceptable?"), then put technical details (file paths, function names, framework mechanics) after, as supporting evidence in parentheses. Never lead with implementation jargon; the person answering holds the intent, not the codebase.

If a question can be answered by exploring the codebase, explore the codebase instead.

Do not enact the plan until I confirm we have reached a shared understanding.
