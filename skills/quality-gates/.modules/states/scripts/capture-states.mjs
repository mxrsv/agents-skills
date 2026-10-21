#!/usr/bin/env node
// Screenshots each target control in a forced state, per colour mode, for a comparison sheet.
//
//   node capture-states.mjs --url <url with {mode}> --label <A> --out <dir>
//     [--modes light,dark] [--state focus|hover] [--channel chrome|none] --target name=selector ...
//
// playwright-core resolves from the current directory (the project root). Files are written as
// <out>/<label>-<mode>-<name>.png; a JSON summary goes to stdout.
import { mkdirSync } from "node:fs";
import { createRequire } from "node:module";
import { join } from "node:path";

const args = process.argv.slice(2);
const options = { modes: "light,dark", state: "focus", channel: "chrome", targets: [] };
for (let i = 0; i < args.length; i += 2) {
  const [flag, value] = [args[i].replace(/^--/, ""), args[i + 1]];
  if (flag === "target") {
    const at = value.indexOf("=");
    options.targets.push({ name: value.slice(0, at), selector: value.slice(at + 1) });
  } else options[flag] = value;
}
if (!options.url || !options.label || !options.out || options.targets.length === 0) {
  throw new Error("usage: --url <url{mode}> --label <L> --out <dir> --target name=selector ...");
}

const { chromium } = createRequire(join(process.cwd(), "noop.js"))("playwright-core");
mkdirSync(options.out, { recursive: true });
const browser = await chromium.launch({
  headless: true,
  ...(options.channel === "none" ? {} : { channel: options.channel }),
});
const page = await browser.newPage({ viewport: { width: 1280, height: 860 }, deviceScaleFactor: 2 });
const summary = {};
const PAD = 14;

for (const mode of options.modes.split(",")) {
  for (const { name, selector } of options.targets) {
    await page.goto(options.url.replaceAll("{mode}", mode));
    await page.waitForLoadState("networkidle");
    await page.evaluate(() => document.fonts.ready);
    const target = page.locator(selector).filter({ visible: true }).first();
    if ((await target.count()) === 0) {
      summary[`${mode}-${name}`] = "missing";
      continue;
    }
    await target.scrollIntoViewIfNeeded();
    if (options.state === "hover") {
      await target.hover();
    } else {
      // One keyboard event first, so programmatic focus shows :focus-visible.
      await page.keyboard.press("Tab");
      await target.focus();
    }
    await page.waitForTimeout(250); // let a state transition finish before the shot
    const box = await target.boundingBox();
    await page.screenshot({
      path: join(options.out, `${options.label}-${mode}-${name}.png`),
      clip: { x: box.x - PAD, y: box.y - PAD, width: box.width + PAD * 2, height: box.height + PAD * 2 },
    });
    summary[`${mode}-${name}`] = await target.evaluate(
      (node, state) => (state === "hover" ? node.matches(":hover") : node.matches(":focus-visible")),
      options.state,
    );
  }
}

console.log(JSON.stringify(summary, null, 1));
await browser.close();
