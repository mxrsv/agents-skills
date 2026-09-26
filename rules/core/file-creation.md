# File creation & structure (F-rules)

Rules for creating ANY new file, in every kind of repo.

- **F1.** BEFORE creating a new file → look for an existing file with the same function (Glob/Grep). If one exists → edit it, do NOT create a new copy.
- **F2.** BEFORE creating a new file → determine its location from the repo's `AGENTS.md`, or from `~/.claude/templates/project-structure.md`. Unsure about the location → ASK, do not guess.
- **F3.** NEVER create files named like `.bak`, `.old`, `.orig`, `-v2`, `-v3`, `-final`, `-copy` — edit the original directly, git keeps the history.
  - ❌ `auth-v2.ts`, `page.tsx.bak` → ✅ edit `auth.ts`, `page.tsx` directly
- **F4.** Temporary / experimental / debug / intermediate-output files → the session scratchpad, NEVER inside the repo. Exception: a prototype built with the `prototype` skill sits next to the code it will replace, so it can be wired in and then deleted.
- **F5.** NEVER create new files with generic names `utils.*`, `helpers.*`, `misc.*` — name them by function.
  - ❌ `utils.ts` → ✅ `format-date.ts`, `parse-url-params.ts`
- **F6.** File names: kebab-case. If the repo has another convention (PascalCase components, snake_case Python) → follow the repo.
- **F7.** A new file MUST be imported/referenced from at least one place within the same task — no orphan files.
- **F8.** Size: 200–400 lines typical, 800 max. At the limit → split the module following the rules for that language.
- **F9.** One file, one responsibility — content outside that responsibility goes to another file.

## Checklist before creating a file

- [ ] Searched for a file with the same function? (F1)
- [ ] Location matches AGENTS.md / project-structure? (F2)
- [ ] Name avoids the banned patterns and is not generic? (F3, F5, F6)
- [ ] Is it a temporary file? → scratchpad (F4)
- [ ] Is there a place that imports/references it? (F7)
