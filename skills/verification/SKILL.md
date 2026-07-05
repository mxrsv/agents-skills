---
name: verification
description: Use before claiming work is done, fixed, or passing. Requires fresh evidence from commands, tests, builds, or other concrete checks in the current state.
---

# Verification

Use this skill whenever a claim needs evidence.

## Workflow

1. Identify the claim.
2. Choose the command or check that proves it.
3. Run it fresh.
4. Read the actual output and exit code.
5. State the result accurately.

## Evidence Examples

- test command output
- lint or typecheck results
- build success
- manual reproduction no longer failing
- diff inspection for review-only tasks

## Rules

- Do not say `should pass`, `probably works`, or equivalent.
- Re-verify after additional edits.
- If full verification is too expensive or unavailable, say exactly what was and was not checked.
