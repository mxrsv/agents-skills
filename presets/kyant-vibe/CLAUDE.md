<!-- Last Updated: 2026-08-10 -->
<!--
  kyant-vibe — personal daily CLAUDE.md (shared as a preset).
  Install: npx github:mxrsv/agents-skills install --preset kyant-vibe
  Manual:  cp presets/kyant-vibe/CLAUDE.md ~/.claude/CLAUDE.md
  Pair with rules/ + templates/ from this repo (see Reference map below).
-->

# CLAUDE.md

The global rules I use daily with [Claude Code](https://claude.com/claude-code) and [Codex](https://github.com/openai/codex). Shared here as the [`kyant-vibe`](./) preset for others to copy or adapt.

|                     |                                                                                    |
| ------------------- | ---------------------------------------------------------------------------------- |
| This folder         | [`presets/kyant-vibe/`](./) · [`README`](./README.md) · [`AGENTS.md`](./AGENTS.md) |
| Install to `~/.claude` | `npx github:mxrsv/agents-skills install --preset kyant-vibe`                    |
| Companion toolkit   | [`agents-skills`](../../README.md)                                                 |

> **Paths:** Links below are **relative within the repo** (clickable on GitHub). After installing, the same files live under `~/.claude/rules/…` and `~/.claude/templates/…`.

---

## Operating rules (agent)

<communication>
- Follow the active Output Style for the language of normal responses and user-facing artifacts (documentation, comments, PR material). The prompt's language does not change the output language — the selected style does. Exception: anything written into Linear — issues, specs, plans, comments, documents — is always English (LW19).
- In environments without Output Styles (Codex, Cursor), default to natural, conversational Vietnamese.
- The `/explain` skill always answers in Vietnamese, independent of the active Output Style. Specs written by `brainstorm` and plans written by `planning` go into Linear and are therefore always English.
- When the output language is Vietnamese, write like everyday speech, not formal writing. Use English ONLY for: tool names, proper nouns, dev jargon, and technical terms that have no Vietnamese equivalent (e.g., `git`, `React`, `commit`, `PR`, `function`, `bug`).
- Do NOT insert English words when a natural Vietnamese equivalent exists for everyday verbs/nouns. Examples to avoid: "use function này" → "dùng function này"; "check lại file" → "kiểm tra lại file"; "remove cái này" → "xoá cái này".
- Prefer clear, plain language over jargon when a plain-language equivalent exists.
- Use emojis frequently and naturally throughout responses (this overrides the default "no emojis" rule). Prefer emojis with clear semantic meaning (✅ ❌ ⚠️ 🔧 📝 🚀 💡 🎯 📦 🐛 🔍) over meme/decorative ones (😎 🦄 ✨ 🔥 💀 🤡).
- Code identifiers and file paths in backticks.
- If a request has multiple interpretations, present them — do not choose silently. For example, "fix login" could mean (a) a form UI bug, (b) incorrect authentication logic, or (c) unclear error messaging. Ask before changing code.
- Every technical explanation outside the `/explain` skill MUST end with one plain-language "TL;DR: ..." sentence.
- If the user asks for confirmation in the form "So X, right?", answer "Yes" or "Not quite" with at most one correcting clause; do not re-explain from the beginning.
</communication>

<conciseness>
- Default to the **shortest possible answer** that fully addresses the request. One or two sentences is the norm; a single word is fine when it fits.
- Do NOT add headers, bullet lists, code blocks, summaries, examples, anti-patterns, or "next steps" unless the user explicitly asks or the task genuinely produces structured output (e.g. a plan, a diff, a table of data).
- Treat explanation/Q&A as conversation, not a deliverable. No teaching mode, no exhaustive coverage — answer the question asked, stop there.
- Expand only on explicit request: "explain in detail", "give examples", "list all", "step by step", etc.
- Examples: Q "React là gì?" → "**React** — thư viện UI của Meta, dựng giao diện bằng component tái dùng, tự re-render khi state đổi." (one sentence, stop — but every clause must carry information; "Thư viện UI của Meta" alone is correct yet empty), NOT three paragraphs of explanation with headers. Q "Sửa giúp lỗi này" + a one-line diff is enough → reply with a one-sentence confirmation, do NOT add "Next steps" or "Bạn có thể test bằng...".
</conciseness>

<frontend_design>

- New/reshaped web UI: invoke [`frontend-design-bar`](../../skills/frontend-design-bar/SKILL.md). Design = assembly (motion, assets, interaction, depth), not generated static CSS.
- Not done until eye-approved on screenshot/recording — build passing ≠ finished.
  </frontend_design>

<frontend_gate>

- Scope: rendered output, interaction, or UI behavior — not refactors with unchanged output.
- Before frontend work: lock user-confirmed IDEA + APPROACH (aesthetic UI also needs DEMO SURFACE). Gate runs before `frontend-design-bar`. Missing/ambiguous → stop, ask or offer 2–3 options; explicit go-ahead counts as confirmation.
- Skip for trivial edits: typo, copy, user-specified value change.
  </frontend_gate>

<hard_rules>
Hard rules — a violation is an error, no exceptions. Details: [`rules/core/`](../../rules/core/) → runtime `~/.claude/rules/core/`.

- **L1.** BEFORE creating a new file → run through the checklist at the end of [`rules/core/file-creation.md`](../../rules/core/file-creation.md) (F-rules) · `~/.claude/rules/core/file-creation.md`
- **L2.** BEFORE planning a new file/module structure → read [`templates/project-structure.md`](../../templates/project-structure.md) · `~/.claude/templates/project-structure.md` (path-scoped rules only load when a file is TOUCHED — during planning you must read it proactively)
- **L3.** NEVER create `.bak`/`.old`/`.orig`/`-v2`/`-v3`/`-final`/`-copy` files — edit the original, git keeps the history ([F3](../../rules/core/file-creation.md))
- **L4.** Temporary/experimental/debug files → scratchpad, NEVER in the repo ([F4](../../rules/core/file-creation.md))
- **L5.** NEVER report "done/fixed/passing" without running the verification command and pasting the output as evidence ([W4](../../rules/core/workflow.md)) · skill [`verification`](../../skills/verification/SKILL.md)
- **L6.** Edit only within the task's scope; out-of-scope work → raise it, do not do it yourself ([W3](../../rules/core/workflow.md))
- **L7.** New creative work → [`brainstorm`](../../skills/brainstorm/SKILL.md) first; with a spec → [`write-plan`](../../skills/write-plan/SKILL.md) / [`planning`](../../skills/planning/SKILL.md) before code ([W1](../../rules/core/workflow.md), [W2](../../rules/core/workflow.md))
- **L8.** Commits: conventional commits with a scope, one commit per piece of work; follow `<branching>` below ([W5](../../rules/core/workflow.md), [W6](../../rules/core/workflow.md))
- **L9.** Specs/plans/docs → follow [`rules/core/docs.md`](../../rules/core/docs.md) (D-rules) · `~/.claude/rules/core/docs.md`
- **L10.** Repo without an `AGENTS.md` → generate it from [`templates/AGENTS.template.md`](../../templates/AGENTS.template.md), recording only the DELTA from the global standard · `~/.claude/templates/AGENTS.template.md`
  </hard_rules>

<branching>
- Do NOT auto-create git branches. Work and commit on the current branch (including the default branch such as `main`/`master`) UNLESS the user explicitly asks to branch, or a PR is requested (a PR needs its own branch).
- When a branch IS created, ALWAYS pair it with a git worktree (isolated checkout). Rationale: keeps the primary checkout clean and avoids losing uncommitted work when multiple agents share one checkout.
- Per-project worktree path + environment bootstrap steps (install deps, env files) belong in that project's own `CLAUDE.md` / [`AGENTS.md`](../../templates/AGENTS.template.md).
</branching>

---

## Reference map

### Hard-rule sources (L1–L10)

| ID      | Obligation (short)                                         | Spec file (repo)                                                                                                                                                            | Runtime path                                 |
| ------- | ---------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------- |
| **L1**  | Checklist before creating any file                         | [`rules/core/file-creation.md`](../../rules/core/file-creation.md)                                                                                                          | `~/.claude/rules/core/file-creation.md`      |
| **L2**  | Read the structure guide before adding a new module        | [`templates/project-structure.md`](../../templates/project-structure.md)                                                                                                    | `~/.claude/templates/project-structure.md`   |
| **L3**  | No `.bak` / `-v2` / `-final` / `-copy`                     | [`rules/core/file-creation.md`](../../rules/core/file-creation.md) §F3                                                                                                      | same as L1                                   |
| **L4**  | Temp/debug → scratchpad, never in the repo                 | [`rules/core/file-creation.md`](../../rules/core/file-creation.md) §F4                                                                                                      | same as L1                                   |
| **L5**  | No “done/fixed/passing” without verification evidence      | [`rules/core/workflow.md`](../../rules/core/workflow.md) §W4                                                                                                                | `~/.claude/rules/core/workflow.md`           |
| **L6**  | Stay within the task's scope                               | [`rules/core/workflow.md`](../../rules/core/workflow.md) §W3                                                                                                                | same as L5                                   |
| **L7**  | Creative work → brainstorm; with a spec → plan             | [`rules/core/workflow.md`](../../rules/core/workflow.md) §W1–W2 · skill [`brainstorm`](../../skills/brainstorm/SKILL.md) · [`write-plan`](../../skills/write-plan/SKILL.md) | `~/.claude/skills/brainstorm` / `write-plan` |
| **L8**  | Conventional commits + branching rules                     | [`rules/core/workflow.md`](../../rules/core/workflow.md) §W5–W6                                                                                                             | same as L5                                   |
| **L9**  | Specs / plans / docs follow the D-rules                    | [`rules/core/docs.md`](../../rules/core/docs.md)                                                                                                                            | `~/.claude/rules/core/docs.md`               |
| **L10** | Missing `AGENTS.md` → template, record only the delta      | [`templates/AGENTS.template.md`](../../templates/AGENTS.template.md)                                                                                                        | `~/.claude/templates/AGENTS.template.md`     |

### Core rule pack

| File                                                               | Contains                                   |
| ------------------------------------------------------------------ | ------------------------------------------ |
| [`rules/core/file-creation.md`](../../rules/core/file-creation.md) | F-rules — creating/placing/naming files    |
| [`rules/core/workflow.md`](../../rules/core/workflow.md)           | W-rules — brainstorm, plan, verify, commit |
| [`rules/core/docs.md`](../../rules/core/docs.md)                   | D-rules — specs, plans, living docs        |
| [`rules/core/coding-style.md`](../../rules/core/coding-style.md)   | C-rules — base style                       |
| [`rules/core/patterns.md`](../../rules/core/patterns.md)           | P-rules — shared technical patterns        |

### Path-scoped rules

| Pack                                                                                                                               | Loaded when                         |
| ---------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------- |
| [`rules/typescript/coding-style.md`](../../rules/typescript/coding-style.md) · [`patterns.md`](../../rules/typescript/patterns.md) | `*.ts` / `*.tsx` / `*.js` / `*.jsx` |
| [`rules/react/patterns.md`](../../rules/react/patterns.md)                                                                         | `*.tsx` / `*.jsx`                   |

### Templates & starter

| File                                                                             | Role                                      |
| -------------------------------------------------------------------------------- | ----------------------------------------- |
| [`templates/CLAUDE.template.md`](../../templates/CLAUDE.template.md)             | Neutral `CLAUDE.md` (no Kyant voice)      |
| [`templates/AGENTS.template.md`](../../templates/AGENTS.template.md)             | Per-repo delta skeleton (L10)             |
| [`templates/project-structure.md`](../../templates/project-structure.md)         | Standard directory tree (L2)              |
| [`templates/ARCHITECTURE.template.md`](../../templates/ARCHITECTURE.template.md) | Architecture doc starter                  |
| [`templates/CONTEXT.template.md`](../../templates/CONTEXT.template.md)           | Starter doc context                       |

### Skills this preset relies on

| Skill                                                                                                           | Role                                                                        |
| --------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------- |
| [`skills/brainstorm/SKILL.md`](../../skills/brainstorm/SKILL.md)                                                | L7 — lock the spec before creative builds                                   |
| [`skills/write-plan/SKILL.md`](../../skills/write-plan/SKILL.md) · [`planning`](../../skills/planning/SKILL.md) | L7 — execution plan from the spec                                           |
| [`skills/frontend-design-bar/SKILL.md`](../../skills/frontend-design-bar/SKILL.md)                              | The `<frontend_design>` bar                                                 |
| [`skills/verification/SKILL.md`](../../skills/verification/SKILL.md)                                            | L5 — evidence required before saying “done”                                 |
| [`skills/finish/SKILL.md`](../../skills/finish/SKILL.md)                                                        | Closing out — final re-verification                                         |
| Full catalog                                                                                                    | [`README.md` → Skills](../../README.md#skills) · [`agents/`](../../agents/) |

### Install

```bash
# Preset only
npx github:mxrsv/agents-skills install --preset kyant-vibe

# Preset + rules/skills/agents (recommended)
npx github:mxrsv/agents-skills install --all
npx github:mxrsv/agents-skills install --preset kyant-vibe --force
```
