---
name: click-path-audit
description: Trace every user-facing button or touchpoint through its full state-change sequence to find bugs where functions work individually but cancel each other out, leave the wrong final state, or leave the UI inconsistent. Use when a button "does nothing", after a shared-state store (Zustand, Redux, context) action changed, after a refactor touching shared state, or before release on critical flows. Not for API shape bugs, styling or performance.
---

# Click-path audit

Find bugs that typecheck and static reading miss: a handler whose calls are each correct but undo each other, race, or never reach the state the button label promises.

Source: adapted from ECC `click-path-audit` (affaan-m/ECC), trimmed.

## Method

For every interactive touchpoint in scope (`onClick`, `onSubmit`, `onChange`, toggles):

1. **Map the stores first.** For each store action or setter in scope, write `action → sets {…} resets {…}`. Flag every **dangerous reset**: an action that clears state it does not own. Do this once, before auditing any handler; it is the shared reference.
2. **Trace the handler in call order.** For each call: what state it reads, writes, and resets as a side effect.
3. **Compare the final state with the button label.** A later call that undoes an earlier one, or a final state the label does not promise, is a bug.

## Bug patterns

| Pattern | Shape |
| --- | --- |
| Sequential undo | `setA(true)` then `setB(null)` where `setB` resets `A` |
| Async race | two `fetch().then(set…)` writing the same field; the last to resolve wins |
| Stale closure | `setCount(count + 1)` twice in one handler adds 1, not 2 |
| Missing transition | "Save" only validates, "Delete" only sets a flag, the endpoint is gone |
| Conditional dead path | the `if` guarding the real work is always false at that point |
| `useEffect` interference | button sets `x`, an effect watching `x` resets it |

Example: "New Email" called `setComposeMode(true)` then `selectThread(null)`; `selectThread` also set `composeMode: false`, so the button did nothing.

## Report

One block per bug, ranked CRITICAL / HIGH / MEDIUM / LOW:

```
CLICK-PATH-NNN [severity]
  Touchpoint: <label> in <file:line>
  Pattern:    <name from the table>
  Trace:      1. <call> → sets {…}   2. <call> → RESETS {…}  ← conflict
  Expected:   <what the label promises>
  Actual:     <final state>
  Fix:        <specific change>
```

Mark anything you could not trace as `unverified`; do not guess. Each confirmed bug gets a regression test (`tdd`).

## Scope

The audit is expensive; scope it to the question:

- **Single page**: after building a page or when a user reports a dead button.
- **Store-focused**: after changing a store action, audit all its callers.
- **Whole app**: before release or after a major refactor; one agent maps all stores first, then one agent per page using that map (`run-agents`).

Use `diagnosing-bugs` first for crashes, wrong response shapes or missing endpoints; this skill is for "everything works yet the UI is wrong".
