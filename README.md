# MetaSkill

MetaSkill is a public repository for managing, standardizing, testing, and publishing reusable AI-agent skills. It keeps lifecycle workflows, publication checks, and selected public-safe skills in one place.

The repository is intentionally public-safe. It should describe reusable workflows, not private machines, private projects, personal accounts, unpublished content, or one-off local context.

## Goals

- Provide reusable workflows for skill inventory, audit, validation, and publication.
- Keep skill contracts truthful: documented behavior must match implemented or clearly manual behavior.
- Make skill quality review repeatable through structure checks, privacy checks, and lightweight test prompts.
- Collect mature reusable skills only after they have been generalized and stripped of private information.

## Scope

MetaSkill currently targets Codex skills by default. Compatibility with other agents' skill formats is not planned at this stage.

## Layout

```text
MetaSkill/
  AGENTS.md
  README.md
  docs/
    skills.md
  skill-management/
  publication-review/
  muxing-skills/
```

## Documentation

- [docs/skills.md](docs/skills.md) summarizes the current skill catalog and routing rules.
- [muxing-skills/README.md](muxing-skills/README.md) explains the collection policy for reusable public skills.
- Each skill's `SKILL.md` is the source of truth for its triggers, workflow, scripts, and supporting resources.

Root files define collaboration norms and repository-level conventions. Detailed operating procedures should live inside the relevant skill directory.

## Public-Safety Policy

Do not commit:

- private absolute paths;
- account names, emails, tokens, API keys, calendar details, or service identifiers;
- unpublished manuscript content, private repository names, or private project notes;
- raw logs or traces from personal runs;
- examples that reveal local directory layouts or private workflows.

Use generic examples such as `example-skill`, `sample-project`, and `private-workspace` when a concrete fixture is needed.

## Basic Workflow

1. Draft or import a candidate skill.
2. Run a privacy pass and remove personal context.
3. Normalize the skill contract and directory shape.
4. Run publication review before claiming public readiness.
5. Validate frontmatter and metadata.
6. Test with at least one realistic prompt when the skill is complex.
7. Move mature public-safe skills into the appropriate public collection.

## Status

This repository is in its initial curation phase. The current priority is to keep the public contract, directory layout, and publication rules stable as reusable skills are imported.
