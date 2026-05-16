# Repository Layout

```text
MetaSkill/
  AGENTS.md
  README.md
  .readthedocs.yaml
  docs/
  skill-management/
  publication-review/
  muxing-skills/
```

## Root Files

- `README.md` introduces the project and points to the full documentation.
- `AGENTS.md` contains repository-level collaboration rules.
- `.readthedocs.yaml` configures hosted documentation builds.

## Skill Directories

- `skill-management/` owns lifecycle workflows.
- `publication-review/` owns publish-before-review checks.
- `muxing-skills/` stores mature reusable skills and public-safe examples.

## Documentation Source

The documentation site source lives under `docs/`. Generated files under `docs/_build/` should not be committed.
