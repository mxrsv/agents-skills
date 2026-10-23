---
name: kyant-kanban
description: Work with the owner's task vault (Tolaria vault `kanban`) in four moves — create a task note, start a task from its note, close a task as Done, reconcile notes with GitHub issues. Use when the owner says "thêm vào kanban", "lưu task này", "làm task X", "đóng task", "sync kanban", names a note in the vault, or asks what is on the board. Procedure only; the schema lives in the vault's AGENTS.md.
---

# Kyant Kanban

The vault is the one list of tasks and the roadmap for the SpaceVibe workspace repos:
`/Users/kyantran/Documents/Development/Vault/kanban`. It is a git repo with no MCP: read and write the
files directly.

Fields, statuses, `intent` values, views and language rules are owned by the vault's `AGENTS.md`
("Task workflow", "Language"). **Read it first, every time**; this skill holds the order of steps
and does not repeat the schema. Notes are Vietnamese; titles copied from an issue stay English.

A write refused with a permission error means the vault is missing from `additionalDirectories`:
tell the owner, do not work around it.

## Create

Only when the owner asks to track something. They often build straight away without a note: never write one unprompted.

1. Self-contained source (an issue with acceptance criteria)? Read the whole body and set `intent: ready`.
   Otherwise run `/kyant-intent` and wait for an explicit yes; then `intent: confirmed`.
2. Pick `repo` by where the code changes. Two repos → one Task per repo plus a `Project` (X1).
3. Copy the shape of `task.md` into `<kebab-slug>.md` at the vault root (`issue-<n>-<slug>.md` when it mirrors an issue). `Issue: <url>` goes right under the H1.
4. Default `status: Later`. Say which status you chose in the reply.

## Start

1. Find the note (`grep -l` the issue number or title in the vault) and read it. That is the brief: no paste needed.
2. `intent: pending` → `/kyant-intent` first.
3. Check the code and `git log` for whether the work is already done. If yes, go to Close with the evidence; do not start.
4. Work in the repo named by `repo`, from a session in that repo (X1). `workspace` tasks work from the workspace session.
5. Leave `status` alone unless the owner moves it.

## Close

`Done` is the owner's call.

1. Propose `Done` with evidence: commit hash or PR link and what was verified. Stop and wait.
2. After the yes: `status: Done`, and under `## Notes` add the date and the commit/PR link.
3. Closing the GitHub issue is a separate yes, unless the PR body already says `Closes #<n>`.
4. Commit in the vault with `git -C <vault> commit -- <paths>` only if the owner asks.

## Sync

Not automatic; the owner asks for it. Read-only until the owner picks.

1. List open issues per repo from the `url` fields (`gh api repos/<owner>/<repo>/issues`; REST, not GraphQL).
2. Report three lists: open issues with no note, notes whose issue is closed (candidates for `Done`), notes whose title drifted from the issue.
3. For every issue you propose to import, read its body and the current code first; set `intent` and a one-line reason per item. Never stamp one value on a batch.
4. Write nothing until the owner names the items.

## Do not

- Set `Done` alone, close an issue alone, or edit `_`-prefixed Tolaria properties.
- Change the schema, the views or `AGENTS.md` unless asked.
- Infer a task's repo or type from its folder.
