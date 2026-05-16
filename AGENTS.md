# MetaSkill Collaboration Guide

MetaSkill is a public repository for reusable skill management workflows and selected Muxing-tuned skills. Treat this repository as publishable by default: keep private machine paths, personal notes, account names, unpublished project details, and one-off local workarounds out of tracked files.

## Skill Routing

- `skill-management/` is the first-class skill for managing skills. It owns inventory, audit, standardization, testing, and publication-readiness workflows.
- `publication-review/` owns publish-before-review checks for privacy, structure, and truthful skill contracts. Use it before moving or publishing any skill.
- `muxing-skills/` contains reusable public skills and examples, including Muxing-refined skills once generalized.
- Root documentation explains routing only. Detailed procedural rules belong in the relevant skill's `SKILL.md`, `references/`, or `scripts/`.

## Repository Boundaries

- Keep tracked files public-safe and reproducible.
- Use generic fixtures such as `example-skill`, `sample-project`, or `private-workspace`.
- Keep examples, metadata, and validation outputs free of private paths, accounts, unpublished projects, personal notes, and operational logs.

## Editing Style

- Prefer concise English for public-facing files.
- Keep examples generic and reproducible.
- Use lowercase hyphenated directory names for skills.
- Keep unrelated cleanup out of focused edits.
- Preserve existing user changes unless explicitly asked to replace them.
