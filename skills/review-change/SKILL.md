---
name: review-change
description: Review a change you just implemented — correctness against its callers, test quality, and code-level security — over a git range or the working tree. Run right after finishing a unit of implementation and before committing it. Not for reviewing a spec or a plan (use /review), not for whole-repo architecture, dependencies or docs drift (use /review-health), not for user flow in a browser (use /review-experience).
---

# Review a change

> **Harness note.** Skill names are written `/name` (Claude Code slash form); in Codex invoke the same skill as `$name`. Sub-agent dispatch is shown as Claude Code's `Agent({ subagent_type: "general-purpose", … })` — in Codex spawn a sub-agent with the same prompt, or apply the contracts inline, in sequence, when sub-agents are unavailable.

Three reviewer contracts over one change: `correctness`, `tests`, `security-code`. Contracts live in [reviewers/](reviewers/) and are the prompt bodies you dispatch — read them, do not summarize them.

Shared report format, finding schema and freshness rules: `~/.claude/templates/review-report.md` (absolute path on purpose — this directory is also reached through the `~/.agents/skills/` symlink used by Codex and Cursor, where a relative `../../templates/` would resolve elsewhere).

## 1. Resolve the source

```bash
git -C <repo> rev-parse HEAD                                   # head_sha
git -C <repo> status --porcelain                               # manifest + dirty flag
git -C <repo> status --porcelain=v1 | shasum -a 1 | awk '{print $1}' # tree_digest
```

| Situation | `source_kind` | Range / manifest |
|---|---|---|
| User named a range, branch or PR | `git-range` | `<base>..<head>`; comparing branches → `base = git merge-base <base> HEAD`. Manifest: `git diff --name-status <base>..<head>` |
| Working tree is dirty, no range given | `working-tree` | Base is `HEAD`. Manifest: `git status --porcelain` |
| Working tree is clean, no range given | `git-range` | Default `HEAD~1..HEAD` |

Manifest comes from `git status --porcelain`, **not `git diff`** — `git diff` is blind to untracked files, and an untracked file is a whole new behavior. `??` entries have no diff: the entire file is the change.

`tree_digest` and the dirty flag come from porcelain in **both** modes.

**A diff does not expire.** Anchored to `base_sha..head_sha` it stays valid however late you review. Reviewing an old change is not a reason to switch profile — it is a reason to write the range into the report header so the reader knows what was looked at.

Ask the user for a one-or-two-sentence **objective** (what the change is trying to do) if it is not already obvious from the conversation. Every reviewer needs it: correctness is judged against intent, not against style.

## 2. Quick triage — mandatory, before any dispatch

Two independent decisions. Do not let one answer the other.

| Variable | Decided by | Floor |
|---|---|---|
| **Which reviewers apply** | risk — route **conservatively**, when unsure turn it on | **never 0 reviewers** |
| **Inline or subagent** | cost — a small change runs inline | **0 subagents is valid** |

A 1-line diff may decide the *run mode*. It may never decide the *coverage* — one line is enough for an auth bypass.

### Variable 1 — which reviewers

| Reviewer | On when |
|---|---|
| `correctness` | **always.** This is the floor; there is no change too small to have callers. |
| `tests` | behavior changed — **including when the test files are themselves the thing that changed.** An assertion-free test or a happy-path-only test is precisely what this reviewer exists to catch, so "the diff is only tests" is a reason to run it, not to skip it. |
| `security-code` | the change touches any of: auth or session · input arriving at a boundary · env vars · secrets or credentials · dependency manifests · shell commands · CI config · permissions or settings · fetching a URL · path handling · serialization/deserialization. Unsure → on. |

**`.md` files are not automatically docs.** In an agent-config repo (`~/.claude`, `~/.agents`, or any repo containing `skills/`, `commands/`, `agents/`), `skills/*/SKILL.md`, `commands/*.md` and `agents/*.md` are **executable behavior** — changing them can change tool access, permissions, or what gets run. Never classify such a diff as "docs only" and never let that classification drop a reviewer. Route them like code: `security-code` on if the file grants tool access, edits an allowlist, or runs a shell command.

Declaring a skip is an audit trail, not a safety net — it makes an omission *visible*, it does not prove the routing was right. Safety comes from routing conservatively.

### Variable 2 — inline or subagent

- Under roughly 150 changed lines across under 5 files, **or** only one reviewer routed on → run the contracts inline, one after another, in this session.
- Otherwise → one subagent per routed reviewer, **all Agent calls sent in a single message** so they run in parallel.
- Cap 4 subagents per command (only 3 exist here).
- Cutting cost means cutting subagents, never cutting reviewers.

## 3. Dispatch

`reviewers/*.md` are supporting files, not agent definitions — no harness loads them automatically (Claude Code discovers agents only from `agents/*.md`, Codex from `~/.codex/agents/*.toml`). So read each contract and **inline its full text into the prompt**.

```
Agent({
  subagent_type: "general-purpose",
  name: "rev-correctness",          // rev-tests · rev-security-code
  model: "sonnet",                  // correctness → opus for a large diff, or concurrency/auth code
  prompt: <envelope below>
})
```

Envelope — the same shape for all three:

```
OBJECTIVE: <what this change is trying to do, 1-2 sentences>
REPO ROOT: <absolute path>
SOURCE KIND: git-range | working-tree
RANGE: <base_sha>..<head_sha>        # working-tree: "HEAD = <sha>, uncommitted"
MANIFEST:
  M  src/auth/session.ts
  A  src/auth/refresh.ts
  ?? skills/foo/SKILL.md

CONTRACT:
<verbatim contents of reviewers/<name>.md>
```

**Do not pre-bundle the evidence.** Reading the diff, the callers and the tests yourself and pasting them into three prompts fails three ways at once: this session floods with the context that subagents exist to keep out, the same evidence is duplicated three times, and a reviewer cannot follow a caller or a trust boundary that falls outside the bundle you chose. Pass objective, range and manifest. Each reviewer reads for itself.

## 4. Collect and write one report

Subagents return findings as text. **Only this skill writes a file.** N subagents writing into `docs/review/` race each other and drift in format.

1. **Dedupe.** Same root cause reported twice → keep the copy owned by the scope boundaries in each contract's *Out of scope* section, and note that another reviewer concurred. Same file:line with genuinely different causes → keep both.
2. **Rank** by severity, then confidence.
3. **Write** `docs/review/YYYY-MM-DD-change-<scope>-<run_id>.md` in the reviewed repo, per `~/.claude/templates/review-report.md`.
   - `<scope>`: `<base7>-<head7>` for a range, `worktree` for the working tree.
   - `<run_id>`: `LC_ALL=C tr -dc 'a-z0-9' < /dev/urandom | head -c 6`
   - Header, then the coverage table — every reviewer listed as `ran` / `blocked` / `skipped`, with a reason for anything that is not `ran`. Omitting a reviewer from that table is a defect in the report.
4. **Report to the user**: blockers first, then the file path. Do not bury findings under a summary, and do not fix anything unless asked.

Finding keys use the 8 domains fixed in the template — one per reviewer. This command produces `code/*` (correctness), `tests/*` and `sec/*`. A finding that wants any other domain belongs to another command; see each contract's *Out of scope*.

## Hard rules

- Route conservatively; never return 0 reviewers.
- Never pre-bundle evidence into subagent prompts.
- One report per run, written by this skill.
- Report findings; do not apply fixes in review mode.
