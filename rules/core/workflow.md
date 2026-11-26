# Workflow

## When to spec or plan

- Default to doing the work directly. Brainstorm or write a spec only when one of these holds:
  - the request has several readings that lead to materially different, hard-to-reverse outcomes (otherwise pick the likeliest and state it);
  - it changes the architecture, the data model or an existing public contract (API, CLI), or changes or removes an existing UI flow (adding a new flow does not count);
  - the user explicitly asks.
- Write a plan when the work spans several sessions or commits, or the user asks for one. A small, clear task needs no plan even if a spec exists; single-session work uses plan mode instead of a plan file.
- Specs in `docs/specs/` own requirements; plans in `docs/plans/` own execution and link the spec. Neither requires the other.
- On a bug, use skill `diagnosing-bugs` before fixing (not `systematic-debugging`), and scale the investigation to the bug.

## Done check

- Before the first edit of a task, state the pass/fail check that shows it is done; done also needs the gates the task triggers: skill `build-review`, and for UI the worst-case break-test and the owner-runtime screenshot in `kyant-ui-rules`.
- The check is a test, typecheck, build exit code, or a screenshot beside the mock. Work with no such check (a UI direction, copy, marketing) uses a side-by-side against a named reference, then the owner's eye; with no reference yet, ask for one.
- Report "done / fixed / passing" only after the check ran, with its command and output pasted as evidence.
- Once the check and its gates pass, stop and report; name further improvements in one line instead of doing them.

## Safety

- Commands that change state in hard-to-reverse ways (delete, DB reset, deploy, migrate): re-check that the evidence supports that specific action; unsure → ask.
- For changes with material data-loss, security or operational risk, present the approach, verification and recovery plan before editing, and get approval unless that scope is already approved.
- Before editing the first file, run `git status --porcelain`. Work on the current checkout and branch by default, even with `M`/`??` files, and leave changes outside the task untouched.
- Do not create or switch to a worktree just because the checkout has uncommitted changes.
- When verification fails, check whether the failure belongs to the task's changes before concluding.
- At the end of a task, delete the experimental and debug files you created.

## Resume and handoff

- Resume from the spec's requirements and the plan's approach, verification and latest handoff, then inspect the actual checkout before editing. Preserve other agents' changes.
- At handoff, record progress, checkout/branch/PR, observed verification, remaining work and blockers in the same plan.
- A merge is not acceptance: mark a task complete only when acceptance criteria and required approvals are met, and report unrun gates. Merge, deploy and release need the user's authorization.

## References and decisions

- A reference that fits more than one thing ("yesterday's video", "the landing page"): list the candidates (path or element, date, one line each) with a recommended pick.
- Local and reversible → act on the pick and name it in one line. Outward-facing or costly (deploy, publish, delete, push), or candidates that differ materially → wait for the choice.
- Owner decisions survive every handoff (spec, plan, build prompt, acceptance): follow skill `decision-traceability`.
- Risky features pass skill `build-review` and flow-changing mocks pass `mock-review` before the owner looks; triggers in skill `decision-traceability`.
