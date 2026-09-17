---
name: diagnosing-bugs
description: Investigate reported bugs, failing tests, unexpected behavior, and performance regressions before fixing them. Build evidence for the cause and verify the original symptom. For read-only reviews, use only the evidence discipline and preserve the read-only scope.
---

# Diagnosing Bugs

Adapted from [Matt Pocock's diagnosing-bugs](https://github.com/mattpocock/skills/blob/main/skills/engineering/diagnosing-bugs/SKILL.md) for the shared Claude Code/Codex workflow.

Use this as the primary debugging workflow. Do not also run `systematic-debugging`. Follow the shared W13 evidence standard even when no fix is requested. Scale the work to the uncertainty and consequence: a small deterministic bug may need one focused check, while an intermittent or cross-system failure needs deeper investigation. Do not turn routine debugging into mandatory planning.

Read the relevant project instructions, issue decisions, and existing architecture notes before interpreting behavior. Follow the project's documentation paths; do not create a parallel spec or incident journal.

## 1. Establish what is known

Separate the user's reported symptom, your direct observations, and your hypotheses. Record expected versus actual behavior and the relevant input, revision, environment, and timing. Cite only evidence you actually inspected; preserve attribution when a result comes from the user or another agent.

Inspect callers and state transitions to identify a useful measurement point. Early hypotheses are allowed to guide investigation, but remain unverified until supported. A suspicious function or stack frame alone does not prove the cause.

For read-only review, inspect valid inputs, reachable callers, guards, and the violated contract. A deterministic code-path proof can establish a defect without running the application. Explain separately whether evidence connects that defect to the reported incident. Keep uncertain candidates outside the confirmed findings list.

## 2. Build the smallest useful check

Prefer a repeatable check that exercises the actual failing path and detects the user's exact symptom. Use an existing focused test, CLI/HTTP reproduction, captured trace replay, or a small isolated harness as appropriate. Check the behavior, not merely that execution avoids crashing.

Run against the unfixed code when available. Show the command or precise manual steps and the relevant observed output. A failed setup, missing credential, or unrelated exception is not reproduction of the reported bug.

Make the check faster and more deterministic where useful. Reduce inputs, configuration, and steps while preserving the failure; stop minimising when you can distinguish causes and verify the fix. There is no mandatory runtime or perfect-minimality threshold.

- For intermittent bugs, record failures/attempts and test conditions. Controlled stress, fixed seeds, and targeted scheduling can help, but distinguish an induced failure from the original incident. Compare like-for-like conditions; a short passing run does not prove a rare bug is gone.
- For performance, establish a baseline under a comparable workload using timing, a profiler, or a query plan. Measure the claimed bottleneck before changing it.
- If human interaction is required, provide short steps and request the observed result. The existing [HITL template](scripts/hitl-loop.template.sh) is optional: adapt a scratchpad copy only when the user has an interactive terminal for it; redact captured output before sharing it.

If reproduction is unavailable, state what was tried and what evidence is missing. Continue useful read-only inspection and analysis of existing logs/traces. Ask for the smallest missing artifact or access only when needed; do not claim confirmation or a verified fix without adequate evidence. Failure to reproduce does not prove there is no bug.

## 3. Test a causal prediction

Choose a hypothesis and state a prediction that could disprove it: "If X causes the symptom, changing or observing Y should produce Z." Consider plausible alternatives when ambiguity remains; do not invent a fixed number of hypotheses for an obvious defect.

Use a targeted probe, breakpoint, trace, or minimal experimental change that distinguishes the alternatives. Change one causal variable at a time where practical. Tag temporary instrumentation for reliable cleanup. Share meaningful predictions and results without requiring another approval for already authorized work.

Connect the trigger, execution path, and failure with evidence. Prefer a controlled comparison where removing the suspected cause removes the symptom under the same conditions, or a trace/code-path proof that rules out the relevant alternatives. A workaround that suppresses the symptom may not establish the underlying cause.

If the result contradicts the prediction, revise or reject the hypothesis instead of stacking fixes. If successive probes stop producing useful evidence, reassess the reproduction and assumptions and report the gap. Failed attempts alone do not prove an architecture problem.

## 4. Fix and verify the original behavior

Implement a focused fix once the causal evidence supports it and the task authorizes edits. Keep diagnostic experiments distinguishable from a verified fix.

When a regression test can exercise the real failure pattern at its callers, write it before the fix and observe the expected failure. Assert the intended behavior independently of the implementation. Avoid a shallow mock test that eliminates the very interaction or timing needed for the bug.

If no suitable automated test is available, explain the specific coverage gap and use the strongest available reproduction or trace evidence. Do not infer an architecture defect merely because you have not found a test boundary; any such finding needs its own evidence. A proposed or applied change remains unverified until its relevant check succeeds.

After the fix, rerun the original scenario as well as any reduced reproduction, then run the relevant regression checks. State the result and its limits: a mock passing is not production proof, and a code defect fixed is not automatically an incident explained. Passing unrelated tests or a build does not confirm the cause.

If an authorized mitigation is needed before the cause is established, identify it as a mitigation and keep the root cause unverified. Do not represent reduced symptoms as a proven root-cause fix.

## 5. Clean up and report

Remove only the temporary instrumentation and scratchpad artifacts you created. Preserve other sessions' changes. Reverify if cleanup changes executable behavior.

Report concisely: confirmed cause or unverified hypothesis, supporting evidence, change made if any, verification result, and remaining gap. Include only the relevant redacted command/output excerpts. Record the established cause and evidence in the existing issue or commit/PR when that action is within scope; do not create a separate report or start an architecture workflow automatically.

## Execution boundaries

- The skill grants no additional permissions. Read-only reviews must not edit code, add instrumentation, or run checks that write state. Use inspection and existing evidence; state any limits.
- Keep credentials in environment variables and redact secrets and sensitive payloads from displayed commands, logs, and captured artifacts. Capture only the data needed for the diagnosis.
- Do not launch a dev server, Playwright, or Computer Use without explicit authorization for the current task. Request missing authorization only for the action that needs it; continue permitted independent work.
- Use the session scratchpad for throwaway harnesses, replay payloads, and modified HITL scripts. Do not change production data or instrumentation, reset shared state, or switch the shared checkout for bisection without the required scope and authorization.
