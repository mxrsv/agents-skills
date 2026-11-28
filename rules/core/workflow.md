# Workflow

## When to write a spec

- Brainstorm or write a spec only when one of these holds:
  - the request has several readings that lead to materially different, hard-to-reverse outcomes (otherwise pick the likeliest and state it);
  - it changes the architecture, the data model or an existing public contract (API, CLI), or changes or removes an existing UI flow (adding a new flow does not count);
  - the work spans several sessions;
  - the user explicitly asks.
- No plan files. The approach lives in plan mode or the chat; present it before editing when it is hard to undo.
- On a bug, use skill `diagnosing-bugs` before fixing (not `systematic-debugging`), and scale the investigation to the bug.

## Done check

- Before the first edit of a task, state the pass/fail check that shows it is done; done also needs the gates the task triggers: skill `build-review`, and for UI the worst-case break-test and the owner-runtime screenshot in `kyant-ui-rules`.
- The check is a test, typecheck, build exit code, or a screenshot beside the mock. Work with no such check (a UI direction, copy, marketing) uses a side-by-side against a named reference, then the owner's eye; with no reference yet, ask for one.
- Report "done / fixed / passing" only after the check ran, with its command and output pasted as evidence.
- Once the check and its gates pass, stop and report; name further improvements in one line instead of doing them.

## Safety

- Commands that change state in hard-to-reverse ways (delete, DB reset, deploy, migrate): re-check that the evidence supports that specific action; unsure → ask.
- For changes with material data-loss, security or operational risk, present the approach, verification and recovery plan before editing, and get approval unless that scope is already approved.
- Make a hard-to-reverse step reversible first where that is cheap (back up before a migration, move to Trash instead of `rm`, work on a branch, release to a few users first), so a wrong call costs a restore instead of the data. What stays hard to reverse still needs the re-check and approval above.
- Before the first edit, check that the working directory is the repo the task is about; if it is another project, stop and say so instead of editing.
- Before restarting or killing an app or process, name it and check that no other session or pane depends on it. Measure CPU or RAM on a separate prod build, never on the owner's running dev app.
- CI lookups (`gh run watch`, `gh run list --commit`) take the full SHA from `git rev-parse HEAD`, not a short one.
- Before editing the first file, run `git status --porcelain`. Work on the current checkout and branch by default, even with `M`/`??` files, and leave changes outside the task untouched.
- Do not create or switch to a worktree just because the checkout has uncommitted changes.
- When verification fails, check whether the failure belongs to the task's changes before concluding.
- At the end of a task, delete the experimental and debug files you created.

## Resume and handoff

- Resume from the spec (requirements, decisions, `## Status`), then inspect the checkout, branch and PR before editing. Preserve other agents' changes.
- At handoff, update the spec's `## Status`: done, remaining, checkout/branch/PR, checks run with results, blockers.
- A legacy plan in `docs/plans/` that is still active: on the next touch, move its status into the spec's `## Status` and mark the plan historical.
- A merge is not acceptance: mark a task complete only when acceptance criteria and required approvals are met, and report unrun gates. Merge, deploy and release need the user's authorization.

## References and decisions

- A reference that fits more than one thing ("yesterday's video", "the landing page"): list the candidates (path or element, date, one line each) with a recommended pick.
- Local and reversible → act on the pick and name it in one line. Outward-facing or costly (deploy, publish, delete, push), or candidates that differ materially → wait for the choice.
- When putting options to the owner, mark each one reversible or hard to reverse and say in one clause what undoing it costs, so the owner sees which choice needs thought and which can be picked fast.
- Before recommending on strategy, product or UX (advice, not code), name the 2–3 assumptions about audience, resources and constraints that would most change the answer; ask the owner about the ones the conversation and repo cannot settle, then give one pick and say what would reverse it.
- Before saying something does not exist (a feature, project, file), search every repo on the machine that could hold it (`find ~ -maxdepth 4 -name .git`), not only the current checkout, and say where you looked.
- Owner decisions survive every handoff (spec, build prompt, acceptance): follow skill `decision-traceability`.
- Risky features pass skill `build-review` and flow-changing mocks pass `mock-review` before the owner looks; triggers in skill `decision-traceability`.
