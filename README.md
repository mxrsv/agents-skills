# Agents & Skills

A personal set of **custom agents** and **skills** for [Claude Code](https://claude.com/claude-code), built up through daily use. This repo is a public backup — it contains no sessions, memory, or sensitive config (see `.gitignore`).

## Structure

```
agents/     — specialized subagents (review, planning, research...)
skills/     — skills invokable via the Skill tool or slash commands
commands/   — custom slash commands
rules/      — coding style / patterns, per-language or shared
```

## Usage

Copy the folders you want into `~/.claude/` (global) or `.claude/` inside a project (local):

```bash
git clone https://github.com/mxrsv/agents-skills.git
cp -r agents-skills/agents   ~/.claude/agents
cp -r agents-skills/skills   ~/.claude/skills
cp -r agents-skills/commands ~/.claude/commands
cp -r agents-skills/rules    ~/.claude/rules
```

Claude Code automatically discovers agents (via the `Agent` tool) and skills (via the `Skill` tool) from the `description` in each file's frontmatter — no extra configuration needed.

## Agents

| Agent                       | Role                                                                                               |
| --------------------------- | -------------------------------------------------------------------------------------------------- |
| `analyst`                   | Research, market/competitive analysis, brainstorming facilitation — produces draft docs for review |
| `architect`                 | System architecture design and technical decisions for large feature/refactor planning             |
| `planner`                   | Detailed planning for complex features and refactors                                               |
| `plan-reviewer`             | Verifies a plan is executable against the current codebase (Gate 2) — read-only                    |
| `code-reviewer`             | Reviews implemented code — findings-first, reports all issues before any fixes (Gate 3)            |
| `engineering-code-reviewer` | Reviews code for correctness/maintainability/security/performance, not style preferences           |
| `typescript-reviewer`       | Deep TypeScript/JS review — type safety, async correctness, security                               |
| `react-reviewer`            | Deep React/JSX review — hook correctness, render performance, accessibility                        |
| `database-reviewer`         | PostgreSQL review — query optimization, schema design, Supabase best practices                     |
| `security-reviewer`         | Detects security vulnerabilities — OWASP Top 10, secrets, injection, SSRF                          |
| `performance-optimizer`     | Finds bottlenecks, optimizes runtime, reduces bundle size                                          |
| `silent-failure-hunter`     | Hunts silent failures — swallowed errors, bad fallbacks, missing error propagation                 |
| `refactor-cleaner`          | Cleans up dead code and duplication — runs knip/depcheck/ts-prune, then safely removes it          |
| `doc-updater`               | Updates codemaps and documentation (README, docs/CODEMAPS)                                         |

## Skills

| Skill                           | When to use                                                                |
| ------------------------------- | -------------------------------------------------------------------------- |
| `brainstorm`                    | Before building a new feature — clarify → propose approaches → lock spec   |
| `write-plan` / `planning`       | Once scope is clear — write an execution plan from a spec                  |
| `plan-review`                   | After a plan exists, before coding — verify feasibility                    |
| `test-driven-development`       | Before writing new logic — enforces Red-Green-Refactor                     |
| `code-review`                   | After implementation, before shipping — verdict APPROVE/WARNING/BLOCK      |
| `review`                        | General findings-first review of specs/plans/code                          |
| `verification`                  | Before claiming work is "done/fixed" — requires real evidence              |
| `finish`                        | When implementation is complete — re-verify, summarize, suggest next steps |
| `security-review`               | When adding auth, handling input, secrets, or payments                     |
| `e2e-testing`                   | Writing/fixing Playwright tests, Page Object Model                         |
| `codebase-onboarding`           | Entering an unfamiliar codebase — build a fast architecture map            |
| `improve-codebase-architecture` | Find refactoring/deepening opportunities in architecture                   |
| `deep-research`                 | Multi-source research with citations (firecrawl + exa)                     |
| `grill-with-docs`               | Stress-test a plan against the existing domain model / ADRs                |
| `explain`                       | Explain a concept/bug/design decision in a deliberate teaching style       |
| `frontend-design-bar`           | Build/reshape web UI — make sure it looks designed, not generic            |
| `frontend-design-direction`     | Set a product-specific frontend design direction                           |
| `html-artifact`                 | Create a self-contained HTML artifact (only when explicitly invoked)       |
| `prototype`                     | Build a throwaway prototype to test a design/data model before committing  |
| `manim-video`                   | Build technical explainer videos with Manim                                |
| `content-engine`                | Create multi-platform content (X, LinkedIn, TikTok, newsletters...)        |
| `create-doc`                    | Create documents from templates (PRD, research report, brief)              |
| `git-workflow`                  | Branching patterns, commit conventions, merge/rebase                       |
| `github-ops`                    | GitHub operations via `gh` — issues/PRs/CI/releases                        |
| `team-agent-orchestration`      | Orchestrate a multi-agent squad — work items, ownership, merge gates       |
| `role-routing`                  | Map analyst/developer/reviewer roles onto Codex-style subagents            |
| `hand-off`                      | Compact the current conversation into a handoff doc for another agent      |
| `teach`                         | Teach the user a new skill or concept within the workspace                 |
| `context-budget`                | Audit token usage across agents/skills/MCP/CLAUDE.md                       |

### `docs-pipeline` — bộ 8 skill docs-bootstrap (thay BMad)

A linear, freeze-gated docs-bootstrap pipeline that ends at a frozen `REQUIREMENTS.md` contract handed off to `superpowers:writing-plans`. Packaged as a **skills-directory plugin** (`skills/docs-pipeline/.claude-plugin/plugin.json`, skills under `skills/docs-pipeline/skills/`) with a shared `references/` (single source of truth for the lock schema, freeze protocol, hash-cascade, and elicitation contract). Skills invoke namespaced, e.g. `/docs-pipeline:kickoff`. Design source: `docs/workflow-pipeline/SPEC.md`.

| Skill           | Role                                                                           |
| --------------- | ------------------------------------------------------------------------------ |
| `/kickoff`      | Phase 0 — scaffold `docs/`, capture + freeze `PRINCIPLES.md` (root hash-graph) |
| `/product`      | Phase 1 — extract intent → freeze `PRD.md` + `BUSINESS-FLOW.md`                |
| `/architecture` | Phase 2 — freeze `ARCHITECTURE.md` (+ conditional `UX-DESIGN.md`)              |
| `/requirements` | Phase 3 (terminal) — distill atomic FR/NFR → freeze `REQUIREMENTS.md`          |
| `/adr`          | Anytime — append-only immutable decision record                                |
| `/reconcile`    | Anytime — open a frozen doc for a local gap → re-freeze → cascade STALE        |
| `/pivot`        | Anytime — escape-hatch for a wrong premise → archive + rewind                  |
| `/agent-rules`  | Standalone — generate a `CLAUDE.md`/`AGENTS.md` (outside the pipeline)         |

## Rules

- `rules/context7.md` — always prefer looking up docs via the Context7 MCP when working with libraries/frameworks
- `rules/common/` — coding style, React patterns, and general patterns shared across languages
- `rules/typescript/` — coding style and patterns specific to TypeScript
