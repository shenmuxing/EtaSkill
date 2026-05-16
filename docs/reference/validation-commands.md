# Validation Commands

Run validation from the repository root.

## Build Documentation

```powershell
uv run --with sphinx --with sphinx-rtd-theme --with myst-parser sphinx-build -b html docs docs/_build/html
```

## Review A Skill

```powershell
uv run python .\publication-review\scripts\review_skill.py .\muxing-skills\example-skill
```

## Validate A Skill Structure

When the validator is available:

```powershell
uv run --with pyyaml python .\muxing-skills\skill-creator\scripts\quick_validate.py .\muxing-skills\example-skill
```

## Search For Private Paths

Use targeted searches before publication:

```powershell
rg -n "C:\\|D:\\|/Users/|/home/|token|api_key|email" .
```
