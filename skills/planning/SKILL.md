---
name: planning
description: Turn clear requirements into an implementation plan in docs/plans/, linking to docs/specs/ for requirements and acceptance criteria. Use for multi-session or multi-commit work, or an explicit plan request. Use brainstorm first if the outcome is unclear.
argument-hint: "[task description or plan path]"
---

# Planning

## One execution record, linked requirements

The conversation supplies goals and approvals. When a plan is needed under W2, use one file at `docs/plans/YYYY-MM-DD-<slug>.md` for technical approach, tasks, progress, verification and handoff. Requirements and acceptance criteria belong in the linked `docs/specs/` record when one exists; do not duplicate them in the plan. A plan can reference agreed conversation requirements when no spec is needed. No tracker, issue key, claim or remote update is required. Small, clear work proceeds directly unless the user requests a plan.

Run inline. This skill does not itself dispatch a subagent.

## Workflow

1. **Read context.** Read the user's request, relevant decisions, repo instructions and any supplied spec or plan. Inspect the checkout/branch and affected code. Search both `docs/specs/` and `docs/plans/` before creating a plan, including older names; reuse its path across sessions and PRs. Resolve conflicting or missing requirements in chat only when they materially change the outcome.
2. **Prepare the execution record.** Use the template below, proportional to the task. If brainstorm already wrote a spec, link to it and map tasks to its acceptance criteria; keep implementation detail in the separate plan. Check ignore rules so the plan can be versioned. Keep relevant research and rejected alternatives with reasons, not raw logs or transcripts. Never invent requirements or verification evidence.
3. **Verify the plan.** Re-read the file and affected code. Map acceptance criteria and failure modes to tasks and concrete checks. Check existing paths, symbols, ordering and dependencies; mark proposed files as new. State unresolved decisions and which tasks they block. Run an independent review only when requested or required by an applicable workflow.
4. **Present the concrete approach.** Show the path, approach and material tradeoffs. Wait only for approval not already given; a previously approved approach does not need approval again because it was saved (D10). Routine in-scope updates need no separate approval. Commit, merge, deploy and release follow the task's authorization.
5. **Execute when authorized.** Update task checkboxes, actual verification and the latest handoff in the same file. Material scope, approach or risk changes return to the user; routine choices remain yours. Update the owning spec if approved requirements change; do not create duplicate specs, checklists, issues or progress documents.

## Template

Body and headings are English (D4), independent of Output Style. The date is the task's start date, not a new filename for each session.

```markdown
# <Task title>

Record: Active task plan
Base revision: <commit used for the code survey>

## Requirements reference and delivery scope

<Relative link to the canonical spec and relevant acceptance-criteria headings/IDs; brief boundary of this delivery slice, not copied requirements. If no spec is needed, summarize the agreed conversation requirements and concrete acceptance checks here. Distinguish open decisions.>

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

/goal <ready-to-paste line built from the linked spec's acceptance criteria>
```

Omit empty optional sections until needed. Add material risks and unresolved decisions where they affect the work; do not hide them in a vague task. No full implementation code, "test it works", "add appropriate validation" or invented output. Split unrelated concerns into independently verifiable tasks, not arbitrary file counts.

## Resume and completion

- Read the linked spec, plan and latest conversation decisions, then check the actual code and git state before resuming. A checked box does not establish current verification. Coordinate overlapping edits and preserve other work; no external claim protocol.
- Keep one checklist across multiple PRs. For cross-repo tasks, name each checkout in the owning plan; do not duplicate progress across repos unless the user requests separate plans.
- Rewrite the latest handoff in place. Include evidence, uncommitted work and any ongoing process the next agent needs to know about. Do not append daily journals.
- Only after acceptance criteria and required approvals are met (W14), set `Record: Historical — not current behavior`, add the completion date as `YYYY-MM-DD` and relevant implementation commits/PR links when available, and retain the file. A merge alone is not completion. If acceptance happens after merge, record the historical marker in a subsequent authorized commit.
- Extract durable constraints, decisions and traps into living docs (D9). Historical plans are excluded from current-code drift maintenance; new follow-up work gets its own task instead of rewriting past intent.
