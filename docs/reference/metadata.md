# Metadata

MetaSkill keeps metadata small and truthful.

## `SKILL.md` Frontmatter

Use only:

```yaml
---
name: example-skill
description: Use when the agent needs to run a generic reusable workflow.
---
```

The `name` should match the folder name. The `description` should state concrete trigger situations and implemented behavior.

## `agents/openai.yaml`

When present, `agents/openai.yaml` should match the skill body. It should not introduce capabilities that `SKILL.md` does not support.

## Catalog Entries

Catalog entries should summarize when to use a skill, where it lives, and any important limits. The catalog should not duplicate the full procedure.
