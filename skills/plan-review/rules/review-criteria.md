# Review Criteria — Reviewer Checklist

## What to check

| Area | What to verify |
|---|---|
| File paths | `[file](path)` links resolve; `file.ts:10-20` refs match real content |
| Signatures | Component/function calls match real prop/arg types; missing required = HIGH |
| Architecture | Matches approved spec; plans don't contradict; dep order correct |
| Verify gates | Each task has concrete command; end-of-plan gates executable in order |
| Test coverage | Happy + edge + error paths; contract/E2E where needed |
| Codebase state | Check git status; plan acknowledges partly-executed files |
| Effort | Task-level realistic; total matches scope |
| i18n / a11y / security | Strings use translation keys; a11y stated; security gate for sensitive ops |

## Output format

```
[PLAN REVIEW — {name} — Iteration X/3]

EXECUTABLE: Yes | No | Partial
Blockers: N or None

CRITICAL (N): / HIGH (N): / MEDIUM (N): / LOW (N):
  [X1] {title} — {file:line}
       {description}
       Fix: {concrete action}

POSITIVE (N, optional):

## Summary
| Severity | Count |

{1-paragraph verdict}
```

## Iteration 2+ rules

1. Verify each previous finding explicitly: "DAT" (fixed with evidence) or "NOT DAT" (still issue).
2. Fresh-eyes scan for NEW issues introduced by fixes.
3. Compare severity trend: convergent (decreasing) = healthy; divergent = escalate human.

## Rules & anti-patterns

| Don't | Do |
|---|---|
| Summarize plan | Flag specific issues with line refs |
| "Looks good" without evidence | List things checked, cite grep/line |
| Pad findings with positives | POSITIVE separate, optional |
| Fix directives before all findings | Findings first, then `Fix:` per item |
| Re-list same finding without verification | Mark "verified from iter N" or "new in N" |
| Downgrade HIGH → MEDIUM to pass | Report honestly; human decides scope |
