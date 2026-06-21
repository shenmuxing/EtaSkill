# Installation

## Copy

Copy `skill-examples/idea-discovery-analysis/` into the target Codex skills directory as `idea-discovery-analysis`.

Use `$CODEX_HOME/skills` when `CODEX_HOME` is set. Otherwise use `~/.codex/skills`.

## Dependencies

- Codex with skill loading enabled.
- Companion skills: `idea-creator-analysis`, `novelty-check`, `deepseek-agent`, and `analysis-plan`.
- Network or local-paper access when the user asks for literature-grounded discovery.

## Install Steps

```powershell
$SkillsRoot = if ($env:CODEX_HOME) { Join-Path $env:CODEX_HOME "skills" } else { Join-Path $HOME ".codex\skills" }
New-Item -ItemType Directory -Force -Path $SkillsRoot | Out-Null
Copy-Item -Recurse -Force .\skill-examples\idea-discovery-analysis (Join-Path $SkillsRoot "idea-discovery-analysis")
```

Install the companion skills listed above when using the full pipeline.

## Update Steps

Repeat the install copy command from a newer checkout. Replace the existing `idea-discovery-analysis` directory as a unit so `SKILL.md` and `agents/openai.yaml` stay in sync.

## Verification

From this repository, run:

```powershell
uv run --with pyyaml python .\skill-examples\skill-creator\scripts\quick_validate.py .\skill-examples\idea-discovery-analysis
python .\scripts\validate_muxing_install.py --source-only --skill idea-discovery-analysis
```

Then start a fresh Codex session and confirm `idea-discovery-analysis` appears in the available skills list.

## Rollback

Remove the installed directory and restore the previous copy from backup or version control:

```powershell
Remove-Item -Recurse -Force (Join-Path $SkillsRoot "idea-discovery-analysis")
```

## Notes

Discovery reports and source summaries should be written in the active project workspace. Keep private papers, local paths, and one-off run logs out of the reusable skill directory.
