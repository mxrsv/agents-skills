# Agents & Skills

Bộ **custom agents** và **skills** cá nhân cho [Claude Code](https://claude.com/claude-code), tích luỹ qua quá trình dùng hàng ngày. Repo này là bản backup công khai — không chứa session, memory, hay bất kỳ config nhạy cảm nào (xem `.gitignore`).

## Cấu trúc

```
agents/     — subagent chuyên biệt (review, planning, research...)
skills/     — skill có thể invoke qua Skill tool hoặc slash command
commands/   — slash command tuỳ biến
rules/      — coding style / pattern áp dụng theo ngôn ngữ hoặc dùng chung
```

## Cách dùng

Copy thư mục tương ứng vào `~/.claude/` (global) hoặc `.claude/` trong project (local):

```bash
git clone https://github.com/mxrsv/agents-skills.git
cp -r agents-skills/agents  ~/.claude/agents
cp -r agents-skills/skills  ~/.claude/skills
cp -r agents-skills/commands ~/.claude/commands
cp -r agents-skills/rules   ~/.claude/rules
```

Claude Code tự nhận diện agent (qua `Agent` tool) và skill (qua `Skill` tool) dựa trên `description` trong frontmatter — không cần cấu hình thêm.

## Agents

| Agent                       | Vai trò                                                                                                |
| --------------------------- | ------------------------------------------------------------------------------------------------------ |
| `analyst`                   | Research, market/competitive analysis, brainstorming facilitation — ra draft document cho người review |
| `architect`                 | Thiết kế kiến trúc hệ thống, quyết định kỹ thuật khi lên plan feature/refactor lớn                     |
| `planner`                   | Lên kế hoạch chi tiết cho feature/refactor phức tạp                                                    |
| `plan-reviewer`             | Review plan có khớp với codebase hiện tại không (Gate 2) — read-only                                   |
| `code-reviewer`             | Review code sau khi implement — findings-first, báo hết lỗi trước khi sửa (Gate 3)                     |
| `engineering-code-reviewer` | Review code tập trung correctness/maintainability/security/performance, bỏ qua style cá nhân           |
| `typescript-reviewer`       | Review chuyên sâu TypeScript/JS — type safety, async correctness, security                             |
| `react-reviewer`            | Review chuyên sâu React/JSX — hook correctness, render performance, a11y                               |
| `database-reviewer`         | Review PostgreSQL — query optimization, schema design, best practice Supabase                          |
| `security-reviewer`         | Phát hiện lỗ hổng bảo mật — OWASP Top 10, secrets, injection, SSRF                                     |
| `performance-optimizer`     | Tìm bottleneck, tối ưu runtime, giảm bundle size                                                       |
| `silent-failure-hunter`     | Săn lỗi bị nuốt âm thầm — swallowed error, fallback tệ, thiếu error propagation                        |
| `refactor-cleaner`          | Dọn dead code, trùng lặp — chạy knip/depcheck/ts-prune rồi xoá an toàn                                 |
| `doc-updater`               | Cập nhật codemap và tài liệu (README, docs/CODEMAPS)                                                   |

## Skills

| Skill                           | Dùng khi nào                                                          |
| ------------------------------- | --------------------------------------------------------------------- |
| `brainstorm`                    | Trước khi build feature mới — clarify → đề xuất hướng → chốt spec     |
| `write-plan` / `planning`       | Sau khi rõ scope — viết plan thực thi từ spec                         |
| `plan-review`                   | Sau khi có plan, trước khi code — verify tính khả thi                 |
| `test-driven-development`       | Trước khi code logic mới — bắt buộc Red-Green-Refactor                |
| `code-review`                   | Sau khi implement, trước khi ship — verdict APPROVE/WARNING/BLOCK     |
| `review`                        | Review tổng quát spec/plan/code, findings-first                       |
| `verification`                  | Trước khi claim "đã xong/đã fix" — cần evidence thật                  |
| `finish`                        | Khi implementation xong — verify lại, tóm tắt, đề xuất bước tiếp theo |
| `security-review`               | Khi thêm auth, xử lý input, secrets, payment                          |
| `e2e-testing`                   | Viết/khắc phục Playwright test, POM pattern                           |
| `codebase-onboarding`           | Vào codebase lạ — dựng architecture map nhanh                         |
| `improve-codebase-architecture` | Tìm cơ hội refactor/deepen kiến trúc                                  |
| `deep-research`                 | Research đa nguồn có trích dẫn (firecrawl + exa)                      |
| `grill-with-docs`               | Stress-test plan so với domain model / ADR hiện có                    |
| `explain`                       | Giải thích khái niệm/bug/quyết định thiết kế theo phong cách sư phạm  |
| `frontend-design-bar`           | Build/reshape UI web — đảm bảo trông "được thiết kế", không generic   |
| `frontend-design-direction`     | Định hướng thiết kế frontend cho sản phẩm cụ thể                      |
| `html-artifact`                 | Tạo HTML artifact tự chứa (chỉ khi gọi tường minh)                    |
| `prototype`                     | Dựng prototype nháp để thử design/data model trước khi commit         |
| `manim-video`                   | Dựng video giải thích kỹ thuật bằng Manim                             |
| `content-engine`                | Tạo content đa nền tảng (X, LinkedIn, TikTok, newsletter...)          |
| `create-doc`                    | Tạo document theo template (PRD, research report, brief)              |
| `git-workflow`                  | Pattern branching, commit convention, merge/rebase                    |
| `github-ops`                    | Vận hành GitHub qua `gh` — issue/PR/CI/release                        |
| `team-agent-orchestration`      | Điều phối squad nhiều agent — work item, ownership, merge gate        |
| `role-routing`                  | Map vai trò analyst/developer/reviewer sang Codex-style subagent      |
| `hand-off`                      | Nén hội thoại hiện tại thành handoff doc cho agent khác               |
| `teach`                         | Dạy user một khái niệm/kỹ năng mới trong workspace                    |
| `context-budget`                | Audit token usage của agents/skills/MCP/CLAUDE.md                     |

## Rules

- `rules/context7.md` — luôn ưu tiên tra doc qua Context7 MCP khi làm việc với library/framework
- `rules/common/` — coding style, pattern React, pattern chung áp dụng mọi ngôn ngữ
- `rules/typescript/` — coding style và pattern riêng cho TypeScript
