# GitHub Actions Efficiency

Load this reference only when the task involves GitHub Actions or CI workflow efficiency.

If the repo is onboarding GitHub Actions for the first time, define a minimal baseline workflow first, then optimize using the rest of this guide.

## Audit Order

Inspect in this order:

1. If `.github/workflows/` is missing or empty, gather baseline requirements first: triggering events, required checks, runtime versions, and repository-specific validation policy.
2. `.github/workflows/*.yml`
3. Docs describing CI expectations
4. Existing reports or run history if the user wants measured impact

For new setups, start with a small workflow that proves core checks, then add matrix breadth or additional jobs only when needed.

Start with common, low-risk waste:

1. Missing dependency caches
2. Missing `concurrency` cancellation
3. Over-broad workflow triggers
4. Duplicate workflow coverage across files or jobs
5. Expensive jobs that run on every change regardless of scope

## Actions-Specific Guidance

### Trigger scoping

- Use `paths` or `paths-ignore` when whole workflows truly should not run for some file classes.
- Use job-level gating when event-level filters are too coarse.
- Prefer explicit changed-file detection when reliability matters more than clever filter expressions.

### Job shaping

- Do not merge jobs blindly. If separate jobs preserve parallelism and shorten the critical path, keep them separate.
- Keep lightweight coordination or change-detection jobs separate from heavy execution jobs when that makes skip behavior obvious.
- If a workflow-only change still runs the full suite, treat that as evidence the gating model is too broad.

### Matrix reduction

Match matrix breadth to the decision being made:

- Full matrix for releases or explicit compatibility validation
- Reduced compatibility matrix for runtime, plugin, packaging, or framework-integration changes
- Single representative latest-version leg for ordinary code changes
- No heavy test job for clearly non-runtime changes when lighter protection already exists

### Optional maintenance jobs

Formatting or autofix jobs that write back to a branch are often better as opt-in jobs.

Good triggers:

- PR label such as `ci:format`
- Manual dispatch
- Explicit comment-command flow if the repo already supports it

If you use a label trigger, remember to listen for PR `labeled` and usually `unlabeled` events or the label change will not reevaluate the job.

### Inside the slowest step

- Work that does not share state runs side by side: `printf '%s\n' "${items[@]}" | xargs -n 1 -P "$jobs" ...`. Check first that the processes share no state (a shared preferences domain, temp file or port), and give each its own copy if they do. Compare the outputs of a serial and a parallel run, byte for byte where possible.
- On a self-hosted runner, keep build outputs between runs: `actions/checkout` with `clean: false`, then `git clean -ffd` (without `-x`), so untracked sources go but ignored outputs stay. Cap their size and say how to wipe them. On hosted runners, use a cache action instead.
- A pipeline under `-o pipefail` fails when its first command does, e.g. `du` on a folder that does not exist yet on the first run. Use `(cmd || true) | ...` where a missing input is normal.

### Skip gates

A gate that skips checks because a CI run was already green (a release reusing CI, a deploy reusing tests):

- Trust only push runs on the protected branch (`gh run list --branch main --event push --status success`). A `pull_request` run checked the PR's merge ref, a tree that may never reach main, and the PR head SHA is what history lookups usually return after a merge.
- Match by content, not by commit: accept a run whose commit has the same files as the target under the checks' inputs (`git diff --quiet <run sha> <target> -- <paths>`). "The last commit that touched the paths" misses runs on merge commits and finds PR heads instead.
- Read the input paths from the CI workflow's own `paths:` filter, so there is one list.
- Any error reading GitHub runs the checks; it never skips them.
- Test the gate with real git and a stubbed `gh` that answers only the filtered query.

## Safe-Change Rules

- Do not hide required release, migration, or shared-library validation.
- Do not widen changed-file scope accidentally when replacing a wrapper action.
- Treat severity drift as a regression risk.
- Match the real check surface before replacing a broad action with native tools.

## Live Validation

Prefer live GitHub validation when possible:

- Trigger `workflow_dispatch` workflows once
- Verify stale-run cancellation with two quick updates
- Verify path-gating with an incremental ignored-only or workflow-only change on an existing branch
- Confirm heavy jobs skip in the UI instead of assuming they would

Do not treat the first push on a brand-new branch as a clean path-ignore test.
