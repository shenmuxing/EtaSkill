param(
    [Parameter(Mandatory = $false)]
    [ValidateSet("Init", "AddSource", "NewPrompt")]
    [string]$Action = "Init",

    [Parameter(Mandatory = $false)]
    [string]$Root = ".agents/pro-manage",

    [Parameter(Mandatory = $false)]
    [string]$Name,

    [Parameter(Mandatory = $false)]
    [string]$SourcePath,

    [Parameter(Mandatory = $false)]
    [ValidateSet("Mutable", "Permanent")]
    [string]$SourceKind = "Mutable",

    [Parameter(Mandatory = $false)]
    [string]$Task,

    [Parameter(Mandatory = $false)]
    [string]$ProjectName,

    [Parameter(Mandatory = $false)]
    [string]$Model = "GPT Pro"
)

$ErrorActionPreference = "Stop"

function Resolve-WorkspacePath {
    param([Parameter(Mandatory = $true)][string]$Path)
    return $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Path)
}

function Ensure-ProManageRoot {
    param([Parameter(Mandatory = $true)][string]$ResolvedRoot)

    foreach ($child in @("sources/mutable", "sources/permanent", "prompts", "outputs", "transcripts")) {
        New-Item -ItemType Directory -Path (Join-Path $ResolvedRoot $child) -Force | Out-Null
    }

    $manifest = Join-Path $ResolvedRoot "sources/manifest.md"
    if (-not (Test-Path -LiteralPath $manifest)) {
        @(
            "# Pro Source Manifest",
            "",
            "| Name | Kind | Local path | Remote status | Notes |",
            "| --- | --- | --- | --- | --- |"
        ) | Set-Content -LiteralPath $manifest -Encoding UTF8
    }

    $record = Join-Path $ResolvedRoot "project-record.md"
    if (-not (Test-Path -LiteralPath $record)) {
        @(
            "# Pro Project Record",
            "",
            "- DEFAULT_ROUTE: chatgpt-web",
            "- SELECTED_ROUTE: chatgpt-web",
            "- PROJECT_NAME: ",
            "- REMOTE_PROJECT_STATE: unknown",
            "- MODEL: GPT Pro",
            "- SOURCE_MANIFEST: sources/manifest.md",
            "- PROMPT_FILE: ",
            "- OUTPUT_FILE: ",
            "- TRANSCRIPT_FILE: ",
            "- AUTHORIZATION_SOURCE: ",
            "- TASK: ",
            "- PROHIBITIONS: no invented citations, hidden assumptions, or workspace edits"
        ) | Set-Content -LiteralPath $record -Encoding UTF8
    }
}

$resolvedRoot = Resolve-WorkspacePath $Root
Ensure-ProManageRoot $resolvedRoot

if ($Action -eq "Init") {
    Write-Output "Initialized $resolvedRoot"
    exit 0
}

$manifestPath = Join-Path $resolvedRoot "sources/manifest.md"

if ($Action -eq "AddSource") {
    if ([string]::IsNullOrWhiteSpace($SourcePath)) {
        throw "Provide -SourcePath for AddSource."
    }

    $resolvedSource = Resolve-WorkspacePath $SourcePath
    if (-not (Test-Path -LiteralPath $resolvedSource)) {
        throw "Source path does not exist: $resolvedSource"
    }

    if ([string]::IsNullOrWhiteSpace($Name)) {
        $Name = [IO.Path]::GetFileNameWithoutExtension($resolvedSource)
    }

    $kindDir = if ($SourceKind -eq "Permanent") { "permanent" } else { "mutable" }
    $extension = [IO.Path]::GetExtension($resolvedSource)
    if ([string]::IsNullOrWhiteSpace($extension)) {
        $extension = ".md"
    }

    if ($SourceKind -eq "Mutable") {
        $stamp = Get-Date -Format "yyMMddHH"
        $targetName = "$Name-$stamp$extension"
    } else {
        $targetName = "$Name$extension"
    }

    $targetPath = Join-Path (Join-Path $resolvedRoot "sources/$kindDir") $targetName
    Copy-Item -LiteralPath $resolvedSource -Destination $targetPath -Force
    Add-Content -LiteralPath $manifestPath -Encoding UTF8 -Value "| $Name | $SourceKind | sources/$kindDir/$targetName | needs-sync | |"
    Write-Output "Added source $targetPath"
    exit 0
}

if ($Action -eq "NewPrompt") {
    if ([string]::IsNullOrWhiteSpace($Task)) {
        throw "Provide -Task for NewPrompt."
    }

    $stamp = Get-Date -Format "yyMMddHH"
    $promptName = if ([string]::IsNullOrWhiteSpace($Name)) { "prompt-$stamp.md" } else { "$Name-$stamp.md" }
    $promptPath = Join-Path (Join-Path $resolvedRoot "prompts") $promptName
    $outputPath = "outputs/$([IO.Path]::GetFileNameWithoutExtension($promptName))-output.md"
    $transcriptPath = "transcripts/$([IO.Path]::GetFileNameWithoutExtension($promptName))-transcript.md"

    @(
        "# GPT Pro Prompt",
        "",
        "- PROJECT_NAME: $ProjectName",
        "- MODEL: $Model",
        "- SOURCE_MANIFEST: ../sources/manifest.md",
        "- OUTPUT_FILE: ../$outputPath",
        "- TRANSCRIPT_FILE: ../$transcriptPath",
        "- TASK: $Task",
        "",
        "## Instructions",
        "",
        "Use only the synchronized project sources and the prompt below. If a needed source is missing or stale, say so explicitly.",
        "",
        "## Prompt",
        "",
        $Task,
        "",
        "END_GPT_PRO_PROMPT"
    ) | Set-Content -LiteralPath $promptPath -Encoding UTF8

    Write-Output "Created prompt $promptPath"
    exit 0
}
