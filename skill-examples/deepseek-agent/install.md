# Installation

## Copy

- Source path: `skill-examples/deepseek-agent/`
- Installed name: `deepseek-agent`
- Destination: `$CODEX_HOME/skills/deepseek-agent`, or
  `~/.codex/skills/deepseek-agent` when `CODEX_HOME` is unset.

## Dependencies

- Companion skills: none.
- External CLIs: `deepseek`, `deepseek-tui`, and either `pwsh` or `powershell`.
- Python packages: none.
- Codex apps/connectors: none.
- Credentials or accounts: DeepSeek account and network access, checked with
  `deepseek doctor` only when that diagnostic is allowed.

## Install Steps

1. Copy this directory into the active Codex skills root.
2. Confirm the installed directory contains `SKILL.md` and
   `scripts/invoke_deepseek.ps1`.
3. Confirm the required CLIs are available on `PATH`.
4. Restart Codex so the skill registry can reload.

## Update Steps

1. Back up the existing installed directory.
2. Replace it with the current source directory, or run `skill-installer` with
   `--update` when installing from a GitHub source.
3. Run the verification steps below.
4. Keep the backup until a harmless wrapper or CLI check succeeds.

## Verification

From the MetaSkill repository root, run:

```powershell
python .\scripts\validate_muxing_install.py --source-only --skill deepseek-agent
```

After installing into the active skills root, run:

```powershell
python .\scripts\validate_muxing_install.py --installed-only --skill deepseek-agent
```

Run the account and network diagnostic only when appropriate:

```powershell
python .\scripts\validate_muxing_install.py --installed-only --skill deepseek-agent --deepseek-doctor
```

## Rollback

1. Remove the failed installed directory.
2. Restore the backup created during update.
3. Restart Codex.

## Notes

- Missing DeepSeek credentials or connectivity is a blocker for DeepSeek
  delegation, not a reason to replace the workflow with Codex-authored prose.
- The bundled PowerShell wrapper is part of the installed package and should be
  resolved from the active skills root.

