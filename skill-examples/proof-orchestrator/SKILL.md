---
name: proof-orchestrator
description: "Coordinate a GPT-pro-centered proof pipeline: standardize user ideas, require user review, package timestamped prompt bundles, call or ingest GPT-pro output through call-gpt-pro, run Codex/DeepSeek checking, delegate bounded local repairs to Codex-managed subagents when useful, and present a repaired usable result without relying on legacy proof-execution."
---

# Proof Orchestrator

Coordinate proof work as a GPT-pro-centered pipeline. Codex is the local
controller and manager: it owns project context, source packaging, approval
gates, tool routing, provenance, audit integration, and final assembly. GPT-pro
is the main engine for hard or central proof obligations. DeepSeek is an
independent adversarial reviewer when available.

Invoking this skill authorizes Codex to create Codex-capability subagents for
bounded local repair work inside the active proof run. This authorization covers
only non-budget local delegation for detail-fillable gaps, incomplete small
proof steps, notation fixes, formatting repairs, and concrete patch drafting
from supplied materials. It does not authorize GPT-pro spending, source upload,
theorem broadening, replacing GPT-pro for hard central proof obligations, or
accepting subagent work without Codex review.

## Default Pipeline

```text
user idea
  -> proof-plan standardizes the idea
  -> user reviews the bundle
  -> call-gpt-pro dry-runs or sends the approved handoff when the user approves spending
  -> user-provided or call-gpt-pro GPT-pro output is saved
  -> Codex and DeepSeek audit the output when appropriate
  -> Codex performs or delegates bounded local repairs and status labeling
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

## GPT Pro Stress Tests

For proof-orchestrator stress tests that use the ChatGPT web route, keep every
test run isolated:

1. Create a fresh ChatGPT Project for the run.
2. Disable memory sharing with the user's general ChatGPT context when the UI
   provides that setting.
3. Add only the resource files required by the run.
4. Ask the test prompt in that Project.
5. Keep different stress tests and unrelated proof conversations in separate
   Projects and run directories.

Record the Project name, source manifest, and memory-isolation status in the
handoff or ledger before treating the run as reproducible.

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
- `SUBAGENT_REPAIR_IN_PROGRESS`
- `SUBAGENT_REPAIR_REVIEWED`
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
   - use `proof-checker-v2` as the structured adversarial audit driver when it is installed and the claim is user-facing or fragile;
   - use direct `deepseek-agent` review as the fallback when `proof-checker-v2` is unavailable, blocked, or unsuitable;
   - write the audit to `audit.md` or another user-specified path;
   - treat DeepSeek/Codex checking as adversarial review unless the local proof step is simple and explicitly labeled.
7. Repair and present:
   - make local edits or delegate to Codex-capability subagents when the fix is mechanical, wording-level, a formatting repair, a detail-fillable gap, or a simple proof patch directly justified by the audit;
   - if the audit exposes a substantive gap, mark `NEEDS_GPT_PRO_REDO` and prepare a focused redo prompt instead of patching the theorem locally;
   - write `final.md` only when the result is usable and its epistemic status is explicit.

## Subagent Repair Delegation

Use subagents as Codex-directed repair workers, not as independent theorem
owners. The parent Codex thread remains the manager and must define the task,
review the result, integrate only verified parts, and own the final status.

Spawn a subagent when all of these hold:

- the proof run has a saved GPT-pro output, audit finding, or user-provided
  draft with a concrete local defect;
- the defect is bounded enough to state as one repair task;
- the needed assumptions and source material are already available locally or
  can be included in the subagent brief;
- the task can be checked by Codex afterward without solving a new central
  theorem from scratch.

Good subagent tasks include filling an omitted algebraic step, repairing a
notation mismatch, proving a small lemma already implied by the materials,
rewriting a flawed paragraph while preserving theorem status, or producing a
focused patch for `final.md`. Do not delegate an open-ended proof search,
unstated assumption invention, theorem reformulation, citation lookup, source
upload, GPT-pro call, or budgeted action.

Each subagent brief must state:

1. the exact local target and output contract;
2. the supplied assumptions and authoritative source excerpts or file paths;
3. the forbidden moves, especially no theorem broadening, no new unsupported
   assumptions, no external citation invention, and no unrelated file edits;
4. whether the subagent may edit files or must return an answer-only patch;
5. the acceptance checks Codex will apply before integration.

Record useful subagent work in `codex-ledger.md` or `audit.md`: subtask name,
input files, output path or patch location, and whether Codex accepted,
modified, rejected, or escalated the result. If a subagent finds a substantive
gap rather than a local repair, mark `NEEDS_GPT_PRO_REDO` and prepare a focused
redo prompt.

## Audit Policy

Run an audit when:

- GPT-pro claims a theorem, lemma, proposition, reduction, regret bound, or key equivalence;
- a fragile assumption or hidden gap would change the conclusion;
- the user asks for checking, verification, audit, or red-team review.

Do not run old Codex proof workers as an audit substitute.

## Forbidden

- Do not use archived legacy proof skills by default.
- Do not call `proof-writer-v2` or `proof-execution` to create the main proof.
- Do not ask DeepSeek to replace GPT-pro for a hard central proof unless the user explicitly changes the pipeline.
- Do not run local plan-execute-replan proof search unless the user explicitly asks for a legacy comparison.
- Do not spend GPT-pro budget automatically; prepare the handoff and wait for the user or a user-provided GPT-pro result.

## Legacy Comparison

If the user explicitly requests old-vs-new validation, use the archived legacy paths named in `AGENTS.md`. Keep legacy outputs in a separate run directory and label them clearly as `LEGACY_RESULT`, never as the default pipeline.
