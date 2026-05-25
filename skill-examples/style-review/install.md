# Installation

## Copy

- Source path: `skill-examples/style-review/`
- Installed name: `style-review`
- Destination: `$CODEX_HOME/skills/style-review`, or
  `~/.codex/skills/style-review` when `CODEX_HOME` is unset.

## Dependencies

- Companion skills: none.
- External CLIs: `agent-style` is required for deterministic audit and compare
  commands.
- Python packages: none for the skill itself.
- Codex apps/connectors: none.
- Credentials or accounts: none.

## Install Steps

1. Copy this directory into the active Codex skills root.
2. Confirm `SKILL.md`, `references/rule-detectors.md`, and
   `references/revision-prompt.md` exist in the installed directory.
3. Install or expose the `agent-style` CLI on `PATH`.
4. Restart Codex so the skill registry can reload.

## Update Steps

1. Back up the existing installed directory.
2. Replace it with the current source directory, or run `skill-installer` with
   `--update` when installing from a GitHub source.
3. Run the verification steps below.
4. Keep the backup until the updated skill has loaded successfully.

## Verification

From the MetaSkill repository root, run:

```powershell
uv run python .\scripts\validate_muxing_install.py --source-only --skill style-review
```

After installing into the active skills root, run:

```powershell
uv run python .\scripts\validate_muxing_install.py --installed-only --skill style-review
```

Run a harmless CLI check:

```powershell
agent-style --version
```

## Rollback

1. Remove the failed installed directory.
2. Restore the backup created during update.
3. Restart Codex.

## Notes

- This package is vendored from
  `https://github.com/yzhao062/agent-style/tree/main/skills/style-review`.
- The skill writes polished drafts beside the source file only after user
  confirmation, using `FILE.reviewed.md`.
- A/B comparison mode reports deltas and does not write files.
