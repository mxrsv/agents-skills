import { existsSync, readFileSync } from "node:fs";
import { fileURLToPath } from "node:url";
import { describe, expect, it } from "vitest";

/**
 * Lint config exempts legacy files by name while a migration moves them (Q1). A name that no
 * longer exists exempts nothing and hides that the list should have shrunk, so every named
 * exemption must still point at a file. Copy to `scripts/` and set the two constants.
 */

const ROOT = fileURLToPath(new URL("../", import.meta.url));
/** The folder holding both generated primitives and pre-preset controls. */
const CONTROLS_DIR = "src/components/ui/";

interface Override {
  readonly files: readonly string[];
  readonly excludeFiles?: readonly string[];
}

interface Config {
  readonly settings?: { readonly shadcn?: { readonly ignoreImports?: readonly string[] } };
  readonly overrides: readonly Override[];
}

// `.oxlintrc.json` allows whole-line `//` comments; JSON.parse does not.
const config = JSON.parse(
  readFileSync(`${ROOT}.oxlintrc.json`, "utf8").replace(/^\s*\/\/.*$/gm, ""),
) as Config;

const isGlob = (path: string): boolean => /[*?{[]/.test(path);

const namedExemptions = config.overrides.flatMap((override) =>
  (override.excludeFiles ?? []).filter((path) => !isGlob(path)),
);

// `ignoreImports` patterns end in `/(name|name)$`: the pre-preset controls, by module name.
const ignoredControls = (config.settings?.shadcn?.ignoreImports ?? [])
  .flatMap((pattern) => /\(([^()]+)\)\$$/.exec(pattern)?.[1].split("|") ?? [])
  .sort();

const exemptedControls = namedExemptions
  .filter((path) => path.startsWith(CONTROLS_DIR))
  .map((path) => path.slice(CONTROLS_DIR.length).replace(/\.[jt]sx?$/, ""))
  .sort();

describe("oxlint exemptions", () => {
  it("finds named exemptions at all — an empty list would pass everything", () => {
    expect(namedExemptions.length).toBeGreaterThan(0);
  });

  it.each(namedExemptions)("%s still exists", (path) => {
    expect(existsSync(`${ROOT}${path}`)).toBe(true);
  });

  it("ignores exactly the controls it exempts from the primitive checks", () => {
    expect(ignoredControls).toEqual([...new Set(exemptedControls)]);
  });
});
