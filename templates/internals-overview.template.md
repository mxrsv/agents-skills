> Generated from `~/.claude/templates/internals-overview.template.md` — a LIVING document, updated in place (D1, D9).
> Entry point of `docs/internals/` (D5). Keep only what "a maintainer would get wrong without it"; if reading the code answers it, drop it.

> **For maintainers.** This page is about how the system is built and why — not a usage guide.

# {{Project name}} — internals overview

{{One sentence: what the system does, what it runs on}}

## Modules and boundaries

| Module   | Responsibility   | In               | Out               |
| -------- | ---------------- | ---------------- | ----------------- |
| {{name}} | {{one sentence}} | {{who calls it}} | {{what it calls}} |

## Main data flow

1. {{step}} — [{{function}}](../../{{path/to/file.ts}}#L10)

## Decisions still in force and their reasons

- {{decision}} — {{why, one sentence}} — [{{evidence}}](../../{{path}})

## Cross-module constraints

- {{what one module must uphold so another does not break}}

## Traps hard to see from the code

- {{symptom → cause → related file/command}}

{{When a decision changes → REWRITE the corresponding passage, do not append a second telling (D1). Work in progress and drift → Linear issue (D4, D7).}}
