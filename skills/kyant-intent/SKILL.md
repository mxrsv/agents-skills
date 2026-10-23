---
name: kyant-intent
description: Turn a short, loose ask into a confirmed statement of intent before anything changes. One question per turn, each with a grounded guess, until the agent can predict the user's next answers; ends in a restate the user approves. Works for any ask whose intent is unclear (a feature, a UI direction, a workflow or setup change, a roadmap, a product bet). Not for stress-testing a decision that already exists (use grilling).
---

# Kyant Intent

Adapted from [Addy Osmani's interview-me](https://github.com/addyosmani/agent-skills/blob/main/skills/interview-me/SKILL.md) (MIT), reshaped around how this user works: short dictated prompts, one-token answers, mocks over prose for taste.

The ask is short on purpose. The agent fills the gap by reading what already exists, then asks only what the code, docs and memory cannot answer. The deliverable is a restate the user says yes to; specs, plans and code come after.

## When to use

- The user types `/kyant-intent`, usually with a one-line ask.
- The ask names a direction but not who it serves, why now, what done looks like, or the binding limit.

Skip it when the ask is already clear (just do the work) or is a pure information question. Never run it non-interactively (CI, scheduled jobs, `/loop`): report the missing intent as a blocker instead of guessing.

## The loop

### 0. Ground before the first question

Read the repo instructions, related specs and plans, the code the ask touches, memory about the user's taste and past decisions, and live state when the ask is about something running. A short prompt works only because this step supplies what the user left out. Keep it proportionate: enough to make the first guess specific. Never ask what a file can answer.

### 1. Open with a read

One sentence for what the user wants, plus an honest confidence number. Below ~70%, name what is missing on the same line.

```
HYPOTHESIS: You want TinySift to stop costing CPU while nobody is looking at it.
CONFIDENCE: ~40% — missing: when you saw the cost, and what number counts as fixed
```

If you cannot predict the user's reaction to your next three questions, the number is too high.

### 2. One question per turn, guess attached

```
Q:     <one question>
GUESS: <your answer for them, the reason, and what it rests on>
```

- **One per turn.** The next question usually depends on this answer, and a batch gets skimmed.
- **Ground the guess.** Cite the file, spec line, measurement or memory it comes from. Tag each fact claim as verified (checked this session) or hypothesis; a wrong fact inside a guess gets accepted along with the guess.
- **Options for concrete forks.** When the choice is between known alternatives, offer (a)/(b)/(c) and guess one, so the user can answer "A". Keep open questions for who, why and success, where options would plant an answer.
- **Be visibly willing to be wrong.** Now and then guess in a direction you expect the user to push back on.

### 3. Branch when words are the wrong medium

- **Taste or visual direction** (look, layout, motion): build a quick mock with 2–3 directions in `~/scratch/<repo>/` and let the user pick by eye. The pick answers the question; resume the loop.
- **Needs outside evidence** ("how do others do this?"): run the research or scout, report the finding in a few lines, then re-ask the pending question.
- **Tangent** (the user asks something unrelated): answer briefly, re-ask the pending question once, then wait. Do not repeat it on every later message.
- **Pivot** (an answer changes the frame): drop the confidence number, say which earlier answers it invalidates, and continue from the new frame.

### 4. Probe "want vs. should want"

Answers that sound like best practice ("scalable", "clean", "the standard way", "I should probably…") hide the real want. Ask:

> *"If you didn't have to justify this to anyone, what would you actually want?"*

### 5. Stop test

Stop asking when you can predict the user's reaction to the next three questions. If several rounds pass and you still cannot, say so: "I've asked N questions and still can't predict your answers. Something foundational is missing. Step back?"

### 6. Restate

Write it back in the user's words, one line each, so they can correct line by line:

```
- Outcome:      <one line>
- User:         <who benefits>
- Why now:      <what changed>
- Success:      <how we know it worked>
- Constraint:   <the binding limit>
- Out of scope: <what we are explicitly not doing>
```

`Out of scope` is mandatory; silent disagreement about non-goals is half of misalignment. Tag lines the user accepted only by taking your guess with `(agent's pick)`, so they can revisit them.

### 7. The yes

**Answers vs. delegation.** "theo guess", "A" or "đúng" in reply to a concrete proposal accepts something specific: take it as answered. "Whatever you think" with nothing on the table is delegation: re-ask as a choice between two concrete options.

**The restate gate.** Only an explicit yes to the restate ends the loop. "Sounds good" (ask what to refine) and "sure, let's go" said to escape the interview (ask whether something is missing) are not yes. Fold corrections in and restate until the yes is explicit.

**After the yes:**

- **Yes plus a go-ahead** ("yes, làm luôn đi", "approve, build it"): the work is authorized. Continue in the same turn; do not ask again.
- **Bare yes** ("yes", "đúng", "ok"): deliver the confirmed intent, offer the next step in one line (implement now, or write the spec in `docs/specs/` first when W1/W2 applies) and **stop the turn**. Do not invoke tools or start downstream work until the user picks.

A bare yes confirms what the user wants, not that work starts now.

## Output

A confirmed statement of intent. When the work needs a durable record, it goes in the linked spec `docs/specs/YYYY-MM-DD-<slug>.md` (D0/D4); a plan links to that spec instead of copying it. Otherwise it stays in chat. To stress-test the decision afterwards, the user can run `grilling`.

## Example

A real run, condensed (TinySift, 2026-10-22). Ask: "xử lý vấn đề performance khi tinysift chạy, chiếm khá nhiều CPU và RAM".

```
(ground)    Measured first: ~21% of one core with the window open, a spike on every
            2 s refresh, and the hidden window still refreshing its list.
HYPOTHESIS: You want TinySift to stop burning CPU while you are not looking at it.

Q:     When you saw the cost, were you looking at TinySift or working in another app?
GUESS: another app. Then the fix is to stop reading and redrawing when you are not looking.
User:  ngừng đọc khi không focus app đúng không
Agent: Not quite: stop when the window is not visible (hidden, minimized, covered,
       another Space), not on focus loss; on a second monitor you are still reading it.
       CONFIDENCE: ~65% — missing: the trade-off on return, and the target number.
Q:     Stopping while hidden leaves a gap in the 5-minute chart. Acceptable?
GUESS: yes; you open it to see the machine now, not five minutes ago.
User:  chấp nhận, ẩn thì ngừng hẳn
Q:     Also cut the cost while the window is visible, or only the hidden case for now?
GUESS: hidden case only; the visible redraw cost is a separate, riskier UI job.
User:  theo guess
Agent: <restate, Out of scope: redraw cost while visible>
User:  yes làm luôn đi        ← yes plus a go-ahead: build in the same turn
```

Hidden CPU went from ~21% to 0.7% of one core and RAM from ~205 MB to 56 MB. The scope cut and the focus-vs-visibility correction both happened before any code changed.

## Red flags

- Asking something a file, spec or memory already answers
- Two or more questions in one message
- A question without a guess, or a guess that presents an unchecked fact as verified
- A confidence number below ~70% with no reason
- Three rounds without confidence rising: reframe instead of grinding
- Debating taste in prose when a mock would settle it
- Re-asking the pending question on every message after a tangent
- Accepting "whatever you think" with nothing on the table
- Accepting a buzzword answer ("scalable", "clean", "modern") without the "didn't have to justify it" probe
- A restate without `Out of scope`
- Writing a spec, plan or code before the restate gets an explicit yes
- Starting tools or downstream work after a bare yes, or asking again after a yes that already said go

## Verification

- [ ] Grounding came before the first question; no question asked what a file could answer
- [ ] The first turn had a hypothesis and confidence; every number below ~70% had a reason
- [ ] One question per turn, each with a grounded guess; fact claims tagged verified or hypothesis
- [ ] Taste questions, if any, went to a mock instead of prose
- [ ] The "didn't have to justify it" probe ran on any buzzword or convention answer
- [ ] The restate had all six lines, including `Out of scope`, with agent picks tagged
- [ ] The yes to the restate was explicit; after it, work continued only on a go-ahead, otherwise the turn stopped
- [ ] At the stop, the next three reactions were predictable
