# Skill Lifecycle

Use this lifecycle when turning a local workflow into a reusable skill.

## 1. Inventory

Identify the skill directory, entrypoint, scripts, references, assets, and metadata. Record what is actually implemented before rewriting the public contract.

## 2. Normalize

Use a lowercase hyphenated folder name. Keep `SKILL.md` as the source of truth. Optional directories such as `references/`, `scripts/`, and `assets/` should exist only when the skill uses them.

## 3. Public-Safety Pass

Remove private paths, account identifiers, unpublished project details, raw operational logs, and examples that reveal private workflows. Replace them with generic fixtures.

## 4. Contract Audit

Compare the promised behavior against the included resources. Mark unsupported behavior as manual, optional, or out of scope instead of implying that it is implemented.

## 5. Validation

Run structure and privacy checks where available. For complex skills, also test at least one realistic prompt and record any limits that remain manual.

## 6. Promotion

Move mature skills into `skill-examples/` only after publication review. Update the catalog and any routing documentation that depends on the skill.
