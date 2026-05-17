# Installation Checks

Skill installation has two phases: copying the skill package and validating that
the active agent can actually use it. `install.md` is the per-skill contract for
dependencies, update steps, verification, and rollback. The installer can copy
the package and surface this file, but the installing agent must complete the
documented checks before declaring the skill ready.

## Installing Agent Checklist

After copying a skill into the active skills root:

1. Resolve the installed skills root from `$CODEX_HOME/skills`, or use
   `~/.codex/skills` when `CODEX_HOME` is unset.
2. Confirm the installed directory name matches the `SKILL.md` frontmatter
   `name`.
3. Read `install.md` when present and follow its verification section.
4. Confirm referenced bundled files exist, especially `scripts/`, `references/`,
   and `assets/` files named by the workflow.
5. Confirm companion skills are also installed when the skill delegates to them.
6. Confirm external CLIs are available on `PATH`; run `--version` or a harmless
   smoke command when practical.
7. Confirm required Codex app connectors are installed and usable when the skill
   depends on authenticated browser, calendar, mail, drive, or GitHub access.
8. Run optional account or network diagnostics only when the skill asks for them
   and the environment is allowed to perform that check.
9. Report unresolved dependencies as blockers. Do not replace a missing
   dependency with a different workflow unless the skill explicitly allows that
   fallback.

## Skill Example Smoke Checker

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
