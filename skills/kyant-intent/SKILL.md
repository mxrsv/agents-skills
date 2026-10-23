---
name: kyant-intent
description: Find out what the user actually wants before any plan, spec or code exists, when an ask hits a W1 threshold with unclear intent or the user calls /kyant-intent. Runs Read → Ask → Dig → Stop → Lock, one question per turn with a guess attached, until ~95% confidence; ends in a restate the user confirms. Pre-decision only; to stress-test a plan or decision that already exists, use grilling.
---

# Kyant Intent

A short ask goes in; a confirmed statement of intent comes out. What people ask for and what they want differ: they ask for "a dashboard" because that is what one asks for, or "make it faster" with no number to hit. The cheapest moment to close that gap is before any plan, spec or code exists; once building starts, switching costs are real, the user rationalizes the wrong thing into "good enough", and the misfit gets locked in.

## When to call

- **Call** when a W1 threshold is hit and the intent is unclear: the ask is missing at least one of **who** the user is, **why** they want it, what **success** looks like, or the binding **constraint**. Also when the user invokes it: `/kyant-intent`, "interview me", "before we start, are we sure?"
- **Don't call** when the ask is unambiguous and self-contained ("rename this variable", "fix this typo"), the user asked for speed over verification, it is a pure information request ("how does X work?"), it is a mechanical operation (renames, formats, file moves), or you already have ≥95% confidence (run the Stop test before assuming you don't).
- **Live user only.** Never run in CI pipelines, scheduled runs, `/loop` or autonomous loops. There, flag the underspecified ask as a blocker instead of guessing.

## The loop

`Read → Ask → Dig → Stop → Lock`. Read opens the interview; Ask and Dig repeat each turn; Stop decides when to Lock.

### Read

Before asking anything, write your best read of what the user wants in **one sentence**, plus an honest confidence number (0–100%):

```
HYPOTHESIS: You want a way to answer "how are we doing?" in standup, and "dashboard" was the convention that came to mind.
CONFIDENCE: ~30% — missing: who it's for, what "metrics" means in context, and what success looks like
```

The number forces honesty. If you wrote a high number but cannot predict the user's reactions to the next three questions you would ask, the number is wrong; start at the level you can defend. Below ~70%, append on the same line what is still unresolved or missing, so the user knows what the interview needs to surface.

### Ask

One question per turn, with your guess attached:

```
Q:     <one focused question>
GUESS: <your hypothesis for the answer, with the reasoning that produced it>
```

Wait for the user to react before asking the next one.

**Why one at a time:**

- The user can't react to your hypotheses if you bury them in a list.
- Batches encourage skim-reading and surface answers.
- The third question often depends on the answer to the first; asking them together locks in the wrong framing.
- The user's energy for careful thinking is finite; spend it one question at a time.

**Why attach a guess:**

- The user reacts faster to a wrong guess than they generate an answer from scratch.
- It commits you to a hypothesis you can be visibly wrong about, which keeps you honest.
- It surfaces *your* assumptions, which is what the interview is meant to expose.

The risk is a polite user agreeing with your guess to be agreeable. Be visibly willing to be wrong, and now and then guess in a direction you expect the user to push back on.

### Dig

The most dangerous answers are the ones where the user says what a thoughtful answer *sounds like* rather than what they actually want. Watch for:

- best-practice talk without specifics ("I want it to be scalable", "clean architecture");
- deference to convention ("the way most apps do it", "the standard approach");
- "I should probably…", "I think I'm supposed to…", "good engineering practice says…";
- buzzwords as goals: "modern", "scalable", "robust" instead of a specific outcome.

When you hear one, ask:

> *"If you didn't have to justify this to anyone, what would you actually want?"*

That single question often does more work than the previous five.

### Stop

You are done asking when you can answer yes to:

> *Can I predict the user's reaction to the next three questions I would ask?*

If yes, you have shared understanding: stop and Lock. If no, ask the next question. This is a checkable test, not a vibe. It also has a floor: if several rounds pass and you still can't predict, that is information about the ask, not a reason to keep grinding. Tell the user: "I've asked X questions and I still can't predict your reactions. Something foundational is missing. Want to step back?"

### Lock

**Restate.** Write back what you now think the user wants, tight (5–8 lines), in their language where possible, so they can confirm or correct line by line:

```
Here's what I now think you want:

- Outcome:      <one line>
- User:         <one line — who benefits>
- Why now:      <one line — what changed>
- Success:      <one line — how we know it worked>
- Constraint:   <one line — the binding limit>
- Out of scope: <one line — what we're explicitly not doing>

Yes / no / refine?
```

`Out of scope` is non-negotiable. Half of misalignment is silent disagreement about what is *not* being built.

**Get an explicit yes.** These are **not** yes:

- "Whatever you think is best." → The user is delegating, so they don't have 95% confidence either. Re-ask with two concrete options framed as a choice.
- "Sounds good." → Ambiguous. Ask "Anything you'd refine?" Silence isn't confirmation.
- "Sure, let's go." → Often a polite exit, not an endorsement. Same follow-up.
- Silence followed by "okay let's start." → The user has given up on the interview, not converged. Stop and ask whether you've missed something.

If they correct you, fold the correction in and restate. Loop until the yes is explicit.

**After the yes:**

1. Deliver the confirmed statement of intent, with any last corrections folded in.
2. Read the yes:
   - **Yes plus a go-ahead** ("yes, làm luôn đi", "approve, build it"): the work is authorized. Continue into it in the same turn; do not ask again.
   - **Bare yes** ("yes", "đúng", "ok"): offer the next step in one line (implement now, or write the spec in `docs/specs/` first when W1/W2 applies) and **stop the turn**. Do not invoke tools or start downstream work until the user picks.

A bare yes confirms what the user wants, not that work starts now. Stopping there gives one checkpoint before files change; stopping after a go-ahead only adds a round trip.

## Output

The deliverable is the **confirmed statement of intent**: the restate with an explicit yes. Specs, plans and task lists are downstream and consume it. When the work needs a durable record, put the intent in the linked spec `docs/specs/YYYY-MM-DD-<slug>.md` (D0/D4); a plan links to that spec instead of copying it. Otherwise return it in chat. To stress-test a decision once it exists, use `grilling`.

## Real run

TinySift, 2026-10-22, condensed. The ask: "xử lý vấn đề về performance khi tinysift chạy nó chiếm khá nhiều CPU và RAM, cần điều tra tinysift đang run trên máy tôi trước". The user asked for an investigation first, so the agent measured before the first question: ~21% of one core with the window open, a spike on every 2 s refresh, and a hidden window that still refreshed its list.

```
Q:     When you saw the cost, were you looking at TinySift or working in another app?
GUESS: another app. Then the fix is to stop reading and redrawing when you are not looking.
User:  ngừng đọc khi không focus app đúng không
Agent: Not quite: stop when the window is not visible (hidden, minimized, fully covered,
       another Space), not on focus loss; on a second monitor you are still reading it.
       CONFIDENCE: ~65% — missing: the trade-off on return, and what counts as fixed.
Q:     Stopping while hidden leaves a gap in the 5-minute chart. Acceptable?
GUESS: yes; you open it to see the machine now, not five minutes ago.
User:  chấp nhận, ẩn thì ngừng hẳn
Q:     Also cut the redraw cost while the window is visible, or only the hidden case for now?
GUESS: hidden case only; the visible redraw cost is a separate, riskier UI job.
User:  theo guess
Agent: <restate; Out of scope: redraw cost while visible>
User:  yes làm luôn đi        ← yes plus a go-ahead: build in the same turn
```

Hidden CPU dropped from ~21% to 0.7% of one core and RAM from ~205 MB to 56 MB. The scope cut and the focus-vs-visibility correction both landed before any code changed.

## Traps

| Trap | Do instead |
|---|---|
| "Asking too many questions wastes their time." | 4–6 targeted questions cost little; building the wrong thing costs far more, and the user bears it. |
| "I'll figure it out as I build." | Discovery after code exists is rework; switching costs are ~10x what they are now. |
| Accepting "whatever you think is best" as an answer | It is delegation, not decision. Re-ask with two concrete options as a choice. |
| "I should give them several options to pick from." | Options work when the user knows what they want and is choosing between trade-offs. Before that, listing options widens the search; asking narrows it. |
| "If I attach my guess, I'm leading them." | Leading is the point; reacting beats generating from scratch. The risk is sycophancy, so stay visibly willing to be wrong. |
| "We've talked enough, I get it." | Run the Stop test. If you can't predict their reaction to the next three questions, you don't get it yet. |
| "The user said yes, we're done." | A yes after a vague restate or an open-ended "sounds good" is hollow. Restate concretely and re-confirm. |
| Three or more questions in one message | That is batching, not interviewing. Ask one. |
| A question without your guess | That is surveying, not committing. Attach the guess. |
| Questions framed as "what would be best practice?" | Ask what they actually want. |
| Accepting a sophistication-signaling answer ("scalable", "clean", "modern") | Run the Dig probe before accepting it. |
| Three or more rounds without confidence visibly rising | You are asking the wrong questions. Step back and reframe. |
| A confidence number below ~70% with no reason | Name what is missing; the user can't close a gap they can't see. |
| Producing a spec, plan or task list, or saving the intent doc, before an explicit yes | The artifact implies a yes the user didn't give. Wait for the yes. |
| Tools or downstream work right after a bare yes, or asking again after a yes that already said go | Follow the Lock rule for reading the yes. |
| Skipping `Out of scope` in the restate | Silent disagreement about non-goals is half of misalignment. Always include it. |

## Self-check

- [ ] Read: the first turn stated a hypothesis with a confidence number
- [ ] Every confidence number below ~70% came with a one-line reason
- [ ] Ask: one question per turn, each with the agent's guess attached
- [ ] Dig: the "didn't have to justify it" probe ran on any sophistication- or convention-signaling answer
- [ ] Stop: at the stop point, the agent could predict reactions to the next three questions
- [ ] Lock: the restate covered Outcome / User / Why now / Success / Constraint / Out of scope
- [ ] Lock: the user confirmed with an explicit yes (not "whatever you think", not "sounds good", not silence)
- [ ] After the yes: continued only if it carried a go-ahead; otherwise delivered the intent, offered the next step and stopped the turn
- [ ] Any handoff (spec, plan or `grilling`) was framed in terms of the confirmed intent, not the original underspecified ask
