# install.md Protocol

`install.md` is the per-skill installation contract for MetaSkill skills. It
describes what an installing agent must do after copying a skill package and how
to update or verify the installed copy.

Keep this file public-safe. Do not include private machine paths, account names,
tokens, unpublished project details, raw logs, or local-only workarounds.

## When To Include It

Every skill in `skill-examples/` should include `install.md` unless the skill is
only a minimal fixture. Core repository skills may include it when they are meant
to be copied into an active Codex skills root.

## Required Sections

Use these headings in this order:

```markdown
# Installation

## Copy

## Dependencies

## Install Steps

## Update Steps

## Verification

## Rollback

## Notes
```

The sections have these responsibilities:

- `Copy`: source path, installed skill name, and destination root assumptions.
- `Dependencies`: companion skills, CLIs, Python packages, apps/connectors, and
  credentials that must be checked.
- `Install Steps`: deterministic steps after the package is copied.
- `Update Steps`: how to replace or refresh an existing installation.
- `Verification`: read-only or harmless smoke checks an agent can run before
  declaring the skill ready.
- `Rollback`: how to restore the previous installation after an update failure.
- `Notes`: public-safe limitations, manual checks, and environment assumptions.

## Template

```markdown
# Installation

## Copy

- Source path: `skill-examples/example-skill/`
- Installed name: `example-skill`
- Destination: `$CODEX_HOME/skills/example-skill`, or
  `~/.codex/skills/example-skill` when `CODEX_HOME` is unset.

## Dependencies

- Companion skills: none.
- External CLIs: none.
- Python packages: none.
- Codex apps/connectors: none.
- Credentials or accounts: none.

## Install Steps

1. Copy this directory into the active Codex skills root.
2. Confirm `SKILL.md` exists in the installed directory.
3. Restart Codex so the skill registry can reload.

## Update Steps

1. Back up the existing installed directory.
2. Replace it with the current source directory.
3. Run the verification steps below.
4. Keep the backup until the updated skill has loaded successfully.

## Verification

1. Run the MetaSkill source smoke check:

   ```powershell
   python .\scripts\validate_muxing_install.py --source-only --skill example-skill
   ```

2. If checking an installed copy, run:

   ```powershell
   python .\scripts\validate_muxing_install.py --installed-only --skill example-skill
   ```

## Rollback

1. Remove the failed installed directory.
2. Restore the backup created during update.
3. Restart Codex.

## Notes

- Manual connector or credential checks must be reported as warnings or
  blockers, not silently skipped.
```
