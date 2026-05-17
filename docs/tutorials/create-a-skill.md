# Create A Skill

This tutorial creates a minimal reusable skill package.

## 1. Choose A Public Name

Use lowercase hyphen-case:

```text
example-skill/
```

## 2. Add The Entrypoint

Create `SKILL.md` with frontmatter accepted by the system `skill-creator` validator. `name` and `description` are required; `metadata`, `license`, and `allowed-tools` are optional when they are actually needed.

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

## 4. Add install.md

For reusable skills, add `install.md` with copy, dependency, install, update,
verification, rollback, and notes sections. Use the template in
`docs/reference/install-md-protocol.md`.

## 5. Validate Before Promotion

Run structure checks and publication review before adding the skill to the catalog.
