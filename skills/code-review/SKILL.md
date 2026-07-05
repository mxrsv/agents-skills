---
name: code-review
description: Dispatch code-reviewer agent for findings-first code review. Use after implementation, before shipping. Verdict: APPROVE/WARNING/BLOCK.
agent: code-reviewer
---

# Code Review

Dispatch `code-reviewer` agent. Do not self-review.

## 1. Prepare payload

- **OBJECTIVE** — what this code implements (1-2 sentences)
- **SPEC/REQUIREMENTS** — approved spec or user's original request
- **WORKING DIRECTORY** — absolute path to project root
- **CHANGED FILES** — file paths only, NOT contents
- **ITERATION** — X/3 (default 1/3)
- **PREVIOUS FINDINGS** — if iteration >1, fixed/outstanding summary

## 2. Dispatch

```
Agent tool:
  subagent_type: "code-reviewer"
  prompt: |
    OBJECTIVE: {objective}
    SPEC/REQUIREMENTS: {spec or user request}
    WORKING DIRECTORY: {project root}
    CHANGED FILES: {file paths list}
    ITERATION: {X}/3
    {if iteration > 1: PREVIOUS FINDINGS: {previous_findings}}

    Review this code. Follow your review process.
```

Do NOT paste file contents — agent has Read/Grep/Glob/Bash.

## 3. Handle verdict

- **APPROVE** → present report. Done.
- **WARNING** → present report. User decides to merge or fix.
- **BLOCK** → fix approved issues → re-dispatch (max 3 iterations)
- **3 iterations exhausted** → escalate to human
