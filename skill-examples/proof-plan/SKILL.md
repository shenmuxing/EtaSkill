---
name: proof-plan
description: "Standardize a user's proof idea into a GPT-pro-ready timestamped prompt bundle for user review. Use when the user asks for proof planning, proof idea standardization, GPT-pro proof prompt preparation, proof diagnosis setup, proof planning in Chinese, or wants Codex to prepare task materials for GPT-pro while keeping local proof attempts scoped and auditable."
---

# Proof Plan

Turn a raw proof idea into a compact GPT-pro prompt bundle that the user can
review before spending GPT-pro budget.

This skill is primarily a standardization agent. Codex may do local sanity
checks, prove simple self-contained lemmas, and repair formatting or notation
issues when the result is directly checkable from the supplied materials.
Substantive proof gaps, central theorem claims, and fragile repairs should be
packaged for GPT-pro or another explicitly approved reviewer instead of being
silently solved locally. Assume GPT-pro is mathematically strong and broadly
knowledgeable, but does not know this project's purpose, local notation, user
intent, or which source materials are authoritative.

## Output Directory

Create one run directory per idea:

```text
prompts/<YYMMDDHH-num>/
```

Use local time for `YYMMDDHH`. Use a two-digit counter such as `01`, `02`, `03`; choose the next unused counter when several ideas are prepared in the same hour.

The minimal GPT-pro-facing bundle is:

```text
prompts/<YYMMDDHH-num>/task.md
prompts/<YYMMDDHH-num>/materials.md
```

Optional local-only files may be added when useful:

```text
prompts/<YYMMDDHH-num>/codex-notes.md
prompts/<YYMMDDHH-num>/review.md
prompts/<YYMMDDHH-num>/sources/
```

Do not force a fixed section list into `task.md` or `materials.md`. Include only the information GPT-pro needs to do the assigned proof task well.

## Workflow

1. Read the user's idea and only the local files needed to understand notation, assumptions, and source materials.
2. Normalize the idea into a GPT-pro task:
   - what GPT-pro is being asked to prove, disprove, repair, or diagnose;
   - which local materials are authoritative;
   - which assumptions may be used;
   - which assumptions are only candidate repairs;
   - which claims must not be silently assumed.
3. Write `task.md` as the GPT-pro-facing instruction. Keep project motivation short; include only enough context for GPT-pro to understand why the task matters.
4. Write `materials.md` as the GPT-pro-facing task materials. This may contain
   pasted definitions, theorem sketches, notation, source excerpts, and
   pointers to files in `sources/`. If a `proof-usage` move is used, expand it
   into a concrete proof-idea card with named assumptions, the short derivation
   to try, source or material attribution, technique usage, and failure modes;
   do not include only the strategy name.
5. If needed, copy directly readable source snapshots into `sources/`. Prefer exact local material over memory.
6. Write `review.md` when the user needs an approval checkpoint. This file should make it easy for the user to see what GPT-pro will be asked and what assumptions are being frozen.
7. If Codex performed a simple local proof or sanity check, record it in
   `codex-notes.md` or `review.md` with its dependency on the supplied
   materials. Do not put local proof claims into `task.md` unless GPT-pro is
   being asked to audit them.
8. Stop for user review unless the user already explicitly approved handoff packaging.

## GPT-pro Prompt Rules

`task.md` should tell GPT-pro to:

- give a direct conclusion first;
- separate proved statements, conjectures, imported results, repaired statements, and unsupported claims;
- classify gaps as detail-fillable, requiring additional assumptions, requiring an external theorem, or not currently provable from the supplied materials;
- label every assumption added beyond the materials as a proposed repair;
- avoid inventing citations, theorem numbers, regret bounds, or proof obligations;
- use Obsidian-compatible Markdown math with `$...$` and `$$...$$`.

## Codex-Only Context

Research goal, user taste, project purpose, budget concern, and orchestration state can live in `codex-notes.md` or `review.md`. Do not put them into GPT-pro-facing files unless they change the mathematical task.

## Boundaries

- Do not present a central theorem proof as established merely because Codex
  found a plausible route.
- Do not generate nontrivial lemma proofs as a substitute for GPT-pro when the
  user asked for external proof planning or proof diagnosis.
- Do not dispatch `proof-writer-v2` or legacy `proof-execution` workers.
- Do not mark a statement as proved before GPT-pro output and a later audit support it.
- Do not use archived legacy proof skills unless the user explicitly requests a legacy comparison.
