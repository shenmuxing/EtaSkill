# Installation

## Copy

Copy `skill-examples/idea-creator-analysis/` into the target Codex skills directory as `idea-creator-analysis`.

Use `$CODEX_HOME/skills` when `CODEX_HOME` is set. Otherwise use `~/.codex/skills`.

## Dependencies

- Codex with skill loading enabled.
- Optional Codex-capability subagents for higher-depth idea generation.
- Optional companion skills: `deepseek-agent`, `novelty-check`, and `analysis-plan` for critique and follow-up planning.

## Install Steps

```powershell
$SkillsRoot = if ($env:CODEX_HOME) { Join-Path $env:CODEX_HOME "skills" } else { Join-Path $HOME ".codex\skills" }
New-Item -ItemType Directory -Force -Path $SkillsRoot | Out-Null
Copy-Item -Recurse -Force .\skill-examples\idea-creator-analysis (Join-Path $SkillsRoot "idea-creator-analysis")
```

## Update Steps

Repeat the install copy command from a newer checkout. Replace the existing `idea-creator-analysis` directory as a unit so `SKILL.md`, `references/`, `scripts/`, and `agents/openai.yaml` stay in sync.

## Verification

From this repository, run:

```powershell
uv run --with pyyaml python .\skill-examples\skill-creator\scripts\quick_validate.py .\skill-examples\idea-creator-analysis
python .\scripts\validate_muxing_install.py --source-only --skill idea-creator-analysis
```

Then start a fresh Codex session and confirm `idea-creator-analysis` appears in the available skills list.

## Rollback

Remove the installed directory and restore the previous copy from backup or version control:

```powershell
Remove-Item -Recurse -Force (Join-Path $SkillsRoot "idea-creator-analysis")
```

## Notes

Generated idea reports belong in the active project workspace, not in the installed skill directory.
