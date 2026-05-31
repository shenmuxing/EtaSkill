# Installation

## Copy

- Source path: `skill-examples/proof-cooker/`
- Installed name: `proof-cooker`
- Destination: `$CODEX_HOME/skills/proof-cooker`, or
  `~/.codex/skills/proof-cooker` when `CODEX_HOME` is unset.

## Dependencies

- Companion skills: `proof-material` and `proof-usage`.
- External CLIs: none.
- Python packages: none.
- Codex apps/connectors: none.
- Credentials or accounts: none.

## Install Steps

1. Copy this directory into the active Codex skills root.
2. Install or verify the companion `proof-material` and `proof-usage` skills.
3. Confirm the installed directory contains `SKILL.md`, `references/taxonomy-template.md`, and `references/cooking-checklist.md`.
4. Restart Codex so the skill registry can reload.

## Update Steps

1. Back up the existing installed directory.
2. Replace it with the current source directory.
3. Run the verification steps below.
4. Keep the backup until a simple cooking request can load the skill instructions.

## Verification

From the MetaSkill repository root, run:

```powershell
python .\scripts\validate_muxing_install.py --source-only --skill proof-cooker
```

After installing into the active skills root, run:

```powershell
python .\scripts\validate_muxing_install.py --installed-only --skill proof-cooker
```

## Rollback

1. Remove the failed installed directory.
2. Restore the backup created during update.
3. Restart Codex.

## Notes

- `proof-cooker` writes final reusable categories into `proof-usage`, not raw extraction notes.
- Every cooked entry should preserve links back to `proof-material` IDs.
