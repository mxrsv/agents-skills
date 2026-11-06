---
name: run-agents
description: Delegate the owner's work to subagents with house defaults — split it into tasks, pick the model per job, run independent tasks in parallel, carry a whole plan through without stopping, review once at the end. Use when the owner asks, in any language, to run or hand work to subagents ("run các subagent", "chạy subagent", "gọi agent", "dùng subagent sonnet", "chạy 5 agents review", "build song song", "làm song song các task"). Not for a plain review of a change, repo or running app with no ask for agents (use built-in /code-review), not when agents are only the product or topic being discussed, and not for a Workflow script.
argument-hint: "[plan path | task] [model] [number of agents]"
---

# run-agents

The owner says "run các subagent"; this skill supplies what they would otherwise type after it.
Their words win: a named model, agent count or order overrides every default below.

## 1. Find the work

Take the tasks from the plan or spec they named (read both when both exist), else the plan just
agreed, else the conversation. Do not redo a settled brainstorm, spec or plan. If one is still
required, W1, W2 and D10 decide; otherwise start. No work to split → ask one question.

## 2. Pick the model

Always pass `model`: leaving it out inherits the main session's model.

| Job                                        | `model`  |
| ------------------------------------------ | -------- |
| Write code, fix, mock, docs, research scan | `sonnet` |
| Plan, spec, root-cause debug, a decision   | `opus`   |
| Review of a mock, video, copy              | `opus`   |

## 3. Split into waves

Record `git rev-parse HEAD` as the baseline before the first wave; section 5 needs it.

- **Same wave, same message:** tasks with no dependency and no shared file. At most 5 per wave
  unless the owner gives a number; the rest go in the next wave.
- **Later wave:** a task that needs another's result or edits the same file. No worktree unless the
  owner asks or a PR needs one (`CLAUDE.md` `<branching>`).
- **Brief:** goal, files it owns, files it must not touch, the check to run. A subagent knows nothing
  else. It does not commit: parallel commits collide on the shared git index.

## 4. Build through

After each wave, in the same turn: run the repo's checks yourself (W4), read each task's diff, commit
only verified work with `git commit -- <paths>` (it takes the whole file, so nothing unverified may
sit in those paths), tick the plan, start the next wave. Waiting for agents is not a stop.

Stop only for:

- an irreversible or outward-facing action not already authorized, such as push, merge, release,
  publish or deleting the owner's data. A W17 track they approved counts; temp files you made do not;
- a W17 cut-over: removing a switch or an old surface needs their eye approval first;
- something only the owner can do, such as a login;
- a UI direction with no chosen mock: render the mocks, stop once, then build through;
- a material change to the approved scope or approach (D10);
- nothing left can proceed.

Anything else: take the recommended option, record it in the plan, report it at the end. Eye
approval during the build comes once, after the last wave (`CLAUDE.md` `<frontend>`). If an older
plan lists it between tasks, move those tasks to the end of the plan and keep building.

A task that fails: first check what it left behind. Retry once, with the error in the brief, only if
running it again is safe. Otherwise, or if it fails again, mark it blocked. Tasks that depend on it
or touch the files it left dirty wait; the rest finish.

## 5. Review once, at the end

After the last wave, never per task, skipped only if no file changed: run `/code-review` on
`<baseline>..HEAD`. Without that range it reads only the last commit. Fix its confirmed blocker, high
and medium findings in the work just built, re-run the checks, commit. Report the rest. A blocker you
cannot resolve means the work is not done: say so.

A plain review ask goes to built-in `/code-review`. Spawn reviewers directly only for what it
skips (a mock, a video) or when the owner names the agents or criteria.

## 6. Report

Use `<reply_format>`. In `Result`, one row per task: task, model, status. Then the decisions taken,
then what still waits for the owner, only what applies: eye approval (open the main artifact, W18),
push, blocked tasks.
