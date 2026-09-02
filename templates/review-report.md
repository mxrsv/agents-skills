# Review report — shared data contract

Every reviewer contract and every `/review-*` skill points here. Change it here; never duplicate it.

## 1. Filename

```
docs/review/YYYY-MM-DD-<profile>-<scope>-<run_id>.md
```

- `<profile>` — `change` | `experience` | `health` | `release`
- `<scope>` — normalized for a filename:
  - git range `a1b2c3d..e4f5g6h` → `a1b2c3d-e4f5g6h` (7 chars per end)
  - working tree → `worktree`
  - URL → hostname plus slugified path, e.g. `localhost-3000-checkout`
  - profile `release` → `worktree`, with `source_kind: working-tree`. It reviews no range; the point in time is anchored by `head_sha` + `reviewed_at`, and `run_id` prevents filename collisions.
- `<run_id>` — 6 random base36 characters

**The filename must be immutable.** Running the same profile twice in one day under the same name overwrites the earlier run — data lost, and it violates the frozen nature of a dated milestone document (D1).

## 2. Required header

```yaml
---
run_id:        <6 chars>
profile:       change | experience | health | release
scope:         <as above>
reviewed_at:   YYYY-MM-DDTHH:MM:SS+07:00
source_kind:   git-range | working-tree | url
head_sha:      <full sha, or null when source_kind=url>
dirty:         true | false
tree_digest:   <sha1 of `git status --porcelain`>
deploy_rev:    <only when source_kind=url; null if not determinable>
---
```

⚠️ `tree_digest` must be built from **`git status --porcelain`**, never from `git diff`. `git diff` is blind to untracked files — a matching digest with completely different behavior is entirely possible.

⚠️ **Pinned digest command. Every lane MUST use this exact line:**

```bash
git status --porcelain=v1 | shasum -a 1 | awk '{print $1}'
```

Do not substitute `sha1sum`, do not switch `--porcelain` to v2, do not add or drop a trailing newline. The freshness gate compares digests **byte for byte** — one lane computing it differently by a single character makes **every report permanently stale**, and `/review-release` will never allow `SHIP`.

## 3. Evidence coverage — required, immediately after the header

```markdown
## Coverage

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
evidence:   <screenshot path · log excerpt · file:line>
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

Take the **most recent report per profile**, ranked by the `reviewed_at` header field.

- Do not use mtime (it changes on copy, touch, or a typo fix). Do not use the date in the filename.
- Missing or malformed `reviewed_at` → fall back to the filename date, then mtime, and mark that row `ordering-uncertain`.

⚠️ **Do NOT filter by `head_sha` matching the current head.** Reports are always written *before* the later commits the release decision covers, so that filter returns empty in the most common case and the freshness rules become dead code.

> **Freshness CLASSIFIES evidence; it does not FILTER evidence.** A stale `health` report is still worth reading — it just cannot support a `SHIP` decision.

## 7. Who writes the file

**Only the parent skill writes the report.** Reviewers return findings; they never write files themselves. N reviewers writing one file race each other and produce inconsistent formatting.
