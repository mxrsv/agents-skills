---
name: planning
description: Turn clear requirements into one repo task plan containing scope, decisions, implementation, verification and handoff. Use for multi-session or multi-commit work, or an explicit plan request. Use brainstorm first if the outcome is unclear.
argument-hint: "[task description or plan path]"
---

# Planning

## One task file

The conversation supplies goals and approvals. When a plan is needed under W2, use one file at `docs/plans/YYYY-MM-DD-<slug>.md`; requirements, execution, progress and handoff share that file. No tracker, issue key, claim or remote update is required. Small, clear work proceeds directly unless the user requests a plan.

Run inline. This skill does not itself dispatch a subagent.

## Workflow

1. **Read context.** Read the user's request, relevant decisions, repo instructions and any supplied plan. Inspect the checkout/branch and affected code. Search for an existing task plan before creating one, including older names; reuse its path across sessions and PRs. Resolve conflicting or missing requirements in chat only when they materially change the outcome.
2. **Prepare one record.** Use the template below, proportional to the task. If brainstorm already wrote requirements, add implementation detail to that same file. Check ignore rules so the plan can be versioned. Keep relevant research and rejected alternatives with reasons, not raw logs or transcripts. Never invent requirements or verification evidence.
3. **Verify the plan.** Re-read the file and affected code. Map acceptance criteria and failure modes to tasks and concrete checks. Check existing paths, symbols, ordering and dependencies; mark proposed files as new. State unresolved decisions and which tasks they block. Run an independent review only when requested or required by an applicable workflow.
4. **Present the concrete approach.** Show the path, approach and material tradeoffs. Wait only for approval not already given; a previously approved approach does not need approval again because it was saved. Plan approval covers its commit and routine in-scope updates (D14). It does not authorize merge, deploy or release.
5. **Execute when authorized.** Update task checkboxes, actual verification and the latest handoff in the same file. Material scope, approach or risk changes return to the user; routine choices remain yours. Do not create another spec, checklist, issue or progress document.

## Template

Body and headings are English (D4), independent of Output Style. The date is the task's start date, not a new filename for each session.

```markdown
# <Task title>

Record: Active task plan
Base revision: <commit used for the code survey>

## Goal and scope

<Goal, included work, explicit exclusions and relevant constraints.>

## Decisions and acceptance criteria

<Decisions approved in conversation; concrete, verifiable acceptance criteria. Distinguish open decisions.>

## Approach

<Technical approach, relevant research, alternatives and reasons where useful.>

## Tasks

- [ ] **Task 1: <name>**
  - Files: <existing paths; mark new files explicitly>
  - Depends on: <only real dependencies>
  - Build: <specific actions>
  - Verify: `<command>` → <expected result>; <criterion covered>

## Verification evidence

<Observed commands/results and unrun gates, added during execution.>

## Handoff

<Latest progress; checkout/branch/PR if any; remaining work; blockers and next action.>
```

Omit empty optional sections until needed. Add material risks and unresolved decisions where they affect the work; do not hide them in a vague task. No full implementation code, "test it works", "add appropriate validation" or invented output. Split unrelated concerns into independently verifiable tasks, not arbitrary file counts.

## Resume and completion

- Read the plan and latest conversation decisions, then check the actual code and git state before resuming. A checked box does not establish current verification. Coordinate overlapping edits and preserve other work; no external claim protocol.
- Keep one checklist across multiple PRs. For cross-repo tasks, name each checkout in the owning plan; do not duplicate progress across repos unless the user requests separate plans.
- Rewrite the latest handoff in place. Include evidence, uncommitted work and any ongoing process the next agent needs to know about. Do not append daily journals.
- Only after acceptance criteria and required approvals are met (W14), set `Record: Historical — not current behavior`, add the completion date and relevant implementation commits/PR links when available, and retain the file. A merge alone is not completion. If acceptance happens after merge, record the historical marker in a subsequent authorized commit.
- Extract durable constraints, decisions and traps into living docs (D9/D14). Historical plans are excluded from current-code drift maintenance; new follow-up work gets its own task instead of rewriting past intent.
