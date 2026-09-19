---
name: hand-off
description: Compact the current conversation into a handoff document for another agent to pick up.
argument-hint: "What will the next session be used for?"
---

Summarize the current state so a fresh agent can continue. If the task has a plan, update its Handoff section in place (D4/W14); do not create a second document. Otherwise return the handoff in chat, and create a scratchpad handoff file only when the user asks for a portable file. No external tracker is required. Include the checkout/branch/PR if any, scope and decisions, observed verification, uncommitted work, active processes, blockers and the next action.

Include a "suggested skills" section in the document, which suggests skills that the agent should invoke.

Do not duplicate content already captured in other artifacts (plans, living docs, commits, diffs). Reference them by path or URL instead.

Redact any sensitive information, such as API keys, passwords, or personally identifiable information.

If the user passed arguments, treat them as a description of what the next session will focus on and tailor the doc accordingly.
