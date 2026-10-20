---
paths:
  - "**/*.ts"
  - "**/*.tsx"
  - "**/*.js"
  - "**/*.jsx"
---

# TypeScript/JavaScript Coding Style

> This file extends [core/coding-style.md](../core/coding-style.md) with TypeScript/JavaScript specific content.

## Preferences

- Add parameter and return types to exported functions, shared utilities, and public class methods; let TypeScript infer local variables.
- `interface` for extendable object shapes; `type` for unions, intersections, tuples and mapped types. Prefer string-literal unions over `enum` unless interop requires one.
- No `any` in application code: `unknown` for external or untrusted input, narrowed safely; generics when the type depends on the caller.
- Component props: a named `interface` or `type`; type callback props; no `React.FC` without a specific reason.
- In `.js`/`.jsx`, use JSDoc when types help and migrating to TypeScript is impractical; keep it aligned with runtime behavior.
- Validate external input with Zod and infer types from the schema (`z.infer`).
- No `console.log` in production code; use the project's logger.
