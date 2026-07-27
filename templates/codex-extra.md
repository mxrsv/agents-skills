<tools>
- Never use `pnpm exec` — run binaries directly (`pnpm tsc`, `pnpm eslint`) or via `pnpm run <script>`.
</tools>

<pull_request_convention>
PR title and body MUST be written in Vietnamese. Code identifiers, branch names, file paths, and CLI commands stay in English.

Title: imperative mood, max 70 chars, format `<type>: <short description in Vietnamese>`.

Body (use whichever sections apply):

- `## Tóm tắt` — 2-3 bullets covering what + why (required)
- `## Lý do` — context, link to issue if any
- `## Thay đổi chính` — main files/logic changed
- `## Cách test` — actionable checklist (required)
- `## Screenshots` — required if there are UI changes
- `## Breaking Changes` — required if there is breaking behavior

Each PR focuses on a single concern. The test plan must be concrete steps, not "run tests".
</pull_request_convention>
