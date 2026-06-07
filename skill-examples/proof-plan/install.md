# Installation

## Copy

- Source path: `skill-examples/proof-plan/`
- Installed name: `proof-plan`
- Destination: `$CODEX_HOME/skills/proof-plan`, or
  `~/.codex/skills/proof-plan` when `CODEX_HOME` is unset.

## Dependencies

- Companion skills: none required.
- External CLIs: none.
- Python packages: none.
- Codex apps/connectors: none.
- Credentials or accounts: none.

## Install Steps

1. Copy this directory into the active Codex skills root.
2. Confirm the installed directory contains `SKILL.md` and
   `agents/openai.yaml`.
3. Restart Codex so the skill registry can reload.

## Update Steps

1. Back up the existing installed directory.
2. Replace it with the current source directory, or run `skill-installer` with
   `--update` when installing from a GitHub source.
3. Run the verification steps below.
4. Keep the backup until a harmless planning run creates the expected prompt
   bundle shape.

## Verification

From the MetaSkill repository root, run:

```powershell
python .\scripts\validate_muxing_install.py --source-only --skill proof-plan
```

After installing into the active skills root, run:

```powershell
python .\scripts\validate_muxing_install.py --installed-only --skill proof-plan
```

Manual smoke test:

```text
Use $proof-plan to standardize this sample proof idea into a prompt bundle:
prove that a contraction mapping on a complete metric space has at most one fixed point.
```

The run should produce a `prompts/<YYMMDDHH-num>/` bundle with `task.md` and
`materials.md`, and should label any local proof sanity check separately from
the GPT-pro-facing task.

## Rollback

1. Remove the failed installed directory.
2. Restore the backup created during update.
3. Restart Codex.

## Notes

- This skill prepares proof prompts and materials; it does not require GPT-pro
  credentials by itself.
- Use `proof-orchestrator` plus `call-gpt-pro` when the workflow should package
  or send an approved GPT-pro handoff.
