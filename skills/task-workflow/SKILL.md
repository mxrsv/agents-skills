---
name: task-workflow
description: Pick the workflow that fits the size of a task — small, single session, multi-session, idea work, unattended run or review — and the effort level, following the Claude Code best-practices page. Use at the start of a task when it is unclear how much process it needs, before starting an unattended or scheduled run, or when setting up a review of finished work.
---

# Workflow by task size

Each row follows a section of the Claude Code best-practices page; the link is the source.

## Small task

- Do it, run the pass/fail check, and report with the check's output.
- Source: [Give Claude a check to run](https://code.claude.com/docs/en/best-practices#give-claude-a-check-to-run).

## Single session

- Use plan mode; no plan file.
- Run `/clear` between unrelated tasks, and after two failed corrections clear and write a better prompt instead of a third correction.
- Source: [Steer the session](https://code.claude.com/docs/en/best-practices#steer-the-session), [Keep cost and context down](https://code.claude.com/docs/en/best-practices#keep-cost-and-context-down).

## Multi-session

- Write the spec in `docs/specs/` with a `## Status` updated at each handoff, and end it with a `/goal` line built from the acceptance criteria. No plan file.
- Source: [Give Claude a check to run](https://code.claude.com/docs/en/best-practices#give-claude-a-check-to-run) (`/goal`), [Brainstorm with Claude first](https://code.claude.com/docs/en/best-practices#brainstorm-with-claude-first).

## Idea work

- Have Claude interview you until it could write a spec, then build from that spec in a fresh session.
- Use `/effort low` while brainstorming.
- Source: [Brainstorm with Claude first](https://code.claude.com/docs/en/best-practices#brainstorm-with-claude-first), [Change the model and effort](https://code.claude.com/docs/en/best-practices#change-the-model-and-effort).

## Unattended run

- Before starting, answer five questions: what done looks like, how Claude checks itself, what is in scope, the cap (`--max-turns` or `--max-budget-usd`), and which human approves the result.
- Source: [Let Claude run without you](https://code.claude.com/docs/en/best-practices#let-claude-run-without-you).

## Review

- A fresh subagent reviews the diff against the spec and reports only correctness gaps: tell it "skip style".
- Source: [Review against your spec](https://code.claude.com/docs/en/best-practices#review-against-your-spec).

## Effort

- `/effort high` or `/effort xhigh` for subtle bugs; `/effort low` for quick back-and-forth.
- `max` only for hard problems Claude works through without you; it overthinks ordinary tasks.
- Source: [Change the model and effort](https://code.claude.com/docs/en/best-practices#change-the-model-and-effort).
