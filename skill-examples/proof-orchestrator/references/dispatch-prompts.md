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

## Preflight Difficulty Probe Prompt

```text
Use $proof-orchestrator to run a preflight difficulty probe before any GPT-pro
handoff or budget request.

Run directory:
prompts/<YYMMDDHH-num>/

Inputs:
- prompts/<YYMMDDHH-num>/task.md
- prompts/<YYMMDDHH-num>/materials.md
- optional source snapshots under prompts/<YYMMDDHH-num>/sources/

Output:
prompts/<YYMMDDHH-num>/preflight.md

Requirements:
- Attempt the shortest honest local answer from the supplied materials.
- Decide whether the task is immediate from definitions, only a domain/support/topology mismatch, already implied by prompt wording, or genuinely hard enough for GPT-pro.
- Classify the run as one of SEND_TO_GPT_PRO, LOCAL_ONLY, REWRITE_PROMPT, SPLIT_CASE, or ASK_USER.
- If the status is not SEND_TO_GPT_PRO, recommend the smallest next action before any GPT-pro spend.
- Do not broaden the theorem, invent citations, call GPT-pro, upload sources, or edit unrelated files.
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

## Subagent Repair Prompt

For bounded local repairs, generate the subagent brief from the fixed template
instead of rewriting role and guardrails by hand:

```powershell
.\.codex\skills\proof-orchestrator\scripts\new_subagent_repair_prompt.ps1 `
  -RunDirectory prompts\<YYMMDDHH-num> `
  -TargetPath prompts\<YYMMDDHH-num>\final.md `
  -Request "[concrete local repair request]" `
  -SourcePath prompts\<YYMMDDHH-num>\gpt-pro-output.md,prompts\<YYMMDDHH-num>\audit.md `
  -AllowMissingTarget
```

Then pass the generated `subagent-repair-prompt.md` to the Codex-capability
subagent. Parent Codex must review the result before integration.
