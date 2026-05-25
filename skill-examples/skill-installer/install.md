# Installation

## Copy

- Source path: `skill-examples/skill-installer/`
- Installed name: `skill-installer`
- Destination: `$CODEX_HOME/skills/skill-installer`, or
  `~/.codex/skills/skill-installer` when `CODEX_HOME` is unset.

## Dependencies

- Companion skills: none.
- External CLIs: `git` is required only when installing from private repositories
  or when GitHub archive download is unavailable.
- Python packages: standard library only.
- Codex apps/connectors: none.
- Credentials or accounts: optional `GITHUB_TOKEN` or `GH_TOKEN` for private
  GitHub repositories or higher GitHub API limits.

## Install Steps

1. Copy this directory into the active Codex skills root.
2. Confirm the installed directory contains `SKILL.md`, `install.md`, and:
   - `scripts/list-skills.py`
   - `scripts/install-skill-from-github.py`
   - `scripts/github_utils.py`
3. Restart Codex so the skill registry can reload.

## Update Steps

1. Back up the existing installed `skill-installer` directory.
2. Replace it with the current source directory, or run the installer with
   `--update` when installing from a GitHub source.
3. Run the verification steps below.
4. Keep the backup until the updated skill has loaded successfully.

## Verification

From the MetaSkill repository root, run:

```powershell
python .\scripts\validate_muxing_install.py --source-only --skill skill-installer
```

After installing into the active skills root, run:

```powershell
python .\scripts\validate_muxing_install.py --installed-only --skill skill-installer
```

Optionally verify that listing works against the default public source:

```powershell
python .\skill-examples\skill-installer\scripts\list-skills.py --format json
```

## Rollback

1. Remove the failed installed `skill-installer` directory.
2. Restore the backup created during update.
3. Restart Codex.

## Notes

- This skill copies skill packages and reports per-skill `install.md` guidance.
  It does not silently install external tools, configure credentials, or verify
  authenticated app connectors.
- Network access is required for GitHub listing or installation commands.
