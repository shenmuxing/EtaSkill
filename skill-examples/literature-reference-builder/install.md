# Installation

## Copy

- Source path: `skill-examples/literature-reference-builder/`
- Installed name: `literature-reference-builder`
- Destination: `$CODEX_HOME/skills/literature-reference-builder`, or
  `~/.codex/skills/literature-reference-builder` when `CODEX_HOME` is unset.

## Dependencies

- Companion skills: none.
- External CLIs: none.
- Python packages: none.
- Codex apps/connectors: Chrome plugin.
- Credentials or accounts: any academic or publisher access already available
  through the user's Chrome session.

## Install Steps

1. Copy this directory into the active Codex skills root.
2. Confirm `SKILL.md` exists in the installed directory.
3. Confirm the Codex Chrome plugin is available before using the skill.
4. Restart Codex so the skill registry can reload.

## Update Steps

1. Back up the existing installed directory.
2. Replace it with the current source directory, or run `skill-installer` with
   `--update` when installing from a GitHub source.
3. Run the verification steps below.

## Verification

From the MetaSkill repository root, run:

```powershell
python .\scripts\validate_muxing_install.py --source-only --skill literature-reference-builder
```

After installing into the active skills root, run:

```powershell
python .\scripts\validate_muxing_install.py --installed-only --skill literature-reference-builder
```

The installed check reports Chrome as a manual connector check.

## Rollback

1. Remove the failed installed directory.
2. Restore the backup created during update.
3. Restart Codex.

## Notes

- This skill must not bypass paywalls or access controls. Unavailable papers
  should be recorded as unresolved rather than fetched through dubious mirrors.
