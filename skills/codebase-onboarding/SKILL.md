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

| Mục recon                                    | File đích                                                       | Template                                       |
| -------------------------------------------- | --------------------------------------------------------------- | ---------------------------------------------- |
| Stack, Common commands, Conventions, Gotchas | `AGENTS.md` (gốc repo)                                          | `~/.claude/templates/AGENTS.template.md`       |
| —                                            | `CLAUDE.md` (gốc repo) — nội dung là đúng một dòng `@AGENTS.md` | —                                              |
| Architecture, request/data flow              | `docs/ARCHITECTURE.md`                                          | `~/.claude/templates/ARCHITECTURE.template.md` |
| Trạng thái hiện tại                          | `docs/CONTEXT.md`                                               | `~/.claude/templates/CONTEXT.template.md`      |
| Key directories                              | `docs/CODEMAP.md` (tuỳ chọn)                                    | —                                              |

Luật khi sinh:

- **NEVER ghi đè file đã tồn tại.** Đã có → bỏ qua, báo "đã có". Sửa file cũ cho đúng D6/D7 là việc tay riêng, KHÔNG thuộc bootstrap.
- Mọi claim về hành vi MUST là markdown link **tương đối từ chính file chứa link** + nhãn ý định (D6). Trong `docs/*.md` trỏ ra code → bắt đầu bằng `../`.
- Mỗi file MUST kết bằng mục "Chưa khớp thực tế" (D7); rỗng thì ghi rõ rỗng.
- Không bịa. Không xác minh được → ghi `unknown`.
- Xong thì chạy `bash ~/.claude/scripts/docs-compliance.sh <repo>` và dán output.

## Quyền thao tác

| write             | approve                       | stage | commit |
| ----------------- | ----------------------------- | ----- | ------ |
| ✅ (không ghi đè) | ✅ trình cho người dùng duyệt | ❌    | ❌     |

KHÔNG `git add`, KHÔNG `git commit` (D14).
