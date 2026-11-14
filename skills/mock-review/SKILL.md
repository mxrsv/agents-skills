---
name: mock-review
description: Review an HTML mock before any code is written, by an agent that did not draw it. It asks whether each element has a job, whether the flow dead-ends, whether bad-data states are drawn or declared, whether the mock reuses the app's blocks, and which lines the owner approved. Use when the owner says "rà mock", "review mock", "mock này có gì thừa", or asks for a second look at a mock. Not for the built app (build-review), removal in shipped code (simplify-review) or the visual craft of a web page (frontend-design-bar).
argument-hint: "<mock.html> [model]"
---

# Mock review: what is decided here?

A mock is where a decision is cheapest to change. Review it in a read-only subagent that did not
draw it (`opus`, `high`; a model the owner names wins). It removes nothing.

Give the agent the mock, the spec or ledger with the owner's quoted decisions, the app's design doc
and shared blocks, and the owner's taste in three to seven lines.

| Angle | Run when | Ask |
| ----- | -------- | --- |
| Job and flow | always | Walk the task step by step: dead ends, extra steps, what first open shows. |
| Lean | always | Which copy, control or figure has no job, or restates its neighbour? |
| Bad data | always | Empty, loading, error, long text: drawn, or listed in `notShown` with the intended behaviour? |
| Consistency | always | Which blocks, words and colours does the app already have, and where does the mock invent a second one? |
| Decisions | always | Which lines did the owner approve, and which did the mock's author infer (W20)? |
| Numbers | a figure is shown | Meaning, source, direction; try it on real data now (W23). |
| Safety | it deletes, moves or runs something | What must never happen, what is selected by default, how the user gets it back. |
| Progress and cost | long work or live figures | How work in progress shows; does the design need constant redraw? |
| Platform | permissions, menu bar, windows | What it needs from the OS, and what the screen shows when refused. |

Each finding names the element and the state. Facts are tested now, not after the build: real
files, a spike, a walk-through (UP6).

Report to the owner, then put each finding where it is decided: a real trade-off becomes a switch in
the mock's rail, an undrawn state goes to `notShown` with the intended behaviour, an inferred line
goes to the spec's "Inferred, not decided" list.
