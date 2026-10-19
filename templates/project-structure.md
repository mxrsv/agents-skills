# Standard project structure

Reference for L2/F2: when planning a new file structure or unsure where a file belongs.
The repo's `AGENTS.md` (if any) ALWAYS wins over this document.

## 1. Next.js App Router

```
src/
├─ app/                     # routes; one directory per segment
│  ├─ (group)/page.tsx      # page by route group
│  └─ api/<resource>/route.ts
├─ components/
│  ├─ ui/                   # primitives (shadcn) — do not hand-edit what can be generated
│  └─ <feature>/            # components by feature; >400 lines → folder module (see rules/react)
├─ lib/                     # pure functions, parsing, API clients
├─ hooks/                   # shared hooks: use-*.ts
└─ types/                   # shared types
e2e/                        # Playwright specs
docs/                       # documentation (D-rules) — three living reader tiers plus specs and plans
  README.md                 #   index
  internals/overview.md     #   living — architecture, decisions + reasons, constraints, traps (entry point, D5)
  internals/<topic>.md      #   only when "a maintainer would get it wrong without it"
  user/<task>.md            #   usage guides, product voice, no implementation detail
  operations/<runbook>.md   #   setup, release, debug for maintainers
  DESIGN-LANGUAGE.md        #   only for repos with codified design rules
  specs/YYYY-MM-DD-<slug>.md # requirements, scope, design decisions, acceptance criteria (D0/D4)
  plans/YYYY-MM-DD-<slug>.md # link to spec; technical tasks, progress, evidence, handoff (D0/D4)
  # review → chat or explicitly requested PR; evidence → scratchpad/requested artifacts
  # NO review/, superpowers/ or .planning/; small work needs neither spec nor plan
AGENTS.md                   # repo-specific rules — required (D5)
```

- One-way dependency: `components/ → lib/`; NEVER `lib/ → components/` (even type-only).
- Thin route handlers — logic lives in `lib/` or `services/`.
- Unit tests sit next to the file: `foo.ts` + `foo.test.ts`.

## 2. Node API service

```
src/
├─ routes/                  # HTTP handlers, thin
├─ services/                # business logic
├─ repositories/            # data access (repository pattern)
├─ lib/                     # pure utilities
└─ types/
prisma/                     # schema + migrations (if using Prisma)
scripts/                    # CLI / ops scripts, one job per script
data/                       # tracked seed / fixture data
```

- Handler → service → repository; no skipping layers (a handler never calls a repository directly).

## 3. Vite + Tauri desktop

```
src/                        # frontend (TS)
├─ components/
├─ lib/
└─ styles/
src-tauri/
└─ src/                     # Rust backend; thin command handlers
scripts/                    # build / pipeline scripts
```

- Logic shared between frontend/backend → define the contract in one place (types), do not keep two copies.

## Every project type

- File with no obvious home → ASK before creating it (F2), propose a location with a reason.
- Project type not in the list above (Python pipeline, extension, notes…) → follow the repo's existing convention; empty repo → propose the structure in the plan for approval first.
