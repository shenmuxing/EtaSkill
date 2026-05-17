# Prepare A Muxing Skill For Public Release

`muxing-skills/` contains reusable public skills and examples. A skill belongs there only after it has been generalized beyond a private workflow.

## Checklist

1. The skill name is lowercase hyphen-case.
2. `SKILL.md` frontmatter contains only `name` and `description`.
3. The description states when to use the skill.
4. Examples use generic fixtures.
5. Included resources are referenced by the workflow.
6. Unsupported behavior is marked as manual, optional, or out of scope.
7. Companion skills, external CLIs, app connectors, and bundled scripts are
   named clearly enough for an installing agent to verify them.
8. Installed path examples use `$CODEX_HOME` with a `~/.codex/skills` fallback.
9. Publication review has no blockers.
10. The source package passes:

```powershell
python .\scripts\validate_muxing_install.py --source-only --skill <skill-name>
```

## Catalog Update

After promotion, add a short entry to [Skill Catalog](../skills.md). Keep the catalog concise and link detailed behavior back to each skill's `SKILL.md`.
