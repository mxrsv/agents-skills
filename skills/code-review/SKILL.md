---
name: code-review
description: Parallel code review — dispatches code-reviewer (precision) + review-recall (recall) concurrently, then review-adjudicator merges them into one triaged report. Findings-first. Verdict APPROVE/WARNING/BLOCK.
---

# Code Review

Three-agent pipeline. Do not self-review.

```
code-reviewer ─┐
               ├─→ review-adjudicator ─→ one report + one verdict
review-recall ─┘
```

Runs on every review. On a non-sensitive diff, `review-recall` self-triages and returns in
one line, so the recall side stays cheap; adjudication is skipped when there's nothing to
verify (see step 3).

## 1. Prepare payload

- **OBJECTIVE** — what this code implements (1-2 sentences)
- **SPEC/REQUIREMENTS** — approved spec or user's original request
- **WORKING DIRECTORY** — absolute path to project root
- **CHANGED FILES** — file paths only, NOT contents. If not supplied, derive with
  `git diff --name-only HEAD` (add `--staged` for staged work; fall back to `git log --oneline -5`
  if there is no diff).
- **ITERATION** — X/3 (default 1/3)
- **PREVIOUS FINDINGS** — if iteration >1, fixed/outstanding summary

## 2. Dispatch both reviewers IN PARALLEL

Send BOTH in a SINGLE message (two Agent tool calls) so they run concurrently. Give each the
SAME neutral payload. Do NOT paste file contents — each has Read/Grep/Glob/Bash. Do NOT prime
specific suspected bugs: each agent must investigate independently, and priming the recall pass
with the answer invalidates it.

```
Two Agent tool calls in ONE message:

  subagent_type: "code-reviewer"          subagent_type: "review-recall"
  prompt: |                                prompt: |
    OBJECTIVE: {objective}                   OBJECTIVE: {objective}
    SPEC/REQUIREMENTS: {spec}                SPEC/REQUIREMENTS: {spec}
    WORKING DIRECTORY: {root}                WORKING DIRECTORY: {root}
    CHANGED FILES: {paths}                   CHANGED FILES: {paths}
    ITERATION: {X}/3                         ITERATION: {X}/3
    {if >1: PREVIOUS FINDINGS: ...}          {if >1: PREVIOUS FINDINGS: ...}
    Review this code. Follow your            Review this code. Follow your
    review process.                          review process.
```

## 3. Adjudicate

**Skip-fast:** if `review-recall` returned `0 candidates` (non-sensitive diff) AND
`code-reviewer` has nothing above LOW, there is nothing to verify or dedup — present
`code-reviewer`'s report directly and go to step 4. Do not spend an adjudicator turn on a no-op.

Otherwise dispatch `review-adjudicator` with the working directory and BOTH full reports:

```
Agent tool:
  subagent_type: "review-adjudicator"
  prompt: |
    WORKING DIRECTORY: {root}

    PRECISION REPORT (code-reviewer):
    {full code-reviewer output, verbatim}

    RECALL REPORT (review-recall):
    {full review-recall output, verbatim}

    Adjudicate: verify each recall candidate against the repo, drop refuted ones, dedup
    against the precision report, emit one report + one verdict. Follow your process.
```

## 4. Handle verdict

Present the single adjudicated report (one verdict). Then:

- **APPROVE** → present report. Done.
- **WARNING** → present report. User decides to merge or fix.
- **BLOCK** → fix approved issues → re-run from step 2 (max 3 iterations).
- **3 iterations exhausted** → escalate to human.
