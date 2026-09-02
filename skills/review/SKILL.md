---
name: review
description: Review a spec or a plan before implementation starts — completeness, ambiguity, feasibility, executable steps, missing dependencies. For reviewing the project itself (code, UX, architecture, deps, docs) use the /review-change, /review-experience, /review-health and /review-release commands instead.
---

# Review (specs and plans)

> **Harness note.** Skill names are written `/name` (Claude Code slash form); in Codex invoke the same skill as `$name`. Sub-agent dispatch is shown as Claude Code's `Agent({ subagent_type: "general-purpose", … })` — in Codex spawn a sub-agent with the same prompt, or apply the contracts inline, in sequence, when sub-agents are unavailable.

This skill reviews **artifacts you are about to build from** — a spec or a plan.

**It does not review the project.** Code, UX, runtime, tests, security, dependencies and docs drift are covered by the review framework commands:

| Command | Reviews |
| --- | --- |
| `/review-change` | correctness, tests, security of a change |
| `/review-experience` | real user flow in a browser |
| `/review-health` | architecture, dependencies, docs/contracts |
| `/review-release` | synthesis of the above into a ship decision |

## Dispatch, don't self-review

Send the artifact to a subagent so the review is not anchored by whoever wrote it.

```
Agent tool:
  subagent_type: "general-purpose"
  name: "review-<spec|plan>"
  prompt: |
    OBJECTIVE: {what this spec/plan is for, 1-2 sentences}
    UPSTREAM CONTEXT: {approved spec, or "no spec attached — skip scope check"}
    ITERATION: {X}/3
    {if iteration > 1: PREVIOUS FINDINGS: {fixed / outstanding}}

    ARTIFACT:
    {full text}

    Review criteria: {inline the contents of rules/review-criteria.md}
```

Do NOT paste codebase contents — the subagent can read and search the codebase and should look for itself.

## Lens

- **spec** — completeness, ambiguity, feasibility, edge cases, success criteria
- **plan** — ordering, executable steps, verification path, missing files or dependencies, whether each phase ends in something runnable

## Verdict handling

- **EXECUTABLE: Yes** → present the report. Done.
- **EXECUTABLE: Partial** → present the report. The user decides whether to proceed.
- **EXECUTABLE: No** → fix HIGH/CRITICAL in the artifact, re-dispatch. Max 3 iterations.
- **3 iterations exhausted** → stop and escalate to the user.

## Rules

- Report findings before proposing fixes; order by severity; include file references.
- No findings → say so explicitly and name the residual risk.
- Do not self-congratulate or bury findings under a summary.
- Do not fix while in review mode unless asked.

Criteria detail: [rules/review-criteria.md](rules/review-criteria.md)
