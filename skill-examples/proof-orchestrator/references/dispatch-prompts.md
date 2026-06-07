# GPT-pro Proof Pipeline Prompts

These templates are for the new pipeline only. They authorize local proof work
only for simple, directly checkable steps; hard central proof obligations should
go to GPT-pro or an explicitly approved reviewer.

## Standardization Prompt

```text
Use $proof-plan to standardize this proof idea into a GPT-pro prompt bundle.

Run directory:
prompts/<YYMMDDHH-num>/

User idea:
[paste idea]

Inputs:
- [path]: [why relevant]

Requirements:
- Create task.md and materials.md.
- Include only the context GPT-pro needs.
- Keep Codex-only project motivation and user-review notes out of GPT-pro-facing files unless mathematically necessary.
- Record any simple local sanity check or directly checkable proof step in review.md or codex-notes.md.
- Stop for user review unless approval is already explicit.
```

## Handoff Prompt

```text
Use $proof-orchestrator with $call-gpt-pro to prepare the GPT-pro handoff for this approved run.

Run directory:
prompts/<YYMMDDHH-num>/

Requirements:
- Validate task.md and materials.md.
- Write handoff.md.
- List exact files and reading order for GPT-pro.
- Run the call-gpt-pro wrapper in DryRun mode if available.
- Do not add new substantive proof content to the GPT-pro handoff unless it is explicitly labeled as a local sanity check for GPT-pro to audit.
- Mark status READY_FOR_GPT_PRO or NEEDS_USER_REVIEW.
```

## Audit Prompt

```text
Use $proof-orchestrator to audit the GPT-pro proof output with Codex checks and DeepSeek review when appropriate.

Target:
prompts/<YYMMDDHH-num>/gpt-pro-output.md

Output:
prompts/<YYMMDDHH-num>/audit.md

Focus:
- hidden assumptions;
- unsupported repaired statements;
- quantifier and constant dependencies;
- applicability of imported theorems;
- whether the conclusion follows from the supplied materials.

Do not silently repair the proof. Label proposed repairs separately. Codex may apply mechanical formatting fixes and simple proof patches after the audit when the justification is explicit.
```

## Redo Prompt

```text
Create a focused GPT-pro redo prompt from the audit.

Inputs:
- prompts/<YYMMDDHH-num>/task.md
- prompts/<YYMMDDHH-num>/materials.md
- prompts/<YYMMDDHH-num>/gpt-pro-output.md
- prompts/<YYMMDDHH-num>/audit.md

Output:
prompts/<YYMMDDHH-num>/redo-task.md

Requirements:
- Ask GPT-pro to address only the audited gap or unsupported step.
- Preserve the original task constraints.
- Do not let Codex fill a substantive proof gap locally unless the user explicitly changes the task into local proof work.
```

## Finalization Prompt

```text
Prepare the final user-facing proof artifact.

Inputs:
- prompts/<YYMMDDHH-num>/gpt-pro-output.md
- prompts/<YYMMDDHH-num>/audit.md
- optional redo output

Output:
prompts/<YYMMDDHH-num>/final.md

Requirements:
- Preserve proved / repaired / conjectural / unsupported labels.
- Apply local mechanical edits, wording repairs, and simple proof patches that are explicitly supported by the audit.
- If a substantive gap remains, mark the artifact as not ready instead of polishing it into a false proof.
```
