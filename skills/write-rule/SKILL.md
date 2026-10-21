---
name: write-rule
description: Turn a repeated mistake, an owner decision or a review finding into a rule an agent will actually follow — chooses the enforcement tier (type, lint, policy test, doc), writes the what/why line, and handles legacy code with a ratchet. Use when adding or editing a line in AGENTS.md, a design-language rulebook or ~/.claude/rules, or when the same correction has been made twice. Not for task plans or specs.
---

# write-rule — a rule is only as strong as what enforces it

A rule that lives only in prose gets broken by the next agent that did not read it. Pick the
strongest enforcement that is cheap, then write the shortest text that still carries the why.

## 1. Qualify

Write a rule only if all three hold; otherwise fix it in the code or drop it:

- It has been broken, or reviewed away, at least twice (or the owner decided it once, explicitly).
- A reader cannot get it from the code or the types.
- It is about this repo, not general craft the agent already knows.

## 2. Choose the tier (strongest cheap one wins)

| Tier | Use when | Example |
| ---- | -------- | ------- |
| **Type / compiler** | the wrong call can be made unrepresentable | a control's props omit the thing callers must not set |
| **Lint rule** | a syntactic pattern, no legacy debt or an allowlist | no `electron` import in the renderer |
| **Policy test** | a repo-wide scan, a count that may only fall (ratchet) | no new button class family; docs and stylesheet stay in sync |
| **Doc only** | judgement, taste, an invariant no tool can see | "no continuously repainting animation" |

Say the tier in the rule or in the commit. "Doc only" is a legitimate answer, but name it so a
later reader knows nothing will catch a slip.

Check how the repo runs lint before choosing it: a hook that runs `--quiet` on changed files
silences warnings and fails on every touched legacy file. With legacy code, prefer a ratchet
test (baseline file, count may only go down) or a lint rule with a shrinking allowlist.

For a lint tier, measure before enabling: skill `quality-gates`, module `probe`, counts the
hits per rule per path group, unscoped and scoped. A `warn` level is no ratchet when the hook
is quiet and CI fails only on errors. Exempt legacy files by name at error level, give each
exemption a comment, and add a test that every named exemption still exists. An override
replaces the rule's options for the files it matches, so repeat the existing entries in it.

## 3. Write it

One bullet, in this order, no preamble:

1. **Imperative with the scope**: what to do, where it applies ("Settings", "under `src/`").
2. **Why**, one clause: the failure it prevents. Drop the rule if you cannot name one.
3. **The escape hatch**: when breaking it is right, and who signs off.
4. **A link** to the enforcing file, spec or trap page (living-doc claims need resolving links).

Do not write: history ("we used to"), a list of every case, a rule that restates a type
signature, or a claim that a test exists before it does.

## 4. Place it

- Cross-cutting and agent-facing → `AGENTS.md` (numbered, short).
- Visual or interaction invariant → the design-language file, plus its checklist line.
- A trap that needs a paragraph → the internals trap page; AGENTS.md carries one line + link.
- Personal workflow → `~/.claude/rules`, never a project file.

Rules describe current behaviour: if the enforcement lives on an unmerged branch, write the rule
on that branch.

## 5. Verify

Run the repo's doc and policy checks on the touched files; confirm each link resolves and each
cited rule number exists. Report the tier chosen and anything left doc-only.
