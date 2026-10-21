import { execFileSync } from "node:child_process";
import { createRequire } from "node:module";
import { mkdirSync, mkdtempSync, rmSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

// Resolved from the project that copies this file, wherever its node_modules sit.
const OXLINT = join(
  dirname(createRequire(import.meta.url).resolve("oxlint/package.json")),
  "bin/oxlint",
);
const PLUGIN = fileURLToPath(new URL("./index.mjs", import.meta.url));

export interface Finding {
  readonly line: number;
  readonly message: string;
}

interface Diagnostic {
  readonly code: string;
  readonly message: string;
  readonly filename: string;
  readonly labels: ReadonlyArray<{ readonly span: { readonly line: number } }>;
}

/**
 * Runs the real oxlint once over every fixture with one `local/` rule switched on and
 * returns that rule's findings per fixture name. One process per call keeps the suite
 * cheap enough for the pre-push hook.
 */
export function lintFixtures(
  rule: string,
  fixtures: Readonly<Record<string, string>>,
): Record<string, Finding[]> {
  const dir = mkdtempSync(join(tmpdir(), "local-oxlint-"));
  try {
    for (const [name, source] of Object.entries(fixtures)) {
      mkdirSync(dirname(join(dir, name)), { recursive: true });
      writeFileSync(join(dir, name), source);
    }
    const config = {
      jsPlugins: [PLUGIN],
      plugins: [],
      categories: { correctness: "off", suspicious: "off", perf: "off" },
      rules: { [`local/${rule}`]: "error" },
    };
    writeFileSync(join(dir, "oxlintrc.json"), JSON.stringify(config));
    const args = [OXLINT, "-c", "oxlintrc.json", "-f", "json", ...Object.keys(fixtures)];
    let stdout: string;
    try {
      stdout = execFileSync(process.execPath, args, { cwd: dir, encoding: "utf8" });
    } catch (error) {
      // oxlint exits 1 when it reports an error; the JSON report is complete either way.
      stdout = (error as { stdout: string }).stdout;
    }
    const { diagnostics } = JSON.parse(stdout) as { diagnostics: Diagnostic[] };
    const findings: Record<string, Finding[]> = Object.fromEntries(
      Object.keys(fixtures).map((name) => [name, []]),
    );
    for (const diagnostic of diagnostics) {
      if (diagnostic.code !== `local(${rule})`) continue;
      findings[diagnostic.filename]?.push({
        line: diagnostic.labels[0]?.span.line ?? 0,
        message: diagnostic.message,
      });
    }
    return findings;
  } finally {
    rmSync(dir, { recursive: true, force: true });
  }
}
