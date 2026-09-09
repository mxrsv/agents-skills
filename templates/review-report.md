# Review report — shared data contract

Every reviewer contract and every `/review-*` skill points here. Change it here; never duplicate it.

**A report is a comment on the Linear issue that owns the work — never a file in the repo** (D4, since 2026-09-07 / MXR-37). `docs/review/` no longer exists as a destination; `file-guard.sh` warns after a write there (it runs PostToolUse, so it does not refuse — the rule is yours to keep).

## 1. Where a report lives

```
save_comment { issueId: "<ISSUE-ID>", body: <report> }     # Linear MCP — Claude Code tool id: mcp__plugin_linear_linear__save_comment
```

- `<ISSUE-ID>` — the issue the user is working under (`MXR-123`). Not given → ask which issue; every task has one (D0). Do not pick one by guessing from the branch name.
- One comment per run, posted **once**, never edited afterwards. `save_comment` with `id` on a report comment is forbidden: a milestone record is immutable, and `/review-release` ranks runs by `reviewed_at` inside the body, so a rewritten body corrupts the ordering.
- A reply thread under the report is free for discussion; findings stay in the top-level comment.
- Screenshots and other evidence files → `prepare_attachment_upload` → `PUT` → `create_attachment_from_upload` on the same issue, **one file at a time** (the signed URL expires in 60 s). The finding's `evidence` cites the attachment title. No Linear MCP in the harness (Codex without it) → describe the evidence in the comment text; never save it into the repo.
- No Linear MCP at all → print the whole report in chat as one fenced markdown block and say which issue it belongs on. **Never write a file** as the fallback.

## 2. Required header — the first thing in the comment body

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

The heading line and the fenced `yaml` block are what `/review-release` parses out of `list_comments`. A comment without both is not a report.

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
evidence:   <attachment title · log excerpt · file:line>
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

```
list_comments { issueId: "<ISSUE-ID>", limit: 250 }     # page with `cursor` until hasNextPage=false
```

Keep only top-level comments whose body starts with `## Review:` and carries the §2 `yaml` block. Take the **most recent report per profile**, ranked by the `reviewed_at` field in that block.

- Do not use the comment's `createdAt` (a late repost of an older run carries a newer timestamp). Do not use the order `list_comments` returns.
- Missing or malformed `reviewed_at` → fall back to the comment's `createdAt`, and mark that row `ordering-uncertain`.
- Replies (comments with a parent) are discussion, not reports — skip them.

⚠️ **Do NOT filter by `head_sha` matching the current head.** Reports are always written *before* the later commits the release decision covers, so that filter returns empty in the most common case and the freshness rules become dead code.

> **Freshness CLASSIFIES evidence; it does not FILTER evidence.** A stale `health` report is still worth reading — it just cannot support a `SHIP` decision.

## 7. Who posts the comment

**Only the parent skill posts the report.** Reviewers return findings as text; they never call `save_comment` themselves. N reviewers posting one report race each other and produce inconsistent formatting.
