---
name: skill-comply
description: Measure whether agents actually follow a skill, rule or agent definition instead of assuming they do. Generates a behavioural spec from the .md file, runs it as 3 scenarios of falling prompt support (supportive, neutral, competing) through `claude -p`, classifies the tool calls against the spec and reports compliance per scenario with timelines. Use when asked "is this rule actually followed?", after adding or rewriting a rule or skill, or when auditing rules marked "Doc only". Costs real tokens; use `--dry-run` first.
---

# skill-comply

Source: ECC `skill-comply` (affaan-m/ECC), tests and fixtures dropped; the 220 upstream tests passed on the copy before it was trimmed.

## Run

From the skill directory (the package imports `scripts.*` from the cwd):

```bash
cd ~/.claude/skills/skill-comply
uv run python -m scripts.run --dry-run <path-to-md>   # spec + scenarios only, 2 haiku calls
uv run python -m scripts.run <path-to-md>             # full run: 3 × `claude -p` (default sonnet)
uv run python -m scripts.run --gen-model haiku --model sonnet --output <report.md> <path-to-md>
```

Targets: `skills/*/SKILL.md`, `rules/**/*.md`, `agents/*.md` (for agents it checks the agent is invoked when expected, not its inner workflow).

## What it does

1. `spec_generator` turns the file into ordered expected steps.
2. `scenario_generator` writes 3 prompts: supportive, neutral, competing (pushes against the rule).
3. `runner` executes each in a throwaway git repo under `$TMPDIR/skill-comply-sandbox-<uid>/` with `claude -p --allowedTools Read,Write,Edit,Bash,Glob,Grep`, and captures tool calls from stream-json.
4. `classifier` (LLM) labels each tool call with a spec step; `grader` checks order deterministically.
5. `report` writes `results/<name>.md` (gitignored): spec, prompts, score per scenario, timeline.

A rule that is followed even in the **competing** scenario holds on its own; one followed only when the prompt supports it needs stronger enforcement.

## Limits

- Not a hard sandbox: the run's `Bash` is unrestricted and the agent loads your real `~/.claude` config, which is the point of the measurement. Only setup commands are allowlisted. Run it on files you wrote, not on untrusted ones.
- Spec quality comes from an LLM, so a vague rule gives a vague measurement; read the generated spec before trusting a score.
- Each full run is several agent sessions; check the `--dry-run` spec first.
- Ignore the report's "promote to hook" advice; hooks are not used here.
