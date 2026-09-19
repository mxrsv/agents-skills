# Review report — shared data contract

Every reviewer contract and every `/review-*` skill points here. Change it here; never duplicate it.

**Return review reports in chat by default.** Post a PR comment only when the user explicitly requests it. Do not require a tracker, issue key or remote write to complete a review. Separate `docs/review/` files remain disallowed (D4).

## 1. Where a report lives

- The parent returns one structured report per run in the conversation. Preserve the report header and evidence so it can be supplied to `review-release` later.
- A new run gets a new report; do not silently rewrite the evidence or timestamp of a previous run. Discussion is separate from the report.
- Reference screenshots/logs through actual scratchpad paths or user-requested artifact links; disclose when evidence is unavailable. Do not upload automatically or link files you are about to delete.
- During authorized implementation, capture actionable outcomes and remaining blockers in the existing task plan. A read-only review does not edit that plan. The full report remains in chat or the explicitly requested PR comment.
- If the user requests a portable full report, save an artifact in scratchpad and provide its path. Do not invent a permanent report directory or auto-create an external issue.

## 2. Required header — the first thing in the report body

````markdown
## Review: <profile> · <scope> · <run_id>

```yaml
run_id:        <6 chars>
profile:       change | experience | health | release
scope:         <see below>
reviewed_at:   YYYY-MM-DDTHH:MM:SS+07:00
source_kind:   git-range | working-tree | url
head_sha:      <full sha, or null when source_kind=url>
dirty:         true | false
tree_digest:   <sha1 of `git status --porcelain`>
deploy_rev:    <only when source_kind=url; null if not determinable>
```
````

- `<profile>` — `change` | `experience` | `health` | `release`
- `<scope>`:
  - git range `a1b2c3d..e4f5g6h` → `a1b2c3d-e4f5g6h` (7 chars per end)
  - working tree → `worktree`
  - URL → hostname plus slugified path, e.g. `localhost-3000-checkout`
  - profile `release` → `worktree`, with `source_kind: working-tree`. It reviews no range; the point in time is anchored by `head_sha` + `reviewed_at`, and `run_id` keeps runs apart.
- `<run_id>` — 6 random base36 characters: `LC_ALL=C tr -dc 'a-z0-9' < /dev/urandom | head -c 6`

The heading line and the fenced `yaml` block are what `/review-release` reads from supplied report blocks. Text without both is not a structured report.

⚠️ `tree_digest` must be built from **`git status --porcelain`**, never from `git diff`. `git diff` is blind to untracked files — a matching digest with completely different behavior is entirely possible.

⚠️ **Pinned digest command. Every lane MUST use this exact line:**

```bash
git status --porcelain=v1 | shasum -a 1 | awk '{print $1}'
```

Do not substitute `sha1sum`, do not switch `--porcelain` to v2, do not add or drop a trailing newline. The freshness gate compares digests **byte for byte** — one lane computing it differently by a single character makes **every report permanently stale**, and `/review-release` will never allow `SHIP`.

## 3. Evidence coverage — required, immediately after the header

```markdown
### Coverage

| Reviewer | Status | Reason |
|---|---|---|
| architecture | ran | |
| deps         | blocked | no lockfile in the repo; stack could not be determined |
| contracts    | skipped | the change touches no docs, config or schema |
```

Status: `ran` · `blocked` (no evidence available to read) · `skipped` (the router decided it was not needed).
**Dropping a reviewer without a row in this table is an error.**

## 4. Finding

```yaml
key:        <domain>/<area>/<problem>
severity:   blocker | high | medium | low
confidence: high | medium | low
evidence:   <artifact path/link · log excerpt · file:line>
impact:     <who is affected, and when>
action:     <a concrete step that can be taken now>
```

**`<domain>` is exactly these 8 values** — one per reviewer:

| Domain | Reviewer |
|---|---|
| `code` | correctness |
| `tests` | tests |
| `sec` | security-code |
| `ux` | user-flow |
| `perf` | runtime |
| `arch` | architecture |
| `deps` | deps |
| `docs` | contracts |

Examples: `ux/checkout/error-recovery` · `arch/auth/circular-import` · `code/auth/null-deref-on-refresh` · `tests/payment/no-failure-path`

## 5. Budget per reviewer

- `blocker` — unlimited
- actionable findings — **at most 3**
- minor — collapse into a single summary line; do not enumerate

A hard cap like "at most 5 findings" is wrong: with 8 blockers you cannot hide 3 of them.

## 6. Freshness rules — used by `/review-release` to decide `SHIP`

| `source_kind` | Fresh when |
|---|---|
| `git-range`, `working-tree` | same `head_sha` **and** `dirty: false` **and** `tree_digest` matches |
| `url` | `deploy_rev` == the `head_sha` under consideration, **or** the user confirms the deployment was built from that head |

Any condition off → report it as **stale** and do NOT return `SHIP`.

## 6b. Which reports to read — `/review-release`

Read reports already present in the conversation, explicitly supplied report artifacts, or comments on a specific PR when the user requests that source. Do not fetch a tracker or search the repo for an implicit report store. A task-plan summary is not a full report.

Keep report blocks whose heading starts with `## Review:` and includes the §2 header. Select the most recent report per profile by `reviewed_at`. Missing/malformed timestamps make ordering uncertain; do not guess from chat order or filesystem modification time, and do not use that report to justify `SHIP` until clarified.

Do not filter by current `head_sha`: freshness classifies evidence rather than filtering it. Stale evidence is still useful context but cannot support `SHIP`. If prior runs are unavailable, disclose the history gap instead of claiming all earlier blockers were checked.

## 7. Who returns the report

Only the parent assembles and returns the report. Reviewers return findings as text; they do not post comments, write task plans or create report files. External posting requires the user's explicit request.
