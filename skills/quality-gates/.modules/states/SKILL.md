---
name: states
description: Capture keyboard-focus or hover states of real controls in light and dark, before and after a styling change, and compose them into comparison sheets for the owner's eye review.
---

# States — show the indicator, do not describe it

Reading classes does not tell whether a focus ring is visible on a filled control in dark mode.
A sheet does. Use it whenever focus, selection, hover, disabled or theme styling changes (U4).

## Needs

- A page that renders the real controls (gallery, specimen, storybook) and a mode switch the
  URL can set, e.g. `?mode=dark` — write `{mode}` where it goes.
- `playwright-core` in the project and an installed Chrome, or Playwright's own Chromium.
- Permission for visual tooling if the repo or user restricts it. A dev server you start is
  yours to stop: note its PID, check its working directory, kill only that PID.

## Steps

1. Check the port is free (`lsof -iTCP:<port> -sTCP:LISTEN` prints nothing), then start the
   dev server in its own command with a strict-port flag and keep the PID `$!` returns. Before
   capturing, confirm the listener is that PID and its working directory is your checkout.
   Another session's server may hold the port: then your server failed, and its pages are
   theirs. Stop only the PID you started — never one found by port.
2. Capture the current state for every variant you will change (`--label A`):

   ```sh
   node <module>/scripts/capture-states.mjs --url "http://127.0.0.1:<port>/<page>?mode={mode}" \
     --label A --out <scratch dir> --state focus \
     --target button='[data-slot="button"]' --target input='[data-slot="input"]'
   ```

   Each target is the first visible match. Focus states press Tab before `focus()`, so the
   browser shows `:focus-visible`; the summary prints whether it matched — a `false` there
   means the shot proves nothing.
3. Apply each candidate change and capture again (`--label B`, `--label C`). Keep each
   candidate as a patch so the chosen one can be re-applied after the review.
4. Compose: `node <module>/scripts/compose-sheet.mjs --out <scratch dir> --labels A,B,C
   --names button,input` writes `sheet-light.png` and `sheet-dark.png`.
5. Look at the sheets yourself first, then send them to the user with what each column is.
   Stop for the eye review; commit only the approved candidate. Stop the server.

Screenshots stay in scratch, never in the repo.
