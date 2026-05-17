# Installation

## Copy

- Source path: `skill-examples/literature-idea-planner/`
- Installed name: `literature-idea-planner`
- Destination: `$CODEX_HOME/skills/literature-idea-planner`, or
  `~/.codex/skills/literature-idea-planner` when `CODEX_HOME` is unset.

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
python .\scripts\validate_muxing_install.py --source-only --skill literature-idea-planner
```

After installing into the active skills root, run:

```powershell
python .\scripts\validate_muxing_install.py --installed-only --skill literature-idea-planner
```

The installed check reports Chrome as a manual connector check.

## Rollback

1. Remove the failed installed directory.
2. Restore the backup created during update.
3. Restart Codex.

## Notes

- Generic unauthenticated web search is not an equivalent substitute when the
  skill requires Chrome for logged-in academic access or Google Scholar behavior.

