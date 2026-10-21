#!/usr/bin/env node
// Lays captured state shots side by side, one sheet per colour mode.
//
//   node compose-sheet.mjs --out <dir> --labels A,B,C --names button,input [--modes light,dark]
//
// Reads <out>/<label>-<mode>-<name>.png and writes <out>/sheet-<mode>.png. Missing shots show
// as an empty cell. playwright-core resolves from the current directory.
import { existsSync, readFileSync } from "node:fs";
import { createRequire } from "node:module";
import { join } from "node:path";

const args = process.argv.slice(2);
const options = { modes: "light,dark", channel: "chrome" };
for (let i = 0; i < args.length; i += 2) options[args[i].replace(/^--/, "")] = args[i + 1];
if (!options.out || !options.labels || !options.names) {
  throw new Error("usage: --out <dir> --labels A,B --names a,b [--modes light,dark]");
}

const labels = options.labels.split(",");
const names = options.names.split(",");
const { chromium } = createRequire(join(process.cwd(), "noop.js"))("playwright-core");
const browser = await chromium.launch({
  headless: true,
  ...(options.channel === "none" ? {} : { channel: options.channel }),
});

const cell = (file) =>
  existsSync(file)
    ? `<img src="data:image/png;base64,${readFileSync(file).toString("base64")}" style="height:56px">`
    : "";

for (const mode of options.modes.split(",")) {
  const dark = mode === "dark";
  const head = `<tr><th></th>${labels.map((label) => `<th>${label}</th>`).join("")}</tr>`;
  const rows = names
    .map(
      (name) =>
        `<tr><td>${name}</td>${labels
          .map((label) => `<td>${cell(join(options.out, `${label}-${mode}-${name}.png`))}</td>`)
          .join("")}</tr>`,
    )
    .join("");
  const page = await browser.newPage({ viewport: { width: 400 + labels.length * 260, height: 200 } });
  await page.setContent(
    `<body style="margin:0;padding:16px;background:${dark ? "#1c1917" : "#fafaf9"};color:${dark ? "#e7e5e4" : "#1c1917"};font:13px system-ui">` +
      `<h3 style="margin:0 0 8px">${mode}</h3><table cellpadding="8">${head}${rows}</table></body>`,
  );
  await page.screenshot({ path: join(options.out, `sheet-${mode}.png`), fullPage: true });
  await page.close();
}

await browser.close();
console.log(`sheets written to ${options.out}`);
