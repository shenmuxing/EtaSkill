param(
  [Parameter(Mandatory=$true)]
  [string]$CaseFile,

  [Parameter(Mandatory=$true)]
  [string]$OutputFile,

  [string[]]$SourceFile = @(),

  [string[]]$PriorIdeaFile = @(),

  [ValidateSet('high', 'xhigh')]
  [string]$Reasoning = 'xhigh'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Resolve-ExistingPath {
  param([string]$PathValue, [string]$Label)
  $resolved = Resolve-Path -LiteralPath $PathValue -ErrorAction SilentlyContinue
  if (-not $resolved) {
    throw "$Label not found: $PathValue"
  }
  $resolved.ProviderPath
}

function Read-Utf8Text {
  param([string]$PathValue)
  [System.IO.File]::ReadAllText($PathValue, [System.Text.UTF8Encoding]::new($false, $true))
}

$casePath = Resolve-ExistingPath -PathValue $CaseFile -Label 'CaseFile'
$sourcePaths = @()
foreach ($path in $SourceFile) {
  $sourcePaths += Resolve-ExistingPath -PathValue $path -Label 'SourceFile'
}
$priorPaths = @()
foreach ($path in $PriorIdeaFile) {
  $priorPaths += Resolve-ExistingPath -PathValue $path -Label 'PriorIdeaFile'
}

$outputPath = if ([System.IO.Path]::IsPathRooted($OutputFile)) {
  [System.IO.Path]::GetFullPath($OutputFile)
} else {
  [System.IO.Path]::GetFullPath((Join-Path (Get-Location) $OutputFile))
}

$outputParent = Split-Path -Parent $outputPath
if ($outputParent) {
  New-Item -ItemType Directory -Force $outputParent | Out-Null
}

$lines = New-Object System.Collections.Generic.List[string]
$lines.Add('# Codex Idea Generation Brief')
$lines.Add('')
$lines.Add('ROLE: You are a Codex research-idea generation subagent. Generate theory-first reinforcement learning research ideas.')
$lines.Add('')
$lines.Add('MODEL REQUIREMENT FOR CALLER: spawn this brief on the latest GPT-family Codex-capability model available; prefer gpt-5.5 when explicit model selection exists.')
$lines.Add("REASONING REQUIREMENT FOR CALLER: $Reasoning")
$lines.Add('')
$lines.Add('TASK:')
$lines.Add('- Read the case and supplied source summaries.')
$lines.Add('- Generate 6-10 non-duplicate theory-first candidates.')
$lines.Add('- Prefer theorem targets, counterexamples, lower bounds, diagnostic principles, or proof techniques over experiment-first ideas.')
$lines.Add('- Avoid repeating any prior ideas listed below, including close renames or minor variants.')
$lines.Add('- Return one ranked shortlist and one recommended idea.')
$lines.Add('')
$lines.Add('OUTPUT CONTRACT:')
$lines.Add('- Answer only in Markdown.')
$lines.Add('- Use the Candidate Schema from idea-creator-analysis.')
$lines.Add('- Include a duplicate-risk note for each shortlisted idea.')
$lines.Add('- Mark nonstandard identities as lemma candidates unless already derived from supplied facts.')
$lines.Add('- End with `END_CODEX_IDEA_GENERATION`.')
$lines.Add('')
$lines.Add('CASE FILE:')
$lines.Add("- $casePath")
$lines.Add('')
$lines.Add('SOURCE FILES:')
if ($sourcePaths.Count -eq 0) {
  $lines.Add('- None supplied.')
} else {
  foreach ($path in $sourcePaths) { $lines.Add("- $path") }
}
$lines.Add('')
$lines.Add('PRIOR IDEA FILES TO AVOID:')
if ($priorPaths.Count -eq 0) {
  $lines.Add('- None supplied.')
} else {
  foreach ($path in $priorPaths) { $lines.Add("- $path") }
}
$lines.Add('')
$lines.Add('CASE CONTENT:')
$lines.Add('```markdown')
$lines.Add((Read-Utf8Text -PathValue $casePath))
$lines.Add('```')
$lines.Add('')
foreach ($path in $sourcePaths) {
  $lines.Add("SOURCE EXCERPT: $path")
  $lines.Add('```text')
  $content = Read-Utf8Text -PathValue $path
  if ($content.Length -gt 30000) {
    $content = $content.Substring(0, 30000) + "`n[TRUNCATED BY BRIEF GENERATOR]"
  }
  $lines.Add($content)
  $lines.Add('```')
  $lines.Add('')
}
foreach ($path in $priorPaths) {
  $lines.Add("PRIOR IDEA EXCERPT TO AVOID: $path")
  $lines.Add('```markdown')
  $content = Read-Utf8Text -PathValue $path
  if ($content.Length -gt 20000) {
    $content = $content.Substring(0, 20000) + "`n[TRUNCATED BY BRIEF GENERATOR]"
  }
  $lines.Add($content)
  $lines.Add('```')
  $lines.Add('')
}

[System.IO.File]::WriteAllText($outputPath, ($lines -join [Environment]::NewLine), [System.Text.UTF8Encoding]::new($false))
Write-Host "Wrote Codex idea generation brief: $outputPath"
