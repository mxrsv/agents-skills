# Core Coding Style (C-rules)

Language-agnostic. Language-specific rules extend these in `rules/<language>/`.

## Immutability (CRITICAL)

- **C1.** ALWAYS create new objects; NEVER mutate existing ones.

```
WRONG:   modify(original, field, value)  → changes original in-place
CORRECT: update(original, field, value) → returns new copy with change
```

## File Organization

- **C2.** Many small files > few large files: 200–400 lines typical, 800 max.
- **C3.** Keep functions small (< 50 lines) and nesting ≤ 4 levels.
- **C4.** Organize by feature/domain, not by technical type; extract utilities out of large modules.

## Error Handling

- **C5.** Handle errors explicitly at every level; NEVER silently swallow them.
- **C6.** User-friendly messages in UI-facing code; detailed error context in server logs.

## Input Validation

- **C7.** Validate ALL external input at system boundaries (user input, API responses, file content).
- **C8.** Use schema-based validation where available; fail fast with clear messages.

## Constants

- **C9.** No hardcoded values — use constants or config.

## Checklist before marking work complete

- [ ] No mutation (C1); files/functions within size limits (C2, C3)
- [ ] Errors handled explicitly, input validated (C5–C8)
- [ ] No hardcoded values (C9); readable, well-named code
