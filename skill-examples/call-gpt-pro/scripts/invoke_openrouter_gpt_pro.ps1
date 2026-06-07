param(
    [Parameter(Mandatory = $false)]
    [string]$PromptFile,

    [Parameter(Mandatory = $false)]
    [string]$Prompt,

    [Parameter(Mandatory = $false)]
    [string]$SystemPrompt,

    [Parameter(Mandatory = $false)]
    [string]$Model,

    [Parameter(Mandatory = $false)]
    [string]$ResultFile,

    [Parameter(Mandatory = $false)]
    [string]$OutputFile,

    [Parameter(Mandatory = $false)]
    [string]$TranscriptFile,

    [Parameter(Mandatory = $false)]
    [string]$RequirePattern,

    [Parameter(Mandatory = $false)]
    [int]$TimeoutSeconds = 1800,

    [Parameter(Mandatory = $false)]
    [int]$MaxTokens = 0,

    [Parameter(Mandatory = $false)]
    [double]$Temperature = -1,

    [Parameter(Mandatory = $false)]
    [string]$ReasoningEffort,

    [Parameter(Mandatory = $false)]
    [int]$ReasoningMaxTokens = 0,

    [switch]$AllowEmptyOutput,
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

function Fail-WithCode {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Message,

        [Parameter(Mandatory = $true)]
        [int]$Code
    )

    [Console]::Error.WriteLine($Message)
    exit $Code
}

function Resolve-OutputPath {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    $resolved = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Path)
    $parent = Split-Path -Parent $resolved
    if (-not [string]::IsNullOrWhiteSpace($parent) -and -not (Test-Path -LiteralPath $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }
    return $resolved
}

if ([string]::IsNullOrWhiteSpace($PromptFile) -and [string]::IsNullOrWhiteSpace($Prompt)) {
    throw "Provide either -PromptFile or -Prompt."
}

if (-not [string]::IsNullOrWhiteSpace($PromptFile) -and -not [string]::IsNullOrWhiteSpace($Prompt)) {
    throw "Provide only one of -PromptFile or -Prompt."
}

if ($TimeoutSeconds -lt 1) {
    throw "-TimeoutSeconds must be at least 1."
}

if (-not [string]::IsNullOrWhiteSpace($PromptFile)) {
    $resolvedPromptFile = (Resolve-Path -LiteralPath $PromptFile).Path
    $promptText = Get-Content -LiteralPath $resolvedPromptFile -Raw
} else {
    $resolvedPromptFile = $null
    $promptText = $Prompt
}

if ([string]::IsNullOrWhiteSpace($promptText)) {
    throw "Prompt is empty."
}

if ([string]::IsNullOrWhiteSpace($Model)) {
    $Model = $env:OPENROUTER_GPT_PRO_MODEL
}
if ([string]::IsNullOrWhiteSpace($Model)) {
    $Model = "openai/gpt-5.5-pro"
}

$messages = @()
if (-not [string]::IsNullOrWhiteSpace($SystemPrompt)) {
    $messages += [ordered]@{
        role = "system"
        content = $SystemPrompt
    }
}
$messages += [ordered]@{
    role = "user"
    content = $promptText
}

$body = [ordered]@{
    model = $Model
    messages = $messages
}

if ($MaxTokens -gt 0) {
    $body["max_tokens"] = $MaxTokens
}

if ($Temperature -ge 0) {
    $body["temperature"] = $Temperature
}

if (-not [string]::IsNullOrWhiteSpace($ReasoningEffort) -or $ReasoningMaxTokens -gt 0) {
    $reasoning = [ordered]@{}
    if (-not [string]::IsNullOrWhiteSpace($ReasoningEffort)) {
        $reasoning["effort"] = $ReasoningEffort
    }
    if ($ReasoningMaxTokens -gt 0) {
        $reasoning["max_tokens"] = $ReasoningMaxTokens
    }
    $body["reasoning"] = $reasoning
}

if ($DryRun) {
    [pscustomobject]@{
        Endpoint = "https://openrouter.ai/api/v1/chat/completions"
        Model = $Model
        PromptFile = $resolvedPromptFile
        PromptLength = $promptText.Length
        SystemPromptLength = if ($null -ne $SystemPrompt) { $SystemPrompt.Length } else { 0 }
        ResultFile = $ResultFile
        OutputFile = $OutputFile
        TranscriptFile = $TranscriptFile
        RequirePattern = $RequirePattern
        MaxTokens = $MaxTokens
        Temperature = $Temperature
        ReasoningEffort = $ReasoningEffort
        ReasoningMaxTokens = $ReasoningMaxTokens
        WouldUseApiKey = -not [string]::IsNullOrWhiteSpace($env:OPENROUTER_API_KEY)
    } | ConvertTo-Json -Depth 5
    exit 0
}

if ([string]::IsNullOrWhiteSpace($env:OPENROUTER_API_KEY)) {
    throw "Set OPENROUTER_API_KEY before making a real OpenRouter call."
}

$headers = @{
    "Authorization" = "Bearer $($env:OPENROUTER_API_KEY)"
}

if (-not [string]::IsNullOrWhiteSpace($env:OPENROUTER_HTTP_REFERER)) {
    $headers["HTTP-Referer"] = $env:OPENROUTER_HTTP_REFERER
}

if (-not [string]::IsNullOrWhiteSpace($env:OPENROUTER_APP_TITLE)) {
    $headers["X-OpenRouter-Title"] = $env:OPENROUTER_APP_TITLE
}

$jsonBody = $body | ConvertTo-Json -Depth 20
$endpoint = "https://openrouter.ai/api/v1/chat/completions"

try {
    $response = Invoke-RestMethod `
        -Method Post `
        -Uri $endpoint `
        -Headers $headers `
        -Body $jsonBody `
        -ContentType "application/json" `
        -TimeoutSec $TimeoutSeconds
} catch {
    $details = $_.ErrorDetails.Message
    if ([string]::IsNullOrWhiteSpace($details)) {
        $details = $_.Exception.Message
    }
    Fail-WithCode "OpenRouter request failed: $details" 1
}

$message = $null
if ($null -ne $response.choices -and $response.choices.Count -gt 0) {
    $message = $response.choices[0].message
}

$content = ""
if ($null -ne $message -and $null -ne $message.content) {
    $content = [string]$message.content
}

if (-not $AllowEmptyOutput -and [string]::IsNullOrWhiteSpace($content)) {
    $rawForError = $response | ConvertTo-Json -Depth 20
    Fail-WithCode "OpenRouter returned an empty message content. Raw response: $rawForError" 1
}

if (-not [string]::IsNullOrWhiteSpace($RequirePattern) -and $content -notmatch $RequirePattern) {
    $rawForError = $response | ConvertTo-Json -Depth 20
    if (-not [string]::IsNullOrWhiteSpace($OutputFile)) {
        Set-Content -LiteralPath (Resolve-OutputPath $OutputFile) -Value $rawForError -Encoding UTF8
    }
    Fail-WithCode "GPT Pro output did not match required pattern '$RequirePattern'." 1
}

if (-not [string]::IsNullOrWhiteSpace($ResultFile)) {
    $resolvedResult = Resolve-OutputPath $ResultFile
    Set-Content -LiteralPath $resolvedResult -Value $content -Encoding UTF8
}

$rawResponse = $response | ConvertTo-Json -Depth 50
if (-not [string]::IsNullOrWhiteSpace($OutputFile)) {
    Set-Content -LiteralPath (Resolve-OutputPath $OutputFile) -Value $rawResponse -Encoding UTF8
}

if (-not [string]::IsNullOrWhiteSpace($TranscriptFile)) {
    $usage = $null
    if ($null -ne $response.usage) {
        $usage = $response.usage
    }
    [pscustomobject]@{
        Timestamp = (Get-Date).ToString("o")
        Endpoint = $endpoint
        Model = $Model
        PromptFile = $resolvedPromptFile
        PromptLength = $promptText.Length
        SystemPromptLength = if ($null -ne $SystemPrompt) { $SystemPrompt.Length } else { 0 }
        ResultFile = $ResultFile
        OutputFile = $OutputFile
        OutputLength = $content.Length
        RequirePattern = $RequirePattern
        ResponseId = $response.id
        Usage = $usage
    } | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath (Resolve-OutputPath $TranscriptFile) -Encoding UTF8
}

if (-not [string]::IsNullOrWhiteSpace($ResultFile)) {
    Write-Output "Wrote GPT Pro result to $ResultFile"
} else {
    Write-Output $content
}

exit 0
