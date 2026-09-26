---
name: review-release
description: Decide whether to ship, fix, refactor, keep building, or rethink from existing change, experience and health reports in conversation or supplied artifacts. Use at a milestone or before release. Synthesizes evidence without re-scanning the codebase.
argument-hint: "[report paths or review context]"
---

# Review: release (synthesis)

> **Harness note.** Skill names are written `/name` (Claude Code slash form); in Codex invoke the same skill as `$name`. Sub-agent dispatch is shown as Claude Code's `Agent({ subagent_type: "general-purpose", … })` — in Codex spawn a sub-agent with the same prompt, or apply the contracts inline, in sequence, when sub-agents are unavailable.

This lane produces **one decision** and **at most three next actions**. Nothing else.

```
SHIP · FIX FIRST · REFACTOR · CONTINUE BUILDING · RETHINK
```

## How this lane differs from the other three

| | `change` · `experience` · `health` | `release` |
| --- | --- | --- |
| Execution | fans out to subagents | **inline, no fan-out** |
| Evidence | the codebase, the browser, the dependency tree | **only supplied review reports + what you tell it** |
| Output | findings | **one verdict + ≤3 actions** |

**Never re-scan the codebase.** Re-scanning re-discovers exactly what the other three profiles just found, at full cost, with a weaker contract. If evidence is missing, the answer is "coverage is 2/3", not "let me go look".

**Evidence boundary — read this literally:**

- ALLOWED: structured reports already in this conversation, explicitly supplied report artifacts, or comments on a specific PR when requested. A report starts with `## Review:` and carries the template §2 `yaml` block.
- ALLOWED: git *metadata* — `git rev-parse`, `git status --porcelain`, `git rev-list --count`, `git log --oneline`. Freshness math needs these; they are not a codebase scan.
- FORBIDDEN: reading, grepping or globbing source, tests, configs, lockfiles or general docs to discover/verify findings. Only explicitly supplied report content may be read as an artifact; a task-plan summary is not a full report.
- FORBIDDEN: spawning subagents. This lane is inline.

Resolve evidence from the conversation and explicitly supplied report paths. Missing reports → ask for those reports or state the coverage gap; do not require a tracker id or fetch remote state implicitly.

## Step 1 — anchor the current state

```bash
git rev-parse HEAD
git status --porcelain=v1 | shasum -a 1 | awk '{print $1}'   # current tree_digest
git status --porcelain | head -1                     # empty output => dirty: false
```

Hold these three values. Every freshness test compares against them.

## Step 2 — select which reports to read

Read the available structured report blocks (template §6b). Ignore ordinary discussion and plan summaries.

**Selection rule: for each of `change`, `experience`, `health`, take the most recent report by its `reviewed_at` header, not chat order or filesystem modification time.** Missing/malformed timestamps make ordering uncertain; clarify rather than treating the report as fresh.

Rationale, and why not the obvious alternative: selecting only reports whose `head_sha` matches the current head would return nothing in the ordinary case, because reports are written before the follow-up commits that a release decision is about. That would make the freshness law dead code and this lane useless. So freshness **classifies** evidence, it does not **filter** it — a stale `health` report is still worth reading, it just cannot support `SHIP`.

Ignore prior `release` reports for evidence purposes — they are decisions, not findings. They are used only to bound Step 4.

## Step 3 — classify freshness

Apply `~/.claude/templates/review-report.md` §6 exactly. Two rules, chosen by the report's `source_kind`:

**`git-range` / `working-tree`** — fresh only if ALL THREE hold:

1. report `head_sha` == current `HEAD`
2. report `dirty: false` AND the working tree is clean right now
3. report `tree_digest` == current `git status --porcelain` digest

**`url`** (this is how `experience` reports are anchored) — fresh only if:

- report `deploy_rev` == the `head_sha` under judgement, OR
- the user confirms in this conversation that the reviewed deployment was built from that head.

`deploy_rev: null` is not fresh by default. Ask: *"The `experience` report reviewed `<url>` but recorded no deploy revision. Was that deployment built from `<head7>`?"* An unanswered question is a `stale`, not a `fresh`.

Compute distance for every stale report so the number is concrete:

```bash
git cat-file -e <report_head_sha>^{commit} 2>/dev/null && \
  git rev-list --count <report_head_sha>..HEAD
```

If the sha is not in the repo (rebased, dropped, different clone), record `distance: unknown — sha not in this repo` rather than guessing.

**Any deviation on any condition → `stale`. A stale report can never support `SHIP`.**

## Step 4 — carry unresolved blockers forward

The latest report of a profile does not contain blockers that an earlier run raised and nobody fixed. Those still count.

Scan back through same-profile reports **newer than the most recent `release` report** (if there is no prior `release` report, cap the lookback at 10 reports). Collect findings with `severity: blocker` whose `key` does not appear in the selected latest report. If earlier runs are unavailable, disclose that history gap; do not claim it was checked.

Each carried blocker is `carried — not re-verified`. This lane cannot verify a fix; verification requires reading code, which is forbidden here. It clears only when:

- the user states it is fixed, or
- a **fresh** report of the same profile at the current head no longer lists that key.

**Blockers only.** Do not carry `high` or below — that turns a synthesis into an unbounded backlog replay.

## Step 5 — talk to the user

This lane needs conversation; it is the reason it runs inline. Ask, in this order, and stop for answers:

1. **Product direction.** *"What is this release for, and what does 'done' mean for it right now?"* Without this, `CONTINUE BUILDING` and `RETHINK` are indistinguishable from `SHIP`.
2. **`url` confirmations** — any `experience` report whose `deploy_rev` is null or mismatched (Step 3).
3. **Coverage acknowledgment** — for each missing or stale profile, name what evidence is absent and get an explicit answer. Not a generic warning; one question per gap:
   - *"`experience` has never run. You would be shipping with no evidence that a user can complete the flow. Accept that?"*
   - *"`change` last ran 47 commits ago. Nothing has reviewed correctness of those 47 commits. Accept that?"*
4. **Carried blockers** — for each, *"still open, or fixed since?"*

## Step 6 — decide

**`SHIP` is the only verdict with a mechanical gate. All five conditions must hold:**

1. at least 2 of the 3 source profiles have a report, and
2. every report consulted is `fresh`, and
3. no open blockers in any consulted report, and
4. no carried blocker still open (Step 4), and
5. every coverage gap was explicitly acknowledged by the user in this conversation (Step 5.3).

Fail any one → `SHIP` is off the table. Say which condition failed.

**The other four are judgement, settled in the dialogue.** Signals, not a lookup table:

| Signal | Points toward |
| --- | --- |
| Any open blocker, anywhere | `FIX FIRST` |
| Findings are mostly `arch/*` at `high`, code is described as hard to change | `REFACTOR` |
| Few findings, and the product direction says the feature is not finished | `CONTINUE BUILDING` |
| The same `key` recurs unresolved across 3+ runs | `RETHINK` — the approach is not converging, not the fix |
| `experience` shows users cannot complete the core task | `RETHINK`, not `FIX FIRST` |
| Findings contradict the stated product direction | `RETHINK` |

Then **at most 3 next actions**, each concrete enough to start today, ordered. If there are more than three candidates, that ranking *is* the value this lane adds — do not widen the list to avoid choosing.

### Preconditions — how little evidence is too little

| Reports found | Behaviour |
| --- | --- |
| 0 | **`blocked`.** Emit no verdict. Say: no structured review report is available for this task. Cold start per the framework: run `/review-health` first (cheapest, needs only the repo), then `/review-change` or `/review-experience` depending on what you are working on. |
| 1 | Verdict allowed, marked **provisional**. `SHIP` is forbidden regardless of freshness — gate condition 1 fails. |
| 2 or 3 | Full synthesis. |

`blocked` is a precondition failure, not a sixth verdict.

## Output format

**Start with the required report heading and YAML header (template §2). The first narrative line after that header is the coverage declaration.**

```
Coverage: 2/3 profiles. `experience` has never run. `health` ran at `a3f2c1`, 47 commits behind head. `change` fresh at head.
```

Without that coverage declaration before the verdict, this lane is a confidence generator: a verdict that sounds informed while resting on evidence nobody counted. Then:

```
VERDICT: FIX FIRST

Why: <2-4 sentences tied to specific finding keys and the product direction>

Next:
1. <action>  — <which finding key it closes>
2. <action>
3. <action>

Carried blockers (not re-verified): sec/auth/token-in-log
Acknowledged gaps: experience never ran — user accepted
```

## Return the report

Return one structured release report in chat, or post to a specific PR only when explicitly requested. Do not auto-create a report file or external issue. Use a new `run_id` for this run.

Header per `~/.claude/templates/review-report.md` §2, with:

- `source_kind: working-tree` — the decision accounts for uncommitted state, so the working tree is the thing judged.
- `scope: worktree` — the template defines three scope forms and none of them is release-specific. `worktree` is the accurate one of the three; the head anchor lives in `head_sha`, and `run_id` keeps runs apart.
- `head_sha`, `dirty`, `tree_digest` — the values captured in Step 1.

Body order: **coverage table first** (template §3, adapted — rows are the three source profiles, with `fresh` / `stale` / `never-ran` and the commit distance), then verdict, then reasoning, then the ≤3 actions, then carried blockers, then acknowledged gaps.

This lane is inline, so it assembles and returns the report itself (template §7). The verdict is advice; `SHIP` does not grant merge/deploy/release permission.

## Known limitation — stated, not solved

**This command only runs when you remember to type it, or when an agent recognises the moment and calls it.** No hook enforces it, and none can — the framework is manual by design.

The failure mode is specific: the moment you most need this lane is when you are stuck and going in circles, and being stuck is exactly the state in which you do not step back and notice you are stuck. An agent mid-task has the same blind spot. Model invocation can only fire from the `description` — that is a mitigation, not a fix, and it depends on the agent noticing. Treat a missed `/review-release` as expected, not exceptional.

## Contract

Load [reviewers/strategy.md](reviewers/strategy.md) and follow it. It runs inline here — do not pass it to a subagent.
