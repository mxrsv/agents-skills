---
name: codebase-onboarding
description: Use when entering a new codebase, needing a fast architecture map, or generating onboarding notes from an unfamiliar project. Focuses on reconnaissance first, then targeted reads.
---

# Codebase Onboarding

Use this skill for fast orientation in a new repository.

## Workflow

1. Reconnaissance first:
   - inspect top-level structure
   - detect language, framework, package manager, tests, CI, env files
2. Identify:
   - entry points
   - key directories
   - request/data flow
   - project conventions
3. Read only the files that matter for those findings.
4. Xuất kết quả theo hợp đồng ở mục "Bootstrap" bên dưới.

## Output Shape

- `Stack`
- `Architecture`
- `Key directories`
- `Common commands`
- `Conventions`
- `Gotchas`

## Rules

- Do not read everything.
- Prefer `rg`, manifests, config files, and a few representative files.
- Optimize for navigation and execution, not encyclopedic coverage.

## Bootstrap (`--bootstrap`)

Ánh xạ kết quả recon vào đúng file theo D-rules:

| Mục recon                                    | File đích                                                       | Template                                             |
| -------------------------------------------- | --------------------------------------------------------------- | ---------------------------------------------------- |
| Stack, Common commands, Conventions, Gotchas | `AGENTS.md` (gốc repo)                                          | `~/.claude/templates/AGENTS.template.md`             |
| —                                            | `CLAUDE.md` (gốc repo) — nội dung là đúng một dòng `@AGENTS.md` | —                                                    |
| Architecture, request/data flow, Key directories | `docs/internals/overview.md`                                | `~/.claude/templates/internals-overview.template.md` |
| —                                            | `docs/README.md` — index trỏ tới `user/`, `internals/`, `operations/` (tầng nào không có thì không liệt kê) | — |

"Trạng thái hiện tại" (đang làm gì, còn treo gì) KHÔNG sinh file — đó là issue Linear (D0/D4).

Luật khi sinh:

- **NEVER ghi đè file đã tồn tại.** Đã có → bỏ qua, báo "đã có". Sửa file cũ cho đúng D1/D6 là việc tay riêng, KHÔNG thuộc bootstrap.
- Claim về hành vi trong `AGENTS.md` MUST là markdown link **tương đối từ chính file chứa link** + nhãn ý định (D6). Trong `docs/internals/*.md` trỏ ra code → bắt đầu bằng `../../`; không cần nhãn.
- `docs/internals/overview.md` chỉ giữ điều "maintainer sẽ làm sai nếu thiếu": quyết định + lý do, constraint xuyên module, trap. Không catalog file, không kể lại control-flow (D9).
- Không bịa. Không xác minh được → ghi `unknown`.
- Xong thì chạy `bash ~/.claude/scripts/docs-compliance.sh <repo>` và `bash ~/.claude/scripts/docs-anchors.sh <repo>`, dán output.

## Quyền thao tác

| write             | approve                       | stage | commit |
| ----------------- | ----------------------------- | ----- | ------ |
| ✅ (không ghi đè) | ✅ trình cho người dùng duyệt | ❌    | ❌     |

KHÔNG `git add`, KHÔNG `git commit` (D14).
