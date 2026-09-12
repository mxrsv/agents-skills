> Global standard: ~/.claude v{{YYYY-MM-DD}} — stamp the global standard's date when generating this file; update it when syncing to a newer standard.

# {{Project name}}

{{One-liner: what the project does}}. Stack: {{Next.js 15 / Node 22 / Tauri 2 / ...}}.

## Common commands

| Command              | Purpose                    |
| -------------------- | -------------------------- |
| `{{pnpm dev}}`       | {{dev server, which port}} |
| `{{pnpm test}}`      | {{unit tests}}             |
| `{{pnpm typecheck}}` | {{tsc --noEmit}}           |
| `{{pnpm build}}`     | {{production build}}       |

## Directory structure

```
{{actual directory tree — only the branches agents touch often, with a one-line note per branch}}
```

Locations that differ from the `~/.claude/templates/project-structure.md` standard (record only the DIFFERENCES):

- {{file type}} → `{{path}}` — {{one-line reason}}

## Documentation

Most code changes need no documentation change; agents and maintainers can read the code.
The index is [docs/README.md](docs/README.md) `current`.

- `docs/internals/` holds architectural decisions and their reasons, constraints that span
  modules, and traps that are hard to discover from the source. Before adding a paragraph,
  ask what a maintainer would get wrong without it. If reading the relevant code answers the
  question, leave it out. It is the one place in the repository that still takes new
  documentation.
- `docs/user/` helps users accomplish tasks, in the voice of the shipped product, with no
  implementation detail and no contributor tooling. Update the feature's section when how to
  use it changes; a UI tweak needs no entry and a new control needs no page.
- `docs/operations/` is the maintainer runbook: setup, release, debugging. Every page under
  `internals/` and `operations/` opens with the "For maintainers" callout.
- Do not write file catalogs, field or method enumerations, control-flow narration, or
  appended PR summaries. Types, tests and code already record the implementation. When a
  documented decision changes, rewrite or remove the text; never append a second account of
  the new behaviour. Keep a local explanation in a code comment; use an internal page only
  when the reasoning crosses boundaries.
- Plans, specs, research notes and review reports are not committed. A merged PR is the
  implementation record, and active work lives in the issue that owns it.

{{Delete the tiers the repo does not have (a CLI repo has no user/ …). This section does NOT name the tracker tool — choosing the tool is the user's call, and the global rules D0/D4 already cover it.}}

## Repo-specific rules (R-rules — only the delta from the global standard)

- **R1.** {{rule that applies only to this repo, e.g.: NEVER run bare `prisma migrate dev` — use `pnpm migrate:dev`}}
- **R2.** {{...}}

## Known traps

- {{trap 1 — symptom, cause, related file/command}}

## Language

- Docs/comments: {{Tiếng Việt / English-only}}
- Commit messages: {{English, conventional commits}}
