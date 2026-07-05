---
name: context-budget
description: Use to audit token consumption across agents, skills, MCP servers, and CLAUDE.md. Identifies bloat, redundancy, and produces optimization recommendations. Meta-maintenance skill.
---

# Context Budget

## The Rule

**KNOW YOUR TOKEN COSTS. EVERY COMPONENT HAS A PRICE.**

Agent descriptions load every time. MCP tools cost ~500 tokens each. Skills load on invocation. Bloat accumulates silently.

## When to Use

- System feels slow or hitting context limits
- Before adding new agents/skills/MCP servers
- Periodic maintenance (monthly)
- After major system changes

## Process

### Phase 1: Inventory

Scan and estimate token cost for each component:

| Component | How to estimate | Where |
|---|---|---|
| **Agents** | `words × 1.3` | `.claude/agents/*.md` |
| **Skills** | `words × 1.3` (SKILL.md only — extra files load on demand) | `.claude/skills/*/SKILL.md` |
| **CLAUDE.md** | `words × 1.3` | All CLAUDE.md files |
| **MCP servers** | `~500 tokens per tool` | Check `/mcp` or settings.json |
| **Rules** | `words × 1.3` | `.claude/rules/*.md` |

```bash
# Quick word count for all agents
wc -w .claude/agents/*.md

# Quick word count for all skills
find .claude/skills -name "SKILL.md" -exec wc -w {} +

# Count MCP tools loaded
# Check /context output in Claude Code
```

### Phase 2: Classify

| Category | Criteria | Action |
|---|---|---|
| **Always needed** | Used every session | Keep |
| **Sometimes needed** | Used weekly | Consider on-demand |
| **Rarely needed** | Used monthly or less | Remove or lazy-load |

### Phase 3: Detect Issues

Flag these patterns:

| Issue | Threshold | Fix |
|---|---|---|
| **Bloated agent description** | >30 words in frontmatter `description` | Shorten — description is for routing, not docs |
| **Heavy agent** | >200 lines | Move details to skill or reference doc |
| **Heavy skill** | >150 lines | Condense or split into SKILL.md + reference files |
| **MCP over-subscription** | >10 servers loaded | Disable unused servers |
| **CLAUDE.md bloat** | >200 lines | Split into focused rules files |
| **Redundant components** | Agent + skill overlap | Merge or clarify boundaries |
| **Unused components** | Never referenced in flows | Remove |

### Phase 4: Report

```text
[CONTEXT BUDGET AUDIT]

Total estimated overhead: {n} tokens

| Component | Count | Tokens | % |
|-----------|-------|--------|---|
| Agents    | {n}   | {n}    | % |
| Skills    | {n}   | {n}    | % |
| CLAUDE.md | {n}   | {n}    | % |
| MCP tools | {n}   | {n}    | % |
| Rules     | {n}   | {n}    | % |

Issues found: {n}
1. {issue} — {component} — Save: ~{n} tokens
2. {issue} — {component} — Save: ~{n} tokens

Top 3 recommendations:
1. {action} — saves ~{n} tokens
2. {action} — saves ~{n} tokens
3. {action} — saves ~{n} tokens

Capacity: {remaining}% free after overhead
```

## Key Insights

- **MCP is the biggest lever** — each tool schema ~500 tokens. 10 servers × 5 tools = 25,000 tokens
- **Agent descriptions load always** — even if agent never runs. Keep short.
- **Skill SKILL.md loads on invocation** — extra files in skill folder load only when Read
- **CLAUDE.md loads always** — every token counts

## Enforcement

- **ALWAYS** include token estimates with evidence
- **ALWAYS** produce actionable recommendations
- **NEVER** recommend removing components without checking if they're referenced

## Shared By

All agents (meta-maintenance)
