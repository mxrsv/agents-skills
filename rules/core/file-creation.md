# File creation & structure (F-rules)

Rules for creating any new file, in any repo.

- **F1.** Before creating a new file → look for an existing file with the same function (Glob/Grep). If one exists → edit it, do not create a new copy.
- **F2.** Before creating a new file → determine its location from the repo's `AGENTS.md`, or from `~/.claude/templates/project-structure.md`. State the chosen location in one line; ask only before creating a new top-level directory.
- **F3.** Never create files named like `.bak`, `.old`, `.orig`, `-v2`, `-v3`, `-final`, `-copy` — edit the original directly, git keeps the history.
- **F4.** Temporary / experimental / debug / intermediate-output files → the session scratchpad, never inside the repo. A mock or demo that must outlive a reboot goes in `~/scratch/<repo>/`, outside any repo. Exception: a prototype built with the `prototype` skill sits next to the code it will replace, so it can be wired in and then deleted.
- **F5.** Never create new files with generic names `utils.*`, `helpers.*`, `misc.*` — name them by function.
  - ❌ `utils.ts` → ✅ `format-date.ts`, `parse-url-params.ts`
- **F6.** File names: kebab-case. If the repo has another convention → follow the repo.
- **F7.** A new file must be imported/referenced from at least one place within the same task — no orphan files.
- **F8.** Size: 200–400 lines typical, 800 max. At the limit → split the module.
- **F9.** One file, one responsibility.
