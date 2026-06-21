# Installation

## Copy

- Source path: `skill-examples/call-gpt-pro/`
- Installed name: `call-gpt-pro`
- Destination: `$CODEX_HOME/skills/call-gpt-pro`, or
  `~/.codex/skills/call-gpt-pro` when `CODEX_HOME` is unset.

## Dependencies

- Companion skills: none.
- External CLIs: either `pwsh` or `powershell` for local source management and
  the OpenRouter fallback.
- Python packages: none.
- Codex apps/connectors: Chrome is required for the preferred ChatGPT web route;
  OpenRouter fallback requires none.
- Credentials or accounts: ChatGPT web account with GPT Pro access for the
  preferred ChatGPT Project route. OpenRouter fallback uses `OPENROUTER_API_KEY`; some OpenAI
  Pro models may also require provider-side BYOK configuration in OpenRouter.

## Install Steps

1. Copy this directory into the active Codex skills root.
2. Confirm the installed directory contains `SKILL.md`, the two route files
   under `references/`, the local source-management script, and the bundled
   OpenRouter PowerShell script:
   `scripts/manage_pro_sources.ps1` and
   `scripts/invoke_openrouter_gpt_pro.ps1`.
3. Confirm the ChatGPT web account has GPT Pro access when using the preferred
   route, and that ChatGPT Projects are available in the visible web UI.
4. Set `OPENROUTER_API_KEY` outside the repository and outside the skill
   package only when OpenRouter fallback is needed.
5. Restart Codex so the skill registry can reload.

## Environment Variables

No environment variables are required for the ChatGPT Project route.
OpenRouter fallback uses the variables below.

Run the PowerShell commands below in PowerShell, where the prompt usually starts
with `PS`. They will fail in `cmd.exe`, where the prompt looks like
`<user-profile>`.

For one temporary PowerShell session:

```powershell
$env:OPENROUTER_API_KEY = "sk-or-your-key-here"
```

For a persistent Windows user-level setting:

```powershell
[Environment]::SetEnvironmentVariable("OPENROUTER_API_KEY", "sk-or-your-key-here", "User")
```

After setting a persistent value, restart Codex and any terminals that need to
use the skill. Verify in a fresh PowerShell session:

```powershell
if ($env:OPENROUTER_API_KEY) { "OPENROUTER_API_KEY is set" } else { "OPENROUTER_API_KEY is missing" }
```

Optional model override:

```powershell
[Environment]::SetEnvironmentVariable("OPENROUTER_GPT_PRO_MODEL", "openai/gpt-5.5-pro", "User")
```

To remove a persistent value:

```powershell
[Environment]::SetEnvironmentVariable("OPENROUTER_API_KEY", $null, "User")
[Environment]::SetEnvironmentVariable("OPENROUTER_GPT_PRO_MODEL", $null, "User")
```

If only `cmd.exe` is available, use `setx` for a persistent user-level setting:

```bat
setx OPENROUTER_API_KEY "sk-or-your-key-here"
```

Open a new terminal after `setx`; it does not update the current `cmd.exe`
process.

Never write a real API key into tracked files, prompt files, transcripts, shell
history intended for sharing, or the skill package itself.

## Update Steps

1. Back up the existing installed directory.
2. Replace it with the current source directory, or run `skill-installer` with
   `--update` when installing from a GitHub source.
3. Run the verification steps below.
4. Keep the backup until a harmless dry run succeeds.

## Verification

From the MetaSkill repository root, run:

```powershell
python .\scripts\validate_muxing_install.py --source-only --skill call-gpt-pro
```

After installing into the active skills root, run:

```powershell
python .\scripts\validate_muxing_install.py --installed-only --skill call-gpt-pro
```

Run a no-cost wrapper dry run:

```powershell
$SkillsRoot = if ($env:CODEX_HOME) { Join-Path $env:CODEX_HOME 'skills' } else { Join-Path $HOME '.codex/skills' }
$GptProSkill = Join-Path $SkillsRoot 'call-gpt-pro'
& (Join-Path $GptProSkill 'scripts\invoke_openrouter_gpt_pro.ps1') -Prompt "Return OK only." -DryRun
```

Verify the local source manager without touching ChatGPT Web:

```powershell
& (Join-Path $GptProSkill 'scripts\manage_pro_sources.ps1') -Root .\.agents\pro-manage -Action Init
& (Join-Path $GptProSkill 'scripts\manage_pro_sources.ps1') `
  -Root .\.agents\pro-manage `
  -Action NewPrompt `
  -Task "Return OK only."
```

Verify the ChatGPT Project route by reading `references/chatgpt-web.md`,
confirming the Chrome skill/plugin is available to Codex, and checking that the
visible ChatGPT UI exposes Projects. Do not run a web sync or prompt-dispatch
smoke test unless the user has authorized creating/updating a Project and
sending the prompt to ChatGPT Web.

Run a real network call only when spending OpenRouter credits is acceptable:

```powershell
& (Join-Path $GptProSkill 'scripts\invoke_openrouter_gpt_pro.ps1') -Prompt "Return OK only."
```

## Rollback

1. Remove the failed installed directory.
2. Restore the backup created during update.
3. Restart Codex.

## Notes

- Missing credentials or provider access is a blocker for GPT Pro delegation,
  not a reason to invent an outside-model result.
- Keep prompts and outputs in the active workspace, not in the skill directory.
- The ChatGPT Project route is preferred: after the user authorizes
  `call-gpt-pro`, Codex maintains `.agents/pro-manage`, confirms Project source
  sync through Chrome, sends the next prompt, captures the answer, audits it,
  and then integrates verified parts.
