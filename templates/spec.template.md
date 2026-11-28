# {{Title: the outcome, not the task}}

Started: {{YYYY-MM-DD}} · Owner: {{owner}} · Repos: {{repo → checkout path, one per repo}}

{{Copy to docs/specs/YYYY-MM-DD-<slug>.md. English body and headings. Delete a section that does not apply instead of leaving it empty. Update in place; never append a second account of a changed decision.}}

## Goal

{{One paragraph: what is true when this is done, and for whom.}}

## Scope

- {{What this spec covers.}}

## Out of scope

- {{What it does not cover. Check each line against Decisions: a line that narrows a decision needs the owner's explicit yes.}}

## Decisions

| ID | Owner's decision (quoted) | Requirement | Acceptance check |
| --- | --- | --- | --- |
| {{D1}} | {{"exact words or the chosen option"}} | {{what the build must do}} | {{AC number}} |

{{Every decision the owner settled gets a row (skill `decision-traceability`). A decision with no row is a defect.}}

## Inferred, not decided

| Line | Source |
| --- | --- |
| {{sentence with no owner decision behind it}} | {{mock / app convention / agent's choice}} |

{{Does not block the build. Ask in one batch only the lines that touch data deletion, money or a hard-to-reverse contract.}}

## Behavior and error cases

- {{User flow, API/CLI behavior or UI states, including empty, loading, failure and worst-case data.}}

## Acceptance criteria

1. {{A runnable check: test, typecheck, build exit code, or screenshot beside the mock. "Make it like X" → side-by-side with X per surface.}}

## Constraints

- {{Performance, platform, compatibility or contract limits.}}

## Open questions

- {{Unresolved, with the recommended answer. Remove when settled and move the answer to Decisions.}}

## Status

- Done: {{…}}
- Remaining: {{…}}
- Checkout / branch / PR: {{…}}
- Checks run: {{command → result}}
- Blockers: {{none / …}}

{{Update at every handoff. At freeze: add the completion date and the implementation commits or PR links.}}

/goal {{one condition built from the acceptance criteria}}
