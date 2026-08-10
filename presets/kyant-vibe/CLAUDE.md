<!-- Last Updated: 2026-08-10 -->
<!--
  kyant-vibe — personal daily CLAUDE.md (shared as a preset).
  Install: npx github:mxrsv/agents-skills install --preset kyant-vibe
  Manual:  cp presets/kyant-vibe/CLAUDE.md ~/.claude/CLAUDE.md
  Pair with rules/ + templates/ from this repo (see Reference map below).
-->

# CLAUDE.md

Luật global mình dùng hàng ngày với [Claude Code](https://claude.com/claude-code) và [Codex](https://github.com/openai/codex). Share ở đây dưới dạng preset [`kyant-vibe`](./) để người khác copy hoặc chỉnh.

|                     |                                                                                    |
| ------------------- | ---------------------------------------------------------------------------------- |
| Folder này          | [`presets/kyant-vibe/`](./) · [`README`](./README.md) · [`AGENTS.md`](./AGENTS.md) |
| Cài vào `~/.claude` | `npx github:mxrsv/agents-skills install --preset kyant-vibe`                       |
| Toolkit kèm theo    | [`agents-skills`](../../README.md)                                                 |

> **Đường dẫn:** Link bên dưới là **relative trong repo** (bấm được trên GitHub). Sau khi cài, cùng file nằm dưới `~/.claude/rules/…` và `~/.claude/templates/…`.

---

## Luật vận hành (agent)

<communication>
- Always respond in Vietnamese with a natural, conversational tone — like everyday speech, not formal writing.
- Use English ONLY for: tool names, proper nouns, dev jargon, and technical terms that have no Vietnamese equivalent (e.g., `git`, `React`, `commit`, `PR`, `function`, `bug`).
- Do NOT insert English words when a natural Vietnamese equivalent exists for everyday verbs/nouns. Examples to avoid: "use function này" → "dùng function này"; "check lại file" → "kiểm tra lại file"; "remove cái này" → "xoá cái này".
- Use emojis frequently and naturally throughout responses (this overrides the default "no emojis" rule). Prefer emojis with clear semantic meaning (✅ ❌ ⚠️ 🔧 📝 🚀 💡 🎯 📦 🐛 🔍) over meme/decorative ones (😎 🦄 ✨ 🔥 💀 🤡).
- Code identifiers and file paths in backticks.
- If multiple interpretations of a request exist, present them — don't pick silently. Example: user says "sửa login" → could mean (a) UI bug ở form login, (b) auth logic sai, (c) error message khó hiểu. Hỏi rõ trước khi fix.
</communication>

<conciseness>
- Default to the **shortest possible answer** that fully addresses the request. One or two sentences is the norm; a single word is fine when it fits.
- Do NOT add headers, bullet lists, code blocks, summaries, examples, anti-patterns, or "next steps" unless the user explicitly asks or the task genuinely produces structured output (e.g. a plan, a diff, a table of data).
- Treat explanation/Q&A as conversation, not a deliverable. No teaching mode, no exhaustive coverage — answer the question asked, stop there.
- Expand only on explicit request: "explain in detail", "give examples", "list all", "step by step", etc.
- Examples: Q "React là gì?" → "Thư viện UI của Meta." (1 câu, dừng), KHÔNG phải 3 đoạn giải thích kèm headers. Q "Sửa giúp lỗi này" + 1 dòng diff đủ → trả lời 1 câu xác nhận, KHÔNG thêm "Next steps" hay "Bạn có thể test bằng...".
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
Luật cứng — vi phạm là lỗi, không có ngoại lệ. Chi tiết: [`rules/core/`](../../rules/core/) → runtime `~/.claude/rules/core/`.

- **L1.** TRƯỚC KHI tạo file mới → soát checklist cuối [`rules/core/file-creation.md`](../../rules/core/file-creation.md) (F-rules) · `~/.claude/rules/core/file-creation.md`
- **L2.** TRƯỚC KHI plan cấu trúc file/module mới → đọc [`templates/project-structure.md`](../../templates/project-structure.md) · `~/.claude/templates/project-structure.md` (luật path-scoped chỉ nạp khi ĐỤNG file — lúc planning phải chủ động đọc)
- **L3.** NEVER tạo file `.bak`/`.old`/`.orig`/`-v2`/`-v3`/`-final`/`-copy` — sửa file gốc, git giữ lịch sử ([F3](../../rules/core/file-creation.md))
- **L4.** File tạm/thí nghiệm/debug → scratchpad, NEVER trong repo ([F4](../../rules/core/file-creation.md))
- **L5.** NEVER báo "xong/đã sửa/pass" khi chưa chạy lệnh verify và dán output bằng chứng ([W4](../../rules/core/workflow.md)) · skill [`verification`](../../skills/verification/SKILL.md)
- **L6.** Chỉ sửa trong phạm vi task; việc ngoài scope → nêu ra, không tự làm ([W3](../../rules/core/workflow.md))
- **L7.** Việc creative mới → [`brainstorm`](../../skills/brainstorm/SKILL.md) trước; có spec → [`write-plan`](../../skills/write-plan/SKILL.md) / [`planning`](../../skills/planning/SKILL.md) trước khi code ([W1](../../rules/core/workflow.md), [W2](../../rules/core/workflow.md))
- **L8.** Commit: conventional commits có scope, một commit một việc; tuân `<branching>` bên dưới ([W5](../../rules/core/workflow.md), [W6](../../rules/core/workflow.md))
- **L9.** Specs/plans/docs → theo [`rules/core/docs.md`](../../rules/core/docs.md) (D-rules) · `~/.claude/rules/core/docs.md`
- **L10.** Repo chưa có `AGENTS.md` → sinh từ [`templates/AGENTS.template.md`](../../templates/AGENTS.template.md), chỉ ghi DELTA so với chuẩn global · `~/.claude/templates/AGENTS.template.md`
  </hard_rules>

<branching>
- Do NOT auto-create git branches. Work and commit on the current branch (including the default branch such as `main`/`master`) UNLESS the user explicitly asks to branch, or a PR is requested (a PR needs its own branch).
- When a branch IS created, ALWAYS pair it with a git worktree (isolated checkout). Rationale: keeps the primary checkout clean and avoids losing uncommitted work when multiple agents share one checkout.
- Per-project worktree path + environment bootstrap steps (install deps, env files) belong in that project's own `CLAUDE.md` / [`AGENTS.md`](../../templates/AGENTS.template.md).
</branching>

---

## Bản đồ tham chiếu

### Nguồn hard-rule (L1–L10)

| ID      | Nghĩa vụ (ngắn)                                            | File spec (repo)                                                                                                                                                            | Path lúc chạy                                |
| ------- | ---------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------- |
| **L1**  | Checklist trước khi tạo bất kỳ file nào                    | [`rules/core/file-creation.md`](../../rules/core/file-creation.md)                                                                                                          | `~/.claude/rules/core/file-creation.md`      |
| **L2**  | Đọc guide cấu trúc trước khi thêm module mới               | [`templates/project-structure.md`](../../templates/project-structure.md)                                                                                                    | `~/.claude/templates/project-structure.md`   |
| **L3**  | Cấm `.bak` / `-v2` / `-final` / `-copy`                    | [`rules/core/file-creation.md`](../../rules/core/file-creation.md) §F3                                                                                                      | giống L1                                     |
| **L4**  | Tạm/debug → scratchpad, không vào repo                     | [`rules/core/file-creation.md`](../../rules/core/file-creation.md) §F4                                                                                                      | giống L1                                     |
| **L5**  | Không báo “xong/đã sửa/pass” khi chưa có bằng chứng verify | [`rules/core/workflow.md`](../../rules/core/workflow.md) §W4                                                                                                                | `~/.claude/rules/core/workflow.md`           |
| **L6**  | Giữ trong phạm vi task                                     | [`rules/core/workflow.md`](../../rules/core/workflow.md) §W3                                                                                                                | giống L5                                     |
| **L7**  | Việc sáng tạo → brainstorm; có spec → plan                 | [`rules/core/workflow.md`](../../rules/core/workflow.md) §W1–W2 · skill [`brainstorm`](../../skills/brainstorm/SKILL.md) · [`write-plan`](../../skills/write-plan/SKILL.md) | `~/.claude/skills/brainstorm` / `write-plan` |
| **L8**  | Conventional commits + luật branching                      | [`rules/core/workflow.md`](../../rules/core/workflow.md) §W5–W6                                                                                                             | giống L5                                     |
| **L9**  | Specs / plans / docs theo D-rules                          | [`rules/core/docs.md`](../../rules/core/docs.md)                                                                                                                            | `~/.claude/rules/core/docs.md`               |
| **L10** | Thiếu `AGENTS.md` → template, chỉ ghi delta                | [`templates/AGENTS.template.md`](../../templates/AGENTS.template.md)                                                                                                        | `~/.claude/templates/AGENTS.template.md`     |

### Gói rule lõi

| File                                                               | Bao gồm                                    |
| ------------------------------------------------------------------ | ------------------------------------------ |
| [`rules/core/file-creation.md`](../../rules/core/file-creation.md) | F-rules — tạo/đặt/đặt tên file             |
| [`rules/core/workflow.md`](../../rules/core/workflow.md)           | W-rules — brainstorm, plan, verify, commit |
| [`rules/core/docs.md`](../../rules/core/docs.md)                   | D-rules — specs, plans, docs sống          |
| [`rules/core/coding-style.md`](../../rules/core/coding-style.md)   | C-rules — style nền                        |
| [`rules/core/patterns.md`](../../rules/core/patterns.md)           | P-rules — pattern kỹ thuật dùng chung      |

### Rules theo path

| Gói                                                                                                                                | Khi nào nạp                         |
| ---------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------- |
| [`rules/typescript/coding-style.md`](../../rules/typescript/coding-style.md) · [`patterns.md`](../../rules/typescript/patterns.md) | `*.ts` / `*.tsx` / `*.js` / `*.jsx` |
| [`rules/react/patterns.md`](../../rules/react/patterns.md)                                                                         | `*.tsx` / `*.jsx`                   |

### Templates & starter

| File                                                                             | Vai trò                                   |
| -------------------------------------------------------------------------------- | ----------------------------------------- |
| [`templates/CLAUDE.template.md`](../../templates/CLAUDE.template.md)             | `CLAUDE.md` trung lập (không giọng Kyant) |
| [`templates/AGENTS.template.md`](../../templates/AGENTS.template.md)             | Skeleton delta theo repo (L10)            |
| [`templates/project-structure.md`](../../templates/project-structure.md)         | Cây thư mục chuẩn (L2)                    |
| [`templates/ARCHITECTURE.template.md`](../../templates/ARCHITECTURE.template.md) | Starter doc kiến trúc                     |
| [`templates/CONTEXT.template.md`](../../templates/CONTEXT.template.md)           | Starter doc context                       |

### Skills preset này hay dựa vào

| Skill                                                                                                           | Vai trò                                                                     |
| --------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------- |
| [`skills/brainstorm/SKILL.md`](../../skills/brainstorm/SKILL.md)                                                | L7 — chốt spec trước khi build sáng tạo                                     |
| [`skills/write-plan/SKILL.md`](../../skills/write-plan/SKILL.md) · [`planning`](../../skills/planning/SKILL.md) | L7 — plan thực thi từ spec                                                  |
| [`skills/frontend-design-bar/SKILL.md`](../../skills/frontend-design-bar/SKILL.md)                              | Thanh chuẩn `<frontend_design>`                                             |
| [`skills/verification/SKILL.md`](../../skills/verification/SKILL.md)                                            | L5 — phải có bằng chứng trước khi bảo “xong”                                |
| [`skills/finish/SKILL.md`](../../skills/finish/SKILL.md)                                                        | Đóng việc — verify lại lần cuối                                             |
| Catalog đầy đủ                                                                                                  | [`README.md` → Skills](../../README.md#skills) · [`agents/`](../../agents/) |

### Cài kèm

```bash
# Chỉ preset
npx github:mxrsv/agents-skills install --preset kyant-vibe

# Preset + rules/skills/agents (khuyên dùng)
npx github:mxrsv/agents-skills install --all
npx github:mxrsv/agents-skills install --preset kyant-vibe --force
```
