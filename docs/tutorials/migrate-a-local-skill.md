# Migrate A Local Skill

This tutorial converts a private local skill into a public-safe candidate.

## 1. Copy Only The Skill Package

Start from the minimum files needed to understand and run the workflow. Avoid copying logs, private prompts, generated outputs, or unrelated scratch files.

## 2. Remove Private Context

Search for private paths, accounts, project names, and one-off workflow details. Replace examples with generic fixtures.

## 3. Rewrite The Contract

Keep only reusable behavior. If the local version depends on a private tool, describe that dependency generically or mark it out of scope.

## 4. Validate And Review

Use `skill-management/` for structure and lifecycle cleanup, then `publication-review/` for final public-readiness review.
