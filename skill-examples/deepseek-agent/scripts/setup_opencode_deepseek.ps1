param(
    [Parameter(Mandatory = $false)]
    [string]$ApiKeyEnvVar = "DEEPSEEK_API_KEY",

    [Parameter(Mandatory = $false)]
    [string]$Model = "deepseek/deepseek-v4-pro",

    [Parameter(Mandatory = $false)]
    [string]$Binary = "opencode",

    [Parameter(Mandatory = $false)]
    [string]$Workspace = ".",

    [Parameter(Mandatory = $false)]
    [string]$ResultFile = ".agents/tmp/deepseek-agent-opencode-verify-result.md",

    [Parameter(Mandatory = $false)]
    [string]$TranscriptFile = ".agents/tmp/deepseek-agent-opencode-verify-transcript.json",

    [Parameter(Mandatory = $false)]
    [int]$TimeoutSeconds = 300,

    [switch]$SkipRun
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

if (-not (Get-Command $Binary -ErrorAction SilentlyContinue)) {
    Fail-WithCode "OpenCode command '$Binary' was not found on PATH. Install OpenCode first, then rerun this setup script." 1
}

$resolvedWorkspace = (Resolve-Path -LiteralPath $Workspace).Path

$processKey = [Environment]::GetEnvironmentVariable($ApiKeyEnvVar, "Process")
$userKey = [Environment]::GetEnvironmentVariable($ApiKeyEnvVar, "User")
$hasProcessKey = -not [string]::IsNullOrWhiteSpace($processKey)
$hasUserKey = -not [string]::IsNullOrWhiteSpace($userKey)

if (-not $hasProcessKey -and -not $hasUserKey) {
    Fail-WithCode "Set $ApiKeyEnvVar in your own shell or user environment before running this verification script. Do not pass API keys as command arguments." 1
}

if (-not $hasProcessKey -and $hasUserKey) {
    [Environment]::SetEnvironmentVariable($ApiKeyEnvVar, $userKey, "Process")
}

$version = & $Binary --version 2>&1
if ($LASTEXITCODE -ne 0) {
    Fail-WithCode "OpenCode version probe failed: $version" $LASTEXITCODE
}

if ($SkipRun) {
    [pscustomobject]@{
        Status = "configured"
        Binary = $Binary
        Version = ($version | Select-Object -First 1)
        Workspace = $resolvedWorkspace
        Model = $Model
        ApiKeyEnvironmentVariable = $ApiKeyEnvVar
        ApiKeyPresent = $true
        VerificationRun = "skipped"
    } | ConvertTo-Json -Depth 4
    exit 0
}

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$wrapper = Join-Path $scriptDir "invoke_deepseek.ps1"
if (-not (Test-Path -LiteralPath $wrapper)) {
    Fail-WithCode "Could not find wrapper script at '$wrapper'." 1
}

$resolvedResultFile = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($ResultFile)
$resultParent = Split-Path -Parent $resolvedResultFile
if (-not [string]::IsNullOrWhiteSpace($resultParent) -and -not (Test-Path -LiteralPath $resultParent)) {
    New-Item -ItemType Directory -Path $resultParent -Force | Out-Null
}

$briefFile = Join-Path $resultParent "deepseek-agent-opencode-verify-brief.md"
@"
ROLE: DeepSeek backend verification agent.
TASK: Verify that OpenCode can run non-interactively with the configured DeepSeek provider.
WORKSPACE: $resolvedWorkspace
OUTPUT CONTRACT: answer-only. Write exactly one short Markdown paragraph to:
$resolvedResultFile
ACCEPTANCE CRITERIA: The result file must contain the marker DEEPSEEK_AGENT_OPENCODE_OK.
PROHIBITIONS: Do not edit any files except the result file.
"@ | Set-Content -LiteralPath $briefFile -Encoding UTF8

& $wrapper `
  -PromptFile $briefFile `
  -Workspace $resolvedWorkspace `
  -Model $Model `
  -UsePromptFileReference `
  -ResultFile $resolvedResultFile `
  -Json `
  -OutputFile ".agents/tmp/deepseek-agent-opencode-verify-output.json" `
  -TranscriptFile $TranscriptFile `
  -RequirePattern "DEEPSEEK_AGENT_OPENCODE_OK" `
  -Auto `
  -TimeoutSeconds $TimeoutSeconds

if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}

[pscustomobject]@{
    Status = "verified"
    Binary = $Binary
    Version = ($version | Select-Object -First 1)
    Workspace = $resolvedWorkspace
    Model = $Model
    ApiKeyEnvironmentVariable = $ApiKeyEnvVar
    ApiKeyPresent = $true
    ResultFile = $resolvedResultFile
    TranscriptFile = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($TranscriptFile)
} | ConvertTo-Json -Depth 4
