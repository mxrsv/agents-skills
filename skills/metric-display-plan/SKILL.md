---
name: metric-display-plan
description: Before any UI mock, mock brief or design-direction round for a surface that shows several pieces of data (overview, dashboard, status page, summary card, settings with readings), work out per element what question the user brings to it and what kind of data it is, choose a form for each element from that, and only then generate ideas and layouts. Use it whenever you are about to mock, sketch, brief subagents for, or propose directions for a data-bearing screen — "làm mock", "dựng mock Overview", "đề xuất cách hiển thị", "thiết kế lại dashboard", "mock nhanh cho tôi", "redesign the overview" — and whenever every element on a screen is drifting into the same tile, the same number-plus-chart, or the owner says the ideas feel limited or samey. Not for building or judging the finished UI (kyant-ui-rules).
metadata:
  origin: user
---

# Metric display plan

A screen with five readings is five questions, not one template applied five times. This skill makes the
question and the data's nature decide each element's form *before* anyone mocks, briefs or picks a layout.

## Why this exists

One form repeated across a screen usually means nobody chose it: the data source's shape picked it. Layout variety can hide that the content has none. Decide the form per element. A worked case: `references/worked-example.md`.

The failure has three roots, and each step below closes one:
- Thinking from the data source instead of the user's question (step 2).
- One form for all elements because it is the cheapest to brief (steps 3–4).
- "Divergent directions" that differ only in arrangement (step 5).

## When to run it

Before the first mock or mock brief of any surface with two or more data elements, including a redesign,
a new direction round (reference first, redesign in `kyant-ui-rules`) and a `run-agents` mock wave. Run it again when
the owner says a mock feels samey or limited. It takes one pass over the element list; it is not a
replacement for the owner's decisions, it feeds them.

## Step 1 — List the elements

Name every element the surface must show, from the spec, ledger or product truth (`PRODUCT.md`), not from
the old screen. Keep composite things split: "CPU" and "CPU per core" are two elements if they answer
different questions.

## Step 2 — Write the element sheet

One row per element. Fill every column; a blank column is the signal you are guessing.

| Column | What to write | Example (Disk) |
|---|---|---|
| **Question** | The question the user brings, in their words | "Will I run out of space soon?" |
| **Kind** | rate · level · stock · budget · composition · event · list · status | stock |
| **Change speed vs horizon** | How fast it moves compared with the window the screen covers | moves over days; the screen covers now |
| **Good / bad** | Which direction is good, and where the thresholds are | more free is good; < 10% free is bad |
| **Lead figure** | The one number or word that answers the question | `61 GB free` |
| **Second line** | What makes the lead figure actionable | `↓ 3.2 GB in 24 h · full in ~19 days` |
| **Data truth** | Exists now / needs storing / needs a new reader / cannot be known | 24 h change needs samples kept across Quit |

Kinds, briefly — they drive the form:
- **rate** (CPU %, network throughput): changes by the second; "now" plus direction matters.
- **level** (RAM used, temperature): bounded, slower; position against a limit matters.
- **stock** (disk free, battery charge): drains or fills over hours or days; time-to-empty matters.
- **budget** (quota, rate limit, plan minutes): spent against a reset; what is *left* and *when it resets*.
- **composition** (memory parts, storage by type): parts of a whole.
- **event** (crash, update available, hot Mac): binary or rare; appears only when it happens.
- **list** (top apps, sessions): ranking; who, not how much.
- **status** (pressure Normal, connected): a word.

If the data cannot be known (macOS gives no byte threshold for memory pressure, say), the sheet says so and
the form must not invent it ("a number shown is a number delivered" in `kyant-ui-rules`).

## Step 3 — Choose a form per element

Pick from the kind and the question, not from what the neighbouring element uses. `references/form-catalog.md`
lists forms per kind with when each fits. Two rules carry most of the weight:

- **A time-series chart earns its place only when the question is about shape over time *and* the data
  moves meaningfully within the window shown.** A stock over 1 hour is a flat line; a rate over a day hides
  the spike. When the chart belongs to another page, the summary surface gives "now + which way" instead.
- **The lead figure is the total the user expects first** (CPU %, GB used, battery %), and the headroom or
  context line sits under it. The owner asked for exactly this after the TinySift headroom mock led with
  "7 of 12 cores free".

## Step 4 — Template check

Count forms. If more than half the elements share one form, stop and justify each in one line ("all five
are rates shown live, so a sparkline is honestly right") or redo step 3 for the ones that only inherited
it. Ask of each element: *what would it show if charts did not exist?* If that answer is better, use it.

## Step 5 — Diverge on ideas, then on layout

Before arranging anything, write at least three **organising ideas** — what the screen is *about*, not how
it is tiled. Examples from the TinySift round: *headroom* (everything as what is left), *a status sentence*
(one generated line, details below), *today's digest* (what happened since morning), *two budgets* (machine
vs account). Then, for the chosen idea(s), produce layout directions that differ in structure and
storytelling (redesign in `kyant-ui-rules`). A direction that only rearranges the same element forms is not a new direction.

## Step 6 — Hand it on

- **To the owner:** put the open choices into a grilling round (one question per real choice, with a
  recommendation): kind-level choices ("Overview has no charts?"), per-element forms worth a decision, the
  organising idea. Record answers in the ledger.
- **To mock subagents:** paste the element sheet and the chosen forms into every brief, verbatim. Do not
  write "each with a sparkline" or any other uniform instruction; give each element its own form. Tell the
  agent to keep the sheet's lead figures and to flag any element where the form fights the layout rather
  than silently normalising it.

## Output

The element sheet (step 2 table plus a **Form** column from step 3), the template-check note, and the list
of organising ideas. Keep it in the chat or in the spec folder next to the ledger, not in a separate report.
