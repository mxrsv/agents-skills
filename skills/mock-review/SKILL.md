---
name: mock-review
description: Review an HTML mock before any code is written, by an agent that did not draw it. It asks whether each element has a job, whether the flow dead-ends, whether bad-data states are drawn or declared, whether the mock reuses the app's blocks, and which lines the owner approved. Use when the owner says "rà mock", "review mock", "mock này có gì thừa", or asks for a second look at a mock; run it unasked when a mock changes an existing task flow, before it becomes requirements. Not for the built app (build-review), removal in shipped code (simplify-review) or the look of a page (the owner's eye under kyant-ui-rules).
argument-hint: "<mock.html> [model]"
---

# Mock review: what is decided here?

A mock is where a decision is cheapest to change. Agent `read-only-reviewer` reviews it, never the
session that drew it; a model the owner names wins. It reports; it changes nothing.

Give it the mock, the spec or ledger with the owner's quoted decisions, the app's design doc and
shared blocks, what the engine can actually do, real sample data, and the owner's taste in three to
seven lines.

| Angle | Run when | Ask |
| ----- | -------- | --- |
| Job and flow | always | Walk entry, task, outcome and recovery: dead ends, extra steps, first open. |
| Lean | always | What has no job, or repeats its neighbour? |
| Bad data | always | Empty, loading, error, long text: drawn, or declared in `notShown` with the intended behaviour? |
| Consistency | always | Which blocks, words and meanings does the app already have, and where does the mock invent a second one? |
| Decisions | always | Which lines are the owner's quoted approvals, and which are inference (skill `decision-traceability`)? |
| Numbers | a figure is shown | Meaning, source and direction against the real samples; without samples, unverified (FE-D3). |
| Safety | an action changes or runs something | Targets, defaults, consent and recovery, against what the engine can do. |
| Progress | long or live work | How progress, cancel and refresh rate show; what will need measuring. |
| Platform | it depends on something outside the screen | What it needs (a permission, a login, a network, a screen size) and what shows without it; which checks remain for the build. |

Each finding names the element and the state.

The session that owns the mock places each finding: a real trade-off becomes a switch in the mock's
rail, an undrawn state goes to `notShown` with the intended behaviour, an inferred line goes to the
spec's "Inferred, not decided" list.
