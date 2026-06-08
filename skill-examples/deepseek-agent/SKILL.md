---
name: deepseek-agent
description: "Call a DeepSeek-backed OpenCode agent as a separate writing or revision agent from Codex. Use when Codex needs to delegate manuscript prose, LaTeX section drafting, academic text revision, or paper-writing feedback loops to DeepSeek, especially from the codex-deepseek-paper-protocol skill."
---

# DeepSeek Agent

Use this skill to invoke a DeepSeek-backed agent through OpenCode. Codex remains the controller: it prepares the brief, chooses the output contract, calls the external agent, then reviews the result before integrating it.

The skill name preserves the protocol role: `DeepSeek` means the delegated model/backend should be DeepSeek. The local execution layer is OpenCode, not `deepseek-tui`.

This skill is a calling layer, not a writing protocol. For two-agent paper workflows, first follow `codex-deepseek-paper-protocol`, then use this skill at the delegation step.

## Preconditions

Verify the CLI only when the current session has not already done so:

```powershell
opencode --version
opencode auth list
# Run one of these, depending on the host:
pwsh -NoProfile -Command '$PSVersionTable.PSVersion'
powershell -NoProfile -Command '$PSVersionTable.PSVersion'
```

`opencode` should be available on `PATH`, or the caller should pass the wrapper's `-Binary` parameter with the target executable name or path. The bundled wrapper is a PowerShell script, so either `pwsh` or Windows PowerShell must be available to run it.

The DeepSeek API key must be available to OpenCode through its normal provider configuration or environment loading. Set the key in your own shell or user environment before running the verification helper; do not pass API keys as command arguments. On Windows Command Prompt, use the bundled prompt-based helper:

```bat
%USERPROFILE%\.codex\skills\deepseek-agent\scripts\set_deepseek_env.cmd
```

Then open a new terminal and verify:

```powershell
$SkillsRoot = if ($env:CODEX_HOME) { Join-Path $env:CODEX_HOME 'skills' } else { Join-Path $HOME '.codex/skills' }
$DeepSeekAgentSkill = Join-Path $SkillsRoot 'deepseek-agent'
& (Join-Path $DeepSeekAgentSkill 'scripts\setup_opencode_deepseek.ps1') `
  -Model 'deepseek/deepseek-chat'
```

Do not commit API keys, generated `.env` files, transcripts, or verification outputs. If OpenCode reports missing credentials or provider connectivity failure, stop and report the blocker. Do not substitute Codex-authored manuscript prose for the DeepSeek delegation.

When resolving this installed skill, use `$env:CODEX_HOME` when present and fall back to the default Codex skills root when it is unset:

```powershell
$SkillsRoot = if ($env:CODEX_HOME) { Join-Path $env:CODEX_HOME 'skills' } else { Join-Path $HOME '.codex/skills' }
$DeepSeekAgentSkill = Join-Path $SkillsRoot 'deepseek-agent'
```

## Invocation

Use the standard invocation path by default. Resolve the bundled wrapper from this skill directory, and invoke it from the repository root so relative workspace paths still resolve correctly:

```powershell
$SkillsRoot = if ($env:CODEX_HOME) { Join-Path $env:CODEX_HOME 'skills' } else { Join-Path $HOME '.codex/skills' }
$DeepSeekAgentSkill = Join-Path $SkillsRoot 'deepseek-agent'
& (Join-Path $DeepSeekAgentSkill 'scripts\invoke_deepseek.ps1') `
  -PromptFile .\path\to\brief.md `
  -Workspace . `
  -Model 'deepseek/deepseek-chat' `
  -Auto `
  -UsePromptFileReference `
  -ResultFile .\.agents\tmp\deepseek-result.md `
  -Json `
  -OutputFile .\.agents\tmp\deepseek-output.json `
  -TranscriptFile .\.agents\tmp\deepseek-transcript.json `
  -TimeoutSeconds 1800
```

For CLI diagnostics only, direct prompt text is acceptable:

```powershell
$SkillsRoot = if ($env:CODEX_HOME) { Join-Path $env:CODEX_HOME 'skills' } else { Join-Path $HOME '.codex/skills' }
$DeepSeekAgentSkill = Join-Path $SkillsRoot 'deepseek-agent'
& (Join-Path $DeepSeekAgentSkill 'scripts\invoke_deepseek.ps1') `
  -Prompt "Return OK only." `
  -Workspace . `
  -Model 'deepseek/deepseek-chat'
```

Do not pass the whole brief through stdout. Save the brief in the workspace, let OpenCode attach and read it, and require the artifact to be written to a file. This is the standard path for writing and revision work. It avoids two fragile channels: passing the full brief as a command-line argument, and returning the artifact through stdout/JSON. The wrapper validates that `-ResultFile` exists and is non-empty.

Use `-Model <provider/model>` to force a DeepSeek backend, such as `deepseek/deepseek-chat` or the model ID configured in the local OpenCode setup. If omitted, the wrapper uses `$env:DEEPSEEK_AGENT_MODEL`; if that is also unset, OpenCode's configured default model is used.

Use `-Agent <name>` only when a project or user OpenCode agent has been configured for this delegation path. If omitted, OpenCode uses its default agent.

## Session Reuse

Use fresh sessions by default for unrelated manuscript tasks, different target sections, or materially different source contexts. Reuse an OpenCode session only inside one bounded writing task, especially K-round review/revision loops, where preserving the same draft context and improving provider-side prefix/cache behavior is useful.

The wrapper supports two optional OpenCode session controls:

- `-Continue`: pass `--continue` to continue the most recent session.
- `-ResumeSession <id-or-prefix>`: pass `--session <id-or-prefix>` to resume a specific saved session.

Do not pass both. Prefer `-ResumeSession` when the previous round's session id is known, because `-Continue` can attach to the wrong recent session if another OpenCode task ran in the same workspace.

For round 1 of a task, start fresh and save the transcript/output. For later rounds of the same task, use `-ResumeSession` if the session id can be recovered from OpenCode session output or `opencode session list`; otherwise use `-Continue` only when no other OpenCode session has run in this workspace since round 1.

Example revision round:

```powershell
$SkillsRoot = if ($env:CODEX_HOME) { Join-Path $env:CODEX_HOME 'skills' } else { Join-Path $HOME '.codex/skills' }
$DeepSeekAgentSkill = Join-Path $SkillsRoot 'deepseek-agent'
& (Join-Path $DeepSeekAgentSkill 'scripts\invoke_deepseek.ps1') `
  -PromptFile .\.agents\tmp\deepseek-revision-brief.md `
  -Workspace . `
  -ResumeSession <session-id-or-prefix> `
  -Model 'deepseek/deepseek-chat' `
  -Auto `
  -UsePromptFileReference `
  -ResultFile .\.agents\tmp\deepseek-result-r2.md `
  -Json `
  -OutputFile .\.agents\tmp\deepseek-output-r2.json `
  -TranscriptFile .\.agents\tmp\deepseek-transcript-r2.json `
  -TimeoutSeconds 1800
```

Session reuse is an optimization, not a license to rely on stale context. Each revision brief must still restate the active target files, output contract, non-negotiable constraints, and the specific issues to fix.

Set the surrounding shell/tool timeout longer than `-TimeoutSeconds`; otherwise the caller can kill PowerShell before the wrapper can stop OpenCode and write diagnostics. In Codex, use a shell timeout at least 60 seconds longer than the wrapper timeout.

`-StreamIdleTimeoutSeconds` remains accepted for compatibility with older callers but no longer configures `deepseek-tui`.

The wrapper treats a successful process with an empty required result file as a failed delegation. If a bounded text output must be complete, put an end marker in the brief (for example `END_DEEPSEEK_OUTPUT`) and pass `-RequirePattern "END_DEEPSEEK_OUTPUT"`. When `-ResultFile` is set, the marker is checked in the result file.

Use `-Auto` with `-UsePromptFileReference`; the wrapper requires it so OpenCode can attach and read the saved brief. In the OpenCode CLI this maps to automation-friendly permission skipping, so the brief must tightly constrain file access. Do not treat `-Auto` itself as permission to edit manuscript files. The brief's `OUTPUT CONTRACT` decides whether edits are allowed:

- `direct-edit`: the agent may edit only the listed target files.
- `unified-diff`, `replacement-block`, or `answer-only`: the agent must not edit manuscript files directly; write the requested artifact to `-ResultFile`.

After any `-Auto` run, inspect changed files before integration. If non-`direct-edit` output touched manuscript files, treat it as an output-contract violation.

Use `-Json` by default for non-interactive delegation where Codex needs structured run logs. OpenCode can emit JSON event streams rather than a single `success/output` object, so the result file remains the authoritative long artifact when `-ResultFile` is set.

## Brief Contract

Every prompt sent through this skill must include:

1. `ROLE`: the receiving agent's concrete task role, such as manuscript revision agent, proof-drafting agent, critique agent, or answer-only analysis agent.
2. `TASK`: the exact writing or revision task.
3. `WORKSPACE`: the project root and relevant file paths.
4. `CONTEXT`: selected excerpts or summaries the DeepSeek-backed agent is allowed to rely on.
5. `CONSTRAINTS`: facts, notation, citations, style, and claims that must be preserved.
6. `OUTPUT CONTRACT`: one of:
   - `direct-edit`: edit listed files in the workspace and return changed-file list plus summary.
   - `unified-diff`: write the patch to the agreed `-ResultFile`; stdout should contain only changed-file list plus summary.
   - `replacement-block`: write the replacement text to the agreed `-ResultFile`; stdout should contain only target location plus summary.
   - `answer-only`: write analysis or draft text to the agreed `-ResultFile`; stdout should contain only summary.
7. `PROHIBITIONS`: no invented citations, unsupported results, author metadata, unrelated file edits, or secret exposure.
8. `ACCEPTANCE CRITERIA`: concrete checks Codex will apply.

For paper writing, constrain substance and facts, not exact wording. Let the DeepSeek-backed agent choose prose, local paragraph order, transitions, and explanatory framing.

## Output Handling

After the external agent returns:

1. Inspect the transcript or changed files.
2. Confirm the output contract was followed. For JSON output, inspect the event stream and process diagnostics; do not rely only on the process exit code.
3. If `-ResultFile` was used, inspect that file as the authoritative artifact.
4. Verify only intended files changed when `-Auto` was used.
5. Review content against the protocol acceptance criteria.
6. Apply patches or replacement blocks only after review.
7. Run compile/lint checks when the target artifact supports them.

If the DeepSeek-backed agent produces unusable prose, write a revision brief and call this skill again. Do not directly replace delegated manuscript text with Codex-authored prose while the two-agent protocol is active.

## Public Migration Notes

When copying this skill into a public repository or shared skill collection, keep the operational contract but remove private machine assumptions. Use install-root variables such as `$env:CODEX_HOME` or relative skill paths instead of personal absolute paths, keep examples generic, and do not include local transcripts, account details, unpublished project names, or one-off workspace logs. If a local wrapper path is needed, document how to resolve it from the installed `deepseek-agent` skill directory.

## Failure Handling

- If the CLI command fails, preserve the command, exit code, and relevant stderr in the user-facing report.
- If the wrapper exits with code 124, it hit `-TimeoutSeconds`, not necessarily a DeepSeek API timeout. Inspect `-TranscriptFile` for `TimedOut`, `Stdout`, and `Stderr`; then rerun with a larger `-TimeoutSeconds` and a larger caller timeout.
- If OpenCode reports missing DeepSeek credentials, run `scripts/setup_opencode_deepseek.ps1` with the API key supplied at runtime, or configure the provider through OpenCode's normal auth flow.
- If OpenCode returns JSON events but no result file, treat it as a failed delegation whenever `-ResultFile` was required.
- If the output is truncated or malformed, rerun with `-UsePromptFileReference`, `-ResultFile`, and a required end marker via `-RequirePattern`, or switch to `direct-edit` when bounded file edits are safer than returning long text through stdout.
- If direct edits touched unrelated files, stop and report the changed paths before attempting integration.
- If the prompt would exceed practical command-line size, save it to a brief file and call the wrapper with `-PromptFile -UsePromptFileReference`.
