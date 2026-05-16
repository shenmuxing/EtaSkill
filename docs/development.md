# Development Guide

Use focused edits and keep repository documentation public-facing.

## Documentation Changes

- Keep `README.md` short.
- Put user-facing guides under `docs/`.
- Put detailed skill procedures in the relevant skill directory.
- Avoid duplicating procedure text across root docs and skill files.

## Skill Changes

- Preserve existing behavior unless the task explicitly changes the contract.
- Update metadata when trigger behavior changes.
- Run publication review before promoting a skill.

## Generated Files

Do not commit `docs/_build/` or local validation output unless the file is an intentional fixture.
