---
name: review-health
description: Structural health review of a repo — architecture and coupling, dependency risk, and drift between living docs/schema/config and the code. Use at a milestone, after a big refactor or merge, or as the first review on a never-reviewed repo; needs only the repo, no running app and no diff. Not for a specific change or diff (use /review-change), not for UX or runtime behavior (use /review-experience), not for a ship decision (use /review-release).
---

# /review-health

> **Harness note.** Skill names are written `/name` (Claude Code slash form); in Codex invoke the same skill as `$name`. Sub-agent dispatch is shown as Claude Code's `Agent({ subagent_type: "general-purpose", … })` — in Codex spawn a sub-agent with the same prompt, or apply the contracts inline, in sequence, when sub-agents are unavailable.

Reviews **the repo as it stands** — not a diff, not a running app.

| Reviewer | Evidence source | Looks for |
| --- | --- | --- |
| `architecture` | code tree · git churn, blame, hotspots | coupling, boundary violations, duplication, dead code |
| `deps` | lockfile · the stack's own audit tool · bundle size | CVEs, version skew, license, bloat |
| `contracts` | living docs + anchors · schema · config · build assumptions ↔ code | drift |

Three genuinely independent evidence sources. They never read the same thing twice, so fanning out is a real saving here — unlike `/review-change`, where all three reviewers share one diff.

**Cold start.** A repo that has never been reviewed starts here. This profile needs nothing but the repo — no dev server, no credentials, no base commit. Its output (churn ranking + drift) is what tells you where to point `/review-change` and `/review-experience` next. `/review-release` is meaningless until at least two profiles have run.

## 1. Collect the manifest — parent, once

```bash
git rev-parse HEAD                                    # head_sha
git status --porcelain                                # THE manifest
git status --porcelain=v1 | shasum -a 1 | awk '{print $1}'  # tree_digest
LC_ALL=C tr -dc 'a-z0-9' < /dev/urandom | head -c 6   # run_id
date +%Y-%m-%dT%H:%M:%S%:z                            # reviewed_at
```

Use `git status --porcelain`, **never `git diff`**. `git diff` is blind to untracked files, and untracked files are executable behavior — a repo can carry two dozen untracked skill directories while `git diff` reports nothing.

`dirty` is `true` when the porcelain output is non-empty.

## 2. Read the three contracts

- [reviewers/architecture.md](reviewers/architecture.md)
- [reviewers/deps.md](reviewers/deps.md)
- [reviewers/contracts.md](reviewers/contracts.md)

They are supporting files, not subagent definitions — no harness loads them automatically (Claude Code discovers agents only from `agents/*.md`, Codex from `~/.codex/agents/*.toml`), so you must read each contract and **paste its full text into the dispatched prompt**.

## 3. Decide execution mode — not coverage

Two separate variables. Do not mix them.

| Variable | Decided by | Floor |
| --- | --- | --- |
| Which contracts apply | risk | **always all three** — the sources are disjoint, so all three are always relevant |
| Subagent or inline | cost | 0 subagents is legal |

Coverage is fixed at three for this profile. A contract that finds nothing to read returns `blocked` — that is the *reviewer's* verdict, not permission for you to drop it. `skipped` should essentially never appear in a health report.

**Default: three subagents in parallel.** Go inline (apply the contracts yourself, in sequence) only for a repo small enough that the fan-out costs more than it saves — roughly under 30 tracked files with no dependency manifest. Cap for any `/review-*` command is 4 subagents; this one uses 3.

## 4. Dispatch — all three calls in ONE message

Three `Agent` calls in a single message run in parallel. Sent one per message, they serialize and you lose the whole point.

```
Agent({ subagent_type: "general-purpose",
        name: "rev-architecture",
        model: "opus",
        prompt: <full text of reviewers/architecture.md> + OBJECTIVE + SCOPE + MANIFEST })

Agent({ subagent_type: "general-purpose",
        name: "rev-deps",
        model: "haiku",
        prompt: <full text of reviewers/deps.md> + OBJECTIVE + SCOPE + MANIFEST })

Agent({ subagent_type: "general-purpose",
        name: "rev-contracts",
        model: "sonnet",
        prompt: <full text of reviewers/contracts.md> + OBJECTIVE + SCOPE + MANIFEST })
```

Same `subagent_type`, different `name`, different `prompt`, different `model`. The contract carries the review logic; the agent type carries nothing. `name` is what lets you tell three concurrent runs apart. Set `model` per reviewer — `deps` is mechanical (cheap model), `architecture` is judgment-heavy (strong model).

The tail appended to every prompt:

```
OBJECTIVE: health review of <repo> at <head_sha><, dirty> — <one line on why it is being reviewed now>
SCOPE:     repo root <absolute path>. source_kind=working-tree.
MANIFEST:  <verbatim `git status --porcelain` output, or "clean working tree">
           ` ?` entries are untracked and invisible to git history — treat them as churn-unknown.
```

### What the parent does NOT do

**Do not pre-collect evidence.** Do not read the code tree, run the audit tool, or run the docs scripts and paste the results into the prompts. That defeats the reason for using subagents: your own context fills up, the same evidence is duplicated three times, and a reviewer can no longer follow a thread out of whatever bundle you happened to assemble. You pass objective + scope + manifest. Nothing else.

**Do not let subagents write files or post comments.** Three writers racing on one issue produce conflicts and inconsistent format. They return findings as text; you post once.

## 5. Merge and post ONE report

Format, header fields, finding schema, domain list, budget and freshness rules all live in `~/.claude/templates/review-report.md`. Follow it; do not restate it here and do not invent fields. The report is `save_comment { issueId: <ISSUE-ID>, body }` on the issue the review was asked under — ask for the id if none was named; never a file in the repo.

Fixed for this profile:

```
where:        comment on issue <ISSUE-ID>
profile:      health
scope:        worktree
source_kind:  working-tree
head_sha:     <from step 1>
dirty:        <from step 1>
tree_digest:  <from step 1>
deploy_rev:   null
```

Merging:

- Dedupe across reviewers — keep the version with the stronger evidence, drop the restatement. Budget stays per reviewer; three reviewers at 3 findings each is 9, not 3.
- Domain prefixes are pre-assigned so parallel reviewers cannot drift the key space: `architecture` → `arch/`, `deps` → `deps/`, `contracts` → `docs/`.
- The coverage table lists **all three** reviewers with `ran` / `blocked` / `skipped` and a reason. Omitting a reviewer from that table is an error, not a shortcut.
- A reviewer that returned `blocked` still gets its row, with the reason it gave verbatim.

## 6. Report back

Give the user: the comment URL, the coverage line in one sentence, and the blockers plus the highest-severity findings. Do not paste the whole report back.

Findings live in the report comment and nowhere else. Anything the user decides to act on, they turn into a Linear issue or a `docs/internals/` rewrite by hand. There is no register and no auto-filing.

## Hard rules

- The parent posts the report. Reviewers never do. No file in the repo.
- `git status --porcelain` for the manifest and the digest — never `git diff`.
- All three dispatch calls in one message.
- No finding without evidence. `blocked` with a reason beats a plausible guess.
