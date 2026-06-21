# Installation

## Copy

Copy `skill-examples/experiment-plan/` into the target Codex skills directory as `experiment-plan`.

Use `$CODEX_HOME/skills` when `CODEX_HOME` is set. Otherwise use `~/.codex/skills`.

## Dependencies

- Codex with skill loading enabled.
- Access to the project files or papers the user wants converted into an experiment plan.
- Optional shared references in `skill-examples/shared-references/` when installing this skill as part of the full MetaSkill analysis workflow.

## Install Steps

```powershell
$SkillsRoot = if ($env:CODEX_HOME) { Join-Path $env:CODEX_HOME "skills" } else { Join-Path $HOME ".codex\skills" }
New-Item -ItemType Directory -Force -Path $SkillsRoot | Out-Null
Copy-Item -Recurse -Force .\skill-examples\experiment-plan (Join-Path $SkillsRoot "experiment-plan")
```

If the target environment uses the shared reference files, also copy `skill-examples/shared-references/` next to the installed skill.

## Update Steps

Repeat the install copy command from a newer checkout. Replace the existing `experiment-plan` directory as a unit so `SKILL.md` and referenced guidance stay in sync.

## Verification

From this repository, run:

```powershell
uv run --with pyyaml python .\skill-examples\skill-creator\scripts\quick_validate.py .\skill-examples\experiment-plan
python .\scripts\validate_muxing_install.py --source-only --skill experiment-plan
```

Then start a fresh Codex session and confirm `experiment-plan` appears in the available skills list.

## Rollback

Remove the installed directory and restore the previous copy from backup or version control:

```powershell
Remove-Item -Recurse -Force (Join-Path $SkillsRoot "experiment-plan")
```

## Notes

This skill produces experiment planning artifacts in the active workspace. Do not store private datasets, credentials, or project logs in the reusable skill directory.
