# Repository Layout

```text
MetaSkill/
  AGENTS.md
  README.md
  .readthedocs.yaml
  docs/
  skill-management/
  publication-review/
  skill-examples/
```

## Root Files

- `README.md` introduces the project and points to the full documentation.
- `AGENTS.md` contains repository-level collaboration rules.
- `.readthedocs.yaml` configures hosted documentation builds.

## Skill Directories

- `skill-management/` owns lifecycle workflows.
- `publication-review/` owns publish-before-review checks.
- `skill-examples/` stores mature reusable skills and public-safe examples.
- Reusable skill directories normally contain `SKILL.md` and `install.md`, plus
  only the optional `agents/`, `references/`, `scripts/`, and `assets/`
  directories they actually use.

## Documentation Source

The documentation site source lives under `docs/`. Generated files under `docs/_build/` should not be committed.
