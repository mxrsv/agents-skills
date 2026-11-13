---
name: simplify-review
description: After a feature or a run of features has landed, send ONE read-only subagent through the whole app to find what can be removed or made simpler, both in the UI (copy, controls, steps, two patterns for one job) and in the code (screens with no way in, hidden tabs, leftover switches, near-duplicate components), every finding either proven or labelled as opinion and checked against the owner's recorded decisions; then show the cheap ones as real before/after renders so the owner approves by eye. Use when the owner says "rà soát tối giản", "có gì thừa không", "cái gì lược bỏ được", "tối giản UI/UX", "simplify review", "what can we remove", or asks for an agent to look for unnecessary or redundant things after building. Not for the code changed in this session (built-in /simplify), a code-only over-engineering audit (ponytail-audit), bugs (code-review), or tightening one screen (impeccable distill).
argument-hint: "[screen or area] [model]"
---

# Simplify review: what can go?

The session that built a feature reads its own work kindly and has little context left to read the
rest of the app. So the review runs in one fresh subagent, and this session's job is the brief: the
agent knows only what the brief says. Three things in the brief decide the quality of the result:
the product's facts, the owner's taste and decisions, and the evidence rule. Generic "simplify this"
prompts return opinions mixed with facts and flag things the owner chose on purpose.

## 1. Gather what the agent cannot know

- **Scope:** the area the owner named, else the whole app; say which in one line. Leave out what
  they leave out (a website, marketing).
- **Paths:** repo roots and how to run git in them, `AGENTS.md`, product and design-language docs,
  where specs, plans and decision ledgers live, earlier review reports it must not repeat.
- **How to see a screen without opening a window:** the repo's snapshot or story script, with the
  exact command. None → the agent reads source only.
- **The owner's taste:** three to seven one-line rules from memory and the design-language doc.
  They are a filter: what follows them is not a finding, what breaks them is.
- **The machine:** assume the owner is working on it. No app launch, no window, no `open`.
- **Output folder:** `~/scratch/<repo>/<YYYY-MM-DD>-simplify-review/` (F4). The harness refuses a
  subagent's report file, so the agent returns the report as text and this session saves it
  unchanged as `report.md`.

## 2. Spawn the agent

Use the strongest review model on offer unless the owner names one (the first run used `fable`):
the value is judgement over a lot of reading. Run in the background and tell the owner the scope,
the finding classes and the report path in one message.

How many agents (the owner's number wins):

- **A feature or one area → one agent.** One reader ranks its own list, and nothing overlaps.
- **The whole app → split by kind of work,** at most four: one agent for B and C (reachability,
  dead code, duplicates: repo-wide searches) and one agent for A per group of about five screens
  (judgement on renders). Why: the first whole-app run with a single agent ran out of room and
  left several surfaces and every light-theme render unexamined.
- **When split:** every agent gets the same brief except "What to look for" and its screen list,
  is told which parts belong to the others so it does not report them, and returns its own ranked
  list. This session merges them: drop duplicates, re-rank into one list of 25, keep each
  finding's class and tag, and carry every agent's "did not get to" into the report.

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
1. A ranked list, at most 25, ordered by payoff for the user divided by cost to remove. Each row:
   title, class, tag, evidence, the removal in one or two sentences, rough size, risk.
2. Per-screen notes for what fell below the cut.
3. Unverified leads.
4. One paragraph on the habits that keep producing the excess.
End with the count per class and the top 10 as one line each with `path:line`. Be plain about what
you did not get to.
```

## 3. Report, then stop once

Save the report. Open the cited `path:line` of every item you are about to call safe to remove: a
subagent's mistakes arrive in the same confident voice as its findings (W13). Then tell the owner,
in this order and in their language:

1. **Remove now:** small, provable, no decision involved.
2. **Decided but not done:** dead code whose removal is already a task. Name the unticked task and
   what blocks it (usually a pending eye approval). This is a queue to clear, not a new finding.
3. **Defects exposed:** class C.
4. **Judgement calls worth a look,** with the "Owner decision: reconsider?" items last.

Change nothing yet. The owner picks; this is the one stop.

## 4. Before and after, for the eye

When the owner wants to see the picks ("xem thử", "before after"), spawn one `sonnet` agent:

- **Real renders, not a redrawn page.** Render "before" from the code as it is, make the smallest
  view-level edit per item in the working tree (uncommitted; unused members, copy constants and
  tests stay for now), render "after". No render path in the repo → skip the page, show the diff
  per item, and say the eye check moves to the running app.
- **The agent looks at every pair** and reports what moved. If a line it would remove is the only
  place a consequence is stated, it keeps the line and says so.
- **The page** is a copy of `~/.claude/templates/mock-shell.html` (UP8): axis `item` with one
  option per change, axis `view` (`after` | `before`). Presets: the full recommendation first, then
  `Trước` (`view: before`) and `Sau` (`view: after`), which name only `view` so keys 2 and 3 flip
  the current item in place. `notShown` lists items with no visible change (a closed menu). The
  stage shows the render plus a 2× crop of the changed region. It goes in the output folder beside
  `before/` and `after/`.

Then check the page loads, view the "after" of each judgement item yourself, open the page (W18),
and list per item what goes and any information that goes with it. Ask which items stay.

## 5. Land what was approved

- **Approved:** finish the removal: parameters, members and copy left unused, tests pinned to the
  removed text, user docs, and a dated line in the spec or ledger that the owner approved it on the
  render. Run the repo's gate, then `git commit -- <paths>`.
- **Not approved:** restore those hunks.
- **Out of reach here:** code waiting on a cut-over (W17) or an eye approval keeps waiting; report
  its task. An "Owner decision" item changes only on an explicit yes (W20).

Say in the result that the proof is renders, not the running app (W22).
