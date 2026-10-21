# ESLint instead of oxlint

Use only when the project already runs ESLint 9 and moving to oxlint is out of scope.
Untested here: the `local` rules use the ESLint rule API (`create(context)`,
`context.sourceCode.getAllComments()`, `getCommentsBefore()`, `context.report({ loc })`), so
they should load as an ESLint plugin unchanged. Prove it with a positive-control fixture before
relying on it, and record the result in `references/lessons.md`.

```js
// eslint.config.mjs
import { plugin as shadcn } from "@shadcn/lint"
import tsParser from "@typescript-eslint/parser"
import local from "./scripts/oxlint-plugin/index.mjs"

export default [
  {
    files: ["**/*.{js,jsx,ts,tsx,mjs}"],
    languageOptions: { parser: tsParser, parserOptions: { ecmaFeatures: { jsx: true } } },
    plugins: { shadcn, local },
    settings: { shadcn: { ui: "@/components/ui" } },
    rules: {
      "local/require-suppression-reason": "error",
      "local/no-unreasoned-skip": "error",
    },
  },
  // Then the same three tiers as references/shadcn-tiers.jsonc, as `files`/`ignores` blocks.
]
```

The fixture harness `assets/oxlint-plugin/lint-fixtures.ts` spawns oxlint; for ESLint, swap
it for `RuleTester` from `eslint`.
