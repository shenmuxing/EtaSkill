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

## Continuation Prompt

```text
Use $proof-orchestrator to continue this proof project from the existing run.

Prior run directory:
prompts/<YYMMDDHH-num>/

Continuation request:
[one sentence from the user or the prior next.md]

Required state reconstruction:
- Read final.md, audit.md, codex-ledger.md, run-log.md, and any next*.md,
  redo*.md, or continuation*.md files in the prior run directory.
- Inspect the matching .agents/pro-manage/runs/<run-id>/ record if a GPT-pro
  handoff happened.
- Treat final.md plus audit.md as the calibrated project state; use
  gpt-pro-output.md only as raw evidence unless the audit says otherwise.
- Identify accepted claims, conjectural claims, rejected routes, open proof
  obligations, source snapshots, remote Project/conversation state, and the
  next narrow target.

New run directory:
prompts/<YYMMDDHH-num>/

Requirements:
- Create a new child run for this continuation.
- Record `Continuation of: <prior-run-id>` in codex-ledger.md or review.md.
- Treat the prior run as the complete transcript and evidence package from the
  previous conversation, not as a checkpoint to resume in place.
- If reusing the same ChatGPT Project, open a new conversation/chat inside that
  Project for the new GPT-pro prompt. Do not continue the prior conversation
  except to retrieve or verify prior output.
- Do not overwrite, rename, or roll forward the prior run's task.md,
  materials.md, gpt-pro-input.md, gpt-pro-output.md, audit.md, final.md,
  handoff.md, or codex-ledger.md.
- Ask for exactly one lemma, obstruction, assumption check, or proof obligation
  when the previous audit isolated one.
- Do not ask GPT-pro for the full theorem until the isolated blocker is
  resolved.
- At the end, create this new run's own next.md with the next target, blockers,
  source requirements, and route state if the project remains nonterminal.
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
- List any required direct Project sources separately, especially PDFs named by
  the user or run manifest, and mark the handoff blocked if those files are not
  visibly synced as separate Project sources.
- For continuations that reuse a ChatGPT Project, record
  `CONVERSATION_MODE: new-project-chat` and require a new conversation/chat
  inside the Project rather than the prior run's conversation.
- Include an explicit output completion marker, normally `END_GPT_PRO_OUTPUT`,
  as the final line GPT-pro should return unless the user forbids changing the
  prompt text.
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

## GPT-pro Output Repair Prompt

```text
Use $proof-orchestrator to repair copied GPT-pro output formatting.

Target:
prompts/<YYMMDDHH-num>/gpt-pro-output.md

Optional companion files:
- prompts/<YYMMDDHH-num>/final.md
- prompts/<YYMMDDHH-num>/audit.md
- prompts/<YYMMDDHH-num>/codex-ledger.md

Requirements:
- Preserve GPT-pro's proof order, labels, claims, constants, assumptions, and
  theorem status.
- Confirm the expected completion marker, normally `END_GPT_PRO_OUTPUT`, when
  the handoff requested it.
- Check balanced `$$` display math delimiters and suspicious blank lines inside
  display math.
- Repair large-brace delimiter corruption: `\left{` -> `\left\{` and
  `\right}` -> `\right\}` when they are delimiter braces. For indicators,
  repair obvious spacing damage such as `\mathbf 1!\left{` to
  `\mathbf 1\!\left\{`.
- Scan for residual web-copy separators such as standalone `====`, `======`,
  `----`, or longer all-`=` / all-`-` lines. Remove or replace them only when
  the intended operator is unambiguous from adjacent formula text or a cleaner
  companion file; otherwise flag the location locally instead of guessing. Do
  not modify Markdown table delimiter rows like `| --- | --- |`.
- Scan for common rendered-math artifacts such as stray `#`, `*{...}`, `\sum*`,
  `\mathbb{E}*`, `\operatorname{...}*`, and malformed right-delimiter
  fragments.
- If the user explicitly asks for manual micro-edits or added details, keep them
  bounded to wording, notation, or directly supported explanatory details. Do
  not add a new central proof step or silently promote conjectural text to a
  proved claim.
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
- Apply the GPT-pro Output Repair checks before final assembly.
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
