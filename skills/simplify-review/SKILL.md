---
name: simplify-review
description: After a feature lands, send a read-only subagent through the app to find UI and code that can be removed or simplified, each finding proven or labelled as opinion and checked against the owner's recorded decisions, then show the picks as real before/after renders. Use when the owner says "rà soát tối giản", "có gì thừa không", "lược bỏ được gì", "simplify review", "what can we remove", or asks for an agent to look for unnecessary or redundant things. Not for this session's diff (/simplify), a code-only audit (ponytail-audit), bugs (code-review) or the look of one screen (kyant-ui-rules).
argument-hint: "[screen or area] [model]"
---

# Simplify review: what can go?

Run the review in a fresh subagent, never in the session that built the work. The agent knows only
the brief, so the brief carries the product's facts, the owner's taste and decisions, and the
evidence rule.

## 1. Gather what the agent cannot know

- **Scope:** the area the owner named, else the whole app; say which.
- **Paths:** repo roots and how to run git there, `AGENTS.md`, product and design docs, where specs
  and decision ledgers live, earlier reports not to repeat.
- **Render command:** the repo's snapshot or story script. None → source only.
- **Taste:** three to seven one-line rules from memory and the design doc. What follows them is not
  a finding; what breaks them is.
- **Output:** `~/scratch/<repo>/<YYYY-MM-DD>-simplify-review/`. The agent returns the report as
  text (the harness refuses its file); save it unchanged as `report.md`.

## 2. Spawn

Spawn agent `read-only-reviewer` (`opus`, `high`); a model, effort or agent count the owner names
wins. Run in the background.

- **A feature or one area:** one agent.
- **The whole app:** up to four, split by kind of work, because a single agent runs out of room: one
  for B and C, one for A per five or so screens. Each gets the brief minus the others' parts and is
  told what the others cover. Merge their lists into one ranked 25, keeping every class, tag and
  "did not get to".

```text
You are doing a read-only "what can we remove or simplify" review of <product, platform, stack>.
The owner builds it by directing agents and suspects it has gathered UI and code that is
unnecessary or redundant. Find it and rank it. You fix nothing.

## Where
<repo roots, in-scope and out-of-scope folders, how to run git>
Read first: <AGENTS.md, design-language doc, PRODUCT.md, the specs folder and its decision ledgers>

## What to look for
A. UI/UX that can be simpler, per screen (<list the screens, popovers, dialogs>):
   - elements, lines of copy, labels, secondary figures, states or controls that no user job needs,
     or that restate what sits next to them;
   - two patterns for one job on the same or sibling screens;
   - steps that could be dropped, settings nobody needs, options that duplicate each other;
   - screens, tabs or cards whose content overlaps another's.
B. Built but not needed:
   - code with no caller, views and fixtures never reached, switches that guard something already
     shipped or already abandoned, hidden tabs, leftovers of replaced surfaces;
   - near-duplicate components or helpers that should be one;
   - backend or FFI surface the app never reads;
   - tests, snapshot scenes or scripts that only cover removed things.
C. A function the UI still promises whose only way in sits on an unreachable surface. Report it as
   a defect, not as a removal.

## The owner's taste (do not report what follows it; do report what breaks it)
<3-7 one-line rules>

## How to look at the UI
<the offscreen render command, or "read the source only">. Renders are fixtures, not the running
app: say so when you cite one. Do not launch the app, open a window or a browser, or run `open`.

## Evidence rules
- Every finding cites `path:line`, plus a render path when the point is visual.
- Two labelled classes, never mixed:
  1. Confirmed redundant: provable from code (a repo-wide search you ran and name, two
     implementations both cited, a flag whose both branches you traced).
  2. Judgement, could be simpler: state the user job the element should serve, why it does not earn
     its place, and what the screen looks like without it.
- Check each finding against the specs and ledgers. The owner decided it (quote + ID) → tag it
  "Owner decision: reconsider?", never a defect. It came from an agent's inference or a mock with
  no owner quote → tag it "Inferred".
- No finding without opening the code. What you could not verify goes under "Unverified leads" with
  the check that would settle it.

## Limits
Read-only in every repo: no edits, commits, stash or branch changes; other sessions may have
uncommitted work there. Write only under <a /tmp folder for renders and scripts>.

## Deliverable (return it as text, in English)
1. A ranked list of the findings that matter most, ordered by payoff for the user divided by cost to remove. Each row:
   title, class, tag, evidence, the removal in one or two sentences, rough size, risk.
2. Per-screen notes for what fell below the cut.
3. Unverified leads.
4. One paragraph on the habits that keep producing the excess.
End with the count per class and the most important ones as one line each with `path:line`. Be plain about what
you did not get to.
```

## 3. Report, then stop once

Save the report, then open the `path:line` of every item you will call safe to remove. Tell
the owner, in their language, in this order:

1. **Remove now:** small, provable, no decision involved.
2. **Decided but not done:** dead code whose removal is already a task; name the task and what
   blocks it.
3. **Defects exposed:** class C.
4. **Judgement calls,** "Owner decision: reconsider?" last.

Change nothing; the owner picks.

## 4. Before and after

When the owner asks to see the picks, spawn one `sonnet` agent:

- **Real renders:** "before" from the code as it is; the smallest view-level edit per item,
  uncommitted (unused members, copy and tests stay); then "after". No render command → show the
  diff per item instead.
- **It views every pair** and keeps any line that is the only place a consequence is stated.
- **The page** is a copy of `~/.claude/templates/mock-shell.html` (the one mock shell) in the output folder: axis
  `item`, axis `view` (`after` | `before`), presets the full recommendation, then `Trước` and `Sau`
  naming only `view`, `notShown` for items with no visible change, the render plus a 2× crop of the
  changed region.

View the "after" of each judgement item yourself, open the page yourself, list per item what goes and
what information goes with it, and ask which items stay.

## 5. Land

- **Approved:** remove what the edit left unused (parameters, members, copy), fix tests pinned to
  the removed text and the user docs, note the approval in the spec or ledger, run the repo's gate,
  `git commit -- <paths>`.
- **Not approved:** restore those hunks.
- **Waiting on a dev-switch cut-over or an eye approval:** leave it and report its task. An "Owner
  decision" item changes only on an explicit yes (skill `decision-traceability`).

Renders are not the running app: check the changed screens in the owner's dev runtime (owner-runtime check), or say
that only renders were checked.
