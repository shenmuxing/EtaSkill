# Publication Checklist

Use this checklist before committing a skill to a public repository or moving it into `skill-examples/`.

## Identity and Privacy

- No private absolute paths.
- No emails, usernames, calendar details, tokens, keys, or service identifiers.
- No unpublished manuscript text, reviewer comments, private project names, or internal notes.
- No examples that reveal local directory layouts or personal workflows beyond the public skill contract.
- No copied logs, traces, prompts, or outputs from private runs unless fully anonymized and useful as a generic fixture.

## Skill Contract

- Folder name is lowercase hyphen-case and matches the frontmatter `name`.
- Frontmatter uses fields accepted by the system `skill-creator` validator: `name`, `description`, `license`, `allowed-tools`, or `metadata`.
- `description` explains what the skill does and concrete situations that should trigger it.
- `SKILL.md` body gives operational instructions, not marketing copy.
- Unsupported behavior is marked as omitted, manual, optional, or out of scope.
- External integrations and local tools are named only when the skill includes enough public instructions to use them.
- Reusable skill examples include `install.md` with copy, dependency, install,
  update, verification, rollback, and notes sections.

## Resources

- `references/` contains detailed guidance that Codex should load only when needed.
- `scripts/` contains deterministic helpers and each helper has been run at least once when practical.
- `assets/` contains templates or static files used by the skill output.
- `agents/openai.yaml`, when present, matches `SKILL.md` and avoids unsupported UI claims.
- No placeholder files remain from scaffolding.

## Validation

- Run the `publication-review` script when Python is available.
- Run the skill validator if available.
- Search for private strings before publication.
- Test at least one realistic prompt for complex skills.
- Re-read generated UI metadata, if present, and ensure it matches `SKILL.md`.
- Run the verification steps documented in `install.md` when practical.
