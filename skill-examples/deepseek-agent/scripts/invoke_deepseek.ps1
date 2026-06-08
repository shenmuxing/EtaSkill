param(
    [Parameter(Mandatory = $false)]
    [string]$PromptFile,

    [Parameter(Mandatory = $false)]
    [string]$Prompt,

    [switch]$UsePromptFileReference,

    [Parameter(Mandatory = $false)]
    [string]$ResultFile,

    [Parameter(Mandatory = $false)]
    [string]$Workspace = ".",

    [Parameter(Mandatory = $false)]
    [string]$Model = $env:DEEPSEEK_AGENT_MODEL,

    [Parameter(Mandatory = $false)]
    [string]$Agent = $env:DEEPSEEK_AGENT_OPENCODE_AGENT,

    [switch]$Continue,

    [Parameter(Mandatory = $false)]
    [string]$ResumeSession,

    [switch]$Auto,
    [switch]$Json,
    [switch]$AllowEmptyOutput,

    [Parameter(Mandatory = $false)]
    [string]$OutputFile,

    [Parameter(Mandatory = $false)]
    [string]$TranscriptFile,

    [Parameter(Mandatory = $false)]
    [string]$RequirePattern,

    [switch]$DryRun,

    [Parameter(Mandatory = $false)]
    [string]$Binary = "opencode",

    [Parameter(Mandatory = $false)]
    [int]$TimeoutSeconds = 1800,

    [Parameter(Mandatory = $false)]
    [int]$StreamIdleTimeoutSeconds = 1200
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

function ConvertTo-ProcessArgumentString {
    param(
        [Parameter(Mandatory = $true)]
        [string[]]$Arguments
    )

    $escaped = foreach ($arg in $Arguments) {
        if ($null -eq $arg) {
            '""'
        } elseif ($arg -notmatch '[\s"]') {
            $arg
        } else {
            '"' + ($arg -replace '(\\*)"', '$1$1\"' -replace '(\\+)$', '$1$1') + '"'
        }
    }
    $escaped -join " "
}

function Resolve-ExecutableCommand {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Command
    )

    if (Split-Path -Parent $Command) {
        return $Command
    }

    $candidates = @()
    if ($IsWindows -or $env:OS -eq "Windows_NT") {
        $candidates += "$Command.exe"
        $candidates += "$Command.cmd"
        $candidates += "$Command.bat"
    }
    $candidates += $Command

    foreach ($candidate in $candidates) {
        $resolved = Get-Command $candidate -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($resolved) {
            return $resolved.Source
        }
    }

    return $Command
}

if ([string]::IsNullOrWhiteSpace($PromptFile) -and [string]::IsNullOrWhiteSpace($Prompt)) {
    throw "Provide either -PromptFile or -Prompt."
}

if (-not [string]::IsNullOrWhiteSpace($PromptFile) -and -not [string]::IsNullOrWhiteSpace($Prompt)) {
    throw "Provide only one of -PromptFile or -Prompt."
}

$resolvedWorkspace = (Resolve-Path -LiteralPath $Workspace).Path

if ($UsePromptFileReference -and [string]::IsNullOrWhiteSpace($PromptFile)) {
    throw "-UsePromptFileReference requires -PromptFile."
}

if ($UsePromptFileReference -and -not $Auto) {
    throw "-UsePromptFileReference requires -Auto so OpenCode can read the brief file with workspace tools."
}

if ($Continue -and -not [string]::IsNullOrWhiteSpace($ResumeSession)) {
    throw "Use only one of -Continue or -ResumeSession."
}

if ($TimeoutSeconds -lt 0) {
    throw "-TimeoutSeconds must be non-negative. Use 0 to wait indefinitely."
}

if ($StreamIdleTimeoutSeconds -lt 1 -or $StreamIdleTimeoutSeconds -gt 3600) {
    throw "-StreamIdleTimeoutSeconds must be between 1 and 3600. It is retained for compatibility with older deepseek-agent callers."
}

$argsList = @("run", "--dir", $resolvedWorkspace)
$fileArgs = @()

if (-not [string]::IsNullOrWhiteSpace($ResumeSession)) {
    $argsList += @("--session", $ResumeSession)
} elseif ($Continue) {
    $argsList += "--continue"
}

if (-not [string]::IsNullOrWhiteSpace($Model)) {
    $argsList += @("--model", $Model)
}

if (-not [string]::IsNullOrWhiteSpace($Agent)) {
    $argsList += @("--agent", $Agent)
}

if ($Json) {
    $argsList += @("--format", "json")
}

if ($Auto) {
    $argsList += "--dangerously-skip-permissions"
}

if (-not [string]::IsNullOrWhiteSpace($PromptFile)) {
    $resolvedPromptFile = (Resolve-Path -LiteralPath $PromptFile).Path
    if ($UsePromptFileReference) {
        $fileArgs += @("--file", $resolvedPromptFile)
        $promptText = "Read the attached task brief and follow it exactly. Do not ask for confirmation."
        if (-not [string]::IsNullOrWhiteSpace($ResultFile)) {
            $resolvedResultFile = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($ResultFile)
            $resultParent = Split-Path -Parent $resolvedResultFile
            if (-not [string]::IsNullOrWhiteSpace($resultParent) -and -not (Test-Path -LiteralPath $resultParent)) {
                New-Item -ItemType Directory -Path $resultParent -Force | Out-Null
            }
            $promptText += " Write any long final artifact, draft, patch, or replacement block to `"$resolvedResultFile`". Keep stdout concise: changed-file list and summary only."
        }
    } else {
        $promptText = Get-Content -LiteralPath $resolvedPromptFile -Raw
    }
} else {
    $promptText = $Prompt
}

if ([string]::IsNullOrWhiteSpace($promptText)) {
    throw "Prompt is empty."
}

$argsList += $promptText
$argsList += $fileArgs

if ($DryRun) {
    [pscustomobject]@{
        Binary = $Binary
        Workspace = $resolvedWorkspace
        Model = $Model
        Agent = $Agent
        Continue = [bool]$Continue
        ResumeSession = $ResumeSession
        Auto = [bool]$Auto
        Json = [bool]$Json
        AllowEmptyOutput = [bool]$AllowEmptyOutput
        RequirePattern = $RequirePattern
        UsePromptFileReference = [bool]$UsePromptFileReference
        ResultFile = $ResultFile
        TimeoutSeconds = $TimeoutSeconds
        StreamIdleTimeoutSeconds = $StreamIdleTimeoutSeconds
        PromptLength = $promptText.Length
        Arguments = $argsList
    } | Format-List
    exit 0
}

$psi = [System.Diagnostics.ProcessStartInfo]::new()
$resolvedBinary = Resolve-ExecutableCommand -Command $Binary
$psi.FileName = $resolvedBinary
$psi.WorkingDirectory = $resolvedWorkspace
$psi.UseShellExecute = $false
$psi.RedirectStandardOutput = $true
$psi.RedirectStandardError = $true
if ($null -ne $psi.ArgumentList) {
    foreach ($arg in $argsList) {
        [void]$psi.ArgumentList.Add($arg)
    }
} else {
    $psi.Arguments = ConvertTo-ProcessArgumentString -Arguments $argsList
}

$process = [System.Diagnostics.Process]::new()
$process.StartInfo = $psi
$timedOut = $false

try {
    [void]$process.Start()
    $stdoutTask = $process.StandardOutput.ReadToEndAsync()
    $stderrTask = $process.StandardError.ReadToEndAsync()

    if ($TimeoutSeconds -eq 0) {
        $process.WaitForExit()
    } else {
        $finished = $process.WaitForExit($TimeoutSeconds * 1000)
        if (-not $finished) {
            $timedOut = $true
            try {
                $process.Kill($true)
            } catch {
                try {
                    Stop-Process -Id $process.Id -Force -ErrorAction SilentlyContinue
                } catch {
                    # Preserve the original timeout failure below.
                }
            }
            $process.WaitForExit()
        }
    }

    $stdout = $stdoutTask.GetAwaiter().GetResult()
    $stderr = $stderrTask.GetAwaiter().GetResult()
    if ($timedOut) {
        $exitCode = 124
    } else {
        $exitCode = $process.ExitCode
    }
} finally {
    if ($null -ne $process) {
        $process.Dispose()
    }
}

if ($Json) {
    $rawOutput = $stdout
} elseif (-not [string]::IsNullOrWhiteSpace($stdout) -and -not [string]::IsNullOrWhiteSpace($stderr)) {
    $rawOutput = $stdout.TrimEnd() + [Environment]::NewLine + $stderr.TrimEnd()
} elseif (-not [string]::IsNullOrWhiteSpace($stdout)) {
    $rawOutput = $stdout
} else {
    $rawOutput = $stderr
}

$diagnosticOutput = ($stdout, $stderr | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }) -join [Environment]::NewLine

if (-not [string]::IsNullOrWhiteSpace($TranscriptFile)) {
    $resolvedTranscript = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($TranscriptFile)
    $transcriptParent = Split-Path -Parent $resolvedTranscript
    if (-not [string]::IsNullOrWhiteSpace($transcriptParent) -and -not (Test-Path -LiteralPath $transcriptParent)) {
        New-Item -ItemType Directory -Path $transcriptParent -Force | Out-Null
    }
    [pscustomobject]@{
        Timestamp = (Get-Date).ToString("o")
        Binary = $Binary
        ResolvedBinary = $resolvedBinary
        Workspace = $resolvedWorkspace
        Model = $Model
        Agent = $Agent
        Continue = [bool]$Continue
        ResumeSession = $ResumeSession
        Auto = [bool]$Auto
        Json = [bool]$Json
        TimeoutSeconds = $TimeoutSeconds
        StreamIdleTimeoutSeconds = $StreamIdleTimeoutSeconds
        PromptLength = $promptText.Length
        ExitCode = $exitCode
        TimedOut = $timedOut
        Stdout = $stdout
        Stderr = $stderr
        RawOutput = $rawOutput
    } | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $resolvedTranscript -Encoding UTF8
}

if (-not [string]::IsNullOrWhiteSpace($OutputFile)) {
    $resolvedOutput = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutputFile)
    $outputParent = Split-Path -Parent $resolvedOutput
    if (-not [string]::IsNullOrWhiteSpace($outputParent) -and -not (Test-Path -LiteralPath $outputParent)) {
        New-Item -ItemType Directory -Path $outputParent -Force | Out-Null
    }
    Set-Content -LiteralPath $resolvedOutput -Value $rawOutput -Encoding UTF8
}

if ($timedOut) {
    $timeoutMessage = "$Binary exceeded -TimeoutSeconds $TimeoutSeconds and was killed. Increase -TimeoutSeconds and make the caller's shell timeout larger than that value for long writing tasks."
    if (-not [string]::IsNullOrWhiteSpace($diagnosticOutput)) {
        Fail-WithCode "$timeoutMessage$([Environment]::NewLine)$diagnosticOutput" 124
    } else {
        Fail-WithCode $timeoutMessage 124
    }
}

if ($exitCode -ne 0) {
    if (-not [string]::IsNullOrWhiteSpace($diagnosticOutput)) {
        Fail-WithCode $diagnosticOutput $exitCode
    } else {
        Fail-WithCode "$Binary exited with code $exitCode and no output." $exitCode
    }
}

if ($Json -and -not [string]::IsNullOrWhiteSpace($rawOutput)) {
    try {
        $jsonLines = $rawOutput -split "`r?`n" | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
        foreach ($line in $jsonLines) {
            $null = $line | ConvertFrom-Json -ErrorAction Stop
        }
    } catch {
        Fail-WithCode "Expected JSON or NDJSON output from $Binary, but parsing failed. Raw output: $rawOutput" 1
    }
}

if (-not [string]::IsNullOrWhiteSpace($ResultFile)) {
    $resolvedResultFile = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($ResultFile)
    if (-not (Test-Path -LiteralPath $resolvedResultFile)) {
        Fail-WithCode "Expected DeepSeek agent to write result file '$resolvedResultFile', but it was not created." 1
    }
    $resultText = Get-Content -LiteralPath $resolvedResultFile -Raw
    if (-not $AllowEmptyOutput -and [string]::IsNullOrWhiteSpace($resultText)) {
        Fail-WithCode "DeepSeek agent wrote result file '$resolvedResultFile', but it is empty." 1
    }
    if (-not [string]::IsNullOrWhiteSpace($RequirePattern) -and $resultText -notmatch $RequirePattern) {
        Fail-WithCode "DeepSeek agent result file '$resolvedResultFile' did not match required pattern '$RequirePattern'." 1
    }
} elseif (-not $AllowEmptyOutput -and [string]::IsNullOrWhiteSpace($rawOutput)) {
    Fail-WithCode "DeepSeek agent exited successfully but produced empty stdout. Treat this as a failed delegation; rerun with -ResultFile, -OutputFile, and -TranscriptFile." 1
} elseif (-not [string]::IsNullOrWhiteSpace($RequirePattern) -and $rawOutput -notmatch $RequirePattern) {
    Fail-WithCode "DeepSeek agent output did not match required pattern '$RequirePattern'. Raw output was saved if -OutputFile or -TranscriptFile was provided." 1
}

Write-Output $rawOutput
exit 0
