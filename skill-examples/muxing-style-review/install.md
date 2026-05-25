# Installation

## Copy

- Source path: `skill-examples/muxing-style-review/`
- Installed name: `muxing-style-review`
- Destination: `$CODEX_HOME/skills/muxing-style-review`, or
  `~/.codex/skills/muxing-style-review` when `CODEX_HOME` is unset.

## Dependencies

- Companion skills: `style-review` for the upstream post-hoc audit/polish
  workflow.
- External CLIs: `agent-style` is required for complete checks that include
  automatic detector evidence.
- Fallback: if `agent-style` is unavailable, the skill can still run the
  manual/model half with `references/check-human.md`, but the report must state
  that automatic detector evidence is missing.
- Python packages: none for the skill itself.
- Codex apps/connectors: none.
- Credentials or accounts: none.

## Attribution

This skill adapts ideas and bundled rule material from *The Elements of Agent
Style* by Yuxuan Zhao, CC BY 4.0. The bundled rule files are derived from:

- `references/RULES.md`: `https://github.com/yzhao062/agent-style/blob/main/RULES.md`
- `references/check-compact.md`: `https://github.com/yzhao062/agent-style/blob/main/agents/codex.md`

## Install Steps

1. Copy this directory into the active Codex skills root.
2. Confirm `SKILL.md`, `references/RULES.md`, `references/check-human.md`, and
   `references/check-compact.md` exist in the installed directory.
3. Restart Codex so the skill registry can reload.

## Update Steps

1. Back up the existing installed directory.
2. Replace it with the current source directory, or run `skill-installer` with
   `--update` when installing from a GitHub source.
3. Run the verification steps below.

## Verification

From the MetaSkill repository root, run:

```powershell
uv run python .\scripts\validate_muxing_install.py --source-only --skill muxing-style-review
```

After installing into the active skills root, run:

```powershell
uv run python .\scripts\validate_muxing_install.py --installed-only --skill muxing-style-review
```

Run a harmless CLI check for complete-check support:

```powershell
agent-style --version
```

## Rollback

1. Remove the failed installed directory.
2. Restore the backup created during update.
3. Restart Codex.

## Notes

- Use the sibling `skill-examples/style-review/` package when users ask for the
  upstream `style-review` audit/polish workflow.
- Complete checks combine `agent-style review --audit-only FILE` with
  `references/check-human.md`.
- Compact checks load `references/check-compact.md` when explicitly requested.
