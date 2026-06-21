# Installation

## Copy

Copy `skill-examples/novelty-check/` into the target Codex skills directory as `novelty-check`.

Use `$CODEX_HOME/skills` when `CODEX_HOME` is set. Otherwise use `~/.codex/skills`.

## Dependencies

- Codex with skill loading enabled.
- Web search or local literature access for novelty verification.
- Optional reviewer integration when the target Codex environment supports reviewer subagents.
- Shared references in `skill-examples/shared-references/` for citation discipline and trace policies.

## Install Steps

```powershell
$SkillsRoot = if ($env:CODEX_HOME) { Join-Path $env:CODEX_HOME "skills" } else { Join-Path $HOME ".codex\skills" }
New-Item -ItemType Directory -Force -Path $SkillsRoot | Out-Null
Copy-Item -Recurse -Force .\skill-examples\novelty-check (Join-Path $SkillsRoot "novelty-check")
Copy-Item -Recurse -Force .\skill-examples\shared-references (Join-Path $SkillsRoot "shared-references")
```

## Update Steps

Repeat the install copy commands from a newer checkout. Replace `novelty-check` and `shared-references` together when shared policy files change.

## Verification

From this repository, run:

```powershell
uv run --with pyyaml python .\skill-examples\skill-creator\scripts\quick_validate.py .\skill-examples\novelty-check
python .\scripts\validate_muxing_install.py --source-only --skill novelty-check
```

Then start a fresh Codex session and confirm `novelty-check` appears in the available skills list.

## Rollback

Remove the installed directory and restore the previous copy from backup or version control:

```powershell
Remove-Item -Recurse -Force (Join-Path $SkillsRoot "novelty-check")
```

## Notes

Novelty reports should cite public sources or user-provided local sources without copying private paths, credentials, or unpublished project details into the reusable skill directory.
