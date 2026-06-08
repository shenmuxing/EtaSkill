# Installation

## Copy

- Source path: `skill-examples/deepseek-agent/`
- Installed name: `deepseek-agent`
- Destination: `$CODEX_HOME/skills/deepseek-agent`, or
  `~/.codex/skills/deepseek-agent` when `CODEX_HOME` is unset.

## Dependencies

- Companion skills: none.
- External CLIs: `opencode`, and either `pwsh` or `powershell`.
- Python packages: none.
- Codex apps/connectors: none.
- Credentials or accounts: DeepSeek API access configured for OpenCode. The bundled setup helper accepts the key at runtime and verifies a non-interactive OpenCode run.

## Install Steps

1. Copy this directory into the active Codex skills root.
2. Confirm the installed directory contains `SKILL.md`,
   `scripts/invoke_deepseek.ps1`, and
   `scripts/setup_opencode_deepseek.ps1`, and
   `scripts/set_deepseek_env.cmd`.
3. Install or verify OpenCode on `PATH`. On Windows, OpenCode documents
   Chocolatey, Scoop, NPM, Mise, Docker, and direct binary release options. A
   common user-level route is:

   ```powershell
   npm install -g opencode-ai
   opencode --version
   ```

4. Configure DeepSeek credentials for OpenCode, or keep the key ready for the verification helper.
5. Restart Codex so the skill registry can reload.

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

Run the DeepSeek/OpenCode credential check only when appropriate. Set the API key yourself in your shell or user environment instead of passing it as a command argument.

From Command Prompt, use the bundled helper:

```bat
%CODEX_HOME%\skills\deepseek-agent\scripts\set_deepseek_env.cmd
```

If `CODEX_HOME` is unset, use:

```bat
%USERPROFILE%\.codex\skills\deepseek-agent\scripts\set_deepseek_env.cmd
```

Open a new terminal after setting the persistent user variable, then run:

```powershell
$SkillsRoot = if ($env:CODEX_HOME) { Join-Path $env:CODEX_HOME 'skills' } else { Join-Path $HOME '.codex/skills' }
& (Join-Path $SkillsRoot 'deepseek-agent\scripts\setup_opencode_deepseek.ps1') `
  -Model 'deepseek/deepseek-chat'
```

Alternatively, set the persistent user environment variable yourself in PowerShell:

```powershell
[Environment]::SetEnvironmentVariable('DEEPSEEK_API_KEY', '<set-this-yourself>', 'User')
```

Open a new terminal after setting a persistent user variable, then run:

```powershell
$SkillsRoot = if ($env:CODEX_HOME) { Join-Path $env:CODEX_HOME 'skills' } else { Join-Path $HOME '.codex/skills' }
& (Join-Path $SkillsRoot 'deepseek-agent\scripts\setup_opencode_deepseek.ps1') `
  -Model 'deepseek/deepseek-chat'
```

## Rollback

1. Remove the failed installed directory.
2. Restore the backup created during update.
3. Restart Codex.

## Notes

- Missing DeepSeek credentials or connectivity is a blocker for DeepSeek
  delegation, not a reason to replace the workflow with Codex-authored prose.
- `deepseek-agent` remains the skill name because the delegated backend is
  DeepSeek. The local execution layer is OpenCode.
- The bundled PowerShell wrapper is part of the installed package and should be
  resolved from the active skills root.
- Keep verification outputs under an untracked scratch area such as
  `.agents/tmp/`.
