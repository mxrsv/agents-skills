---
name: kyant-grill
description: Grill the owner about a plan, decision or idea in rounds that are cheap to answer - confirms the intent as the first question, then asks each round through the AskUserQuestion dialog with the recommendation first, so a right guess costs one Enter. Use when the owner calls /kyant-grill or asks for a fast grill ("grill nhanh"). `grilling` is the original text-format version; for an ask too vague to state, use kyant-intent.
---

Interview the user relentlessly until you reach a shared understanding. Map this as a **design tree**: every decision branches into the decisions that hang off it.

The **root** of the tree is the intent: the outcome, how you will know it worked (a real-world check, not a proxy such as a test count), and what is out of scope. Settle it inside round one, never as a separate interview:

- **You can write every line without guessing**: ask it as the first question of round one, beside the frontier. This is the one exception to the ordering rule below. State the three lines in the question, with "Yes, that is it" as the recommended option. A correction voids the answers that depended on it: recompute the frontier and re-ask only those.
- **A line is a guess** (also who it is for, why now, or the binding constraint, when the tree depends on them): ask the guessed lines alone first, one question each, your guess as the recommended option. A single yes over a guessed root is hollow.
- **The user says it is off**: dig only the line that is off, one question at a time with your guess attached. Do not start the tree on an unconfirmed root.
- **Skip the root** when a confirmed intent, a spec or a written plan is already in the conversation: read the root from it.

Work the tree in **rounds**. The **frontier** is every decision whose prerequisites are already settled: the questions you can ask _now_ without guessing at answers you haven't heard yet. Ask the whole frontier in one round, each question with your recommended answer. Then wait for the user's answers before the next round.

A round must be cheap to answer: accepting a recommendation takes no typing, and a question reads in a few seconds. Write each question in one or two sentences and put the trade-off in the options, not in the body.

**When `AskUserQuestion` is available**, ask the round through it:

- At most 4 questions per call. A larger frontier takes several calls in a row, the decisions that reshape the tree most first.
- 2-4 options per question, your recommendation first with "(Recommended)" at the end of its label. "Other" is added for you; never list it.
- The dialog may be all the user sees, so text you wrote before the call does not count. Each question stands on its own and names what you found that it depends on; each option's `description` says what choosing it leads to.
- Labels name the choice in 1-5 words ("Keep one table", never "A" or "Option 1"), because the ledger quotes them. `header` is at most 12 characters.
- Use `multiSelect` when the choices do not exclude each other, and `preview` when the options are layouts, code or config to compare.
- A question with no enumerable options, or one that does not fit two sentences, goes in the text format below, once the dialog is answered.

**Otherwise** (Codex, Cursor, or the question does not fit the dialog), format the round like so:

```
❓ **Q1** - **<question title>**: <question, one or two sentences>
a. <option>: <what it leads to> ➡️ recommended
b. <option>: <what it leads to>

---

❓ **Q2** - **<question title>**: <question, one or two sentences>
a. <option>: <what it leads to>
b. <option>: <what it leads to> ➡️ recommended

Reply `ok` to take every ➡️, or only the ones you change (`2a`).
```

A question the reply does not mention takes its ➡️; record it in the ledger as the recommended option, accepted.

Each round the user answers reshapes the tree: settled decisions push the frontier outward and unblock questions that depended on them. Recompute the frontier and ask the next round. A question whose answer depends on another question still open in this round belongs to a _later_ round, not this one.

Finding _facts_ is your job, never the user's. When a frontier question needs a fact from the environment (filesystem, tools, etc.), dispatch a sub-agent to find it; don't ask the user for anything you could look up yourself. Don't block on it: a running exploration is an unsettled prerequisite, so only the questions downstream of it wait for the sub-agent to report; ask the rest of the frontier now. The _decisions_ are the user's: put each to them and wait.

The session is done when the frontier is empty: every branch of the design tree visited, nothing left silently assumed. Do not act on it until the user confirms you have reached a shared understanding.

When it is done, write the settled decisions to a decision ledger, one numbered line per decision, quoting what the user chose. The confirmed root is the first entry. Save it where the downstream spec will link to it. Every later artifact cites ledger IDs: the spec's requirements, any build prompt or subagent brief. Before the spec is committed, check that every ledger line maps to a requirement and an acceptance check (skill `decision-traceability`).
