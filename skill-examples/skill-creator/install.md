# Installation

## Copy

- Source path: `skill-examples/skill-creator/`
- Installed name: `skill-creator`
- Destination: `$CODEX_HOME/skills/skill-creator`, or
  `~/.codex/skills/skill-creator` when `CODEX_HOME` is unset.

## Dependencies

- Companion skills: none.
- External CLIs: none.
- Python packages: `pyyaml` for `scripts/quick_validate.py` and
  `scripts/generate_openai_yaml.py`.
- Codex apps/connectors: none.
- Credentials or accounts: none.

## Install Steps

1. Copy this directory into the active Codex skills root.
2. Confirm the installed directory contains `SKILL.md`, `references/openai_yaml.md`,
   and the bundled scripts under `scripts/`.
3. Use `uv run --with pyyaml python ...` or another environment with `pyyaml`
   when running the validator scripts.
4. Restart Codex so the skill registry can reload.

## Update Steps

1. Back up the existing installed directory.
2. Replace it with the current source directory, or run `skill-installer` with
   `--update` when installing from a GitHub source.
3. Run the verification steps below.

## Verification

From the MetaSkill repository root, run:

```powershell
python .\scripts\validate_muxing_install.py --source-only --skill skill-creator
```

Then run the skill's own validator:

```powershell
uv run --with pyyaml python .\skill-examples\skill-creator\scripts\quick_validate.py .\skill-examples\skill-creator
```

After installing into the active skills root, run:

```powershell
python .\scripts\validate_muxing_install.py --installed-only --skill skill-creator
```

## Rollback

1. Remove the failed installed directory.
2. Restore the backup created during update.
3. Restart Codex.

## Notes

- Do not commit generated private examples, local paths, or placeholder
  scaffolding created while testing this skill.

