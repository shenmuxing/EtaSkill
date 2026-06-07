# Scripted OpenRouter Route

Use this fallback when the ChatGPT web route is blocked, the user explicitly
asks for API dispatch, or a reproducible scripted call is more important than
using the web entitlement.

The wrapper calls OpenRouter's OpenAI-compatible chat completions endpoint. It
defaults to `openai/gpt-5.5-pro`; override only when the user names another Pro
slug or when a newer Pro model is confirmed.

## Preconditions

Verify the API key only when a real API call is about to be made:

```powershell
if (-not $env:OPENROUTER_API_KEY) { throw "Set OPENROUTER_API_KEY before calling GPT Pro." }
```

Optional model override:

```powershell
$env:OPENROUTER_GPT_PRO_MODEL = "openai/gpt-5.5-pro"
```

Optional attribution headers:

```powershell
$env:OPENROUTER_HTTP_REFERER = "https://example.com"
$env:OPENROUTER_APP_TITLE = "Example Codex Proof Delegation"
```

Never store API keys, account identifiers, private paths, unpublished source
excerpts, or live transcripts inside the skill directory.

## Dry Run

Resolve the skill path from `SKILL.md`, then validate prompt assembly without
spending API tokens:

```powershell
& (Join-Path $GptProSkill 'scripts\invoke_openrouter_gpt_pro.ps1') `
  -PromptFile .\.agents\tmp\gpt-pro-brief.md `
  -ResultFile .\.agents\tmp\gpt-pro-result.md `
  -DryRun
```

## Real Call

Standard proof delegation:

```powershell
& (Join-Path $GptProSkill 'scripts\invoke_openrouter_gpt_pro.ps1') `
  -PromptFile .\.agents\tmp\gpt-pro-brief.md `
  -ResultFile .\.agents\tmp\gpt-pro-result.md `
  -OutputFile .\.agents\tmp\gpt-pro-response.json `
  -TranscriptFile .\.agents\tmp\gpt-pro-transcript.json `
  -TimeoutSeconds 1800 `
  -RequirePattern "END_GPT_PRO_OUTPUT"
```

Override the fallback model for one call:

```powershell
& (Join-Path $GptProSkill 'scripts\invoke_openrouter_gpt_pro.ps1') `
  -PromptFile .\.agents\tmp\gpt-pro-brief.md `
  -Model "openai/gpt-5.5-pro" `
  -ResultFile .\.agents\tmp\gpt-pro-result.md
```

## Inspect Output

- Treat `-ResultFile` as the authoritative model answer.
- Inspect `-OutputFile` when usage, provider metadata, refusal details, or raw
  response shape matters.
- Treat missing `-RequirePattern` as incomplete unless the run was explicitly
  diagnostic.
- Empty output is a failed delegation unless `-AllowEmptyOutput` was set for a
  diagnostic run.

## Failure Handling

- Missing `OPENROUTER_API_KEY` blocks only the scripted fallback, not the
  Chrome-controlled ChatGPT web route.
- Report OpenRouter or provider errors with status code and error text, without
  exposing credentials.
- If the result is too vague, requests missing context, or introduces an
  unverified assumption, write a smaller follow-up brief and call again only
  after fresh authorization for a second handoff.
