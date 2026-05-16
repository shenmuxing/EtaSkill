---
name: codex-deepseek-paper-protocol
description: "Protocol-level two-agent paper writing workflow. Use when the user wants Codex to plan and review from global context while DeepSeek writes or revises the manuscript through the global deepseek-agent skill, with muxing-style-review used for explicit prose style checks."
---

# Codex-DeepSeek Paper Protocol

Use this skill to coordinate two agents for academic writing:

- **Codex** is the principal reviewer, planner, and protocol controller.
- **DeepSeek** is the writing agent.
- **K = 4** review-feedback rounds by default, unless the user specifies another value.
- The concrete DeepSeek invocation is handled by the global `deepseek-agent` skill.

This skill is a protocol, not a paper template. It defines how the agents cooperate.

## Required Companion Skill

Use `deepseek-agent` whenever this protocol delegates to DeepSeek. In this
repository it is published as `muxing-skills/deepseek-agent`; after installation,
resolve it from the active skills directory.

That skill owns the installed `deepseek` / `deepseek-tui` CLI mechanics, including:

- checking `deepseek doctor` when needed,
- calling the bundled `deepseek-agent/scripts/invoke_deepseek.ps1` wrapper,
- choosing `direct-edit`, `unified-diff`, `replacement-block`, or `answer-only`,
- using the standard invocation path with `-Auto`, `-UsePromptFileReference`, and `-ResultFile`,
- optionally using `-ResumeSession` or `-Continue` for later rounds of the same bounded task.

This protocol owns the brief, review, feedback loop, and integration judgment. Do not duplicate CLI calling details here beyond the delegation rules below.

Use `muxing-style-review` for explicit post-hoc prose style checks during Codex
review. In this repository it is published as `muxing-skills/muxing-style-review`;
after installation, resolve it from the active skills directory.

Invoke it as `@muxing-style-review` or `/muxing-style-review` depending on the active harness. Use `/muxing-style-review FILE` to audit one Markdown prose file, and `/muxing-style-review A.md B.md` to compare two drafts. Treat `muxing-style-review` findings as review evidence; do not let its polish step replace DeepSeek's authorship unless the user explicitly approves that reviewed copy.

## Core Rule

Codex must not directly write manuscript prose when this protocol is active.

Codex may:

- inspect project context,
- decide what should be written,
- select and summarize necessary context,
- write task briefs for DeepSeek,
- review DeepSeek output,
- request revisions,
- apply mechanical integration only when necessary to preserve files, such as accepting a patch, fixing a broken include path, or resolving a trivial LaTeX syntax issue introduced by a patch.

Codex must not:

- draft paragraphs, theorem explanations, related work prose, abstracts, introductions, or conclusions itself,
- rewrite DeepSeek prose directly because it sounds weak,
- silently replace DeepSeek's writing with Codex-authored text,
- over-specify wording so tightly that DeepSeek is reduced to filling blanks.

If prose quality is insufficient, Codex writes a better revision instruction and sends it back to DeepSeek.

## Role Split

### Codex Responsibilities

Codex owns judgment and global coherence:

1. Understand the user's actual goal, target artifact, and audience.
2. Read enough project context to determine what content is needed.
3. Identify the local writing unit: whole paper, chapter, section, subsection, theorem explanation, related work block, or revision pass.
4. Decide the minimum sufficient context DeepSeek needs.
5. Write a clear but non-overconstraining DeepSeek brief.
6. Review DeepSeek output for:
   - self-containedness,
   - logical clarity,
   - correctness,
   - consistency with project context,
   - claim-evidence alignment,
   - notation consistency,
   - citation discipline,
   - venue or book style fit,
   - absence of fabricated results, citations, or claims.
7. Produce revision requests until the output passes or K rounds are exhausted.
8. Report remaining risks to the user.

### DeepSeek Responsibilities

DeepSeek owns writing and revision:

1. Draft the requested manuscript text.
2. Preserve the target format, usually LaTeX or Markdown.
3. Use only the context supplied by Codex and any explicitly allowed project files.
4. Make substantive prose, structure, and explanation changes requested by Codex.
5. Return either direct workspace edits, a unified diff, a clearly delimited replacement block, or answer-only text according to the `deepseek-agent` output contract selected by Codex.

DeepSeek should have room to choose wording, local paragraph order, examples, and explanatory framing, as long as it satisfies Codex's constraints.

## Workflow

### Step 0: Determine Scope

Codex first determines:

- target file(s),
- target writing unit,
- target language and style,
- expected length,
- source materials,
- hard constraints,
- unknowns or assumptions.

If the user request is underspecified but safe assumptions are possible, Codex proceeds and records the assumptions in the DeepSeek brief. Ask the user only when the missing information would change the artifact materially.

### Step 1: Build Global Context

Codex reads project context before delegating. Prefer:

- current manuscript files,
- outline or table of contents,
- nearby sections,
- project notes,
- figures/tables/captions,
- bibliography files,
- reviewer comments or TODOs,
- prior drafts.

Codex should not dump all context into DeepSeek. Select only what is necessary for the writing unit.

### Step 2: Write the DeepSeek Brief

Every DeepSeek brief must include:

1. **Task**: what to write or revise.
2. **Target files**: exact path(s), and whether edits are direct, patch-based, or replacement-block based.
3. **Purpose**: why this text exists in the paper.
4. **Audience**: expected reader and venue/book style.
5. **Context**: concise summaries plus exact excerpts when needed.
6. **Must include**: claims, definitions, equations, examples, citations, or figures that must appear.
7. **Must avoid**: fabricated results, invented citations, unsupported claims, author metadata, unexplained notation, excessive hype.
8. **Freedom**: what DeepSeek may decide independently, such as wording, paragraph transitions, local organization, and explanatory examples.
9. **Output contract**: direct edit, unified diff, or replacement block; include changed-file list.
10. **Acceptance criteria**: concrete checks Codex will apply.

The brief should constrain substance, not micromanage prose. Prefer "explain why X matters and connect it to Y" over sentence-level templates.

### Step 2.5: Session Reuse Plan

Before the first DeepSeek delegation for a bounded writing task, decide whether later rounds should reuse the same DeepSeek session.

Default policy:

- Start a fresh DeepSeek session for round 1 of each distinct manuscript task.
- Reuse the same DeepSeek session for later review/revision rounds of that same task when doing so is likely to preserve useful draft context or improve provider-side prefix/cache behavior.
- Do not reuse a session across different sections, different target files, materially different source contexts, or after a user-directed change of task.
- Prefer `-ResumeSession <id-or-prefix>` when the previous round's session id is known.
- Use `-Continue` only when no other DeepSeek task has run in this workspace since the prior round.

Even when reusing a session, each revision brief must restate the active target files, output contract, non-negotiable constraints, and concrete issues to fix. Session reuse is an optimization, not a substitute for a complete revision brief.

### Step 3: Delegate to DeepSeek

Use `deepseek-agent` to send the brief. Always use the standard invocation path: save the brief to a temporary or task-local Markdown file, have DeepSeek read that file, and require the artifact to be written to `-ResultFile`.

Invoke the global wrapper from the repository root:

```powershell
$DeepSeekAgentSkill = Join-Path $env:CODEX_HOME 'skills\deepseek-agent'
& (Join-Path $DeepSeekAgentSkill 'scripts\invoke_deepseek.ps1') `
  -PromptFile .\path\to\deepseek-brief.md `
  -Workspace . `
  -Auto `
  -UsePromptFileReference `
  -ResultFile .\.agents\tmp\deepseek-result.md `
  -Json `
  -OutputFile .\.agents\tmp\deepseek-output.json `
  -TranscriptFile .\.agents\tmp\deepseek-transcript.json `
  -TimeoutSeconds 1800 `
  -StreamIdleTimeoutSeconds 1200
```

For later rounds of the same bounded task, add exactly one of the session reuse flags:

```powershell
  -ResumeSession <session-id-or-prefix> `
```

or, only when it is safe to continue the latest workspace session:

```powershell
  -Continue `
```

In this protocol, `-Auto` means the DeepSeek process can read the saved brief and use workspace tools. It does not by itself grant permission to edit manuscript files. The output contract in the brief decides what DeepSeek may change, and Codex must verify the changed-file list afterward.

Choose the output contract before invoking:

- `direct-edit`: DeepSeek may edit only the explicit target files. Require a changed-file list and inspect the diff after return.
- `unified-diff`: DeepSeek must not edit manuscript files directly. It writes the patch to `-ResultFile`; Codex inspects and applies it after review.
- `replacement-block`: DeepSeek must not edit manuscript files directly. It writes the bounded replacement text to `-ResultFile`; Codex integrates it after review.
- `answer-only`: DeepSeek must not edit manuscript files directly. It writes analysis, critique, planning, or draft text to `-ResultFile`.

Use `-Model <name>` only when the user specifies one or a project rule requires it. Otherwise use the configured DeepSeek profile.

If the DeepSeek calling skill does not exist yet, stop at a prepared brief and tell the user the missing dependency. Do not substitute Codex drafting for DeepSeek writing.

### Step 4: Codex Review

Codex reviews DeepSeek output against the acceptance criteria and global context.

Run an explicit style check when DeepSeek returns prose in a Markdown-compatible file or extract:

1. If DeepSeek edited a Markdown manuscript file, call `@muxing-style-review` or `/muxing-style-review FILE`.
2. If DeepSeek returned a replacement block or LaTeX-only prose, save only the prose-bearing excerpt to a temporary Markdown review file, then call `@muxing-style-review` or `/muxing-style-review` on that file.
3. If comparing a previous draft with DeepSeek's revision, call `/muxing-style-review A.md B.md`.
4. Record the rule-level findings and classify style issues as BLOCKER, MAJOR, or MINOR according to their manuscript impact.
5. If style fixes are needed under this protocol, send a revision brief back through `deepseek-agent`; do not directly rewrite manuscript prose in Codex.

If the active harness cannot invoke `@muxing-style-review` or `/muxing-style-review`, do not silently replace it with a weaker check. State that the muxing-style-review skill invocation is unavailable, run the strongest available fallback only as supporting evidence (for example `agent-style review --audit-only` on the extracted prose), and record which parts of the style review were skipped, especially semantic rules. Treat skipped semantic style checks as residual risk in the final report.

Do not run `muxing-style-review` on raw LaTeX fragments when markup would dominate the audit. Extract prose or convert a bounded excerpt to Markdown first, preserving citations, equations, labels, and inline code as literal text where needed.

Use this review checklist:

- Is the text self-contained for its position in the manuscript?
- Does the logic flow from motivation to claim to evidence?
- Are all technical statements consistent with the project files?
- Are equations, variables, assumptions, and names consistent?
- Are citations present where needed and absent where unsupported?
- Are results and numbers copied accurately?
- Does the text avoid overclaiming?
- Does the section connect to the previous and next manuscript units?
- Is the output in the requested format?
- Does it introduce any stale labels, duplicate labels, broken references, or TODO placeholders?
- Does `muxing-style-review` flag agent-style violations that materially weaken clarity, tone, specificity, or structure?

Codex classifies issues as:

- **BLOCKER**: incorrect, unsupported, fabricated, incoherent, or unusable.
- **MAJOR**: substantially weak, incomplete, inconsistent, or poorly integrated.
- **MINOR**: localized clarity, style, formatting, or small consistency issue.

### Step 5: Feedback Loop

Run up to K rounds, default K = 4.

For each failed round:

1. Codex writes a revision brief listing only the issues that must change.
2. Codex preserves DeepSeek's valid choices instead of resetting the draft.
3. Codex gives evidence from files or context for each requested change.
4. DeepSeek revises through `deepseek-agent`, reusing the same session with `-ResumeSession` when the session id is known, or `-Continue` only when it is safe to continue the latest workspace session.
5. Codex reviews again.

Track the session identity for each task in the temporary task notes, transcript, or output metadata when available. If session identity cannot be recovered, keep the next revision brief self-contained and either start fresh or use `-Continue` only after confirming no unrelated DeepSeek invocation has occurred in this workspace.

Stop early when:

- no BLOCKER or MAJOR issues remain,
- remaining MINOR issues are acceptable or purely mechanical,
- the user asks to stop.

When K rounds are exhausted, Codex reports:

- what passed,
- what remains unresolved,
- whether the current output is usable,
- the next most useful action.

## Feedback Style

Codex feedback to DeepSeek should be precise and actionable:

- Bad: "Improve the introduction."
- Good: "The introduction states the method before defining the problem. Revise the first three paragraphs so the reader first sees the bottleneck, then the missing capability, then the proposed mechanism. Preserve the current quantitative claim and citation list."

- Bad: "Make it more rigorous."
- Good: "The proof sketch uses `converges` without stating the topology or limit object. Add a sentence that identifies the convergence mode and points to the formal statement in Section 3. Do not introduce a new theorem."

## Non-Overconstraint Rule

Codex should give DeepSeek:

- goals,
- facts,
- constraints,
- examples when needed,
- acceptance criteria.

Codex should avoid giving:

- full paragraph drafts,
- sentence-by-sentence outlines,
- exact phrasing unless preserving a required term,
- unnecessary rhetorical style commands,
- every possible source excerpt when a summary is enough.

The purpose is to let DeepSeek write, while Codex maintains correctness and global coherence.

## File Handling

Before delegation, Codex records the target file state if edits are expected. After DeepSeek returns:

- inspect changed files,
- verify only intended files changed,
- check formatting and references,
- run available compile or lint commands when appropriate,
- avoid overwriting unrelated user edits.

If DeepSeek returns a patch, Codex may apply the patch, but should not rewrite the manuscript content while applying it.

## Publication and Sharing Notes

When this protocol or its companion skills are copied into a public repository, preserve the truthful behavior contract but remove personal absolute paths, account details, unpublished project names, private manuscript text, local transcripts, and one-off workspace logs. Prefer references to companion skill names, relative paths inside the skill package, or install-root variables such as `$env:CODEX_HOME`. Keep examples generic and reproducible, and do not add publication claims that are not implemented by the bundled skills or scripts.

## Final Response

Codex reports:

- target files touched,
- number of DeepSeek rounds used,
- remaining issues by severity,
- verification performed,
- whether the artifact is ready for the next workflow step.

Keep the final response concise. Do not include the full DeepSeek brief unless the user asks for it.
