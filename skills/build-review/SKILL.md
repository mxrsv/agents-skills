---
name: build-review
description: After a feature is built and before the owner is asked to look, a fresh read-only agent tries to break it along the real code paths, covering readiness, a function that lost its way in, data safety, cancel and concurrency, and a refused permission. Use when a feature writes or moves user data, runs external commands or parallel work, touches a system permission or changes how a task is reached; before a cut-over; or when the owner says "rà build", "phá thử", "nghiệm thu", "build review". Not for a mock (mock-review), bugs across a diff (the code-reviewer agent), removal (simplify-review) or the look, which is the owner's eye.
argument-hint: "<feature or plan> [model]"
---

# Build review: can it be broken?

The builder already checks its own work (W4, W22, W23). This covers what a builder does not see in
its own code: one read-only subagent that did not build (`opus`, `high`; a model the owner names
wins).

Give it the spec with its acceptance criteria and the owner's decisions, the active plan with its
verification evidence, the diff range, the product and core paths, and how to run the repo's checks.

| Angle | Run when | Trace |
| ----- | -------- | ----- |
| Readiness | always | Do the promised scope, the integration tasks, the verification evidence and the recorded approvals agree? What is unfinished? |
| Entry points | always | Each promised task, from a reachable control to its outcome. Before a cut-over, the surface being removed too. |
| Safety | it writes, moves or runs something | A wrong target, a default that selects what cannot be rebuilt, stale consent, a partial failure, a command that trusts the user's files. |
| Lifecycle | long or parallel work | Cancel, navigation, restart and overlap. |
| Platform | it depends on the OS | Refusal and revocation. |

It reads code and runs the existing tests; it does not launch the app. So a finding is one of three
(W13): **confirmed** (trigger, `path:line`, wrong result), **hypothesis** (with the check that
settles it), or **runtime check outstanding** (sleep and wake, a revoked permission, a second
display, whatever only the running app shows).

The builder fixes what is confirmed and re-runs the gate. Then ask for the owner's eye, hypotheses
and outstanding runtime checks first, and tick the plan with the commit.
