---
paths:
  - "**/*.ts"
  - "**/*.tsx"
  - "**/*.js"
  - "**/*.jsx"
  - "**/*.mjs"
  - "**/*.cjs"
---

# Code quality gates (Q-rules)

Defaults for any repo; the repo's `AGENTS.md` wins. Lint rules that enforce them ship in skill
`quality-gates` (module `gates`).

- **Q1. Every exception says why.** A lint or type suppression ends with `-- reason` or sits
  under a comment that gives one. An override, allowlist entry or exempt path in lint config
  carries a comment naming what it protects. A change that adds or widens one says so in its
  PR for the owner to accept — a silenced check is a decision, not a fix.
- **Q2. Tests assert behaviour.** Drive the code as the user or caller would and assert what
  they observe; a test that mirrors the implementation or only checks wiring proves nothing.
  A skipped, focused or `todo` test names its tracking issue on the line above; platform gates
  (`skipIf`/`runIf`) need none. A flaky test is fixed, not retried or skipped to go green.
