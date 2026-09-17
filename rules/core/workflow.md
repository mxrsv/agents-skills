# Workflow (W-rules)

- **W1.** Default to doing the work directly. ONLY brainstorm/spec when one of three thresholds is hit: (a) the request is ambiguous or there are several readings of the outcome; (b) it changes the architecture, data model, or a public contract (API / CLI / UI flow); (c) the user explicitly asks. Below the threshold → just code.
- **W2.** Write a plan only when there is an approved spec, or the work spans multiple sessions / multiple commits. On a bug → use `diagnosing-bugs` before fixing; it is the primary debugging workflow and supersedes `systematic-debugging`. Do not run both workflows. Scale the investigation to the bug; apply W13 to every finding, including read-only reviews.
- **W3.** Edit only within the task's scope. Out-of-scope work discovered (drive-by refactors, other bugs) → RAISE IT, do not do it yourself.
- **W4.** NEVER report "done / fixed / passing" without running the verification command (test / typecheck / build / screenshot) and pasting the output as evidence.
- **W5.** Conventional commits with a scope — `type(scope): description`. One commit = one complete piece of work.
- **W6.** Follow the branching rules in CLAUDE.md: do not create branches on your own; a branch (when requested) always comes with a worktree.
- **W7.** Starting a significant new feature → look for a battle-tested skeleton/foundation before building from scratch.
- **W8.** At the end of a task → delete the experimental/debug files you created; check every NEW file against the F-rules checklist.
- **W9.** Commands that change state in hard-to-reverse ways (delete, DB reset, deploy, migrate) → re-check that the evidence actually supports that specific action; unsure → ask.
- **W10.** Frontend: follow `<frontend_gate>` in CLAUDE.md — lock IDEA + APPROACH before doing UI work.
- **W11.** Before editing the first file → `git status --porcelain`. Work on the current checkout and branch by default, even when there are `M`/`??` files; leave changes outside the task's scope untouched. Do NOT create or switch to a worktree just because the checkout has uncommitted changes. Always commit with `git commit -- <paths>`, NEVER `git add -A` / `git commit -a`. Verification fails → determine whether the failure belongs to the task's changes before concluding; a clean worktree is not required for verification.

- **W12.** At the end of every turn that performed actions (file edits, commands/background agents, Linear writes) → the last line reports the session-close signal. `🟢 Đóng session được` ("session can be closed") ONLY when all of the following hold: the task's changes are committed; the handoff is recorded on the Linear issue if there is one (LW6); no background process/subagent is still running; temporary files are cleaned up (W8); no question is waiting for the user's answer. Any one missing → `🔴 Chưa đóng được: <specific reason>` ("cannot close yet"). A Q&A-only turn with no actions → omit this line.

- **W13.** Evidence before conclusions: call a finding or root cause confirmed only with checkable evidence connecting the trigger, reachable execution path, and incorrect behavior. Include the relevant command/steps and observed result, or a concrete code-path proof with valid input; identify the environment/revision when material. A provable defect is not automatically the cause of the reported incident. Without sufficient evidence, label it "Hypothesis — unverified", keep it separate from confirmed findings, and state the next discriminating check. Passing tests after a fix alone do not establish causality. Investigation and minimal diagnostic experiments may continue within the authorized scope; read-only review remains read-only.

## Checklist before reporting completion

- [ ] Ran verification and pasted the output? (W4)
- [ ] Each confirmed finding/root cause has checkable evidence; unverified hypotheses and remaining evidence gaps are explicit? (W13)
- [ ] Changed anything outside the scope? (W3)
- [ ] Temporary files cleaned up, new files checked against F-rules? (W8)
- [ ] Commit message follows the convention? (W5)
- [ ] Committed by path, without sweeping in another session's files? (W11)
- [ ] Last line reports the 🟢/🔴 session-close signal? (W12)
