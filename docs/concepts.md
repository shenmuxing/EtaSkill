# Concepts

## Skill

A skill is a reusable instruction package for an AI agent. In this repository, a skill usually starts with `SKILL.md` and may include supporting resources such as scripts, references, assets, and agent metadata.

## Skill Contract

The skill contract is the behavior promised by the frontmatter `description`, the body of `SKILL.md`, and any user-facing metadata. The contract must stay truthful: if a skill only provides manual guidance, it should not claim automated execution.

## Public-Safe Skill

A public-safe skill can be committed to this repository without exposing private machine paths, account details, unpublished project names, local logs, or one-off private workflows.

## Lifecycle Workflow

The lifecycle workflow covers inventory, audit, normalization, validation, testing, publication review, and catalog updates.

## Publication Review

Publication review is the final pre-publication check. It combines deterministic checks with manual review for privacy, unsupported claims, and resource consistency.
