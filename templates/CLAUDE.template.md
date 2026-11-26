<!-- Last Updated: {{YYYY-MM-DD}} -->
<!-- Neutral starter for a global CLAUDE.md. Replace {{placeholders}}. Prefer short rules agents can obey. -->

# Global instructions

## Communication

- Language: {{Tiếng Việt / English / …}}
- Tone: {{conversational / formal / terse}}
- Prefer native everyday words over mixed-language filler when a clear equivalent exists.
- Code identifiers and file paths in backticks.
- If a request has multiple interpretations, list them and ask before changing code.

## Conciseness

- Default to the shortest answer that fully addresses the request.
- No headers, bullet lists, code blocks, or "next steps" unless asked or the task needs structured output.
- Expand only on explicit request ("explain in detail", "give examples", "step by step", …).

## Frontend

- New or reshaped UI: read `{{kyant-ui-rules}}` (or your UI rulebook) before building.
- Design means assembly (motion, assets, interaction, depth), not generated static CSS alone.
- Not done until eye-approved on a screenshot or recording: a passing build is not finished.
- Scope: rendered output, interaction or UI behavior, not refactors with unchanged output.
- Before frontend work, lock a user-confirmed idea and approach (aesthetic UI also needs a demo surface). Missing or ambiguous → stop, ask or offer 2–3 options; an explicit go-ahead counts as confirmation.
- Skip this for trivial edits: a typo, copy, a user-specified value change.

## Working rules

Details live in `{{~/.claude/rules/core/}}` (or your rules path).

- Before creating a new file, look for an existing file with the same job; before planning a new file or module layout, read the project-structure template.
- Never create `.bak` / `.old` / `.orig` / `-v2` / `-v3` / `-final` / `-copy` files: edit the original; git keeps history.
- Temp, experiment and debug files go in the scratchpad, never the repo.
- Never claim "done / fixed / passing" without running verification and pasting evidence.
- Stay in task scope; call out out-of-scope work instead of doing it silently.
- Default is to take the task and do it; brainstorm, spec or plan only when a workflow threshold is hit (ambiguous outcome, architecture/data-model/public-contract change, explicit request).
- Commits: conventional commits with a scope; one commit, one concern.
- Specs, plans and docs follow your docs rules.
- A repo without `AGENTS.md` gets one generated from the AGENTS template, recording only deltas from the global baseline.

## Branching

- Do not auto-create git branches. Work on the current branch unless the user asks to branch or a PR is requested.
- When a branch is created, pair it with a git worktree (isolated checkout).
- Per-project worktree path and bootstrap steps belong in that project's own `CLAUDE.md` / `AGENTS.md`.
