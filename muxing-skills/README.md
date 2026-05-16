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

## Promotion Checklist

Before adding a skill here:

1. Remove private examples and replace them with generic fixtures.
2. Verify that the frontmatter `description` states when the skill should trigger.
3. Check that every promised operation is implemented or clearly described as manual.
4. Run `publication-review/` and the validator used by `skill-management/` when available.
5. Add a short README only at the collection level, not inside individual skill folders.
