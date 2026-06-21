# Installation

## Copy

Copy `skill-examples/analysis-plan/` into the target Codex skills directory as `analysis-plan`.

Use `$CODEX_HOME/skills` when `CODEX_HOME` is set. Otherwise use `~/.codex/skills`.

## Dependencies

- Codex with skill loading enabled.
- Optional companion skills: `idea-creator-analysis`, `idea-discovery-analysis`, and `experiment-plan` when those workflow handoffs are needed.

## Install Steps

```powershell
$SkillsRoot = if ($env:CODEX_HOME) { Join-Path $env:CODEX_HOME "skills" } else { Join-Path $HOME ".codex\skills" }
New-Item -ItemType Directory -Force -Path $SkillsRoot | Out-Null
Copy-Item -Recurse -Force .\skill-examples\analysis-plan (Join-Path $SkillsRoot "analysis-plan")
```

## Update Steps

Repeat the install copy command from a newer checkout. Replace the existing `analysis-plan` directory as a unit so `SKILL.md` and `agents/openai.yaml` stay in sync.

## Verification

From this repository, run:

```powershell
uv run --with pyyaml python .\skill-examples\skill-creator\scripts\quick_validate.py .\skill-examples\analysis-plan
python .\scripts\validate_muxing_install.py --source-only --skill analysis-plan
```

Then start a fresh Codex session and confirm `analysis-plan` appears in the available skills list.

## Rollback

Remove the installed directory and restore the previous copy from backup or version control:

```powershell
Remove-Item -Recurse -Force (Join-Path $SkillsRoot "analysis-plan")
```

## Notes

This skill writes planning artifacts in the active workspace. Keep private source material and project-specific outputs outside the reusable skill directory.
