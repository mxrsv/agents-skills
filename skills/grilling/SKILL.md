---
name: grilling
description: Grill the user relentlessly about a plan, decision, or idea. Use when the user wants to stress-test their thinking, or uses any 'grill' trigger phrases. For pre-decision intent extraction, use interview-me.
---

Interview the user relentlessly until you reach a shared understanding. Map this as a **design tree**: every decision branches into the decisions that hang off it.

Work the tree in **rounds**. The **frontier** is every decision whose prerequisites are already settled: the questions you can ask _now_ without guessing at answers you haven't heard yet. Ask at most 3 per round: the decisions a wrong answer makes hard to undo, or that only the user knows (taste, priority, money, scope). Settle the rest of the frontier yourself with your recommended answer and list it under `Tự chốt`; the owner answers about one question in eight, so every extra one is reading for nothing. Ask the whole frontier only when the user asks for it. Number each question and give your recommended answer. Then wait for the user's answers before the next round.

Format a round like so:

```
❓ **Q1** - **<question title>**: <question body, might be multiple paragraphs, including multiple choices>

➡️ <your recommended answer>

---

❓ **Q2** - **<question title>**: <question body, might be multiple paragraphs, including multiple choices>

➡️ <your recommended answer>

---

**Tự chốt** (sửa dòng nào sai):
- S1 <decision>: <what you chose>
```

`ok`, a question the reply skips, and a question the user asks back all take the ➡️: record it as recommended, accepted, and do not re-ask.

Each round the user answers reshapes the tree: settled decisions push the frontier outward and unblock questions that depended on them. Recompute the frontier and ask the next round. A question whose answer depends on another question still open in this round belongs to a _later_ round, not this one.

Finding _facts_ is your job, never the user's. When a frontier question needs a fact from the environment (filesystem, tools, etc.), dispatch a sub-agent to find it; don't ask the user for anything you could look up yourself. Don't block on it: a running exploration is an unsettled prerequisite, so only the questions downstream of it wait for the sub-agent to report; ask the rest of the frontier now. The asked _decisions_ are the user's: put each to them and wait.

The session is done when the frontier is empty: every branch of the design tree visited, nothing left silently assumed. Show the ledger, then continue into reversible work in the same turn; wait for a confirmation only before something irreversible or outward-facing.

When it is done, write the settled decisions to a decision ledger, one numbered line per decision, quoting what the user chose or marking it `tự chốt`. Save it where the downstream spec will link to it. Every later artifact cites ledger IDs: the spec's requirements, the plan's tasks, any build prompt or subagent brief. Before the spec is committed, check that every ledger line maps to a requirement and an acceptance check (W20).
