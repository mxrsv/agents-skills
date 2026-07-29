<!-- Last Updated: {{YYYY-MM-DD}} -->
<!-- Neutral starter for a global CLAUDE.md. Replace {{placeholders}}. Prefer short rules agents can obey. -->

<communication>
- Language: {{Tiếng Việt / English / …}}
- Tone: {{conversational / formal / terse}}
- Prefer native everyday words over mixed-language filler when a clear equivalent exists.
- Code identifiers and file paths in backticks.
- If a request has multiple interpretations, list them and ask before changing code.
</communication>

<conciseness>
- Default to the shortest answer that fully addresses the request.
- No headers, bullet lists, code blocks, or "next steps" unless asked or the task needs structured output.
- Expand only on explicit request ("explain in detail", "give examples", "step by step", …).
</conciseness>

<frontend_design>

- New or reshaped web UI: invoke `{{frontend-design-bar}}` (or your design skill).
- Design means assembly (motion, assets, interaction, depth), not generated static CSS alone.
- Not done until eye-approved on screenshot/recording — build passing ≠ finished.
  </frontend_design>

<frontend_gate>

- Scope: rendered output, interaction, or UI behavior — not refactors with unchanged output.
- Before frontend work: lock user-confirmed IDEA + APPROACH (aesthetic UI also needs DEMO SURFACE).
- Missing/ambiguous → stop, ask or offer 2–3 options; explicit go-ahead counts as confirmation.
- Skip for trivial edits: typo, copy, user-specified value change.
  </frontend_gate>

<hard_rules>
Hard rules — violations are errors. Details live in `{{~/.claude/rules/core/}}` (or your rules path).

- L1. BEFORE creating a new file → run the file-creation checklist (F-rules).
- L2. BEFORE planning new file/module layout → read the project-structure template.
- L3. NEVER create `.bak` / `.old` / `.orig` / `-v2` / `-v3` / `-final` / `-copy` — edit the original; git keeps history.
- L4. Temp / experiment / debug files → scratchpad, NEVER the repo.
- L5. NEVER claim "done / fixed / passing" without running verification and pasting evidence.
- L6. Stay in task scope; call out out-of-scope work, do not do it silently.
- L7. New creative work → brainstorm first; with a spec → plan before code.
- L8. Commits: conventional commits with scope; one commit, one concern; follow <branching>.
- L9. Specs / plans / docs → follow your docs rules.
- L10. Repo without AGENTS.md → generate from the AGENTS template; record only deltas vs global baseline.
  </hard_rules>

<branching>
- Do NOT auto-create git branches. Work on the current branch unless the user asks to branch, or a PR is requested.
- When a branch IS created, pair it with a git worktree (isolated checkout).
- Per-project worktree path + bootstrap steps belong in that project's own CLAUDE.md / AGENTS.md.
</branching>
