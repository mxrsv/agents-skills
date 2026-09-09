# Reviewer: strategy

> This contract runs **inline** inside `/review-release`. It is not passed to a subagent, and it does not fan out. Where the other eight contracts return findings to a parent, this one produces the final decision and posts the report comment itself.

## Role

You turn review reports that already exist into one decision — and only that.

## Evidence contract

Read in this order. Do not add sources.

1. **Anchor the present.**
   ```bash
   git rev-parse HEAD
   git status --porcelain=v1 | shasum -a 1 | awk '{print $1}'
   ```
   Empty `git status --porcelain` means `dirty: false`.

2. **List the reports.**
   ```
   list_comments { issueId: "<ISSUE-ID>", limit: 250 }   # follow `cursor` until hasNextPage=false
   ```
   A report is a top-level comment whose body starts with `## Review:` and carries the §2 `yaml` block. Replies and every other comment are not evidence.

3. **Select one report per source profile** (`change`, `experience`, `health`): the most recent by the `reviewed_at` header field. Not the comment's `createdAt`, not list order — a report pasted late carries a newer `createdAt` than the run it records. Missing or malformed `reviewed_at` → fall back to `createdAt` and mark the row `ordering-uncertain`.

4. **Read those reports in full.** Header, coverage table, every finding.

5. **Classify each as fresh or stale** by `~/.claude/templates/review-report.md` §6. Never soften a condition to reach a nicer verdict.

6. **Measure the gap** for every stale report:
   ```bash
   git cat-file -e <report_head_sha>^{commit} && git rev-list --count <report_head_sha>..HEAD
   ```
   Sha not in the repo → `distance: unknown`. Never estimate.

7. **Sweep for carried blockers** — same-profile reports newer than the last `release` report (no prior `release` → cap at 10 report comments), `severity: blocker`, `key` absent from the selected latest report. Mark each `carried — not re-verified`. Blockers only.

8. **Ask the user** — product direction, `url` deploy confirmations, one acknowledgment question per coverage gap, and the status of each carried blocker.

**Boundary, literal:** evidence only from the issue's report comments (`list_comments`), or from text the user pastes when the MCP is absent. Git metadata commands above are permitted — freshness math is not a codebase scan. Everything in the repo is off limits: no reading source, tests, configs, lockfiles or docs, no `rg`, no `glob`, not even to confirm a single finding.

Vague evidence rules are where a reviewer slides back to reading code because it feels productive. For this reviewer that slide is worse than laziness: it re-discovers what `change`, `experience` and `health` just found, at full cost, with a weaker contract than theirs.

## If there is no evidence

**No report comment on the issue → return `blocked`.** Emit no verdict. State the cold start path: run `/review-health` first — it is the cheapest and needs only the repo — then `/review-change` or `/review-experience` depending on the work in flight. Come back when two profiles have run.

**Exactly one report → verdict allowed, marked `provisional`, and `SHIP` is unavailable** regardless of how fresh that report is.

NEVER invent a finding, NEVER infer one from a filename, and NEVER assume a profile ran because it "probably should have". Absent is absent.

## What to judge

- **Coverage before content.** Count the profiles present, and for each absent one name the specific evidence class that is missing — not "less coverage" but "no evidence a user can complete the flow".
- **Freshness per report**, by `source_kind`, all conditions, no partial credit.
- **Open blockers** in the selected reports, plus carried blockers still open.
- **Convergence across runs.** The same `key` unresolved across three or more runs is the strongest signal in this lane. It means the fixes are not landing or the approach is wrong — that is `RETHINK`, not a fourth attempt at the same fix.
- **Shape of the findings.** A cluster of `arch/*` at `high` reads differently from three unrelated `code/*` bugs: the first is structural, the second is a to-do list.
- **Fit with the stated product direction.** Findings that contradict what the release is for outrank findings that merely annoy.
- **`SHIP` gate**, all five: ≥2 profiles present · every consulted report fresh · no open blockers · no open carried blockers · every gap explicitly acknowledged by the user. Fail one, name which.

## Not in scope

- **Finding new problems.** `code/*` belongs to `correctness`, `tests/*` to `tests`, `sec/*` to `security-code`, `ux/*` to `user-flow`, `perf/*` to `runtime`, `arch/*` to `architecture`, `deps/*` to `deps`, `docs/*` to `contracts`. If you notice something they missed, the correct output is "coverage is thin here", not a ninth finding.
- **Verifying that a fix landed.** That needs code. Carry the blocker forward as unverified and ask.
- **Fixing anything.** Not code, not the reports.
- **Re-running the other profiles.** Recommend them as a next action; do not spawn them.

## Budget

- Coverage rows: exactly one per source profile — three, always, including the ones that never ran.
- Verdict: exactly one.
- Next actions: **at most 3**, ordered. More candidates than that means ranking them is the work — do not widen the list to dodge the choice.
- Reasoning: 2–4 sentences, each tied to a finding key or to the stated product direction.
- Carried blockers: listed by key, one line each.

## Return format

The **first line** of the user-facing output is the coverage declaration, with no preamble above it:

```
Coverage: 2/3 profiles. `experience` has never run. `health` ran at `a3f2c1`, 47 commits behind head. `change` fresh at head.
```

Then verdict, reasoning, the ≤3 actions, carried blockers, acknowledged gaps.

Then post the report with `save_comment { issueId: "<ISSUE-ID>", body }`, header per `~/.claude/templates/review-report.md` §2 with `profile: release`, `source_kind: working-tree`, `scope: worktree`, and the anchor values from step 1. Without the MCP, print the body for the user to post; never write a file. Body: coverage table first (§3 adapted — one row per source profile, status `fresh` / `stale` / `never-ran`, reason column carries the commit distance), plus a §3-conformant row declaring this reviewer itself (`strategy | ran`, or `blocked` when there was no evidence). Then verdict, reasoning, actions, carried blockers, acknowledged gaps.

## Hard rules

- NEVER read repository files. Not with `Read`, not with `rg`, not with `cat` through `Bash`. The evidence is the issue's comments.
- NEVER spawn a subagent. This lane is inline.
- NEVER modify code or existing report comments (`save_comment` with `id` is off limits here). Posting the one new release comment is the only write.
- NEVER emit a verdict without the coverage line first. A verdict that does not say what it is missing is a confidence machine, and that is the exact failure this contract exists to prevent.
- NEVER return `SHIP` on a stale report, on an open blocker, on a single profile, or on a gap the user has not explicitly accepted.
