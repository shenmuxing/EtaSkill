# Installation

## Copy

- Source path: `skill-examples/proof-usage/`
- Installed name: `proof-usage`
- Destination: `$CODEX_HOME/skills/proof-usage`, or
  `~/.codex/skills/proof-usage` when `CODEX_HOME` is unset.

## Dependencies

- Companion skills: none required for lookup. `proof-cooker` updates this playbook from `proof-material`.
- External CLIs: none.
- Python packages: none.
- Codex apps/connectors: none.
- Credentials or accounts: none.

## Install Steps

1. Copy this directory into the active Codex skills root.
2. Confirm the installed directory contains `SKILL.md`, `references/index.md`, and `references/source-map.md`.
3. Restart Codex so the skill registry can reload.

## Update Steps

1. Back up the existing installed directory.
2. Replace it with the current source directory.
3. Run the verification steps below.
4. Keep the backup until a lookup request can load the skill instructions.

## Verification

From the MetaSkill repository root, run:

```powershell
python .\scripts\validate_muxing_install.py --source-only --skill proof-usage
```

After installing into the active skills root, run:

```powershell
python .\scripts\validate_muxing_install.py --installed-only --skill proof-usage
```

## Rollback

1. Remove the failed installed directory.
2. Restore the backup created during update.
3. Restart Codex.

## Notes

- Keep entries public-safe, self-contained, and linked to material IDs.
- Use `references/index.md` as the first lookup surface.
- Do not store local proof-finder transcripts, raw screening notes, or run logs in this skill.
