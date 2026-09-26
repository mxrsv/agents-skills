---
paths:
  - "**/*.tsx"
  - "**/*.jsx"
---

# React Patterns

## When NOT to use a form library

A form library (react-hook-form, Formik) is only justified for: multi-step wizards, > 10 fields, complex cross-field validation with a submit flow.

Do NOT use one when: form < 5 fields AND no `handleSubmit` AND live computation (live calc, no submit event) → use plain `useState`.

## Replacement pattern: useState + touched map + zod

```ts
const [values, setValues] = useState<Fields>({ a: "", b: "" });
const [touched, setTouched] = useState<Record<keyof Fields, boolean>>({
  a: false,
  b: false,
});

const handleChange =
  (name: keyof Fields) => (e: ChangeEvent<HTMLInputElement>) => {
    setValues((v) => ({ ...v, [name]: e.target.value }));
    setTouched((t) => (t[name] ? t : { ...t, [name]: true }));
  };

const errors = useMemo(() => {
  const r = schema.safeParse(values);
  if (r.success) return {};
  return r.error.flatten().fieldErrors;
}, [values]);

// Only show the error after the field is touched — matches RHF mode:'onChange'
const hasError = (name: keyof Fields) => touched[name] && !!errors[name];
```

## Lazy useState with external data

ALWAYS lazy-init when state depends on an external source (URL params, props):

```ts
// CORRECT
const [state] = useState(() => parseUrlParams(searchParams));

// WRONG — computed on every render but only applied the first time
const [state] = useState(parseUrlParams(searchParams));
```

## Pure parsing functions

Extract URL params / external data parsing into pure functions in `lib/` (not inline in the component):

- Unit-testable, no dependency on React or Web APIs.
- Mock pattern in tests: `{ get: (k: string) => map.get(k) ?? null }` instead of `new URLSearchParams()`.

## Folder module — when to split a component

**Trigger**: component > ~400 lines AND has ≥ 3 of: form state, memoized computation, sub-components, external data parsing.

**Structure**:

```
component-name/
├── index.tsx                  # wrapper + Suspense, default export
├── component-name-view.tsx    # pure JSX, calls hooks
├── use-*-form.ts              # state + handlers
├── use-*-computation.ts       # useMemo calculations
└── sub-component.tsx          # stateless sub-components
```

Pure functions (parsing, math) → `lib/`, NOT inside the component folder.

**Dependency flow** (a `lib/` → `components/` import creates a cycle):

- ALWAYS: `components/ → lib/`
- NEVER: `lib/ → components/`, even type-only imports

**Consumer import path unchanged**: Next.js/TypeScript auto-resolves `name/index.tsx` from `import "name"`.

**Rollback safety**: 1 extraction task = 1 separate commit → `git revert` step by step.
