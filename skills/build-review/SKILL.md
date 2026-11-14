---
name: build-review
description: After a feature is built and before the owner is asked to look, a fresh read-only agent tries to break it along the real code paths, covering readiness, a function that lost its way in, data safety, cancel and concurrency, and what the feature depends on saying no. For native, web and backend work alike. Use when a feature changes or deletes user data, handles auth or money, runs external commands or parallel work, touches a system permission or changes how a task is reached; before a cut-over; or when the owner says "rà build", "phá thử", "nghiệm thu", "build review". Not for a mock (mock-review), bugs across a diff (the code-reviewer agent), removal (simplify-review) or the look, which is the owner's eye.
argument-hint: "<feature or plan> [model]"
---

# Build review: can it be broken?

The builder already checks its own work (W4, W22, W23). This covers what a builder does not see in
its own code: one run of agent `read-only-reviewer` with `effort: "xhigh"`, never the session
that built; a model or effort the owner names wins.

Give it the spec with its acceptance criteria and the owner's decisions, the active plan with its
verification evidence, the diff range, the product and core paths, and how to run the repo's checks.

| Angle | Run when | Trace |
| ----- | -------- | ----- |
| Readiness | always | Do the promised scope, the integration tasks, the verification evidence and the recorded approvals agree? What is unfinished? |
| Entry points | always | Each promised task, from a reachable control, route or endpoint to its outcome. Before a cut-over, the surface being removed too. |
| Safety | it changes data, spends money or runs something | A wrong target, a default or missing check that lets through what cannot be undone, stale consent, a partial failure, input it trusts. |
| Lifecycle | long, repeated or parallel work | Cancel, retry, leaving and coming back, restart, two at once. |
| Platform | it depends on something outside the code | That thing refusing, changing or missing. |

Read each row in the product's own terms:

- **Native app:** a refused or revoked permission, sleep and wake, a relaunch mid-run, a second
  display.
- **Web:** who may call it, a double submit, a second tab, back and refresh, a slow or failed
  request, a small screen.
- **Backend:** authorisation per record, a retried or duplicated request, a half-applied write or
  migration, a missing secret, a quota, a third party that is down.

It reads code and runs the existing tests; it does not launch the app. So a finding is one of three
(W13): **confirmed** (trigger, `path:line`, wrong result), **hypothesis** (with the check that
settles it), or **runtime check outstanding** (whatever only the running product shows).

The builder fixes what is confirmed and re-runs the gate. Then ask for the owner's eye, hypotheses
and outstanding runtime checks first, and tick the plan with the commit.
