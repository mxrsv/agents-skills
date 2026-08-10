<p align="center">
  <img src="./banner.jpg" alt="kyant-vibe — live vibe coding preset" width="100%">
</p>

<h1 align="center"><code>kyant-vibe</code></h1>

<p align="center">
  Preset vibe-coding livestream của <strong>Kyant</strong> — đúng cái <code>CLAUDE.md</code> dùng trên stream.
</p>

<p align="center">
  <a href="https://www.youtube.com/@kyant_official"><img src="https://img.shields.io/badge/YouTube-@kyant__official-FF0000?style=flat-square&logo=youtube&logoColor=white" alt="YouTube"></a>
  <a href="https://x.com/kyant_vn"><img src="https://img.shields.io/badge/X-@kyant__vn-111827?style=flat-square&logo=x&logoColor=white" alt="X"></a>
  <a href="../../README.md"><img src="https://img.shields.io/badge/repo-agents--skills-0d9488?style=flat-square" alt="agents-skills"></a>
</p>

---

## Trong folder này có gì

| File                         | Vai trò                                                                                      |
| ---------------------------- | -------------------------------------------------------------------------------------------- |
| [`banner.jpg`](./banner.jpg) | Banner hero của preset (Kyant vibe-coding)                                                   |
| [`CLAUDE.md`](./CLAUDE.md)   | Luật vận hành agent toàn cục (giọng, ngắn gọn, frontend gates, hard rules L1–L10, branching) |
| [`AGENTS.md`](./AGENTS.md)   | Entry cho Codex / Cursor — `@CLAUDE.md`                                                      |
| [`README.md`](./README.md)   | Trang này — cách cài + map sang phần còn lại của toolkit                                     |

**Folder này không phải cả toolkit.** Hard rules, agents và skills nằm chỗ khác trong repo (xem [Tham chiếu](#tham-chiếu)).

## Trong `CLAUDE.md` có gì

| Khối                                    | Điều khiển gì                                                                 |
| --------------------------------------- | ----------------------------------------------------------------------------- |
| `<communication>`                       | Giọng Việt đời thường, chính sách emoji, khi nào hỏi lại cho rõ               |
| `<conciseness>`                         | Trả lời ngắn mặc định — không viết luận trừ khi được hỏi                      |
| `<frontend_design>` / `<frontend_gate>` | Thanh chuẩn design + chốt IDEA/APPROACH trước khi làm UI                      |
| `<hard_rules>`                          | L1–L10 — tạo file, verify-trước-khi-báo-xong, scope, brainstorm/plan, commit… |
| `<branching>`                           | Không tự tạo branch; có tạo thì kèm worktree                                  |

Chi tiết hard-rule **không** copy lại đây — chúng trỏ sang [`rules/core/`](../../rules/core/).

## Cài đặt

**Khuyên dùng** (ghi `CLAUDE.md` vào root Claude Code / Codex):

```bash
npx github:mxrsv/agents-skills install --preset kyant-vibe
```

**Full stack Kyant** (skills + agents + rules + preset này):

```bash
npx github:mxrsv/agents-skills install --all
npx github:mxrsv/agents-skills install --preset kyant-vibe --force
```

**Thủ công:**

```bash
git clone https://github.com/mxrsv/agents-skills.git
cp agents-skills/presets/kyant-vibe/CLAUDE.md ~/.claude/CLAUDE.md
cp -r agents-skills/rules ~/.claude/rules   # cần cho link L1–L10
```

> Muốn starter trống thay vì giọng Kyant? Dùng [`templates/CLAUDE.template.md`](../../templates/CLAUDE.template.md).

## Tham chiếu

### Phải ghép (preset này kỳ vọng các file này)

| Path                                                                     | Vì sao                                                   |
| ------------------------------------------------------------------------ | -------------------------------------------------------- |
| [`rules/core/file-creation.md`](../../rules/core/file-creation.md)       | F-rules — L1, L3, L4                                     |
| [`rules/core/workflow.md`](../../rules/core/workflow.md)                 | W-rules — L5–L8 (verify, scope, brainstorm/plan, commit) |
| [`rules/core/docs.md`](../../rules/core/docs.md)                         | D-rules — L9                                             |
| [`rules/core/coding-style.md`](../../rules/core/coding-style.md)         | Baseline coding style                                    |
| [`rules/core/patterns.md`](../../rules/core/patterns.md)                 | Pattern kỹ thuật dùng chung                              |
| [`templates/project-structure.md`](../../templates/project-structure.md) | L2 — file/module mới đặt đâu                             |
| [`templates/AGENTS.template.md`](../../templates/AGENTS.template.md)     | L10 — `AGENTS.md` delta theo repo                        |
| [`templates/CLAUDE.template.md`](../../templates/CLAUDE.template.md)     | `CLAUDE.md` trung lập nếu không muốn giọng Kyant         |

### Rules theo path (nạp khi đụng các file đó)

| Path                                           | Khi nào                             |
| ---------------------------------------------- | ----------------------------------- |
| [`rules/typescript/`](../../rules/typescript/) | `*.ts` / `*.tsx` / `*.js` / `*.jsx` |
| [`rules/react/`](../../rules/react/)           | `*.tsx` / `*.jsx`                   |

### Phần còn lại của toolkit Kyant

| Path                               | Là gì                                                    |
| ---------------------------------- | -------------------------------------------------------- |
| [README gốc repo](../../README.md) | Banner, catalog agent/skill đầy đủ, cách dùng CLI        |
| [`agents/`](../../agents/)         | Subagent (planner, reviewers, …)                         |
| [`skills/`](../../skills/)         | Skills gọi được (`brainstorm`, `frontend-design-bar`, …) |
| [`commands/`](../../commands/)     | Slash command                                            |
| [`hooks/`](../../hooks/)           | File-guard (tên junk, file quá lớn)                      |
| [`assets/`](../../assets/)         | Logo Kyant + banner README                               |

### Kênh

| Platform | Link                                                                   |
| -------- | ---------------------------------------------------------------------- |
| YouTube  | [youtube.com/@kyant_official](https://www.youtube.com/@kyant_official) |
| X        | [x.com/kyant_vn](https://x.com/kyant_vn)                               |

## Tuỳ biến

Fork thoải mái. Đổi ngôn ngữ, emoji, độ ngắn theo stream hoặc team. Giữ **khung hard-rules** + cài [`rules/`](../../rules/) nếu muốn cùng thanh an toàn — lớp vibe là gu; thanh ray là hệ thống.
