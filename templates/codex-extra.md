<codex_sync>
- `~/.codex/AGENTS.md` is generated from CLAUDE.md + the active output style + rules + this file; after editing the sources, run `~/.claude/scripts/render-agent-rules.sh` to sync. Reminder when the gap is ≥ 3 days: Cursor Automation (see the draft in the wiki vault).
- Primary skills: source is `~/.claude/skills/<x>` (git), `~/.agents/skills/<x>` is a symlink to it — Codex reads `~/.agents/skills` natively, invoked as `$name`. After adding / renaming a skill, run `~/.claude/scripts/sync-agents-skills.sh`; `--check` to detect drift.
</codex_sync>

<codex_parity>
Codex equivalents for Claude Code mechanisms named in the rules above:
- "plan mode" → Codex Plan mode. A plan's closing `/goal` line → a Codex goal with the same condition.
- `EnterWorktree` / `claude --worktree` → `git worktree add <path> -b <branch> origin/<default-branch>`, then work in that path.
- Skills written as `/name` in these rules → invoke them as `$name`.
- User-only skills: a skill folder with `agents/openai.yaml` setting `policy.allow_implicit_invocation: false` runs only when invoked as `$name`. Skills that are `off` for Claude are `enabled = false` in `[[skills.config]]`.
- MCP servers that are off by default: Codex keeps them as `enabled = false` under `[mcp_servers.<name>]` in `~/.codex/config.toml`. When the user names one, set `enabled = true` and restart; set it back afterwards. The `<computer_use>` steps that edit `~/.claude/settings.json` (`deniedMcpServers`, `/mcp`) apply to Claude only. Codex's own `node_repl` and `cua_repl` run its browser and computer-use plugins; leave them on.
- Path-scoped rules: Codex loads `rules/core/docs.md` and `rules/docs/*.md` always (above). For React/TypeScript work, read `~/.claude/rules/react/patterns.md` and `~/.claude/rules/typescript/*.md` before editing.
- `AskUserQuestion` → put the batched questions in one message.
- No auto-mode classifier here (approval policy is `never`), so these Claude guards are rules you enforce yourself: never `git push --force` to `windows-mirror` on spacevibe-deck; from spacevibe-deck, ask before editing the sibling repos `spacevibe-api`, `spacevibe-bench`, `spacevibe-hub`, `spacevibe-academy`.
</codex_parity>
