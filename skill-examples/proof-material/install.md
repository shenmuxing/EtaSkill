# Installation

## Copy

- Source path: `skill-examples/proof-material/`
- Installed name: `proof-material`
- Destination: `$CODEX_HOME/skills/proof-material`, or
  `~/.codex/skills/proof-material` when `CODEX_HOME` is unset.

## Dependencies

- Companion skills: none required for lookup. `proof-finder` writes to this library and `proof-cooker` reads from it.
- External CLIs: none.
- Python packages: none.
- Codex apps/connectors: none.
- Credentials or accounts: none.

## Install Steps

1. Copy this directory into the active Codex skills root.
2. Confirm the installed directory contains `SKILL.md` and `references/index.md`.
3. Restart Codex so the skill registry can reload.

## Update Steps

1. Back up the existing installed directory.
2. Replace it with the current source directory.
3. Run the verification steps below.
4. Keep the backup until a lookup request can load the material index.

## Verification

From the MetaSkill repository root, run:

```powershell
python .\scripts\validate_muxing_install.py --source-only --skill proof-material
```

After installing into the active skills root, run:

```powershell
python .\scripts\validate_muxing_install.py --installed-only --skill proof-material
```

## Rollback

1. Remove the failed installed directory.
2. Restore the backup created during update.
3. Restart Codex.

## Notes

- Keep material files source-indexed and public-safe.
- Do not store raw transcripts, run logs, or private paths in this skill.
