# Create A Skill

This tutorial creates a minimal reusable skill package.

## 1. Choose A Public Name

Use lowercase hyphen-case:

```text
example-skill/
```

## 2. Add The Entrypoint

Create `SKILL.md` with frontmatter containing only `name` and `description`.

```markdown
---
name: example-skill
description: Use when the agent needs to demonstrate a generic reusable workflow.
---

# Example Skill

## Workflow

1. Inspect the input.
2. Apply the reusable procedure.
3. Report what changed and what remains manual.
```

## 3. Add Resources Only When Needed

Use `references/`, `scripts/`, and `assets/` only when they support the documented workflow.

## 4. Validate Before Promotion

Run structure checks and publication review before adding the skill to the catalog.
