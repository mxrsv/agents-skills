---
name: build-review
description: After a feature is built and before the owner is asked to look, a fresh read-only agent tries to break it along the real code paths, covering data safety, cancel and concurrency, a refused permission, and a function that lost its way in. Use when a feature deletes or moves data, runs work in parallel or touches a system permission; before a cut-over; or when the owner says "rà build", "phá thử", "nghiệm thu", "build review". Not for a mock (mock-review), bugs across a diff (the code-reviewer agent), removal (simplify-review) or the look, which is the owner's eye.
argument-hint: "<feature or plan> [model]"
---

# Build review: try to break it

The builder already checks its own work (W4, W22, W23). This covers what a builder does not see in
its own code: one read-only subagent that did not build (`opus`, `high`; a model the owner names
wins).

Give it the spec with its acceptance criteria and the owner's decisions, the diff range, and how to
run the repo's checks.

| Angle | Run when | Try |
| ----- | -------- | --- |
| Entry points | always | Do the real task; every function the surface promises still has a way in. |
| Safety | it deletes, moves or runs something | A wrong target, a default that selects what cannot be rebuilt, a partial failure, consent given for an older list, a subprocess that trusts the user's files. |
| Lifecycle | long or parallel work | Cancel, navigate away, relaunch, sleep and wake, two actions at once, a busy core. |
| Platform | a system permission or the menu bar | Refused, revoked mid-run, a second display. |

A finding is confirmed only with its trigger, its code path (`path:line`) and the wrong result;
anything else is "Hypothesis: unverified" with the check that would settle it (W13). No edits, and
no app launch while the owner is at the machine.

The builder fixes what is confirmed and re-runs the gate. Then ask for the owner's eye, unverified
hypotheses first, and tick the plan with the commit. Before a cut-over, also run `simplify-review`
part C on the surface being removed.
