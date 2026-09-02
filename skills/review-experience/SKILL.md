---
name: review-experience
description: Review the real user experience of a running app in a real browser — walk the affected flows, force loading/error/empty states, check 375/768/1440, and capture console and network evidence. Use after UI, navigation or flow changes when a dev or staging URL is reachable, or when someone reports the app is confusing, broken or slow in actual use. Requires a running app. Not for code-level bugs (use /review-change) and not for architecture, dependency or docs health (use /review-health).
---

# Review: experience

> **Harness note.** Skill names are written `/name` (Claude Code slash form); in Codex invoke the same skill as `$name`. Sub-agent dispatch is shown as Claude Code's `Agent({ subagent_type: "general-purpose", … })` — in Codex spawn a sub-agent with the same prompt, or apply the contracts inline, in sequence, when sub-agents are unavailable.

Two reviewer roles, **one browser session**, **one subagent**, **one report**.

| Reviewer | Evidence | Looks for |
| --- | --- | --- |
| `user-flow` | screenshots and accessibility snapshots of the running app at 375 / 768 / 1440 | task completion, navigation, friction, state clarity, loading/error/empty, recovery, accessibility, responsive |
| `runtime` | console messages, network requests, perceivable timing | console errors, failed requests, crashes, races, slowness a user can feel |

**A reviewer's ceiling is the evidence it can read.** Reading JSX never shows a spinner that never resolves, a submit button that 500s, or a modal that traps focus. This is the only review profile that opens a browser. If you end up reading source instead of driving the app, you have not run this skill — you have run a worse `/review-change`.

## Precondition

A reachable app URL. This skill does **not** start, build, install or deploy anything.

- URL not given → ask for it. Do not guess `localhost:3000`.
- App not running → say so and stop. Offer to run it only if the user asks.

## Safety — read before anything else

Walking a real app means submitting real forms. That writes to a real database, and can send real email or charge a real card. This skill is model-invocable, so it can start without anyone having asked for it.

**Environment.** Dev or staging only, with seed data. If you cannot confirm the target is dev or staging — hostname is a production domain, or you simply do not know — **stop and ask**. Never guess.

**Forbidden regardless of approval:** payments and checkout submission, sending email or SMS, account deletion, bulk delete or destructive admin actions, anything touching another person's data.

**The mutation gate.** Reading and navigating are free. Anything that writes — submitting a form, creating/editing/deleting a record, uploading, triggering a job — requires the user's approval **before** it happens.

A subagent cannot ask the user anything. So the gate is resolved here, in the parent, in two places:

1. **Before dispatch** — list the mutating steps the flow needs and get an explicit yes for each. Pass that list into the prompt as the authorization list.
2. **During the run** — if the subagent meets a mutation that is not on the list, its contract requires it to stop, not perform it, and return `blocked_on_approval` with the exact step. You then ask the user and re-dispatch with the list extended.

An empty authorization list is valid and common: a read-only walk still finds most navigation, state-clarity, responsive and accessibility problems.

## Step 1 — Preflight the browser, for real

Before anything else, prove the toolchain works by actually calling it:

```
browser_navigate { url: <target> }   # Playwright MCP — Claude Code tool id: mcp__plugin_playwright_playwright__browser_navigate; Codex: browser_navigate on the `playwright` server
```

- **Success** → continue to Step 2.
- **Failure** (MCP not connected, connection refused, DNS) → **do not spawn a subagent**. Write a report with both reviewers `blocked` and the reason, and stop. A subagent that cannot reach the app produces invented findings.

Do not skip this because "it worked last time". The Playwright MCP is a separate process and the app is someone else's dev server; both die quietly.

## Step 2 — Scope the walk

Adaptive by **scope**, never a whole-app sweep.

| Input | Routes to walk |
| --- | --- |
| A change (branch, diff, "I just did X") | only routes reachable from the changed UI, plus the one screen upstream and downstream of each |
| A complaint ("checkout is confusing") | the named flow end to end |
| No scope given | ask which flow matters; if the user says "just look around", cap at 3 routes and say so in the coverage table |

Both reviewer contracts always apply — `user-flow` and `runtime` are two lenses on the same walk, not two optional add-ons. What adapts is **how far you walk**, not how many lenses you use.

## Step 3 — Dispatch one subagent

Read both contract files and inline their full text into the prompt. `reviewers/*.md` are supporting files, not subagent definitions — nothing loads them automatically.

```
Agent({
  subagent_type: "general-purpose",
  name: "rev-experience",
  prompt: <full text of reviewers/user-flow.md>
        + <full text of reviewers/runtime.md>
        + OBJECTIVE: <what the user wants judged>
        + TARGET URL + ENVIRONMENT (dev | staging, confirmed how)
        + ROUTES IN SCOPE
        + AUTHORIZED MUTATIONS: <explicit list, or "none — read-only walk">
})
```

**One subagent. Never fan out.** Both contracts share one browser session; two subagents would fight over the same page — one navigating away while the other screenshots. It opens the app once, walks the flow once, and applies both contracts to the same evidence.

Claude Code: `subagent_type: "general-purpose"` is verified to inherit the Playwright MCP tools. Do not declare a `tools:` allowlist anywhere; that has been observed to *remove* tools rather than restrict them.

## Step 4 — Write the report

The subagent returns findings and screenshot paths. **The parent writes the file.** Never let the subagent write into `docs/`.

1. Copy every referenced screenshot from the Playwright output directory into `docs/review/assets/<run_id>/`, keeping filenames.
2. Rewrite each finding's `evidence` to the copied path.
3. Write one report at `docs/review/YYYY-MM-DD-experience-<scope>-<run_id>.md` per `~/.claude/templates/review-report.md`.

Header specifics for this profile:

- `source_kind: url`
- `scope` — hostname plus slugged path, e.g. `localhost-3000-checkout`
- `deploy_rev` — for a local dev server, the serving repo's `git rev-parse HEAD`; for a deployed URL, the build revision if the app exposes one, else `null`
- `head_sha`, `dirty`, `tree_digest` — fill from the serving repo when the app is served locally. `tree_digest` is `sha1` of `git status --porcelain`, **not** of `git diff`; `git diff` is blind to untracked files.
- Coverage table lists both `user-flow` and `runtime` with `ran` / `blocked` / `skipped` and a reason.

Freshness for a `url` report holds only when `deploy_rev` matches the `head_sha` under review, or the user confirms the running build came from that head. Otherwise declare it stale — a stale experience report cannot support `SHIP`.

Finally, clean up: close the browser (`browser_close`) and delete the Playwright artifacts left in the working directory (see below).

## Tooling notes

**Use the Playwright MCP server.** It is connected in both harnesses — Claude Code tool ids `mcp__plugin_playwright_playwright__*`; Codex `[mcp_servers.playwright]` in `~/.codex/config.toml`.

**Do not use the `chrome-devtools` MCP** — it is not configured. `web-perf` depends on it and dies at step 0; do not repeat that.

**`claude-in-chrome` is the escape hatch only** for reviewing a deployed app behind a login, where borrowing the real Chrome session is the only way in. It drives the user's actual browser with their actual cookies — ask first, and the forbidden-flow list applies twice as hard.

**Permission prompts mid-run.** Only these seven Playwright tools are pre-approved in `settings.json`:

`browser_navigate` · `browser_snapshot` · `browser_take_screenshot` · `browser_resize` · `browser_hover` · `browser_evaluate` · `browser_console_messages`

Everything else the walk needs — **`browser_network_requests`** (load-bearing for `runtime`), `browser_click`, `browser_type`, `browser_fill_form`, `browser_press_key`, `browser_wait_for`, `browser_select_option`, `browser_navigate_back`, `browser_close` — still works, but may stop and ask for permission part-way through. Expect it; it is not a failure.

**Artifacts land in `.playwright-mcp/` in the working directory**, and that path is not gitignored. Screenshots and snapshots go there by default. Copy what the report references into `docs/review/assets/<run_id>/` and delete the rest before finishing, or the next `git status` is full of noise.

**Evidence goes stale as you navigate.** `browser_network_requests` lists requests *since the current page load* — navigate away and the previous route's requests are gone. Harvest per route, before leaving it. Console has an `all: true` mode that survives navigation, so a final sweep works there; network does not have that luxury. Contract detail is in `reviewers/runtime.md`.

## Not in scope

| Belongs to | What |
| --- | --- |
| `/review-change` | code-level bugs, missing tests, insecure code — anything whose evidence is the diff |
| `/review-health` | architecture, coupling, dependencies, docs drift |
| `/review-release` | the ship decision; this profile produces evidence, not verdicts |
| `frontend-design-bar` | making new UI look designed. This skill judges what exists. |

Do not fix anything. Report findings; the user decides. If a fix is obvious, put it in `action` and move on.

Contracts: [reviewers/user-flow.md](reviewers/user-flow.md) · [reviewers/runtime.md](reviewers/runtime.md)
