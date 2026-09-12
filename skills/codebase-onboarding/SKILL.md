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
4. Emit the result according to the contract in the "Bootstrap" section below.

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

Map the recon results to the right files per the D-rules:

| Recon item                                   | Target file                                                     | Template                                             |
| -------------------------------------------- | --------------------------------------------------------------- | ---------------------------------------------------- |
| Stack, Common commands, Conventions, Gotchas | `AGENTS.md` (repo root)                                         | `~/.claude/templates/AGENTS.template.md`             |
| —                                            | `CLAUDE.md` (repo root) — content is exactly one line `@AGENTS.md` | —                                                 |
| Architecture, request/data flow, Key directories | `docs/internals/overview.md`                                | `~/.claude/templates/internals-overview.template.md` |
| —                                            | `docs/README.md` — index pointing to `user/`, `internals/`, `operations/` (omit tiers that do not exist) | — |

"Current status" (what is being worked on, what is pending) generates NO file — that lives in the Linear issue (D0/D4).

Rules when generating:

- **NEVER overwrite an existing file.** Already exists → skip it and report "already exists". Fixing an old file to comply with D1/D6 is separate manual work, NOT part of bootstrap.
- Behavior claims in `AGENTS.md` MUST be markdown links **relative to the file containing the link** + an intent label (D6). In `docs/internals/*.md`, links out to code → start with `../../`; no label needed.
- `docs/internals/overview.md` keeps only what "a maintainer would get wrong without it": decisions + rationale, cross-module constraints, traps. No file catalogs, no control-flow retelling (D9).
- Do not make things up. Cannot verify → write `unknown`.
- When done, run `bash ~/.claude/scripts/docs-compliance.sh <repo>` and `bash ~/.claude/scripts/docs-anchors.sh <repo>`, and paste the output.

## Permissions

| write             | approve                       | stage | commit |
| ----------------- | ----------------------------- | ----- | ------ |
| ✅ (no overwrite) | ✅ present to the user for approval | ❌ | ❌     |

NO `git add`, NO `git commit` (D14).
