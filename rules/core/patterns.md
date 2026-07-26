# Core Patterns (P-rules)

Language-agnostic. TypeScript implementations live in `rules/typescript/patterns.md`.

## Repository Pattern

- **P1.** Encapsulate data access behind a consistent interface: findAll, findById, create, update, delete.
- **P2.** Business logic depends on the abstract interface, never on the storage mechanism — enables swapping data sources and mock-based testing.

## API Response Format

- **P3.** Use one consistent envelope for every API response: success indicator; data payload (nullable on error); error message (nullable on success); metadata for paginated responses (total, page, limit).
