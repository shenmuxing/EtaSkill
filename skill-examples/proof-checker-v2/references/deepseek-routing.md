# DeepSeek Reviewer Routing

Use DeepSeek as the proof reviewer. Codex remains the controller: gather
context, write the brief, call DeepSeek, validate the response, then produce the
final audit.

## Preferred Route: DeepSeek MCP

Prefer an installed MCP bridge that can call DeepSeek directly, such as
`mcp__llm_chat__chat`.

Use the configured default model unless the user names another DeepSeek model.
Do not expose or write API keys. If the MCP bridge is missing, unavailable, or
misconfigured, do not create credentials inside the repository; report setup as
blocked or use the fallback route.

## Fallback Route: deepseek-agent

Use `deepseek-agent` only when the MCP route is unavailable, fails, times out,
or returns malformed output. This route is also appropriate for long proof
audits that may exceed MCP tool-call wait limits.

Before using this fallback, follow `deepseek-agent` preconditions: the wrapper
script must be present, OpenCode must be installed, and DeepSeek credentials
must be configured outside the repository. Use the installed
`deepseek-agent/scripts/invoke_deepseek.ps1` wrapper on Windows. If the wrapper
cannot run, mark the fallback blocked; do not bypass it with an ad hoc command
unless the user explicitly asks.

Write the brief to `.agents/tmp/proof-checker-v2/deepseek-brief.md` and request
an answer-only artifact at `.agents/tmp/proof-checker-v2/deepseek-result.md`.
The result file is authoritative.

PowerShell fallback invocation:

```powershell
$SkillsRoot = if ($env:CODEX_HOME) {
  Join-Path $env:CODEX_HOME 'skills'
} else {
  Join-Path $HOME '.codex/skills'
}
$DeepSeekAgentSkill = Join-Path $SkillsRoot 'deepseek-agent'
& (Join-Path $DeepSeekAgentSkill 'scripts/invoke_deepseek.ps1') `
  -PromptFile .agents/tmp/proof-checker-v2/deepseek-brief.md `
  -Workspace . `
  -Auto `
  -UsePromptFileReference `
  -ResultFile .agents/tmp/proof-checker-v2/deepseek-result.md `
  -Json `
  -OutputFile .agents/tmp/proof-checker-v2/deepseek-output.json `
  -TranscriptFile .agents/tmp/proof-checker-v2/deepseek-transcript.json `
  -TimeoutSeconds 1800 `
  -StreamIdleTimeoutSeconds 1200
```

The fallback brief must include:

- `ROLE`: adversarial mathematical proof reviewer;
- `TASK`: audit the exact target proof and return structured issues only;
- `WORKSPACE`: project root and relevant file paths;
- `CONTEXT`: proof statement, proof body, nearby definitions, assumptions, and cited lemmas;
- `CONSTRAINTS`: no invented citations, no source edits, no optimistic repair, mark unverified dependencies;
- `OUTPUT CONTRACT`: answer-only, write the audit to the result file;
- `ACCEPTANCE CRITERIA`: issue records have severity, category, location, counterexample status, downstream effect, and minimal repair.

Use fresh DeepSeek sessions for unrelated proof audits. Do not reuse a session
across different theorem targets unless the user asks for a bounded multi-round
audit.

## Reviewer Prompt Template

```text
ROLE:
You are an adversarial mathematical proof reviewer. Find false statements,
hidden assumptions, missing side conditions, illegal interchanges, quantifier
errors, and counterexamples. Prefer an honest blocker over a plausible repair.

TASK:
Audit the target proof below. Do not edit source files. Return a structured
proof audit.

OUTPUT FORMAT:
- Verdict: PASS | WARN | FAIL | BLOCKED | NOT_APPLICABLE
- Claim status: PROVABLE AS STATED | PROVABLE AFTER WEAKENING / EXTRA ASSUMPTION | NOT CURRENTLY JUSTIFIED
- Claim restatement
- Obligation ledger
- Issues, each with severity, category, location, claimed step, problem,
  counterexample status, downstream effect, and minimal repair
- Counterexample pass
- Remaining risks

MANDATORY CHECKS:
Use the taxonomy and side-condition checklist from proof-checker-v2's
references/audit-rubric.md.

TARGET PROOF:
<insert exact proof content and source locations>
```

## Response Validation

After DeepSeek returns:

1. Confirm the output follows the requested issue schema.
2. Check that every fatal or critical issue cites an exact source location or a clearly identifiable proof step.
3. Verify any claimed counterexample algebraically before calling it found; otherwise relabel it as a candidate.
4. Preserve DeepSeek's substantive critique, but correct output-format errors and add local source line numbers when available.
5. If the response is empty, truncated, or mostly generic, rerun once through the fallback route; if still unusable, mark the audit `ERROR` or `BLOCKED`.
