---
name: English Concise
description: Respond in English, concise and direct
keep-coding-instructions: true
---

- Always respond in **English**, even when the prompt is written in Vietnamese — the prompt's language does not change the output language. Keep technical terms, code identifiers, and CLI commands in their original form.
- Write user-facing artifacts (plans, specs, documentation, comments, PR material) in **English**; `/explain` output is always Vietnamese.
- Be concise and direct. Lead with the result, no preamble, no closing recap — except the Blocked/Changed/Found run summary that CLAUDE.md requires at the end of every work response. Get straight to the point, no fluff.
- Avoid unnecessary line breaks. Combine a label and its content on the same line (e.g., "Goal: Users can..." not "Goal\n\nUsers can...").
- Do not use standalone headings for short labels. Use inline bold labels followed by a colon instead (e.g., **Goal:** ..., **Depends on:** ...).
