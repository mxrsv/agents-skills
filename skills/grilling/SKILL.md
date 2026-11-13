---
name: grilling
description: Grill the user relentlessly about a plan, decision, or idea. Use when the user wants to stress-test their thinking, or uses any 'grill' trigger phrases. For pre-decision intent extraction, use interview-me.
---

Work a plan, decision or idea through until you and the user share one understanding, spending as few of their decisions as you can. Be relentless about the tree, not about the user. Map this as a **design tree**: every decision branches into the decisions that hang off it.

Work the tree in **rounds**. The **frontier** is every decision whose prerequisites are already settled: the ones you can settle _now_ without guessing at answers you haven't heard yet. Split the frontier in two:

- **Ask**, at most 3 per round: decisions where a wrong answer is hard to undo, or that only the user knows (taste, priority, money, what is out of scope). When more than 3 qualify, ask the 3 that unblock the most; the rest wait for the next round.
- **Settle yourself** every other frontier decision with your recommended answer, and list it under `Tự chốt`, one line each.

Then wait for the user's reply before the next round.

Why: across 27 sessions (2026-10-30 to 2026-11-13) a round asked 4 questions on median and up to 10, and the owner's replies took up about one question in eight; the rest were read for nothing.

Format a round like so:

```
❓ **Q1** - **<question title>**: <question body, including the choices>

➡️ <your recommended answer>

---

❓ **Q2** - **<question title>**: <question body, including the choices>

➡️ <your recommended answer>

---

**Tự chốt** (sửa dòng nào sai):
- S1 <decision>: <what you chose>
- S2 <decision>: <what you chose>
```

Reading the reply:

- `ok` takes every ➡️.
- A question or `Tự chốt` line the reply does not mention takes its recommended answer. Record it in the ledger as the recommended option, accepted.
- A reply that asks back ("bạn nghĩ nên theo loại nào?") or says they have no view hands you the decision: take the ➡️, say so in one line, move on. Do not re-ask it.

Each round the user answers reshapes the tree: settled decisions push the frontier outward and unblock questions that depended on them. Recompute the frontier and run the next round. A question whose answer depends on another question still open in this round belongs to a _later_ round, not this one.

Finding _facts_ is your job, never the user's. When a frontier question needs a fact from the environment (filesystem, tools, etc.), dispatch a sub-agent to find it; don't ask the user for anything you could look up yourself. Don't block on it: a running exploration is an unsettled prerequisite, so only the questions downstream of it wait for the sub-agent to report; run the rest of the frontier now. The decisions on the Ask side are the user's: put each to them and wait.

The session is done when the frontier is empty: every branch of the design tree visited, each decision either answered by the user or listed under `Tự chốt`, nothing left silently assumed. Show the ledger once. When what follows is reversible (a mock, a spec draft, local code), continue into it in the same turn; wait for a confirmation only before something irreversible or outward-facing.

When it is done, write the settled decisions to a decision ledger, one numbered line per decision, quoting what the user chose or marking the line `tự chốt`. Save it where the downstream spec will link to it. Every later artifact cites ledger IDs: the spec's requirements, the plan's tasks, any build prompt or subagent brief. Before the spec is committed, check that every ledger line maps to a requirement and an acceptance check (W20).
