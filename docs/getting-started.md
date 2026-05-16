# Getting Started

MetaSkill is organized around skill lifecycle work. A typical task starts with a local or draft skill and ends with a public-safe, documented, testable skill package.

## Repository Map

```text
MetaSkill/
  skill-management/       lifecycle workflow for inventory, cleanup, validation, and migration
  publication-review/     publish-before-review workflow for privacy and truthful contracts
  muxing-skills/          reusable public skills and examples
  docs/                   documentation site source
```

## First Workflow

1. Put a candidate skill in a generic working location.
2. Use `skill-management/` to inspect the contract, normalize the folder, and identify missing resources.
3. Replace private examples with generic fixtures such as `example-skill`, `sample-project`, or `private-workspace`.
4. Use `publication-review/` before claiming the skill is public-ready.
5. Update the [Skill Catalog](skills.md) when a mature reusable skill is added.

## Local Documentation Build

Install the docs dependencies and build the site:

```powershell
uv run --with sphinx --with sphinx-rtd-theme --with myst-parser sphinx-build -b html docs docs/_build/html
```

Open `docs/_build/html/index.html` after the build completes.
