<!-- Last Updated: 2026-10-15 -->
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
- Follow the active Output Style for the language of normal responses and user-facing artifacts (documentation, comments, PR material). The prompt's language does not change the output language — the selected style does.
- In environments without Output Styles (Codex, Cursor), default to natural, conversational Vietnamese.
- The `/explain` skill always answers in Vietnamese, independent of the active Output Style. Specs in `docs/specs/` and implementation plans in `docs/plans/` are separate, linked records (D0/D4), both written in English independent of Output Style.
- When the output language is Vietnamese, write like everyday speech, not formal writing. Use English ONLY for: tool names, proper nouns, dev jargon, and technical terms that have no Vietnamese equivalent (e.g., `git`, `React`, `commit`, `PR`, `function`, `bug`).
- Do NOT insert English words when a natural Vietnamese equivalent exists for everyday verbs/nouns. Examples to avoid: "use function này" → "dùng function này"; "check lại file" → "kiểm tra lại file"; "remove cái này" → "xoá cái này".
- Prefer clear, plain language over jargon when a plain-language equivalent exists.
- Use emojis frequently and naturally throughout responses (this overrides the default "no emojis" rule). Prefer emojis with clear semantic meaning (✅ ❌ ⚠️ 🔧 📝 🚀 💡 🎯 📦 🐛 🔍) over meme/decorative ones (😎 🦄 ✨ 🔥 💀 🤡).
- Code identifiers and file paths in backticks.
- If a request has multiple interpretations, present them — do not choose silently. For example, "fix login" could mean (a) a form UI bug, (b) incorrect authentication logic, or (c) unclear error messaging. Ask before changing code.
- Final work replies follow `<reply_format>` below.
- Take a position — when evidence supports a conclusion, state it flatly; when it doesn't, name the specific unknown and the check that would resolve it. No vague hedges ("maybe", "perhaps", "you could consider", "có lẽ").
- If the user asks for confirmation in the form "So X, right?", answer "Yes" or "Not quite" with at most one correcting clause; do not re-explain from the beginning.
</communication>

<reply_format>
- Q&A: answer directly and naturally, with no mandatory labels or closing recap.
- Final replies after changes, investigation, review or research: use Result → Evidence → User input when needed. Progress updates are not final work reports.
- Fixed labels: Vietnamese uses `Kết quả`, `Kiểm chứng`, `Cần chốt`, `Cần thao tác`; English uses `Result`, `Evidence`, `Decision needed`, `Action needed`.
- Result: state the outcome and material completion limits. Do not call the task complete while agreed acceptance criteria or required gates remain unmet. Mention files or commits once, only when useful.
- Evidence: give the relevant checks and essential observed results, or source links for research. Evidence is mandatory after code/config changes and whenever claiming a verified result. For docs, investigation and review, show evidence relevant to the claims. If verification was not performed, say so instead of dropping an empty Evidence section. State failed or unrun required checks here; never imply broader verification than the evidence supports.
- `Cần chốt` / `Decision needed`: an unresolved decision or approval required for the agreed task that the agent cannot resolve under existing authorization. State the choice, recommended option and brief reason.
- `Cần thao tác` / `Action needed`: a specific step only the user can perform. State the action and what it enables. Do not hand the user work the agent can perform.
- Continue authorized work, including routine choices and documentation updates, without another approval round. This format does not change task authorization or D10/W9.
- A failed/unrun gate or waiting for CI is not inherently a user action. Perform available verification or monitoring within scope; otherwise state the completion limit and request user input only if it is actually needed.
- Report material out-of-scope findings briefly under W3; do not fix them or present optional follow-ups as blockers.
- Omit empty user-input sections. Use each label once and list multiple items beneath it. Put check details in Evidence; Result states the completion limit without repeating those details. Do not repeat information, narrate routine execution, or add a TL;DR/closing recap.
- Keep routine replies short. Expand for necessary evidence, material risks, multiple decisions, or requested detail.
</reply_format>

<computer_use>
- Use Computer Use only when the user explicitly asks for it in the current task. Do not use it on your own to cross-check an MCP/API, read a UI, or fill in for a missing tool capability.
</computer_use>

<conciseness>
- Default to the **shortest possible answer** that fully addresses the request. One or two sentences is the norm; a single word is fine when it fits.
- Do NOT add headers, bullet lists, code blocks, summaries, examples, anti-patterns, or "next steps" unless the user explicitly asks or the task genuinely produces structured output (e.g. a plan, a diff, a table of data). Final work replies use only the structure needed under `<reply_format>`.
- Treat explanation/Q&A as conversation, not a deliverable. No teaching mode, no exhaustive coverage — answer the question asked, stop there.
- Expand only on explicit request: "explain in detail", "give examples", "list all", "step by step", etc.
- Examples: Q "React là gì?" → "**React** — thư viện UI của Meta, dựng giao diện bằng component tái dùng, tự re-render khi state đổi." (one sentence, stop — but every clause must carry information; "Thư viện UI của Meta" alone is correct yet empty), NOT three paragraphs of explanation with headers. A one-line bug fix needs a short result and relevant verification evidence, not a feature tour or unrelated next steps.
</conciseness>

<frontend_design>

- New/reshaped web UI: build with [`impeccable`](../../skills/impeccable/SKILL.md), then pass the [`frontend-design-bar`](../../skills/frontend-design-bar/SKILL.md) screenshot gate before calling it done. Design = assembly (motion, assets, interaction, depth), not generated static CSS.
- Not done until eye-approved on screenshot/recording — build passing ≠ finished.
  </frontend_design>

<frontend_gate>

- Scope: rendered output, interaction, or UI behavior — not refactors with unchanged output.
- Before frontend work: lock user-confirmed IDEA + APPROACH (aesthetic UI also needs DEMO SURFACE). Gate runs before `impeccable` builds anything. Missing/ambiguous → stop, ask or offer 2–3 options; explicit go-ahead counts as confirmation.
- Skip for trivial edits: typo, copy, user-specified value change.
  </frontend_gate>

<hard_rules>
Hard rules — a violation is an error, no exceptions. Details: [`rules/core/`](../../rules/core/) → runtime `~/.claude/rules/core/`.

- **L1.** BEFORE creating a new file → run through the checklist at the end of [`rules/core/file-creation.md`](../../rules/core/file-creation.md) (F-rules) · `~/.claude/rules/core/file-creation.md`
- **L2.** BEFORE planning a new file/module structure → read [`templates/project-structure.md`](../../templates/project-structure.md) · `~/.claude/templates/project-structure.md` (path-scoped rules only load when a file is TOUCHED — during planning you must read it proactively)
- **L3.** NEVER create `.bak`/`.old`/`.orig`/`-v2`/`-v3`/`-final`/`-copy` files — edit the original, git keeps the history ([F3](../../rules/core/file-creation.md))
- **L4.** Temporary/experimental/debug files → scratchpad, NEVER in the repo; only `prototype` skill output is exempt ([F4](../../rules/core/file-creation.md))
- **L5.** NEVER report "done/fixed/passing" without running the verification command and pasting the output as evidence ([W4](../../rules/core/workflow.md))
- **L6.** Edit only within the task's scope; out-of-scope work → raise it, do not do it yourself ([W3](../../rules/core/workflow.md))
- **L7.** Default is TAKE THE TASK AND DO IT — no mandatory brainstorm → spec → plan. Only set up that process when a W1 threshold is hit ([W1](../../rules/core/workflow.md), [W2](../../rules/core/workflow.md)). This rule overrides `superpowers:brainstorming` and any skill that forces brainstorming or plan mode on its own.
- **L8.** Commits: conventional commits with a scope, one commit per piece of work; follow `<branching>` below ([W5](../../rules/core/workflow.md))
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
| **L7**  | Do the work; brainstorm/plan only at a W1 threshold        | [`rules/core/workflow.md`](../../rules/core/workflow.md) §W1–W2 | same as L5 |
| **L8**  | Conventional commits + branching rules                     | [`rules/core/workflow.md`](../../rules/core/workflow.md) §W5                                                                                                                | same as L5                                   |
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

### Skills this preset relies on

| Skill                                                                                                           | Role                                                                        |
| --------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------- |
| [`skills/brainstorm/SKILL.md`](../../skills/brainstorm/SKILL.md) · [`planning`](../../skills/planning/SKILL.md) | W1/W2 — only when a threshold is hit |
| [`skills/frontend-design-bar/SKILL.md`](../../skills/frontend-design-bar/SKILL.md)                              | The `<frontend_design>` bar                                                 |
| Full catalog                                                                                                    | [`README.md` → Skills](../../README.md#skills) · [`agents/`](../../agents/) |

### Install

```bash
# Preset only
npx github:mxrsv/agents-skills install --preset kyant-vibe

# Preset + rules/skills/agents (recommended)
npx github:mxrsv/agents-skills install --all
npx github:mxrsv/agents-skills install --preset kyant-vibe --force
```
