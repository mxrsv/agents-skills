# React Patterns

## Khi nào KHÔNG dùng form library

Form library (react-hook-form, Formik) chỉ justified khi: multi-step wizard, > 10 fields, complex cross-field validation với submit flow.

KHÔNG dùng khi: form < 5 fields AND không có `handleSubmit` AND compute live (live calc, no submit event) → dùng `useState` thuần.

## Pattern thay thế: useState + touched map + zod

```ts
const [values, setValues] = useState<Fields>({ a: '', b: '' });
const [touched, setTouched] = useState<Record<keyof Fields, boolean>>({ a: false, b: false });

const handleChange = (name: keyof Fields) => (e: ChangeEvent<HTMLInputElement>) => {
  setValues(v => ({ ...v, [name]: e.target.value }));
  setTouched(t => t[name] ? t : { ...t, [name]: true });
};

const errors = useMemo(() => {
  const r = schema.safeParse(values);
  if (r.success) return {};
  return r.error.flatten().fieldErrors;
}, [values]);

// Chỉ hiện error sau khi touched — match RHF mode:'onChange'
const hasError = (name: keyof Fields) => touched[name] && !!errors[name];
```

## Lazy useState với external data

ALWAYS lazy init khi state phụ thuộc external source (URL params, props):

```ts
// CORRECT
const [state] = useState(() => parseUrlParams(searchParams));

// WRONG — compute mỗi render nhưng chỉ apply lần đầu
const [state] = useState(parseUrlParams(searchParams));
```

## Pure parsing functions

Tách URL params / external data parsing thành pure function ở `lib/` (không inline trong component):
- Unit testable, không phụ thuộc React hay Web API.
- Mock pattern trong test: `{ get: (k: string) => map.get(k) ?? null }` thay vì `new URLSearchParams()`.

## Folder module — khi nào split component

**Trigger**: component > ~400 lines VÀ có ≥ 3 trong số: form state, memoized computation, sub-components, external data parsing.

**Cấu trúc**:
```
component-name/
├── index.tsx                  # wrapper + Suspense, default export
├── component-name-view.tsx    # JSX thuần, gọi hooks
├── use-*-form.ts              # state + handlers
├── use-*-computation.ts       # useMemo calculations
└── sub-component.tsx          # stateless sub-components
```

Pure functions (parsing, math) → `lib/`, KHÔNG trong folder component.

**Dependency flow — CRITICAL**:
- ALWAYS: `components/ → lib/`
- NEVER: `lib/ → components/` kể cả type-only import

**Import path consumer không đổi**: Next.js/TypeScript auto-resolve `name/index.tsx` từ `import "name"`.

**Rollback safety**: 1 task extract = 1 commit riêng → `git revert` từng bước.
