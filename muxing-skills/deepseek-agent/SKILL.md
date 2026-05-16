---
name: deepseek-agent
description: "Call the installed DeepSeek TUI/CLI as a separate writing or revision agent from Codex. Use when Codex needs to delegate manuscript prose, LaTeX section drafting, academic text revision, or paper-writing feedback loops to DeepSeek, especially from the codex-deepseek-paper-protocol skill."
---

# DeepSeek Agent

Use this skill to invoke DeepSeek as a separate agent. Codex remains the controller: it prepares the brief, chooses the output contract, calls DeepSeek, then reviews the result before integrating it.

This skill is a calling layer, not a writing protocol. For two-agent paper workflows, first follow `codex-deepseek-paper-protocol`, then use this skill at the delegation step.

## Preconditions

Verify the CLI only when the current session has not already done so:

```powershell
deepseek --version
deepseek-tui --version
deepseek doctor
```

`deepseek` and `deepseek-tui` should be available on `PATH`, or the caller should
pass the wrapper's `-Binary` parameter with the target executable name or path.

If `deepseek doctor` reports missing credentials or API connectivity failure, stop and report the blocker. Do not substitute Codex-authored manuscript prose for the DeepSeek delegation.

## Invocation

Use the standard invocation path by default. Resolve the bundled wrapper from this
skill directory, and invoke it from the repository root so relative workspace
paths still resolve correctly:

```powershell
$DeepSeekAgentSkill = Join-Path $env:CODEX_HOME 'skills\deepseek-agent'
& (Join-Path $DeepSeekAgentSkill 'scripts\invoke_deepseek.ps1') `
  -PromptFile .\path\to\brief.md `
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

For CLI diagnostics only, direct prompt text is acceptable:

```powershell
$DeepSeekAgentSkill = Join-Path $env:CODEX_HOME 'skills\deepseek-agent'
& (Join-Path $DeepSeekAgentSkill 'scripts\invoke_deepseek.ps1') -Prompt "Return OK only." -Workspace .
```

Do not pass the whole brief through `exec` stdout. Save the brief in the workspace, let DeepSeek read it with tools, and require the artifact to be written to a file:

```powershell
$DeepSeekAgentSkill = Join-Path $env:CODEX_HOME 'skills\deepseek-agent'
& (Join-Path $DeepSeekAgentSkill 'scripts\invoke_deepseek.ps1') `
  -PromptFile .\path\to\brief.md `
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

This is the standard path for writing and revision work. It avoids two fragile channels: passing the brief as a command-line argument, and returning the artifact through stdout/JSON. The wrapper validates that `-ResultFile` exists and is non-empty.

## Session Reuse

Use fresh sessions by default for unrelated manuscript tasks, different target sections, or materially different source contexts. Reuse a DeepSeek session only inside one bounded writing task, especially K-round review/revision loops, where preserving the same draft context and improving provider-side prefix/cache behavior is useful.

The wrapper supports two optional top-level DeepSeek-TUI session controls:

- `-Continue`: pass `--continue` before `exec`, continuing the most recent session in the current workspace.
- `-ResumeSession <id-or-prefix>`: pass `--resume <id-or-prefix>` before `exec`, resuming a specific saved session.

Do not pass both. Prefer `-ResumeSession` when the previous round's session id is known, because `-Continue` can attach to the wrong recent session if another DeepSeek task ran in the same workspace.

For round 1 of a task, start fresh and save the transcript/output. For later rounds of the same task, use `-ResumeSession` if the session id can be recovered from `deepseek-tui sessions` or from the transcript/output; otherwise use `-Continue` only when no other DeepSeek session has run in this workspace since round 1.

Example revision round:

```powershell
$DeepSeekAgentSkill = Join-Path $env:CODEX_HOME 'skills\deepseek-agent'
& (Join-Path $DeepSeekAgentSkill 'scripts\invoke_deepseek.ps1') `
  -PromptFile .\.agents\tmp\deepseek-revision-brief.md `
  -Workspace . `
  -ResumeSession <session-id-or-prefix> `
  -Auto `
  -UsePromptFileReference `
  -ResultFile .\.agents\tmp\deepseek-result-r2.md `
  -Json `
  -OutputFile .\.agents\tmp\deepseek-output-r2.json `
  -TranscriptFile .\.agents\tmp\deepseek-transcript-r2.json `
  -TimeoutSeconds 1800 `
  -StreamIdleTimeoutSeconds 1200
```

Session reuse is an optimization, not a license to rely on stale context. Each revision brief must still restate the active target files, output contract, non-negotiable constraints, and the specific issues to fix.

Set the surrounding shell/tool timeout longer than `-TimeoutSeconds`; otherwise the caller can kill PowerShell before the wrapper can stop `deepseek-tui` and write diagnostics. In Codex, use a shell timeout at least 60 seconds longer than the wrapper timeout.

Timeout controls are split deliberately:

- `-TimeoutSeconds` is the wrapper-level wall-clock limit for the whole `deepseek-tui exec` process. It defaults to 1800 seconds. On timeout the wrapper kills the child process, writes transcript/output files if requested, and exits with code 124.
- `-StreamIdleTimeoutSeconds` sets DeepSeek-TUI's `DEEPSEEK_STREAM_IDLE_TIMEOUT_SECS` for the child process. DeepSeek-TUI documents this as the stream idle timeout, defaulting to 300 seconds and clamped to `1..=3600`. The wrapper defaults to 1200 seconds.

The wrapper treats a successful process with empty model output as a failed delegation unless a result file is expected. If a bounded text output must be complete, put an end marker in the brief (for example `END_DEEPSEEK_OUTPUT`) and pass `-RequirePattern "END_DEEPSEEK_OUTPUT"`. When `-ResultFile` is set, the marker is checked in the result file.

Use `-Auto` with `-UsePromptFileReference`; the wrapper requires it so DeepSeek can read the saved brief and use workspace tools. Do not treat `-Auto` itself as permission to edit manuscript files. The brief's `OUTPUT CONTRACT` decides whether edits are allowed:

- `direct-edit`: DeepSeek may edit only the listed target files.
- `unified-diff`, `replacement-block`, or `answer-only`: DeepSeek must not edit manuscript files directly; write the requested artifact to `-ResultFile`.

After any `-Auto` run, inspect changed files before integration. If non-`direct-edit` output touched manuscript files, treat it as an output-contract violation.

Use `-Json` by default for non-interactive delegation where Codex needs to inspect returned status.

Use `-Model <name>` only when the user or protocol specifies a model. Otherwise rely on the configured DeepSeek profile.

The DeepSeek-TUI `exec` command accepts the prompt as a positional argument, not as a native prompt-file argument. With `-UsePromptFileReference`, the wrapper passes an instruction telling DeepSeek to read the brief file from the workspace; this mode requires `-Auto`. When `-Continue` or `-ResumeSession` is used, the wrapper places the corresponding session flag before the `exec` subcommand.

## Brief Contract

Every prompt sent through this skill must include:

1. `ROLE`: the receiving agent's concrete task role, such as manuscript revision agent, proof-drafting agent, critique agent, or answer-only analysis agent.
2. `TASK`: the exact writing or revision task.
3. `WORKSPACE`: the project root and relevant file paths.
4. `CONTEXT`: selected excerpts or summaries DeepSeek is allowed to rely on.
5. `CONSTRAINTS`: facts, notation, citations, style, and claims that must be preserved.
6. `OUTPUT CONTRACT`: one of:
   - `direct-edit`: edit listed files in the workspace and return changed-file list plus summary.
   - `unified-diff`: write the patch to the agreed `-ResultFile`; stdout should contain only changed-file list plus summary.
   - `replacement-block`: write the replacement text to the agreed `-ResultFile`; stdout should contain only target location plus summary.
   - `answer-only`: write analysis or draft text to the agreed `-ResultFile`; stdout should contain only summary.
7. `PROHIBITIONS`: no invented citations, unsupported results, author metadata, or unrelated file edits.
8. `ACCEPTANCE CRITERIA`: concrete checks Codex will apply.

For paper writing, constrain substance and facts, not exact wording. Let DeepSeek choose prose, local paragraph order, transitions, and explanatory framing.

## Output Handling

After DeepSeek returns:

1. Inspect the transcript or changed files.
2. Confirm the output contract was followed. For JSON output, inspect `status`/`success`, tool summaries, and `output`; do not rely only on the process exit code.
3. If `-ResultFile` was used, inspect that file as the authoritative artifact.
4. Verify only intended files changed when `-Auto` was used.
5. Review content against the protocol acceptance criteria.
6. Apply patches or replacement blocks only after review.
7. Run compile/lint checks when the target artifact supports them.

If DeepSeek produces unusable prose, write a revision brief and call this skill again. Do not directly replace DeepSeek's manuscript text with Codex-authored prose while the two-agent protocol is active.

## Public Migration Notes

When copying this skill into a public repository or shared skill collection, keep the operational contract but remove private machine assumptions. Use install-root variables such as `$env:CODEX_HOME` or relative skill paths instead of personal absolute paths, keep examples generic, and do not include local transcripts, account details, unpublished project names, or one-off workspace logs. If a local wrapper path is needed, document how to resolve it from the installed `deepseek-agent` skill directory.

## Failure Handling

- If the CLI command fails, preserve the command, exit code, and relevant stderr in the user-facing report.
- If the wrapper exits with code 124, it hit `-TimeoutSeconds`, not necessarily a DeepSeek API timeout. Inspect `-TranscriptFile` for `TimedOut`, `Stdout`, and `Stderr`; then rerun with a larger `-TimeoutSeconds` and a larger caller timeout.
- If DeepSeek-TUI reports a stream idle timeout, rerun with a larger `-StreamIdleTimeoutSeconds` up to 3600. This controls `DEEPSEEK_STREAM_IDLE_TIMEOUT_SECS` for the child process.
- If `deepseek-tui exec --json` returns `success=true` but `output` is empty, treat it as a failed delegation unless `-ResultFile` was expected and validated. This can happen with provider-side empty responses; rerun with `-UsePromptFileReference` and `-ResultFile`.
- If the output is truncated or malformed, rerun with `-UsePromptFileReference`, `-ResultFile`, and a required end marker via `-RequirePattern`, or switch to `direct-edit` when bounded file edits are safer than returning long text through stdout.
- If direct edits touched unrelated files, stop and report the changed paths before attempting integration.
- If the prompt would exceed practical command-line size, save it to a brief file and call the wrapper with `-PromptFile`.
