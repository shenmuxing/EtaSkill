# Installation

## Copy

- Source path: `skill-examples/proof-checker-v2/`
- Installed name: `proof-checker-v2`
- Destination: `$CODEX_HOME/skills/proof-checker-v2`, or
  `~/.codex/skills/proof-checker-v2` when `CODEX_HOME` is unset.

## Dependencies

- Companion skills: `deepseek-agent` for fallback reviewer dispatch.
- Optional runtime capability: a configured DeepSeek MCP bridge such as `llm-chat`.
- External CLIs: inherited from `deepseek-agent` when using the fallback route.
- Python packages: none.
- Codex apps/connectors: none.
- Credentials or accounts: DeepSeek credentials are required only when running a real external audit.

## Install Steps

1. Copy this directory into the active Codex skills root.
2. Confirm the installed directory contains `SKILL.md`,
   `agents/openai.yaml`, `references/deepseek-routing.md`,
   `references/audit-rubric.md`, and `references/output-contract.md`.
3. Install or verify `deepseek-agent` if the environment does not provide a
   direct DeepSeek MCP bridge.
4. Restart Codex so the skill registry can reload.

## Update Steps

1. Back up the existing installed directory.
2. Replace it with the current source directory, or run `skill-installer` with
   `--update` when installing from a GitHub source.
3. Run the verification steps below.
4. Keep the backup until a dry-run audit can load the routing, rubric, and
   output contract without missing-file errors.

## Verification

From the MetaSkill repository root, run:

```powershell
python .\scripts\validate_muxing_install.py --source-only --skill proof-checker-v2
```

After installing into the active skills root, run:

```powershell
python .\scripts\validate_muxing_install.py --installed-only --skill proof-checker-v2
```

Manual smoke test:

```text
Use $proof-checker-v2 to audit this proof. Do not call DeepSeek; only verify
that the target boundary, obligation ledger, and output contract are understood.
```

Run a real DeepSeek audit only when credentials are configured and the user has
approved the external reviewer call.

## Rollback

1. Remove the failed installed directory.
2. Restore the backup created during update.
3. Restart Codex.

## Notes

- This skill audits an existing proof; it is not the main proof-generation engine.
- `proof-orchestrator` may call this skill as its preferred structured audit driver when it is installed.
- Missing DeepSeek connectivity is a blocker for external review, not a reason to silently convert the audit into an optimistic local proof.
