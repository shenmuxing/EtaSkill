# Skill Contract

A skill contract is the public promise made by the skill package.

## Contract Sources

- `SKILL.md` frontmatter `description`
- `SKILL.md` body
- `agents/openai.yaml`, when present
- README or catalog entries that summarize the skill

## Rules

- Promise only implemented behavior.
- Name external tools only when the skill explains how they are used.
- Mark unsupported features as manual, optional, or out of scope.
- Keep examples generic and reproducible.
- Update metadata when the skill body changes.

## Common Failure

A common publication blocker is a trigger description that claims automated generation, semantic review, or external integration while the skill only provides manual instructions. Fix this by narrowing the description or adding the missing implementation.
