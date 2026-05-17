# Publication Checklist

Use this condensed checklist before publishing or promoting a skill.

## Privacy

- No private absolute paths.
- No account names, emails, tokens, keys, service identifiers, or calendar details.
- No unpublished project names, manuscript text, private notes, or reviewer comments.
- No raw logs, traces, prompts, or outputs from private runs.

## Contract

- Folder name is lowercase hyphen-case.
- `SKILL.md` frontmatter contains only `name` and `description`.
- The description states concrete trigger situations.
- The body gives operational instructions.
- Unsupported behavior is marked as manual, optional, or out of scope.

## Resources

- `references/` files are used by the workflow.
- `scripts/` helpers have been run when practical.
- `assets/` files support actual output.
- `agents/openai.yaml` matches `SKILL.md`.
- No scaffold placeholders remain.

## Installation Readiness

- Companion skills are named and checked.
- External CLIs are named and have a harmless smoke check when practical.
- Codex app connector dependencies are marked as manual checks.
- Installed path examples work with `$CODEX_HOME` and with the default
  `~/.codex/skills` fallback.
- `scripts/validate_muxing_install.py --source-only --skill <skill-name>` passes
  or any warnings are documented.

For the fuller source checklist, see `publication-review/references/publication-checklist.md`.
