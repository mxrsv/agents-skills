---
name: decision-traceability
description: Keep every decision the owner settled alive from the conversation through spec, build prompt and acceptance, and route risky features and flow-changing mocks through an outside review. Use when writing or committing a spec from owner decisions, writing a build prompt or a subagent brief, defining acceptance for "make it like X", or before asking the owner to look at a feature that changes data, auth, money, permissions or how a task is reached.
---

# Decision traceability

A decision the owner settled (in an intent interview, a grilling round or chat) must survive every handoff:
decision → spec → build prompt → acceptance.

## Before committing the spec

- The spec carries a traceability table (`## Decisions` in `~/.claude/templates/spec.template.md`): each row has the decision, quoted, then its requirement ID, then its acceptance check.
- A decision with no row is a defect.
- Check every Out-of-scope line against the decisions. A line that narrows a decision needs the owner's explicit yes.

## "Make it like X"

- When the goal is "make it like X" (a mock, a reference app), the acceptance compares the real result side by side with X, per surface: structure, content, look and theme.
- Proxies such as a debt count or green tests never stand in for that comparison.

## Before a build prompt or a subagent brief

- Re-read the decisions source, not your own summary.
- Show the owner the table before the build starts.

## Explicit instructions

- A command, skill, option or runtime the owner names is carried out as named, not swapped for a preferred alternative.
- A concern gets one line, then do it.

## Gaps and inferred lines

- Where the owner has not decided and the app already has a shared block or convention for it (a dialog, a row, a control), the build uses that. A mock or reference overrides it only when the owner says so.
- A spec sentence with no owner decision behind it goes in an "Inferred, not decided" list with its source (mock, app convention, agent's choice), never under a decision's ID.
- The inferred list does not block the build. Ask, in one batch, only the lines that touch data deletion, money or a hard-to-reverse contract; the rest follow the recommendation.

## Outside review gates

- A feature that changes or deletes user data, handles auth or money, runs external commands or parallel work, touches a system permission, or changes how a task is reached passes skill `build-review` before the owner is asked to look.
- A mock that changes an existing task flow passes skill `mock-review` before it becomes requirements.
- The owner can waive either review for a task.
