# Installation Checks

Skill installation has two phases: copying the skill package and validating that
the active agent can actually use it. The system `skill-installer` covers the
copy phase for GitHub-hosted skills; MetaSkill skills must document and validate
their own post-install readiness.

## Installing Agent Checklist

After copying a skill into the active skills root:

1. Resolve the installed skills root from `$CODEX_HOME/skills`, or use
   `~/.codex/skills` when `CODEX_HOME` is unset.
2. Confirm the installed directory name matches the `SKILL.md` frontmatter
   `name`.
3. Confirm referenced bundled files exist, especially `scripts/`, `references/`,
   and `assets/` files named by the workflow.
4. Confirm companion skills are also installed when the skill delegates to them.
5. Confirm external CLIs are available on `PATH`; run `--version` or a harmless
   smoke command when practical.
6. Confirm required Codex app connectors are installed and usable when the skill
   depends on authenticated browser, calendar, mail, drive, or GitHub access.
7. Run optional account or network diagnostics only when the skill asks for them
   and the environment is allowed to perform that check.
8. Report unresolved dependencies as blockers. Do not replace a missing
   dependency with a different workflow unless the skill explicitly allows that
   fallback.

## Muxing Skill Smoke Checker

Run from the repository root:

```powershell
python .\scripts\validate_muxing_install.py --source-only
python .\scripts\validate_muxing_install.py --installed-only --skill deepseek-agent
```

Useful options:

- `--skill <name>` checks one skill; repeat it for several skills.
- `--skills-root <path>` checks a non-default installed skills directory.
- `--skip-command-probes` checks whether commands exist without running
  `--version`.
- `--deepseek-doctor` runs `deepseek doctor` for `deepseek-agent`.
- `--strict` treats warnings as failures.

The checker is intentionally read-only. It reports missing commands such as
`deepseek`, `deepseek-tui`, `pwsh` or `powershell`, and `agent-style`; missing
companion skills; and manual connector checks such as Chrome availability.
