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
4. Produce a short onboarding note or update project instructions if asked.

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
