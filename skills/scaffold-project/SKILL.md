---
name: scaffold-project
description: Scaffold a new project repo end to end — official generator, folder layout from the global structure template, lint/format, AGENTS.md, first commit, verified build. Use when the user wants to start, init, bootstrap or create a new app/repo. Covers Next.js App Router today; other stacks follow the structure template and ask first. Not for adding a framework to an existing repo.
argument-hint: "<project-name> [one-line purpose]"
---

# Scaffold project

Turns an empty target into a repo that already passes lint, typecheck and build, and already obeys the global rules (D5, F-rules, `templates/project-structure.md`). Every command below was run end to end before it was written here; change a flag only after re-running the chain.

## Inputs

- Project name (kebab-case) and a one-line purpose. Missing name → ask; missing purpose → leave the AGENTS.md one-liner for the user to fill and say so.
- Target `./<name>` must not exist. Never scaffold into a non-empty directory.
- Stack: Next.js unless the user names another. Node API or Vite + Tauri → use that section of `~/.claude/templates/project-structure.md` with the stack's official generator and propose the commands before running them. Anything else → propose the structure first (template, "Every project type").

## Next.js App Router

1. Generate (Biome is built in and passes on generated code; no React Compiler unless asked):
   `CI=1 pnpm create next-app@latest <name> --ts --tailwind --app --src-dir --import-alias "@/*" --use-pnpm --biome --no-react-compiler --disable-git --yes`
2. UI primitives (fills `src/components/ui/` per the template): `pnpm dlx shadcn@latest init -d --no-monorepo` in the project. Adding components later is the `shadcn` skill's job.
3. Scripts: `npm pkg set scripts.typecheck="tsc --noEmit"`, then `pnpm biome check --write` (shadcn output fails Biome formatting until this runs).
4. `AGENTS.md` from `~/.claude/templates/AGENTS.template.md`, stamped with today's date:
   - Keep the generator's `<!-- BEGIN:nextjs-agent-rules -->…<!-- END:nextjs-agent-rules -->` block verbatim at the top; `next dev` re-adds it when missing.
   - Commands table: `pnpm dev`, `pnpm lint`, `pnpm format`, `pnpm typecheck`, `pnpm build`.
   - Structure deltas: `src/lib/utils.ts` is shadcn's generated `cn()` entry, kept despite F5 because `components.json` points shadcn's imports at that path.
   - Language: docs/comments follow the active Output Style; commits English conventional (W5).
   - Drop template sections and doc tiers the repo does not have yet; no placeholder left in the file.
5. Do not create empty folders (`hooks/`, `types/`, `e2e/`, `docs/…`) or a `CLAUDE.md` (D5); they appear with their first real file.
6. Verify in the project, all must pass: `pnpm run lint`, `pnpm run typecheck`, `pnpm run build`, `bash ~/.claude/scripts/docs-compliance.sh .`
7. `git init -b main`, then `git add -- . && git commit -m "chore(scaffold): bootstrap Next.js app"` — the brand-new tree is entirely this task's output.

## Report

Result: path, stack, what step 4 recorded as deltas. Evidence: the four step-6 outputs. Never create a remote or push; publishing the repo is the user's call.
