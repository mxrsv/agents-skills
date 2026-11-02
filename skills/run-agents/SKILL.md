---
name: run-agents
description: Delegate the owner's work to subagents with house defaults — split it into tasks, pick the model per job, run independent tasks in parallel, carry a whole plan through without stopping, review once at the end. Use when the owner asks, in any language, to run or hand work to subagents ("run các subagent", "chạy subagent", "gọi agent", "dùng subagent sonnet", "build song song", "làm song song các task"). Not for a review-only ask (use review-change, review-health or review-experience) and not for a Workflow script.
argument-hint: "[plan path | task] [model] [number of agents]"
---

# run-agents

The owner says "run các subagent"; this skill supplies what they would otherwise type after it.
Their words win: a named model, agent count or order overrides every default below.

## 1. Find the work

Take the tasks from the plan or spec they named, else the plan just agreed, else the conversation.
Add no brainstorm, spec or plan step. Ask one question only if the work has several readings with
materially different, hard-to-reverse outcomes, or if there is no work to split.

## 2. Pick the model

Always pass `model`: leaving it out inherits the main session's model.

| Job                                        | `model`  |
| ------------------------------------------ | -------- |
| Write code, fix, mock, docs, research scan | `sonnet` |
| Plan, spec, root-cause debug, a decision   | `opus`   |
| Review of a mock, video, copy              | `opus`   |

## 3. Split into waves

- **Same wave, same message:** tasks with no dependency and no shared file. At most 5 per wave
  unless the owner gives a number; the rest go in the next wave.
- **Later wave:** a task that needs another's result or edits the same file. No worktree unless the
  owner asks (`CLAUDE.md` `<branching>`).
- **Brief:** goal, files it owns, files it must not touch, the check to run. A subagent knows nothing
  else. It does not commit: parallel commits collide on the shared git index.

## 4. Build through

After each wave, in the same turn: run the repo's checks yourself (W4), commit verified work with
`git commit -- <paths>`, tick the plan, start the next wave. Waiting for agents is not a stop.

Stop only for:

- an irreversible or outward-facing action: push, merge, release, delete, publish;
- something only the owner can do, such as a login;
- a UI direction with no chosen mock: render the mocks, stop once, then build through;
- a material change to the approved scope or approach (D10);
- nothing left can proceed.

Anything else: take the recommended option, record it in the plan, report it at the end. Eye
approval comes once, after the last wave (`CLAUDE.md` `<frontend>`). A task that fails: retry once
with the error in the brief; still failing → mark it blocked, finish the rest, report it.

## 5. Review once, at the end

Review after the last wave, never per task, and only if code changed. Run `review-change`; fix its
confirmed high and medium findings in the work just built; report the rest.

A review ask goes to the skill that owns it: a change → `review-change`, the whole repo →
`review-health`, a running app → `review-experience`. Spawn reviewers directly only for what those
skip (a mock, a video) or when the owner names the agents or criteria.

## 6. Report

Use `<reply_format>`. In `Result`, one row per task: task, model, status. Then the decisions taken,
then what still waits for the owner: eye approval (open the main artifact, W18) and push.
