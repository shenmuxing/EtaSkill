# Installation

## Copy

- Source path: `skill-examples/proof-finder/`
- Installed name: `proof-finder`
- Destination: `$CODEX_HOME/skills/proof-finder`, or
  `~/.codex/skills/proof-finder` when `CODEX_HOME` is unset.

## Dependencies

- Companion skills: `deepseek-agent` and `proof-material`.
- Downstream skills: `proof-cooker` and `proof-usage` are used after mining, not during normal proof-finder output.
- External CLIs: `deepseek`, `deepseek-tui`, and a shell capable of running the installed `deepseek-agent` wrapper.
- Python packages: none.
- Codex apps/connectors: none.
- Credentials or accounts: DeepSeek account and network access, checked with `deepseek doctor` only when appropriate.

## Install Steps

1. Copy this directory into the active Codex skills root.
2. Install or verify the companion `deepseek-agent` and `proof-material` skills.
3. Restart Codex so the skill registry can reload.

## Update Steps

1. Back up the existing installed directory.
2. Replace it with the current source directory.
3. Run the verification steps below.
4. Keep the backup until a harmless proof-finder prompt can load the skill instructions.

## Verification

From the MetaSkill repository root, run:

```powershell
python .\scripts\validate_muxing_install.py --source-only --skill proof-finder
```

After installing into the active skills root, run:

```powershell
python .\scripts\validate_muxing_install.py --installed-only --skill proof-finder
```

Run the DeepSeek account diagnostic only when appropriate:

```powershell
deepseek doctor
```

## Rollback

1. Remove the failed installed directory.
2. Restore the backup created during update.
3. Restart Codex.

## Notes

- Missing DeepSeek credentials or connectivity blocks full proof-finder operation.
- Proof-finder writes source-indexed material and updates the material index; it does not write final proof-usage categories directly.
- Scratch prompts, transcripts, extracted text, and backtest outputs are local run artifacts and should not be published with the skill.
