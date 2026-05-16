# Review A Skill Before Publishing

Use `publication-review/` before moving a skill into a public collection or claiming that it is public-ready.

## 1. Inspect The Skill

Read:

- `SKILL.md`
- `agents/openai.yaml`, if present
- directly referenced files under `references/`, `scripts/`, and `assets/`

## 2. Run The Checker

```powershell
uv run python .\publication-review\scripts\review_skill.py .\muxing-skills\example-skill
```

## 3. Apply Manual Checks

The script cannot prove whether a claim is truthful. Manually check that the skill does not promise automation, semantic judgment, external integrations, or generated artifacts that are not implemented or clearly marked as manual.

## 4. Report Results

Use blockers first, warnings second, and reviewed files last.
