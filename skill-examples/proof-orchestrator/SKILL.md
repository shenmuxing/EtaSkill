---
name: proof-orchestrator
description: "Coordinate a GPT-pro-centered proof pipeline: standardize user ideas, require user review, package timestamped prompt bundles, call or ingest GPT-pro output through call-gpt-pro, run Codex/DeepSeek checking, and present a repaired usable result without relying on legacy proof-execution."
---

# Proof Orchestrator

Coordinate proof work as a GPT-pro-centered pipeline. Codex is the
standardizer, packager, auditor integrator, and light editor. GPT-pro is the
main engine for hard or central proof obligations. Codex may complete simple,
self-contained proof steps when they are directly checkable, then ask DeepSeek
or another reviewer to audit them when the result matters.

## Default Pipeline

```text
user idea
  -> proof-plan standardizes the idea
  -> user reviews the bundle
  -> call-gpt-pro dry-runs or sends the approved handoff when the user approves spending
  -> user-provided or call-gpt-pro GPT-pro output is saved
  -> Codex and DeepSeek audit the output when appropriate
  -> Codex performs local repairs and status labeling
  -> user receives a usable final artifact
```

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
handoff.md           # exact GPT-pro handoff package
gpt-pro-output.md    # GPT-pro result, once available
audit.md             # checker result or audit summary
final.md             # repaired usable final version
codex-ledger.md      # local orchestration state, optional
sources/             # source snapshots, optional
```

Only `task.md` and `materials.md` are required at the standardization stage.

## State Machine

Use these statuses in `codex-ledger.md`, `review.md`, or `handoff.md` when useful:

- `IDEA_RECEIVED`
- `STANDARDIZED_FOR_USER_REVIEW`
- `USER_APPROVED`
- `READY_FOR_GPT_PRO`
- `WAITING_FOR_GPT_PRO_OUTPUT`
- `GPT_PRO_OUTPUT_INGESTED`
- `AUDIT_READY`
- `NEEDS_GPT_PRO_REDO`
- `LOCAL_REPAIRABLE`
- `READY_FOR_USER`

## Workflow

1. Freeze the current user request:
   - identify the idea and target run directory;
   - decide whether this is a new run or continuation of an existing run;
   - do not broaden the mathematical project without user approval.
2. Standardize with `proof-plan`:
   - create `task.md` and `materials.md`;
   - include project purpose only where it affects the mathematical task;
   - keep Codex-only context in `review.md` or `codex-ledger.md`.
3. User gate:
   - stop for review unless the user has already approved packaging;
   - do not send an unreviewed task to GPT-pro.
4. Package with `call-gpt-pro`:
   - validate that `task.md` and `materials.md` include all source context GPT-pro needs;
   - write `handoff.md` as the exact prompt file or reading-order package;
   - run the `call-gpt-pro` wrapper in `-DryRun` mode when a local wrapper check is useful;
   - mark `READY_FOR_GPT_PRO`.
5. Ingest GPT-pro output:
   - if the user approves a real call, use `call-gpt-pro` and save its result as `gpt-pro-output.md`;
   - if the user provides GPT-pro text manually, save that text as `gpt-pro-output.md` when possible;
   - preserve GPT-pro's labels and proof structure;
   - do not silently upgrade conjectures or repaired statements into proved claims.
6. Audit:
   - use Codex local checking for source alignment, notation, quantifiers, and mechanical consistency;
   - use `deepseek-agent` for an adversarial proof audit when the claim is user-facing or fragile;
   - use `proof-checker-v2` only when it is separately installed and appropriate;
   - write the audit to `audit.md` or another user-specified path;
   - treat DeepSeek/Codex checking as adversarial review unless the local proof step is simple and explicitly labeled.
7. Repair and present:
   - make local edits when the fix is mechanical, wording-level, a formatting repair, or a simple proof patch directly justified by the audit;
   - if the audit exposes a substantive gap, mark `NEEDS_GPT_PRO_REDO` and prepare a focused redo prompt instead of patching the theorem locally;
   - write `final.md` only when the result is usable and its epistemic status is explicit.

## Audit Policy

Run an audit when:

- GPT-pro claims a theorem, lemma, proposition, reduction, regret bound, or key equivalence;
- a fragile assumption or hidden gap would change the conclusion;
- the user asks for checking, verification, audit, or red-team review.

Use `deepseek-agent` for independent review when available. If a local
`proof-checker-v2` skill is separately installed, it may be used as the audit
driver. Do not run old Codex proof workers as an audit substitute.

## Forbidden

- Do not use archived legacy proof skills by default.
- Do not call `proof-writer-v2` or `proof-execution` to create the main proof.
- Do not ask DeepSeek to replace GPT-pro for a hard central proof unless the user explicitly changes the pipeline.
- Do not run local plan-execute-replan proof search unless the user explicitly asks for a legacy comparison.
- Do not spend GPT-pro budget automatically; prepare the handoff and wait for the user or a user-provided GPT-pro result.

## Legacy Comparison

If the user explicitly requests old-vs-new validation, use the archived legacy paths named in `AGENTS.md`. Keep legacy outputs in a separate run directory and label them clearly as `LEGACY_RESULT`, never as the default pipeline.
