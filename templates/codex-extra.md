<tools>
- Never use `pnpm exec` — run binaries directly (`pnpm tsc`, `pnpm eslint`) or via `pnpm run <script>`.
</tools>

<pull_request_convention>
PR title and body MUST be written in Vietnamese. Code identifiers, branch names, file paths, and CLI commands stay in English.

Title: imperative mood, max 70 chars, format `<type>: <short description in Vietnamese>`.

Body (use whichever sections apply):

- `## Tóm tắt` — 2-3 bullets covering what + why (required)
- `## Lý do` — context, link to issue if any
- `## Thay đổi chính` — main files/logic changed
- `## Cách test` — actionable checklist (required)
- `## Screenshots` — required if there are UI changes
- `## Breaking Changes` — required if there is breaking behavior

Each PR focuses on a single concern. The test plan must be concrete steps, not "run tests".
</pull_request_convention>

<codex_sync>
- `~/.codex/AGENTS.md` is generated from CLAUDE.md + rules + this file; after editing the sources, run `~/.claude/scripts/render-agent-rules.sh` to sync. Reminder when the gap is ≥ 3 days: Cursor Automation (see the draft in the wiki vault).
- Primary skills: source is `~/.claude/skills/<x>` (git), `~/.agents/skills/<x>` is a symlink to it — Codex reads `~/.agents/skills` natively, invoked as `$name`. After adding / renaming a skill, run `~/.claude/scripts/sync-agents-skills.sh`; `--check` to detect drift.
</codex_sync>

<codex_parity>
Codex equivalents for Claude Code mechanisms named in the rules above:
- Act on the most likely reading and state it in one line. Ask only before an irreversible or outward-facing action or for a fact only the user knows; report a reversible choice in the result. (Claude gets this from its output style.)
- "plan mode" → Codex Plan mode. A plan's closing `/goal` line → a Codex goal with the same condition.
- `EnterWorktree` / `claude --worktree` → `git worktree add <path> -b <branch> origin/<default-branch>`, then work in that path.
- MCP servers that are off by default: Codex keeps them as `enabled = false` under `[mcp_servers.<name>]` in `~/.codex/config.toml`. When the user names one, set `enabled = true` and restart; set it back afterwards. `deniedMcpServers` applies to Claude only.
- User-only skills: a skill folder with `agents/openai.yaml` setting `policy.allow_implicit_invocation: false` runs only when invoked as `$name`.
- `AskUserQuestion` → put the batched questions in one message.
</codex_parity>
