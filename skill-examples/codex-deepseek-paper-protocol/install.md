# Installation

## Copy

- Source path: `skill-examples/codex-deepseek-paper-protocol/`
- Installed name: `codex-deepseek-paper-protocol`
- Destination: `$CODEX_HOME/skills/codex-deepseek-paper-protocol`, or
  `~/.codex/skills/codex-deepseek-paper-protocol` when `CODEX_HOME` is unset.

## Dependencies

- Companion skills: `deepseek-agent`, `muxing-style-review`.
- External CLIs: inherited from companion skills.
- Python packages: none.
- Codex apps/connectors: none.
- Credentials or accounts: inherited from `deepseek-agent` when DeepSeek is used.

## Install Steps

1. Copy this directory into the active Codex skills root.
2. Install `deepseek-agent` and `muxing-style-review` into the same skills root.
3. Confirm `SKILL.md` exists in each installed companion skill.
4. Restart Codex so the skill registry can reload.

## Update Steps

1. Back up the existing installed directory.
2. Replace it with the current source directory, or run `skill-installer` with
   `--update` when installing from a GitHub source.
3. Recheck that the companion skills are still installed.
4. Run the verification steps below.

## Verification

From the MetaSkill repository root, run:

```powershell
python .\scripts\validate_muxing_install.py --source-only --skill codex-deepseek-paper-protocol
```

After installing into the active skills root, run:

```powershell
python .\scripts\validate_muxing_install.py --installed-only --skill codex-deepseek-paper-protocol
```

## Rollback

1. Remove the failed installed directory.
2. Restore the backup created during update.
3. Restart Codex.

## Notes

- This protocol does not call DeepSeek directly; `deepseek-agent` owns the CLI
  mechanics and account diagnostics.
- Do not substitute Codex-authored manuscript prose when a required companion
  skill is unavailable.

