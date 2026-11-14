---
name: feature-review
description: Review one feature at two moments against the same angles, on the mock before any code and on the built app before the owner is asked to look or an old surface is removed. Use when a mock adds a flow, deletes data or carries a disputed choice; when a build is about to go to the owner's eye; before a cut-over; or when the owner says "rà mock", "rà feature", "nghiệm thu", "feature review". Not for removal alone (simplify-review), a diff's bugs (code-review) or the visual craft of a web page (frontend-design-bar).
argument-hint: "mock | build [surface]"
---

# Feature review: twice, same angles

On the mock, check what is decided. On the build, check what happens. Run a row only when its
condition holds, and name the rows skipped.

| Angle | Run when | On the mock | On the build |
| ----- | -------- | ----------- | ------------ |
| Job and flow | always | walk the task step by step: dead ends, extra steps, first open | do the real task; every entry point still reachable |
| Numbers | a figure is shown | meaning, source, direction, certainty, tried on real data | reconcile with the real source (W23) |
| Safety | it deletes, moves or runs something | what must never happen, defaults, recovery | break it on purpose: wrong target, partial failure, stale consent |
| Lifecycle | long or parallel work | state transitions | cancel, navigate away, relaunch, sleep and wake, two actions at once |
| Platform | permissions, menu bar, windows | what it needs from the OS and what it does when refused | refusal and revocation, menu bar, a second display |
| Release | a release, or stored data changes | what the old version's data and settings keep | install and update the signed build |
| Response and resources | always | how work in progress shows; sampling and redraw budget | latency (100 ms to react), CPU, wakeups and memory per window state |
| Accessibility and consistency | the UI changes | semantics, shared blocks, words, colours | keyboard, screen reader, native render |
| Decisions | always | approved by the owner, or inferred (W20) | matches the reference; the running binary is this build (W22) |
| Lean | always | every element has a job | nothing unreachable; before a cut-over, `simplify-review` parts B and C on what is removed |
| Outside promises | a release | the claims planned | site and notes match the build |
| Feel | the UI changes | not checkable | hover, press, transitions, resize: the owner's eye on the running app |

## mock

A read-only subagent that did not draw the mock (`opus`, `high`). Skip it when the mock only
rearranges approved blocks. For each row run it names the element and what is missing or has no
job. Facts are tested now, not after the build: real files, a spike, a walk-through.

Its findings go where they are decided: a real trade-off becomes a switch on the mock (UP8); the
rest go to `notShown` with the intended behaviour, or to the spec's "Inferred" list. It removes
nothing itself.

## build

The builder runs each applicable row on the real app and reports it as evidence, not applicable or
not checked. A subagent that did not build repeats Safety and Lifecycle when the feature deletes
data or runs work in parallel. What needs a window in front waits until the owner is away, or is
reported not checked.

Then ask for the owner's eye, "not checked" rows first, and record the approval with the commit it
was given on.
