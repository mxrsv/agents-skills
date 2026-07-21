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

Shared external skills are kept in `~/.agents/skills` and exposed to both Claude Code and Codex through symlinks in `~/.claude/skills` and `~/.codex/skills`. The symlink entries tracked in this repo expect the canonical skill directories to exist under `~/.agents/skills`.

## Agents

- **Planning & architecture**
  - **`analyst`** — Research, market/competitive analysis, and brainstorming facilitation; produces draft docs for review.
  - **`architect`** — System architecture design and technical decisions for large feature/refactor planning.
  - **`planner`** — Detailed planning for complex features and refactors.
  - **`plan-reviewer`** — Verifies a plan is executable against the current codebase (Gate 2); read-only.
- **Code review & reliability**
  - **`code-reviewer`** — Reviews implemented code findings-first and reports issues before fixes (Gate 3).
  - **`engineering-code-reviewer`** — Reviews correctness, maintainability, security, and performance rather than style preferences.
  - **`typescript-reviewer`** — Deep TypeScript/JS review covering type safety, async correctness, and security.
  - **`react-reviewer`** — Deep React/JSX review covering hook correctness, render performance, and accessibility.
  - **`database-reviewer`** — PostgreSQL review covering query optimization, schema design, and Supabase practices.
  - **`security-reviewer`** — Detects security vulnerabilities including OWASP Top 10, secrets, injection, and SSRF.
  - **`silent-failure-hunter`** — Hunts swallowed errors, bad fallbacks, and missing error propagation.
- **Performance & maintenance**
  - **`performance-optimizer`** — Finds bottlenecks, optimizes runtime, and reduces bundle size.
  - **`refactor-cleaner`** — Cleans up dead code and duplication using knip/depcheck/ts-prune, then removes it safely.
  - **`doc-updater`** — Updates codemaps and documentation such as README and `docs/CODEMAPS`.

## Skills

- **Discovery & planning**
  - **`brainstorm`** — Before building a feature; clarify the goal, compare approaches, and lock the spec.
  - **`write-plan` / `planning`** — Once scope is clear; write an execution plan from a spec.
  - **`plan-review`** — After a plan exists and before coding; verify feasibility.
  - **`codebase-onboarding`** — Entering an unfamiliar codebase; build a fast architecture map.
  - **`improve-codebase-architecture`** — Find refactoring and deepening opportunities in architecture.
  - **`deep-research`** — Multi-source research with citations using firecrawl and exa.
- **Review, testing & verification**
  - **`test-driven-development`** — Before writing new logic; enforce Red-Green-Refactor.
  - **`code-review`** — After implementation and before shipping; produce an APPROVE/WARNING/BLOCK verdict.
  - **`review`** — General findings-first review of specs, plans, and code.
  - **`verification`** — Before claiming work is done or fixed; require real evidence.
  - **`finish`** — When implementation is complete; re-verify and summarize the result.
  - **`security-review`** — When adding auth, handling input, secrets, or payments.
  - **`e2e-testing`** — Writing or fixing Playwright tests and Page Object Models.
- **Frontend & prototyping**
  - **`frontend-design-bar`** — Build or reshape web UI so it looks designed rather than generic.
  - **`frontend-design-direction`** — Set a product-specific frontend design direction.
  - **`prototype`** — Build a throwaway prototype to test a design or data model before committing.
  - **`html-artifact`** — Create a self-contained HTML artifact when explicitly invoked.
  - **`manim-video`** — Build technical explainer videos with Manim.
- **Content, documentation & workflow**
  - **`content-engine`** — Create multi-platform content for X, LinkedIn, TikTok, and newsletters.
  - **`create-doc`** — Create documents from templates such as PRDs, research reports, and briefs.
  - **`grill-with-docs`** — Stress-test a plan against the existing domain model and ADRs.
  - **`git-workflow`** — Branching patterns, commit conventions, and merge/rebase guidance.
  - **`github-ops`** — GitHub operations via `gh`, including issues, PRs, CI, and releases.
  - **`team-agent-orchestration`** — Orchestrate a multi-agent squad with work items, ownership, and merge gates.
  - **`role-routing`** — Map analyst/developer/reviewer roles onto Codex-style subagents.
  - **`hand-off`** — Compact the current conversation into a handoff doc for another agent.
  - **`teach`** — Teach the user a new skill or concept within the workspace.
  - **`context-budget`** — Audit token usage across agents, skills, MCP, and `CLAUDE.md`.

### Shared external skills

These skills are installed under `~/.agents/skills` and linked into both agent runtimes:

- **Communication**
  - **`caveman`** ([source](https://github.com/juliusbrussee/caveman)) — Use a concise, token-efficient communication style.
- **Frontend & design**
  - **`design-taste-frontend`** ([source](https://github.com/leonxlnx/taste-skill)) — Design anti-slop landing pages, portfolios, and redesigns.
  - **`frontend-design-audit`** ([source](https://github.com/mistyhx/frontend-design-audit)) — Audit usability of existing frontends and live websites.
  - **`high-end-visual-design`** ([source](https://github.com/leonxlnx/taste-skill)) — Apply high-end agency visual design and motion standards.
  - **`imagegen-frontend-web`** ([source](https://github.com/leonxlnx/taste-skill)) — Generate section-by-section visual references for frontend work.
  - **`impeccable`** ([source](https://github.com/pbakaus/impeccable)) — Critique, polish, and improve frontend interfaces.
  - **`redesign-existing-projects`** ([source](https://github.com/leonxlnx/taste-skill)) — Upgrade existing websites/apps without breaking functionality.
- **Debugging & delivery**
  - **`diagnosing-bugs`** ([source](https://github.com/mattpocock/skills)) — Diagnose hard bugs and performance regressions.
  - **`triage`** ([source](https://github.com/mattpocock/skills)) — Categorise issues and turn them into agent-ready briefs.
- **UI systems**
  - **`shadcn`** ([source](https://github.com/shadcn-ui/ui)) — Work with shadcn/ui components, registries, and `components.json`.

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
