# Installation

## Copy

- Source path: `skill-examples/proof-orchestrator/`
- Installed name: `proof-orchestrator`
- Destination: `$CODEX_HOME/skills/proof-orchestrator`, or
  `~/.codex/skills/proof-orchestrator` when `CODEX_HOME` is unset.

## Dependencies

- Companion skills: `proof-plan`, `call-gpt-pro`, and `deepseek-agent`.
- Optional companion skills: `proof-checker-v2` if the local environment
  already provides it.
- External CLIs: inherited from companion skills.
- Python packages: none.
- Codex apps/connectors: none.
- Credentials or accounts: an OpenRouter API key is required only for a real
  `call-gpt-pro` request; DeepSeek credentials are required only when running a
  DeepSeek audit.

## Install Steps

1. Copy this directory into the active Codex skills root.
2. Confirm the installed directory contains `SKILL.md`,
   `agents/openai.yaml`, and `references/dispatch-prompts.md`.
3. Install or verify the required companion skills.
4. Restart Codex so the skill registry can reload.

## Update Steps

1. Back up the existing installed directory.
2. Replace it with the current source directory, or run `skill-installer` with
   `--update` when installing from a GitHub source.
3. Run the verification steps below.
4. Keep the backup until a dry-run handoff reaches `READY_FOR_GPT_PRO` without
   trying to use legacy `proof-execution`.

## Verification

From the MetaSkill repository root, run:

```powershell
python .\scripts\validate_muxing_install.py --source-only --skill proof-orchestrator
```

After installing into the active skills root, run:

```powershell
python .\scripts\validate_muxing_install.py --installed-only --skill proof-orchestrator
```

Manual smoke test:

```text
Use $proof-orchestrator to prepare a GPT-pro handoff for this sample theorem:
prove uniqueness of fixed points for a contraction mapping.
Do not spend GPT-pro budget; only dry-run the handoff.
```

The run should use `proof-plan`, prepare or validate `handoff.md`, route real
calls through `call-gpt-pro`, and avoid any `proof-execution` dependency.

## Rollback

1. Remove the failed installed directory.
2. Restore the backup created during update.
3. Restart Codex.

## Notes

- Codex may complete simple local proof patches when they are explicitly
  labeled and directly checkable from the supplied materials.
- Hard or central proof obligations should go through the reviewed GPT-pro
  handoff, then receive Codex/DeepSeek audit before being treated as usable.
