---
name: scout
description: Study open-source repos to improve the current repo — scan them by specific questions, deep-dive the notable features, compare against the target repo and stop at a ranked plan for approval. Use when the user wants to learn from, benchmark against or borrow ideas from other projects. Not for onboarding into one unfamiliar repo (use codebase-onboarding) and not for implementing the result.
argument-hint: "research <questions> <repos...> | decide <digest path>"
---

# Scout

Funnel from cheap to expensive: wide reads on small models, one decision on a strong model. It covers stages 1–3 and **stops at a plan awaiting approval**; implementation is a separate session (Sonnet, one slice per session, worktree for parallel work).

## Two modes, two sessions

| Mode | Session model | Output |
| --- | --- | --- |
| `research` (stages 1–2) | Sonnet; subagents do the reading | Digest file in the session scratchpad, never in a repo (F4) |
| `decide` (stage 3) | Opus, fresh context | Ranked candidates, then a plan via `planning`, then stop |

Splitting keeps the research context out of the Opus cache. If the session was started on one model, say so and tell the user to open the other mode in a fresh session; do not silently run both.

## Inputs — ask if missing, do not scan broadly

- **Questions (2–3, concrete):** "How does X detect an agent waiting for input?" beats "what features does X have?". Without questions the scan returns features the target already has.
- **Repos:** URLs or local paths. Prefer repos solving the same problem over popular ones.
- **Target repo pain points (optional but valuable):** known bugs, traps docs, user complaints. Without them stage 3 ranks by taste.

## Research mode

1. **Prepare the target.** Read the target's `AGENTS.md` and its architecture overview. Pass a 10-line summary to every subagent so it reads with the target in mind.
2. **Stage 1 — one subagent per repo**, `model: "sonnet"` (`haiku` only when the job is listing files). Each subagent:
   - clones shallow into its own new, empty scratch directory; **never runs install, build, scripts or tests** from the repo (untrusted code);
   - answers each question: approach, the files that implement it, edge cases it handles, license;
   - cites `path:line` for every claim and marks each `verified` (read the lines) or `inferred`;
   - returns the summary only, never raw code.
3. **Verify.** Spot-check at least one cited line per repo yourself and drop or relabel any quote that does not match the file.
4. **Shortlist.** Propose 3–5 candidates against the target's pain points and **ask the user to confirm** before spending on stage 2.
5. **Stage 2 — one subagent per shortlisted feature**, `model: "sonnet"`, higher effort. Read the implementation in full: trade-offs, edge cases, failure handling, tests, what it depends on, what it would cost to port.
6. **Write the digest** (Bash heredoc if `Write` is refused) with: questions, per-repo findings, shortlist, deep-dive notes, licenses, and every claim's evidence label. Report its path and stop.

## Decide mode

Read the digest and the target repo (not the source repos again). For each candidate:

- **Target today:** current behaviour with `path:line` in the target. No line → write `unknown`.
- **Delta:** what the reference does that the target does not, and what problem that solves for the target's users.
- **Cost / risk:** surfaces touched; check the target's fork rules (e.g. PTY, updater, design invariants) and mark candidates that need owner approval.
- **Verdict:** `adopt`, `adapt` or `skip`, with one sentence of reason. Skip anything that exists only because the reference has it.

Rank, then hand the top slice to the `planning` skill (spec for requirements if material, plan for execution). Present the approach and **wait for approval**; do not start implementing.

## Rules

- **Ideas, not code.** Record each reference's license in the digest; copy no code. A public target repo must not absorb incompatible-license code.
- **Evidence labels survive to the end.** An `inferred` claim cannot be the sole basis for `adopt`.
- **Digest and clones stay out of repos**; delete the clones when research ends (W8).
- Final reply follows `<reply_format>`: result, evidence (what was verified, what was inferred), and the decision needed.
