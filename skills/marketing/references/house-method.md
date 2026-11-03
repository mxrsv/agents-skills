# House method: how the owner's products get marketed

Applies to every product and every public asset, above any vendored sub-skill: a sub-skill supplies technique, this file supplies the order and the limits. Each step exists because skipping it cost a real product days of rework.

## Order

Do these in order. Do not design a template, a style or a batch before step 3.

1. **See the product first.** Run or snapshot the newest development build, including work behind a dev switch, and put a screenshot in front of the owner. Say what already works, what is only a mock, and what is missing. Older captures, specs and plans do not count.
2. **Write one sentence: who, what hurts, what on screen fixes it.** Test: a stranger, muted, watching once, can repeat it. If the product cannot show the fix yet, say so and stop, or label a mock. An asset about a limit of the product, or about general knowledge, is not a substitute.
3. **Find a real moment.** Take it from real use or logs: a number that makes the pain obvious. A comparison must hold across most of the data, not one reading. If you created the load yourself, tell the owner before using it.
4. **Storyboard the fix, not the words.** Pain → the action → the answer → one ask. Each beat changes the picture, not only the text. Cut ideas first, then set the length; about 15 s or less for a short clip.
5. **Pick the stage, in this order:**
   - A real recording of the real app. Most credible; needs the owner's time.
   - A recreated UI in HTML: copies the build's look, sort order and scales, replays logged numbers, and says "Recreated from my dev build" on screen and in the post. Name any changed data. It never shows a state the build cannot reach.
     - It also copies the build's behaviour, or it reads as a stiff mock next to a recording: the build's refresh rate, figures that change once per reading, its animation curves, re-sorting, hover and the hand cursor, scrolling.
     - The cursor follows a curved path, eases at both ends and stands still between moves.
     - Camera moves are fine. An effect the app cannot draw, such as dimming the other rows, is not.
     - Render at 60 fps.
     - Before showing it, render it on the data of one of the build's own snapshots and overlay it on that snapshot at 2 px/pt. Fix any column or row that drifts.
   - Zooms on a screenshot only for a draft: they read as stiff.
   - **The frame, owner's pick 2026-11-03:** every stage sits in a macOS screen recording. The recording rests on an original wallpaper (never Apple's) with padding, rounded corners and a shadow, never tilted. The camera zooms towards the action. The captions and the "Recreated…" line keep a patch of wallpaper that no zoom covers. The look is settled: work on the stage, not the background, unless the owner asks.
6. **Render in 16:9, then watch it move.** A short (9:16) only when the owner asks for one. Check every frame sheet for broken text, but judge only the moving video at phone size. Text: 2 lines at most at 9:16, each line on screen for about 0.5 s + 0.3 s per word.
7. **The owner decides by eye.** Show them the video and the claims behind it. Use AI reviewers only for factual claims and wording, not to predict whether people stop or scroll: they judge stills and flip between rounds. One fix round, then post or drop. Real viewers settle the rest.
8. **The owner publishes.** The agent never posts, opens accounts or contacts anyone. Write the post the way a person talks: the pain as a question, what the product does in one line, then the ask. About 200 characters for X. Disclosures such as "Dev build, sample data" fit in one short clause. Do not promise anything the video does not show.

## Limits

- Numbers are real and traceable, measured "on my machine". No invented users, quotes, counts or testimonials.
- An unshipped feature is "in development"; a mock says "In design".
- Public copy names no competitor, and shows no secrets, client repos or paths with a user name.
- A new tool, renderer or effect is not the fix for a weak story. Try one only for a named limit, with the same storyboard.

## Where it lives

Each product's repo:

```
docs/specs/YYYY-MM-DD-marketing-playbook.md   promise, audience, channels and cadence, data source, hours, demand signal
marketing/
  videos/<slug>.json    words, numbers and timing of one video
  stage/                project.css, the recreated UI and styles
  tools/                how this product captures its build and data, if it needs any
  captures/             screenshots and logs, not committed
  exports/<date>/       finished videos and posts.md, not committed; never overwrite one, a new checkpoint gets its own folder
  out/                  render output, not committed
```

The renderer is shared: `~/Documents/Development/Personal/video-kit` (private `mxrsv/video-kit`). Run it from `marketing/`: `node <video-kit>/make.mjs <slug>`. Never copy it into a product. The screen-recording frame, the pointer and the symbols live in TinySift's `marketing/stage/shared/` for now, so a new stage there is only its desk, its shots and its camera plan; move them into video-kit when a second product needs them. Read the playbook before step 1; if it is missing, write it with the owner. Example: TinySift's `tiny-cli`.

## Stuck?

Same clips for a second round and the owner is still unhappy: stop editing. Go back to step 1 and check whether the asset shows the right thing at all.
