# MetaSkill

MetaSkill is a public repository for managing, standardizing, testing, and publishing reusable AI-agent skills. It keeps lifecycle workflows, publication checks, and selected public-safe skills in one place.

The repository is intentionally public-safe. It should describe reusable workflows, not private machines, private projects, personal accounts, unpublished content, or one-off local context.

## Documentation

The full documentation source lives in [docs/](docs/). It is built with Sphinx and the Read the Docs theme.

Start with:

- [Getting Started](docs/getting-started.md)
- [Skill Lifecycle](docs/skill-lifecycle.md)
- [Public-Safety Policy](docs/public-safety.md)
- [Skill Catalog](docs/skills.md)
- [install.md Protocol](docs/reference/install-md-protocol.md)
- [Publication Checklist](docs/reference/publication-checklist.md)

Build the documentation locally:

```powershell
uv run --with sphinx --with sphinx-rtd-theme --with myst-parser sphinx-build -b html docs docs/_build/html
```

## Repository Layout

```text
MetaSkill/
  docs/                 documentation site source
  skill-management/     lifecycle workflow for reusable skills
  publication-review/   publish-before-review workflow
  skill-examples/        reusable public skills and examples
```

## Scope

MetaSkill currently targets Codex skills by default. Compatibility with other agents' skill formats is not planned at this stage.

## Authorship and Scope

MetaSkill is authored and maintained by Muxing Shen. The repository is released as a public-safe, reusable workflow and skill-management project. It does not include private project materials, personal machine configuration, unpublished research drafts, or institutional confidential content.

## Status

This repository is in its initial curation phase. The current priority is to keep the public contract, directory layout, documentation, and publication rules stable as reusable skills are imported.

## Citation

If you use MetaSkill in public work, cite the project as:

```text
Shen, M. (2026). MetaSkill: Reusable AI-agent skill management workflows (v0.1.0) [Computer software]. GitHub. https://github.com/shenmuxing/MetaSkill
```

BibTeX:

```bibtex
@software{shen_metaskill_2026,
  author = {Shen, Muxing},
  title = {MetaSkill: Reusable AI-agent skill management workflows},
  year = {2026},
  version = {0.1.0},
  license = {MPL-2.0},
  url = {https://github.com/shenmuxing/MetaSkill}
}
```

A Zenodo DOI should be added here after the first archived GitHub release is published.
