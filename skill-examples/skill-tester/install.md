# Installation

## Copy

- Source path: `skill-examples/skill-tester/`
- Installed name: `skill-tester`
- Destination: `$CODEX_HOME/skills/skill-tester`, or
  `~/.codex/skills/skill-tester` when `CODEX_HOME` is unset.

## Dependencies

- Companion skills: none.
- External CLIs: none.
- Python packages: none.
- Codex apps/connectors: none.
- Credentials or accounts: none.

## Install Steps

1. Copy this directory into the active Codex skills root.
2. Confirm `SKILL.md` exists in the installed directory.
3. Restart Codex so the skill registry can reload.

## Update Steps

1. Back up the existing installed directory.
2. Replace it with the current source directory, or run `skill-installer` with
   `--update` when installing from a GitHub source.
3. Run the verification steps below.

## Verification

From the MetaSkill repository root, run:

```powershell
python .\scripts\validate_muxing_install.py --source-only --skill skill-tester
```

After installing into the active skills root, run:

```powershell
python .\scripts\validate_muxing_install.py --installed-only --skill skill-tester
```

## Rollback

1. Remove the failed installed directory.
2. Restore the backup created during update.
3. Restart Codex.

## Notes

- Reports created by this skill are local debugging artifacts. Do not commit
  private report contents unless the user explicitly requests a sanitized
  public fixture.

