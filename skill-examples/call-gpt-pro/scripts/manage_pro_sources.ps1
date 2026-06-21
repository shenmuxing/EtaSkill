param(
    [Parameter(Mandatory = $false)]
    [ValidateSet("Init", "AddSource", "NewBundle", "NewPrompt")]
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

function Resolve-SourceReference {
    param(
        [Parameter(Mandatory = $true)][string]$ResolvedRoot,
        [Parameter(Mandatory = $true)][string]$Path
    )

    if ([IO.Path]::IsPathRooted($Path)) {
        return $Path
    }

    $rootRelative = Join-Path $ResolvedRoot $Path
    if (Test-Path -LiteralPath $rootRelative) {
        return $rootRelative
    }

    try {
        return Resolve-WorkspacePath $Path
    } catch {
        return $rootRelative
    }
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

if ($Action -eq "NewBundle") {
    $stamp = Get-Date -Format "yyMMddHH"
    $bundleBase = if (-not [string]::IsNullOrWhiteSpace($Name)) {
        $Name
    } elseif (-not [string]::IsNullOrWhiteSpace($ProjectName)) {
        "$ProjectName-source-bundle"
    } else {
        "source-bundle-$stamp"
    }

    $bundleName = if ([IO.Path]::GetExtension($bundleBase)) { $bundleBase } else { "$bundleBase.txt" }
    $bundlePath = Join-Path (Join-Path $resolvedRoot "sources") $bundleName

    $bundle = [System.Collections.Generic.List[string]]::new()
    $bundle.Add("# ChatGPT Project Source Bundle")
    $bundle.Add("")
    $bundle.Add("- Bundle: $bundleName")
    $bundle.Add("- Source manifest: sources/manifest.md")
    $bundle.Add("")

    $allTableLines = Get-Content -LiteralPath $manifestPath | Where-Object {
        $_ -match '^\|' -and $_ -notmatch '^\|\s*-+'
    }
    $headerLine = $allTableLines | Select-Object -First 1
    $tableLines = $allTableLines | Select-Object -Skip 1
    $headers = @()
    if ($headerLine) {
        $headers = $headerLine.Trim().Trim('|').Split('|') | ForEach-Object { $_.Trim().Trim([char]0x60) }
    }
    $nameIndex = [Array]::IndexOf($headers, "Name")
    if ($nameIndex -lt 0) { $nameIndex = [Array]::IndexOf($headers, "File") }
    if ($nameIndex -lt 0) { $nameIndex = 0 }
    $kindIndex = [Array]::IndexOf($headers, "Kind")
    $localIndex = [Array]::IndexOf($headers, "Local path")
    if ($localIndex -lt 0) { $localIndex = [Array]::IndexOf($headers, "Local source") }
    if ($localIndex -lt 0) { $localIndex = 2 }

    foreach ($row in $tableLines) {
        $cols = $row.Trim().Trim('|').Split('|') | ForEach-Object { $_.Trim().Trim([char]0x60) }
        if ($cols.Count -le $localIndex -or $cols.Count -le $nameIndex) {
            continue
        }

        $sourceName = $cols[$nameIndex]
        $entryKind = if ($kindIndex -ge 0 -and $cols.Count -gt $kindIndex) { $cols[$kindIndex] } else { "Source" }
        $localPath = $cols[$localIndex]
        $resolvedLocal = Resolve-SourceReference -ResolvedRoot $resolvedRoot -Path $localPath

        $bundle.Add("## Source: $sourceName")
        $bundle.Add("")
        $bundle.Add("- Kind: $entryKind")
        $bundle.Add("- Local path: $localPath")
        $bundle.Add("")

        if (Test-Path -LiteralPath $resolvedLocal) {
            $bundle.Add('```markdown')
            $bundle.Add((Get-Content -LiteralPath $resolvedLocal -Raw))
            $bundle.Add('```')
        } else {
            $bundle.Add("MISSING SOURCE: $localPath")
        }
        $bundle.Add("")
    }

    $bundle | Set-Content -LiteralPath $bundlePath -Encoding UTF8
    Write-Output "Created source bundle $bundlePath"
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
        "Use only the synchronized project sources and the prompt below. If a needed source is missing or stale, say so explicitly.",
        "",
        "Do not use external citations, theorem numbers, or source facts unless they are already in the synchronized project sources.",
        "",
        "## Task",
        "",
        $Task,
        "",
        "END_GPT_PRO_PROMPT"
    ) | Set-Content -LiteralPath $promptPath -Encoding UTF8

    $recordPath = Join-Path $resolvedRoot "project-record.md"
    if (Test-Path -LiteralPath $recordPath) {
        $promptRel = "prompts/$promptName"
        $record = Get-Content -LiteralPath $recordPath
        $record = $record | ForEach-Object {
            if ($_ -like "- PROJECT_NAME:*") { "- PROJECT_NAME: $ProjectName" }
            elseif ($_ -like "- MODEL:*") { "- MODEL: $Model" }
            elseif ($_ -like "- PROMPT_FILE:*") { "- PROMPT_FILE: $promptRel" }
            elseif ($_ -like "- OUTPUT_FILE:*") { "- OUTPUT_FILE: $outputPath" }
            elseif ($_ -like "- TRANSCRIPT_FILE:*") { "- TRANSCRIPT_FILE: $transcriptPath" }
            elseif ($_ -like "- TASK:*") { "- TASK: $Task" }
            else { $_ }
        }
        $record | Set-Content -LiteralPath $recordPath -Encoding UTF8
    }

    Write-Output "Created prompt $promptPath"
    exit 0
}
