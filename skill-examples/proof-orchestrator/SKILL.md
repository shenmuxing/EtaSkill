---
name: proof-orchestrator
description: "Coordinate GPT-pro-centered proof runs: prepare reviewed prompt bundles, run preflight difficulty probes, route GPT-pro handoffs, audit outputs, manage bounded local repairs, and produce status-labeled final artifacts."
---

# Proof Orchestrator

## Role

Coordinate proof work as a GPT-pro-centered pipeline. Codex is the local controller and manager for project context, source packaging, approval gates, tool routing, provenance, audit integration, and final assembly. GPT-pro handles hard or central proof obligations. DeepSeek is an independent adversarial reviewer when available.

Invoking this skill grants Codex default authority to create any needed
Codex-capability subagents for the active proof run, including preflight
difficulty probes and bounded, non-budget local repairs. Parent Codex must
define each task, review the result, integrate only verified parts, and own the
final status.

## Run Directory

Each idea run lives under:

```text
prompts/<YYMMDDHH-num>/
```

Preferred files:

```text
task.md              # GPT-pro-facing task instruction
materials.md         # GPT-pro-facing task materials
review.md            # user approval checkpoint, optional
preflight.md         # local/subagent difficulty and prompt-worthiness probe, optional
handoff.md           # exact GPT-pro handoff package
gpt-pro-output.md    # GPT-pro result, once available
audit.md             # checker result or audit summary
final.md             # repaired usable final version
codex-ledger.md      # local orchestration state, optional
next.md              # next proof target or continuation handoff, optional
sources/             # source snapshots, optional
```

Only `task.md` and `materials.md` are required at the standardization stage.

## Continuing A Project

When the user points to an existing run, says to continue, or refers to a
`next*.md` / `redo*.md` artifact, treat the request as project continuation
before treating it as a fresh proof task.

First rebuild the current project state from local artifacts:

- read `final.md`, `audit.md`, `codex-ledger.md`, `run-log.md`, and any
  `next*.md`, `redo*.md`, or `continuation*.md` files in the named run;
- inspect the corresponding `.agents/pro-manage/runs/<run-id>/` record when a
  GPT-pro handoff already happened;
- treat `final.md` plus `audit.md` as the calibrated mathematical state, and
  use `gpt-pro-output.md` only as raw evidence unless the audit says otherwise;
- identify accepted claims, conjectural claims, rejected routes, open proof
  obligations, source snapshots, remote Project/conversation state, and the
  next narrow target.

For a continuation, always create a new run directory. Treat the prior run as
the complete transcript and evidence package from the previous conversation,
not as a checkpoint to resume in place. In the new run's `codex-ledger.md` or
`review.md`, record:

- `Continuation of: <prior-run-id>`;
- the exact prior files read;
- the inherited mathematical status;
- the single open obligation or theorem target for this run;
- whether the ChatGPT Project should be reused, newly isolated, or left
  blocked/unknown;
- when reusing a ChatGPT Project, that GPT-pro must be asked in a new
  conversation/chat inside that Project, not by continuing the prior run's
  conversation.

Treat completed run artifacts as append-only evidence. Do not overwrite,
rename, or roll forward a prior run's `task.md`, `materials.md`,
`gpt-pro-input.md`, `gpt-pro-output.md`, `audit.md`, `final.md`, `handoff.md`,
or `codex-ledger.md` during continuation. A new GPT-pro turn gets fresh files
with the same standard names inside the new run directory. If the user
explicitly asks to revise a prior artifact, handle that as a separate
artifact-edit task, not as proof-project continuation.

Treat prior ChatGPT conversations the same way: append-only evidence, not a
live context window. For every continuation that needs GPT-pro, open a fresh
conversation inside the selected Project so the prompt is not polluted by a
long earlier thread and so context-length pressure cannot silently change the
answer. Reuse the old conversation only to retrieve or verify already-returned
output.

Keep the next prompt narrow. Do not ask GPT-pro for a full theorem when the
previous audit isolated a lemma, counterexample, or assumption check. At the end
of a nonterminal run, create that run's own `next.md` with the next proof target,
known blockers, source requirements, and route state needed by a future child
run.

## GPT Pro Stress Tests

For ChatGPT web stress tests, read `references/stress-tests.md`. Keep unrelated
tests isolated in fresh Projects and run directories. For an explicit
continuation of the same stress-test project, reuse the recorded Project only
when the source set and task lineage still match; otherwise create a fresh
isolated Project and record the parent run link. Reusing a Project for a
continuation still requires a new Project conversation/chat for the new prompt.

## Status Labels

Use these decision statuses in `codex-ledger.md`, `review.md`, or `handoff.md` when useful:

- `STANDARDIZED_FOR_USER_REVIEW`
- `PREFLIGHT_REVIEWED`
- `LOCAL_ONLY`
- `REWRITE_PROMPT`
- `SPLIT_CASE`
- `ASK_USER`
- `READY_FOR_GPT_PRO`
- `WAITING_FOR_GPT_PRO_OUTPUT`
- `NEEDS_GPT_PRO_REDO`
- `LOCAL_REPAIRABLE`
- `READY_FOR_USER`

## Workflow

Default route: user idea -> `proof-plan` -> preflight difficulty probe -> user
review -> `call-gpt-pro` or manual GPT-pro output -> Codex/DeepSeek audit ->
local repair -> final artifact.

1. Freeze the current user request:
   - identify the idea and target run directory;
   - decide whether this is a new run or continuation of an existing run;
   - if it is a continuation, perform the "Continuing A Project" reconstruction
     before writing or dispatching a new prompt;
   - do not broaden the mathematical project without user approval.
2. Standardize with `proof-plan`:
   - create `task.md` and `materials.md`;
   - include project purpose only where it affects the mathematical task;
   - keep Codex-only context in `review.md` or `codex-ledger.md`.
3. Run a preflight difficulty probe before any GPT-pro approval request:
   - have Codex or a Codex-capability subagent attempt the shortest honest local answer from `task.md` and `materials.md`;
   - check whether the target is immediate from definitions, blocked by a domain/support/topology mismatch, already implied by the prompt wording, or genuinely central/hard;
   - write `preflight.md` with status `SEND_TO_GPT_PRO`, `LOCAL_ONLY`, `REWRITE_PROMPT`, `SPLIT_CASE`, or `ASK_USER`;
   - if the probe finds a trivial obstruction, prompt mismatch, or wrong abstraction layer, revise the bundle or ask the user before spending GPT-pro budget.
4. User gate:
   - stop for review unless the user has already approved packaging;
   - do not send an unreviewed task to GPT-pro.
5. Package with `call-gpt-pro`:
   - validate that `task.md` and `materials.md` include all source context GPT-pro needs;
   - validate that `preflight.md` is absent only when the user explicitly skipped it, or else that it recommends `SEND_TO_GPT_PRO`;
   - write `handoff.md` as the exact prompt file or reading-order package;
   - include an explicit output completion marker such as `END_GPT_PRO_OUTPUT`
     in the GPT-pro-facing output contract unless the user forbids changing the
     prompt text;
   - run the `call-gpt-pro` wrapper in `-DryRun` mode when a local wrapper check is useful;
   - mark `READY_FOR_GPT_PRO`.
6. Ingest GPT-pro output:
   - if the user approves a real call, use `call-gpt-pro` and save its result as `gpt-pro-output.md`;
   - when `call-gpt-pro` uses ChatGPT web, keep the run in `WAITING_FOR_GPT_PRO_OUTPUT`
     until the 15-minute polling and completion checks in
     `call-gpt-pro/references/chatgpt-web.md` say the final assistant message
     is complete;
   - if the user provides GPT-pro text manually, save that text as `gpt-pro-output.md` when possible;
   - run the "GPT-pro Output Repair" pass below before treating copied web output
     as usable evidence;
   - preserve GPT-pro's labels and proof structure;
   - do not silently upgrade conjectures or repaired statements into proved claims.
7. Audit:
   - use Codex local checking for source alignment, notation, quantifiers, and mechanical consistency;
   - use `proof-checker-v2` as the structured adversarial audit driver when it is installed and the claim is user-facing or fragile;
   - use direct `deepseek-agent` review as the fallback when `proof-checker-v2` is unavailable, blocked, or unsuitable;
   - write the audit to `audit.md` or another user-specified path;
   - treat DeepSeek/Codex checking as adversarial review unless the local proof step is simple and explicitly labeled.
8. Repair and present:
   - make local edits or delegate a bounded repair task to a Codex-capability subagent when the defect is concrete and checkable from saved GPT-pro output, audit findings, or supplied materials;
   - parent Codex reviews and integrates only verified parts;
   - if the repair requires theorem broadening, unsupported assumptions, or a new central proof, mark `NEEDS_GPT_PRO_REDO` and prepare a focused redo prompt;
   - write `final.md` only when the result is usable and its epistemic status is explicit.

## GPT-pro Output Repair

After saving `gpt-pro-output.md`, perform the same formatting-only cleanup
contract used by `call-gpt-pro/references/chatgpt-web.md`, plus the
proof-specific checks below. This repair pass is for copied-output corruption,
manual micro-edits, and small detail additions only. It must not change proof
claims, constants, assumptions, theorem status, or proof order.

Required checks:

- Confirm the expected completion marker such as `END_GPT_PRO_OUTPUT` is present
  when the handoff requested one.
- Check display math delimiter balance and inspect suspicious blank lines inside
  `$$...$$` blocks.
- Repair GPT/Markdown copy corruption of large braces: `\left{` and `\right}`
  used as delimiters must become `\left\{` and `\right\}`. For indicator
  expressions, also repair obvious spacing damage such as
  `\mathbf 1!\left{...` to `\mathbf 1\!\left\{...`.
- Scan for residual copy separators such as standalone `====`, `======`,
  `----`, or longer all-`=` / all-`-` lines, especially inside display math.
  Remove or replace them only when the intended operator is unambiguous from the
  adjacent formula or a cleaner companion file such as `final.md`; otherwise
  leave a local flag instead of guessing. Do not treat Markdown table delimiter
  rows like `| --- | --- |` as corruption.
- Scan for common rendered-math copy artifacts such as stray `#`, `*{...}`,
  `\sum*`, `\mathbb{E}*`, `\operatorname{...}*`, and malformed right-delimiter
  fragments.

If a cleaned `final.md` already exists and is audit-aligned, it may be used as a
companion source to restore the intended Markdown/LaTeX structure. Keep
`gpt-pro-output.md` recognizable as GPT-pro output unless the user explicitly
asks to rewrite it; record any nontrivial repair in `audit.md`,
`codex-ledger.md`, or the final status note.

## Preflight Difficulty Probe

Use a preflight probe for GPT-pro-bound or stress-test runs unless the user
explicitly asks to skip it. The probe is a budget guard and prompt-quality
check, not a replacement for GPT-pro on hard central proof obligations.

Codex may run the probe itself or delegate it to a Codex-capability subagent.
The subagent must return an answer-only artifact unless Codex explicitly asks
it to write `preflight.md`. It must not broaden the theorem, call GPT-pro, add
external citations, upload sources, or make unrelated edits.

The probe should try to answer the task quickly and then classify the run:

- `SEND_TO_GPT_PRO`: the short local attempt exposes a genuinely hard central
  obligation, fragile proof step, or important uncertainty that merits GPT-pro.
- `LOCAL_ONLY`: the task is already resolved by a short definition-level
  argument, simple counterexample, or mechanical calculation.
- `REWRITE_PROMPT`: the prompt wording forces a shallow or predetermined
  answer, hides the real mathematical question, or asks for a theorem before
  the blockers have been stated.
- `SPLIT_CASE`: the task mixes algorithms, regimes, or assumptions that should
  be separated before GPT-pro sees it.
- `ASK_USER`: the intended research target is ambiguous enough that Codex
  should not choose a direction silently.

Write `preflight.md` with this structure:

```text
Status: SEND_TO_GPT_PRO | LOCAL_ONLY | REWRITE_PROMPT | SPLIT_CASE | ASK_USER

Short local answer:
[the shortest honest answer from the supplied materials]

Triviality and mismatch check:
- Immediate from definitions?
- Only a domain, support, topology, or boundary mismatch?
- Already implied by prompt wording?
- Does the task match the user's likely research intent?

Recommended next action:
[send, answer locally, rewrite, split, or ask]
```

Parent Codex must review the probe. If the probe status is not
`SEND_TO_GPT_PRO`, do not prepare a budgeted GPT-pro call until the bundle is
rewritten, split, answered locally, or explicitly approved by the user.

## Guardrails

- Audit GPT-pro theorem, lemma, proposition, reduction, regret-bound, or key-equivalence claims, especially when a hidden assumption would change the conclusion.
- Treat substantive proof gaps as `NEEDS_GPT_PRO_REDO`; do not patch them locally by broadening the theorem or inventing unsupported assumptions.
- Do not use archived legacy proof skills, old Codex proof workers, or local plan-execute-replan proof search unless the user explicitly asks for a legacy comparison.
- Do not ask DeepSeek or a subagent to replace GPT-pro for a hard central proof unless the user changes the pipeline.
- Do not spend GPT-pro budget automatically; prepare the handoff and wait for the user or a user-provided GPT-pro result.
