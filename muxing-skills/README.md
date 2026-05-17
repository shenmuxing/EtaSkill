# Muxing Skills

This directory stores reusable public skills and examples. Some were refined through Muxing workflows and then generalized; others are imported as public-safe reference examples.

Skills in this collection should be:

- useful beyond one private machine or one private project;
- stripped of personal paths, account names, unpublished content, and local-only assumptions;
- honest about what is implemented versus what remains manual;
- small enough for another agent to understand through `SKILL.md` and optional bundled resources.

## Layout

Each skill lives in its own lowercase hyphenated directory:

```text
muxing-skills/
  example-skill/
    SKILL.md
    agents/openai.yaml
    references/
    scripts/
    assets/
```

Only create optional directories when the skill actually uses them.

## Skill Catalog

For the current skill list and usage summary, see [../docs/skills.md](../docs/skills.md).

## Installation Checks

`skill-installer` copies skill directories into the active Codex skills root. It
does not run per-skill dependency installation, verify companion skills, or set
shell-specific environment variables. An installing agent should therefore run a
post-install check before declaring the skill ready.

Recommended agent flow:

1. Install only the requested skill package directories.
2. Resolve the installed skills root from `$CODEX_HOME/skills`, or fall back to
   `~/.codex/skills` when `CODEX_HOME` is unset.
3. Verify that every installed skill has `SKILL.md`, expected bundled resources,
   and no source-only placeholder files.
4. Verify companion skills and external tools named by the skill contract.
5. Report missing CLIs, unavailable app connectors, and manual credential checks
   as blockers or warnings instead of silently continuing.

Run the repository smoke checker from the repository root:

```powershell
python .\scripts\validate_muxing_install.py --installed-only --skill deepseek-agent
```

Use `--deepseek-doctor` only when it is acceptable to run the DeepSeek account
and network diagnostic in the active environment.

## Promotion Checklist

Before adding a skill here:

1. Remove private examples and replace them with generic fixtures.
2. Verify that the frontmatter `description` states when the skill should trigger.
3. Check that every promised operation is implemented or clearly described as manual.
4. Add any required companion skills, external CLIs, app connectors, and bundled
   scripts to the installation checks.
5. Run `publication-review/`, the validator used by `skill-management/`, and
   `scripts/validate_muxing_install.py --source-only --skill <skill-name>`.
6. Add a short README only at the collection level, not inside individual skill folders.
