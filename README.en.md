<p align="center">
  <img src="assets/banner.jpg" alt="Kyant — agents-skills · vibe coding" width="100%">
</p>

<p align="center">
  <a href="README.md">Tiếng Việt</a> ·
  <strong>English</strong>
</p>

<h1 align="center">agents-skills</h1>

<p align="center">
  <strong>Kyant</strong> toolkit — custom agents, skills, rules &amp; vibe-coding presets for
  <a href="https://claude.com/claude-code">Claude Code</a> and
  <a href="https://github.com/openai/codex">Codex</a>, built from daily livestream use.
</p>

<p align="center">
  <a href="https://www.youtube.com/@kyant_official"><img src="https://img.shields.io/badge/YouTube-@kyant__official-FF0000?style=flat-square&logo=youtube&logoColor=white" alt="YouTube"></a>
  <a href="https://x.com/kyant_vn"><img src="https://img.shields.io/badge/X-@kyant__vn-111827?style=flat-square&logo=x&logoColor=white" alt="X"></a>
  <a href="#quick-start"><img src="https://img.shields.io/badge/install-npx-0d9488?style=flat-square" alt="npx install"></a>
  <a href="https://claude.com/claude-code"><img src="https://img.shields.io/badge/Claude_Code-ready-d97706?style=flat-square" alt="Claude Code"></a>
  <a href="https://github.com/openai/codex"><img src="https://img.shields.io/badge/Codex-ready-2563eb?style=flat-square" alt="Codex"></a>
</p>

<p align="center">
  <a href="#quick-start">Quick start</a> ·
  <a href="#usage">CLI install</a> ·
  <a href="#agents">Agents</a> ·
  <a href="#skills">Skills</a> ·
  <a href="#claudemd-presets-vibe-coding">Presets</a>
</p>

---

Part of the **Kyant** channel system (live vibe coding). No sessions, memory, or secrets are published (see [`.gitignore`](.gitignore)).

## Quick start

```bash
npx github:mxrsv/agents-skills install
```

Common one-liners:

```bash
npx github:mxrsv/agents-skills install --all
npx github:mxrsv/agents-skills install --preset kyant-vibe
npx github:mxrsv/agents-skills install --skill brainstorm --agent planner
npx github:mxrsv/agents-skills list
```

## Usage

### CLI install (recommended)

No clone needed:

```bash
npx github:mxrsv/agents-skills
npx github:mxrsv/agents-skills install
```

Interactive flow:

1. Choose what to install — everything, skills/agents/rules, a **CLAUDE.md preset**, or pick items (`1 3 5`, `1-4`, or `a`)
2. Platform — **Claude Code**, **Codex**, or **both**
3. Target — global (`~/.claude` / `~/.codex`) or local (`./.claude` / `./.codex`)
4. Skip or overwrite existing files
5. Confirm

```
════════════════════════════════════════
 agents-skills installer
════════════════════════════════════════
   1) Everything (skills + agents + commands + rules)
   2) All skills
   3) All agents
   4) All commands
   5) All rules
   6) CLAUDE.md preset…
   7) Pick specific skills…
   …

════════════════════════════════════════
 Platform
════════════════════════════════════════
   1) Claude Code  (~/.claude)
   2) Codex        (~/.codex)
   3) Both
```

Codex notes:

- Slash-commands install into `prompts/` (not `commands/`).
- Agents are skipped on Codex; skills, commands, and rules still install.

Non-interactive:

```bash
npx github:mxrsv/agents-skills install --all
npx github:mxrsv/agents-skills install --skills
npx github:mxrsv/agents-skills install --skill brainstorm --agent planner
npx github:mxrsv/agents-skills install --local --all
npx github:mxrsv/agents-skills install --codex --skills --commands
npx github:mxrsv/agents-skills install --both --skill brainstorm
npx github:mxrsv/agents-skills install --preset kyant-vibe
npx github:mxrsv/agents-skills list
npx github:mxrsv/agents-skills list presets
```

Clone once (no `npx` re-fetch):

```bash
git clone https://github.com/mxrsv/agents-skills.git
cd agents-skills
./bin/agents-skills install
```

### Manual copy

```bash
git clone https://github.com/mxrsv/agents-skills.git
cp -r agents-skills/agents   ~/.claude/agents
cp -r agents-skills/skills   ~/.claude/skills
cp -r agents-skills/commands ~/.claude/commands
cp -r agents-skills/rules    ~/.claude/rules
```

Claude Code discovers agents (`Agent` tool) and skills (`Skill` tool) from each file’s frontmatter `description` — no extra config.

## Structure

| Path                       | Role                                                    |
| -------------------------- | ------------------------------------------------------- |
| [`agents/`](agents/)       | Specialized subagents (review, planning, research…)     |
| [`skills/`](skills/)       | Skills — source of truth; symlinked into `~/.agents/skills` for Codex / Cursor |
| [`commands/`](commands/)   | Custom slash commands                                   |
| [`rules/`](rules/)         | Always-loaded + path-scoped rules                       |
| [`templates/`](templates/) | `AGENTS.md` / `CLAUDE.md` starters + project structures |
| [`presets/`](presets/)     | Named `CLAUDE.md` presets (live vibe-coding)            |
| [`hooks/`](hooks/)         | File-guard (junk names, oversized files)                |
| [`assets/`](assets/)       | README media                                            |

## Agents

Claude Code discovers these via the `Agent` tool (frontmatter `description`). Codex has no per-file subagent mechanism — agents are skipped on the Codex target.

### Planning & architecture

| Agent                                      | Description                                                                              |
| ------------------------------------------ | ---------------------------------------------------------------------------------------- |
| [`analyst`](agents/analyst.md)             | Research, market/competitive analysis, brainstorming facilitation; draft docs for review |
| [`architect`](agents/architect.md)         | System architecture and technical decisions for large features/refactors                 |
| [`planner`](agents/planner.md)             | Detailed planning for complex features and refactors                                     |
| [`plan-reviewer`](agents/plan-reviewer.md) | Gate 2 — verifies a plan is executable against the codebase (read-only)                  |

### Code review & reliability

| Agent                                                      | Description                                                               |
| ---------------------------------------------------------- | ------------------------------------------------------------------------- |
| [`typescript-reviewer`](agents/typescript-reviewer.md)     | Deep TypeScript/JS: types, async correctness, security                    |
| [`react-reviewer`](agents/react-reviewer.md)               | Deep React/JSX: hooks, render performance, a11y                           |
| [`database-reviewer`](agents/database-reviewer.md)         | PostgreSQL: query optimization, schema, Supabase practices                |
| [`security-reviewer`](agents/security-reviewer.md)         | OWASP Top 10, secrets, injection, SSRF                                    |
| [`silent-failure-hunter`](agents/silent-failure-hunter.md) | Swallowed errors, bad fallbacks, missing error propagation                |

### Performance & maintenance

| Agent                                                      | Description                                                |
| ---------------------------------------------------------- | ---------------------------------------------------------- |
| [`performance-optimizer`](agents/performance-optimizer.md) | Bottlenecks, runtime cost, bundle size                     |
| [`refactor-cleaner`](agents/refactor-cleaner.md)           | Dead code / duplication cleanup (knip, depcheck, ts-prune) |
| [`doc-updater`](agents/doc-updater.md)                     | Codemaps and living docs (`README`, `docs/CODEMAPS`)       |

## Skills

### Discovery & planning

Under the [documentation rules](rules/core/docs.md), the conversation supplies goals and approvals; the [planning skill](skills/planning/SKILL.md) keeps requirements, implementation, verification and handoff in one `docs/plans/YYYY-MM-DD-<slug>.md` file. No issue key or external tracker is required. Completed plans remain as historical records; durable knowledge belongs in living docs. Small, clear tasks do not require a plan.

| Skill                                                                               | Description                                                  |
| ----------------------------------------------------------------------------------- | ------------------------------------------------------------ |
| [`brainstorm`](skills/brainstorm/SKILL.md)                                          | Before building — clarify, compare approaches, lock the spec |
| [`planning`](skills/planning/SKILL.md) | Execution plan once scope is clear                           |
| [`codebase-onboarding`](skills/codebase-onboarding/SKILL.md)                        | Fast architecture map for unfamiliar repos                   |
| [`improve-codebase-architecture`](skills/improve-codebase-architecture/SKILL.md)    | Refactor / deepen architecture opportunities                 |
| [`domain-modeling`](skills/domain-modeling/SKILL.md)                                | Ubiquitous language, domain terms, ADRs                      |
| [`interview-me`](skills/interview-me/SKILL.md)                                      | One-question-at-a-time interview to extract real intent      |
| [`find-skills`](skills/find-skills/SKILL.md)                                        | Discover / install agent skills                              |
| [`explain`](skills/explain/SKILL.md)                                                | Teach a concept, bug, or design decision in a chosen style   |

### Review, testing & verification

| Skill                                                                | Description                                       |
| -------------------------------------------------------------------- | ------------------------------------------------- |
| [`review-change`](skills/review-change/SKILL.md)         | Review a change you just made — correctness, tests, security |
| [`review-experience`](skills/review-experience/SKILL.md) | Real user flow in a browser — states, viewports, a11y        |
| [`review-health`](skills/review-health/SKILL.md)         | Repo health — architecture, dependencies, docs drift         |
| [`review-release`](skills/review-release/SKILL.md)       | Synthesize reports → SHIP / FIX / REFACTOR / RETHINK         |
| [`review`](skills/review/SKILL.md)                                   | Findings-first review of specs, plans, or code    |
| [`security-review`](skills/security-review/SKILL.md)                 | Auth, input, secrets, payments                    |
| [`docs-drift`](skills/docs-drift/SKILL.md)                           | Docs vs real code behavior (read-only by default) |
| [`diagnosing-bugs`](skills/diagnosing-bugs/SKILL.md)                 | Hard bugs and performance regressions             |

### Frontend & prototyping

| Skill                                                                      | Description                                    |
| -------------------------------------------------------------------------- | ---------------------------------------------- |
| [`frontend-design-bar`](skills/frontend-design-bar/SKILL.md)               | UI that looks designed, not generic            |
| [`frontend-design-audit`](skills/frontend-design-audit/SKILL.md)           | Usability audit for existing UIs / live sites  |
| [`prototype`](skills/prototype/SKILL.md)                                   | Throwaway prototype before committing          |
| [`impeccable`](skills/impeccable/SKILL.md)                                 | Critique, polish, improve interfaces           |
| [`shadcn`](skills/shadcn/SKILL.md)                                         | shadcn/ui components, registries, chat UI      |

### Content, docs & workflow

| Skill                                                                  | Description                                               |
| ---------------------------------------------------------------------- | --------------------------------------------------------- |
| [`hand-off`](skills/hand-off/SKILL.md)                                 | Compact the conversation for another agent                |
| [`context-budget`](skills/context-budget/SKILL.md)                     | Audit token use across agents, skills, MCP, `CLAUDE.md`   |

### Sharing with Codex / Cursor

Self-authored skills under `skills/` are the **source of truth** (git-tracked). [`scripts/sync-agents-skills.sh`](scripts/sync-agents-skills.sh) creates `~/.agents/skills/<x> → ~/.claude/skills/<x>` symlinks for every git-tracked skill; Codex reads `~/.agents/skills` natively and follows symlinks, so Claude Code, Codex and Cursor all use the same copy — no more drifting duplicates. Codex invokes a skill as `$name` instead of `/name`. Run with `--check` to detect drift: missing symlinks, frontmatter keys no harness reads, same-name copies in `~/.codex/skills`.

### Shared external skills

Installed under `~/.agents/skills` and symlinked into Claude Code / Codex. The CLI skips broken symlinks by default; use `--with-symlinks` when targets exist.

| Skill                                                                      | Upstream                                                                          |
| -------------------------------------------------------------------------- | --------------------------------------------------------------------------------- |
| [`frontend-design-audit`](skills/frontend-design-audit/SKILL.md)           | [mistyhx/frontend-design-audit](https://github.com/mistyhx/frontend-design-audit) |
| [`impeccable`](skills/impeccable/SKILL.md)                                 | [pbakaus/impeccable](https://github.com/pbakaus/impeccable)                       |
| [`diagnosing-bugs`](skills/diagnosing-bugs/SKILL.md)                       | [mattpocock/skills](https://github.com/mattpocock/skills)                         |
| [`shadcn`](skills/shadcn/SKILL.md)                                         | [shadcn-ui/ui](https://github.com/shadcn-ui/ui)                                   |

## CLAUDE.md presets (vibe coding)

**Kyant** livestream preset + a neutral template you can fork.

| Path                                                           | What it is                                                                                |
| -------------------------------------------------------------- | ----------------------------------------------------------------------------------------- |
| [`templates/CLAUDE.template.md`](templates/CLAUDE.template.md) | Neutral global `CLAUDE.md` — fill `{{placeholders}}`                                      |
| [`presets/kyant-vibe/`](presets/kyant-vibe/)                   | **Kyant** vibe-coding preset (Vietnamese tone, short answers, frontend gates, hard rules) |

```bash
npx github:mxrsv/agents-skills install --preset kyant-vibe
cp templates/CLAUDE.template.md ~/.claude/CLAUDE.md   # or start from template
```

Presets write `CLAUDE.md` at the install target. Pair with [`rules/`](rules/) so hard-rule links resolve. Fork the preset — language and emoji policy are taste, not law.

## Rules & templates

| Path                                                               | What                                                                                     |
| ------------------------------------------------------------------ | ---------------------------------------------------------------------------------------- |
| [`rules/core/`](rules/core/)                                       | Always-loaded: file creation (F), workflow (W), docs (D), coding style (C), patterns (P) |
| [`rules/typescript/`](rules/typescript/)                           | Path-scoped for `*.ts/tsx/js/jsx`                                                        |
| [`rules/react/`](rules/react/)                                     | Path-scoped for `*.tsx/jsx`                                                              |
| [`templates/AGENTS.template.md`](templates/AGENTS.template.md)     | Per-project delta rules skeleton                                                         |
| [`templates/CLAUDE.template.md`](templates/CLAUDE.template.md)     | Neutral `CLAUDE.md` starter                                                              |
| [`templates/project-structure.md`](templates/project-structure.md) | Canonical directory trees                                                                |
| [`hooks/file-guard.sh`](hooks/file-guard.sh)                       | Blocks junk filenames; warns on oversized / misplaced files                              |
