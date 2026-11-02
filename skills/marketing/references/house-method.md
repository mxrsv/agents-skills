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
   - Zooms on a screenshot only for a draft: they read as stiff.
6. **Render, then watch it move.** Check every frame sheet for broken text, but judge only the moving video at phone size. Text: 2 lines at most at 9:16, each line on screen for about 0.5 s + 0.3 s per word.
7. **The owner decides by eye.** Show them the video and the claims behind it. Use AI reviewers only for factual claims and wording, not to predict whether people stop or scroll: they judge stills and flip between rounds. One fix round, then post or drop. Real viewers settle the rest.
8. **The owner publishes.** The agent never posts, opens accounts or contacts anyone.

## Limits

- Numbers are real and traceable, measured "on my machine". No invented users, quotes, counts or testimonials.
- An unshipped feature is "in development"; a mock says "In design".
- Public copy names no competitor, and shows no secrets, client repos or paths with a user name.
- A new tool, renderer or effect is not the fix for a weak story. Try one only for a named limit, with the same storyboard.

## Each product keeps

One spec in that repo, `docs/specs/YYYY-MM-DD-marketing-playbook.md`: promise, audience, channels and cadence, how to capture the build, where real data comes from, visual identity, owner's weekly hours, and the signal that counts as demand. Read it before step 1; if it is missing, write it with the owner. Example: TinySift's.

## Stuck?

Same clips for a second round and the owner is still unhappy: stop editing. Go back to step 1 and check whether the asset shows the right thing at all.
