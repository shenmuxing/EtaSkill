# Installation

## Copy

- Source path: `skill-examples/markdown-pdf-feishu-sync/`
- Installed name: `markdown-pdf-feishu-sync`
- Destination: `$CODEX_HOME/skills/markdown-pdf-feishu-sync`, or
  `~/.codex/skills/markdown-pdf-feishu-sync` when `CODEX_HOME` is unset.

## Dependencies

- Companion skills: `lark-drive` and `lark-shared` for Feishu Drive upload and authentication rules.
- External CLIs: `lark-cli`; one Markdown-to-PDF converter chosen in the local rules file.
- Python packages: none beyond the standard library.
- Credentials or accounts: Feishu/Lark credentials are required only when uploading.

## Install Steps

1. Copy this directory into the active Codex skills root.
2. Confirm the installed directory contains `SKILL.md`, `agents/openai.yaml`, `scripts/`, and `references/`.
3. Restart Codex so the skill registry can reload.

## Update Steps

1. Back up the existing installed directory.
2. Replace it with the current source directory, or run `skill-installer` with
   `--update` when installing from a GitHub source.
3. Keep the private local rules file in place; do not overwrite it with public
   example data.
4. Run the verification steps below.

## Verification

From the MetaSkill repository root, run:

```powershell
uv run --with pyyaml python .\skill-examples\skill-creator\scripts\quick_validate.py .\skill-examples\markdown-pdf-feishu-sync
python .\skill-examples\markdown-pdf-feishu-sync\scripts\sync_markdown_pdfs.py --rules .\local\markdown-pdf-feishu-sync\rules.json --dry-run
```

The dry run should print a JSON summary and zero or more planned Markdown files. It should not create PDFs or upload files.

## Notes

- Keep private source directories, Feishu folder tokens, share targets, and generated PDFs under ignored local rules/output paths.
- The bundled script uploads PDFs as Drive files. It does not create Feishu online docx documents from Markdown.

## Rollback

1. Remove the failed installed directory.
2. Restore the backup created during update.
3. Restart Codex.
4. Re-run the dry-run command against the unchanged private local rules file.
