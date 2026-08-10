<p align="center">
  <img src="assets/banner.jpg" alt="Kyant — agents-skills · vibe coding" width="100%">
</p>

<p align="center">
  <strong>Tiếng Việt</strong> ·
  <a href="README.en.md">English</a>
</p>

<h1 align="center">agents-skills</h1>

<p align="center">
  Bộ toolkit của <strong>Kyant</strong> — custom agents, skills, rules &amp; vibe-coding presets cho
  <a href="https://claude.com/claude-code">Claude Code</a> và
  <a href="https://github.com/openai/codex">Codex</a>, dựng từ lúc livestream hàng ngày.
</p>

<p align="center">
  <a href="https://www.youtube.com/@kyant_official"><img src="https://img.shields.io/badge/YouTube-@kyant__official-FF0000?style=flat-square&logo=youtube&logoColor=white" alt="YouTube"></a>
  <a href="https://x.com/kyant_vn"><img src="https://img.shields.io/badge/X-@kyant__vn-111827?style=flat-square&logo=x&logoColor=white" alt="X"></a>
  <a href="#bắt-đầu-nhanh"><img src="https://img.shields.io/badge/install-npx-0d9488?style=flat-square" alt="npx install"></a>
  <a href="https://claude.com/claude-code"><img src="https://img.shields.io/badge/Claude_Code-ready-d97706?style=flat-square" alt="Claude Code"></a>
  <a href="https://github.com/openai/codex"><img src="https://img.shields.io/badge/Codex-ready-2563eb?style=flat-square" alt="Codex"></a>
</p>

<p align="center">
  <a href="#bắt-đầu-nhanh">Bắt đầu nhanh</a> ·
  <a href="#cách-dùng">Cài bằng CLI</a> ·
  <a href="#agents">Agents</a> ·
  <a href="#skills">Skills</a> ·
  <a href="#claudemd-presets-vibe-coding">Presets</a>
</p>

---

Một phần hệ thống kênh **Kyant** (live vibe coding). Không publish session, memory hay secrets (xem [`.gitignore`](.gitignore)).

## Bắt đầu nhanh

```bash
npx github:mxrsv/agents-skills install
```

Một vài lệnh hay dùng:

```bash
npx github:mxrsv/agents-skills install --all
npx github:mxrsv/agents-skills install --preset kyant-vibe
npx github:mxrsv/agents-skills install --skill brainstorm --agent planner
npx github:mxrsv/agents-skills list
```

## Cách dùng

### Cài bằng CLI (khuyên dùng)

Không cần clone:

```bash
npx github:mxrsv/agents-skills
npx github:mxrsv/agents-skills install
```

Luồng tương tác:

1. Chọn cái cần cài — hết, skills/agents/rules, một **CLAUDE.md preset**, hoặc chọn từng mục (`1 3 5`, `1-4`, hoặc `a`)
2. Platform — **Claude Code**, **Codex**, hoặc **cả hai**
3. Target — global (`~/.claude` / `~/.codex`) hoặc local (`./.claude` / `./.codex`)
4. Bỏ qua hoặc ghi đè file đã có
5. Xác nhận

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

Lưu ý với Codex:

- Slash-commands cài vào `prompts/` (không phải `commands/`).
- Agents bị bỏ qua trên Codex; skills, commands và rules vẫn cài bình thường.

Không tương tác:

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

Clone một lần (không phải `npx` fetch lại):

```bash
git clone https://github.com/mxrsv/agents-skills.git
cd agents-skills
./bin/agents-skills install
```

### Copy thủ công

```bash
git clone https://github.com/mxrsv/agents-skills.git
cp -r agents-skills/agents   ~/.claude/agents
cp -r agents-skills/skills   ~/.claude/skills
cp -r agents-skills/commands ~/.claude/commands
cp -r agents-skills/rules    ~/.claude/rules
```

Claude Code tự nhận agents (`Agent` tool) và skills (`Skill` tool) từ frontmatter `description` của từng file — không cần cấu hình thêm.

## Cấu trúc

| Path                       | Vai trò                                              |
| -------------------------- | ---------------------------------------------------- |
| [`agents/`](agents/)       | Subagent chuyên biệt (review, planning, research…)   |
| [`skills/`](skills/)       | Skills gọi qua Skill tool / slash command            |
| [`commands/`](commands/)   | Slash command tự viết                                |
| [`rules/`](rules/)         | Rules luôn nạp + theo path                           |
| [`templates/`](templates/) | Starter `AGENTS.md` / `CLAUDE.md` + cấu trúc project |
| [`presets/`](presets/)     | Preset `CLAUDE.md` có tên (live vibe-coding)         |
| [`hooks/`](hooks/)         | File-guard (tên junk, file quá lớn)                  |
| [`assets/`](assets/)       | Media cho README                                     |

## Agents

Claude Code nhận các agent này qua `Agent` tool (frontmatter `description`). Codex không có cơ chế subagent theo file — agents bị bỏ qua khi cài sang Codex.

### Planning & kiến trúc

| Agent                                      | Mô tả                                                                                  |
| ------------------------------------------ | -------------------------------------------------------------------------------------- |
| [`analyst`](agents/analyst.md)             | Nghiên cứu, phân tích thị trường/đối thủ, hỗ trợ brainstorm; draft docs để người duyệt |
| [`architect`](agents/architect.md)         | Kiến trúc hệ thống và quyết định kỹ thuật cho feature/refactor lớn                     |
| [`planner`](agents/planner.md)             | Lập plan chi tiết cho feature và refactor phức tạp                                     |
| [`plan-reviewer`](agents/plan-reviewer.md) | Gate 2 — kiểm tra plan có chạy được với codebase không (chỉ đọc)                       |

### Code review & độ tin cậy

| Agent                                                      | Mô tả                                                                     |
| ---------------------------------------------------------- | ------------------------------------------------------------------------- |
| [`code-reviewer`](agents/code-reviewer.md)                 | Gate 3 — review ưu tiên finding; báo issue trước khi sửa                  |
| [`review-recall`](agents/review-recall.md)                 | Review phụ ưu tiên recall (độ tin cậy, toàn vẹn dữ liệu, chất lượng test) |
| [`review-adjudicator`](agents/review-adjudicator.md)       | Gộp bản precision + recall thành một kết luận đã lọc                      |
| [`typescript-reviewer`](agents/typescript-reviewer.md)     | TypeScript/JS sâu: types, async đúng, security                            |
| [`react-reviewer`](agents/react-reviewer.md)               | React/JSX sâu: hooks, hiệu năng render, a11y                              |
| [`database-reviewer`](agents/database-reviewer.md)         | PostgreSQL: tối ưu query, schema, thực hành Supabase                      |
| [`security-reviewer`](agents/security-reviewer.md)         | OWASP Top 10, secrets, injection, SSRF                                    |
| [`silent-failure-hunter`](agents/silent-failure-hunter.md) | Lỗi bị nuốt, fallback kém, thiếu lan truyền lỗi                           |

### Hiệu năng & bảo trì

| Agent                                                      | Mô tả                                                |
| ---------------------------------------------------------- | ---------------------------------------------------- |
| [`performance-optimizer`](agents/performance-optimizer.md) | Điểm nghẽn, chi phí runtime, kích thước bundle       |
| [`refactor-cleaner`](agents/refactor-cleaner.md)           | Dọn code chết / trùng lặp (knip, depcheck, ts-prune) |
| [`doc-updater`](agents/doc-updater.md)                     | Codemap và docs sống (`README`, `docs/CODEMAPS`)     |

## Skills

### Khám phá & lập plan

| Skill                                                                            | Mô tả                                                          |
| -------------------------------------------------------------------------------- | -------------------------------------------------------------- |
| [`brainstorm`](skills/brainstorm/SKILL.md)                                       | Trước khi build — làm rõ nhu cầu, so hướng làm, chốt spec      |
| [`planning`](skills/planning/SKILL.md)                                           | Plan thực thi khi phạm vi đã rõ                                |
| [`plan-review`](skills/plan-review/SKILL.md)                                     | Sau plan, trước code — kiểm tra có làm được không              |
| [`codebase-onboarding`](skills/codebase-onboarding/SKILL.md)                     | Bản đồ kiến trúc nhanh cho repo lạ                             |
| [`improve-codebase-architecture`](skills/improve-codebase-architecture/SKILL.md) | Cơ hội refactor / đào sâu kiến trúc                            |
| [`domain-modeling`](skills/domain-modeling/SKILL.md)                             | Ngôn ngữ dùng chung, thuật ngữ domain, ADR                     |
| [`interview-me`](skills/interview-me/SKILL.md)                                   | Phỏng vấn từng câu để moi ý định thật                          |
| [`find-skills`](skills/find-skills/SKILL.md)                                     | Tìm / cài agent skills                                         |
| [`explain`](skills/explain/SKILL.md)                                             | Giảng khái niệm, bug, hoặc quyết định thiết kế theo style chọn |

### Review, test & xác minh

| Skill                                                | Mô tả                                              |
| ---------------------------------------------------- | -------------------------------------------------- |
| [`code-review`](skills/code-review/SKILL.md)         | Review song song → APPROVE / WARNING / BLOCK       |
| [`review`](skills/review/SKILL.md)                   | Review ưu tiên finding cho specs, plans, hoặc code |
| [`security-review`](skills/security-review/SKILL.md) | Auth, input, secrets, thanh toán                   |
| [`docs-drift`](skills/docs-drift/SKILL.md)           | Docs vs hành vi code thật (mặc định chỉ đọc)       |
| [`diagnosing-bugs`](skills/diagnosing-bugs/SKILL.md) | Bug khó và tụt hiệu năng                           |

### Frontend & prototype

| Skill                                                            | Mô tả                                         |
| ---------------------------------------------------------------- | --------------------------------------------- |
| [`frontend-design-bar`](skills/frontend-design-bar/SKILL.md)     | UI trông như được thiết kế, không generic     |
| [`frontend-design-audit`](skills/frontend-design-audit/SKILL.md) | Audit dùng thử cho UI sẵn có / site đang chạy |
| [`prototype`](skills/prototype/SKILL.md)                         | Prototype bỏ được trước khi chốt hướng        |
| [`impeccable`](skills/impeccable/SKILL.md)                       | Phê, mài, cải giao diện                       |
| [`shadcn`](skills/shadcn/SKILL.md)                               | Component shadcn/ui, registry, chat UI        |

### Nội dung, docs & quy trình

| Skill                                              | Mô tả                                         |
| -------------------------------------------------- | --------------------------------------------- |
| [`hand-off`](skills/hand-off/SKILL.md)             | Nén hội thoại để agent khác nhận việc         |
| [`context-budget`](skills/context-budget/SKILL.md) | Rà token qua agents, skills, MCP, `CLAUDE.md` |

### Skills ngoài dùng chung

Cài dưới `~/.agents/skills` rồi symlink vào Claude Code / Codex. CLI mặc định bỏ qua symlink hỏng; dùng `--with-symlinks` khi target đã tồn tại.

| Skill                                                            | Upstream                                                                          |
| ---------------------------------------------------------------- | --------------------------------------------------------------------------------- |
| [`frontend-design-audit`](skills/frontend-design-audit/SKILL.md) | [mistyhx/frontend-design-audit](https://github.com/mistyhx/frontend-design-audit) |
| [`impeccable`](skills/impeccable/SKILL.md)                       | [pbakaus/impeccable](https://github.com/pbakaus/impeccable)                       |
| [`diagnosing-bugs`](skills/diagnosing-bugs/SKILL.md)             | [mattpocock/skills](https://github.com/mattpocock/skills)                         |
| [`shadcn`](skills/shadcn/SKILL.md)                               | [shadcn-ui/ui](https://github.com/shadcn-ui/ui)                                   |

## CLAUDE.md presets (vibe coding)

Preset livestream **Kyant** + template trung lập để fork.

| Path                                                           | Là gì                                                                               |
| -------------------------------------------------------------- | ----------------------------------------------------------------------------------- |
| [`templates/CLAUDE.template.md`](templates/CLAUDE.template.md) | `CLAUDE.md` global trung lập — điền `{{placeholders}}`                              |
| [`presets/kyant-vibe/`](presets/kyant-vibe/)                   | Preset vibe-coding **Kyant** (giọng Việt, trả lời ngắn, frontend gates, hard rules) |

```bash
npx github:mxrsv/agents-skills install --preset kyant-vibe
cp templates/CLAUDE.template.md ~/.claude/CLAUDE.md   # hoặc bắt đầu từ template
```

Presets ghi `CLAUDE.md` vào target cài. Ghép với [`rules/`](rules/) để link hard-rule resolve được. Fork preset thoải mái — ngôn ngữ và emoji là gu, không phải luật.

## Rules & templates

| Path                                                               | Nội dung                                                                       |
| ------------------------------------------------------------------ | ------------------------------------------------------------------------------ |
| [`rules/core/`](rules/core/)                                       | Luôn nạp: tạo file (F), workflow (W), docs (D), coding style (C), patterns (P) |
| [`rules/typescript/`](rules/typescript/)                           | Path-scoped cho `*.ts/tsx/js/jsx`                                              |
| [`rules/react/`](rules/react/)                                     | Path-scoped cho `*.tsx/jsx`                                                    |
| [`templates/AGENTS.template.md`](templates/AGENTS.template.md)     | Skeleton delta rules theo project                                              |
| [`templates/CLAUDE.template.md`](templates/CLAUDE.template.md)     | Starter `CLAUDE.md` trung lập                                                  |
| [`templates/project-structure.md`](templates/project-structure.md) | Cây thư mục chuẩn                                                              |
| [`hooks/file-guard.sh`](hooks/file-guard.sh)                       | Chặn tên file junk; cảnh báo file quá lớn / sai chỗ                            |
