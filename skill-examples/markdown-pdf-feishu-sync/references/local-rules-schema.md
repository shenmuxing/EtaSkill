# Local Rules Schema

Store private rules in an ignored path such as:

```text
local/markdown-pdf-feishu-sync/rules.json
```

## Minimal Shape

```json
{
  "version": 1,
  "feishu": {
    "folder_url": "https://example.feishu.cn/drive/folder/folder_token_here",
    "folder_token": "folder_token_here",
    "identity": "bot"
  },
  "converter": {
    "command": ["npx", "--yes", "md-to-pdf", "{staged_input}", "--basedir", "{source_dir}"],
    "output_extension": ".pdf"
  },
  "output": {
    "pdf_root": "local/markdown-pdf-feishu-sync/out/pdf",
    "manifest": "local/markdown-pdf-feishu-sync/out/manifest.jsonl"
  },
  "defaults": {
    "recursive": true,
    "include_globs": ["**/*.md"],
    "exclude_globs": ["**/.git/**", "**/node_modules/**", "**/.obsidian/**"],
    "category": "uncategorized"
  },
  "categories": {
    "uncategorized": {
      "folder_token": "",
      "share_with": [],
      "status": "pending"
    }
  },
  "sources": [],
  "pending_decisions": []
}
```

## Fields

- `version`: Use `1`.
- `feishu.folder_url`: Human-facing target folder URL.
- `feishu.folder_token`: Drive folder token parsed from the URL.
- `feishu.identity`: `bot` or `user`; passed to `lark-cli --as`.
- `converter.command`: Argument list for the Markdown-to-PDF converter. Use placeholders:
  - `{input}`: absolute Markdown file path.
  - `{staged_input}`: temporary Markdown copy placed beside the intended PDF output.
  - `{output}`: absolute target PDF path.
  - `{output_dir}`: absolute output directory for that PDF.
  - `{source_dir}`: original Markdown file's parent directory.
  - `{stem}`: source file stem.
- `converter.output_extension`: Usually `.pdf`.
- `output.pdf_root`: Directory for generated PDFs. Relative paths resolve from the repository root.
- `output.manifest`: JSONL audit log path. Relative paths resolve from the repository root.
- `defaults`: Fallback discovery settings for sources.
- `categories.<name>.folder_token`: Feishu Drive folder token for that category. If empty, the script falls back to `feishu.folder_token`.
- `categories.<name>.share_with`: Private notes for intended collaborators. The script records these but does not modify permissions.
- `sources`: Explicit source directories to process.
- `pending_decisions`: Questions to resolve before the workflow is considered complete.

## Source Entry

```json
{
  "name": "sample-project",
  "path": "D:/private-workspace/sample-project",
  "category": "research-notes",
  "recursive": true,
  "include_globs": ["**/*.md"],
  "exclude_globs": ["**/.git/**", "**/node_modules/**"],
  "enabled": true
}
```

Rules:

- `name` should be stable and filesystem-friendly.
- `path` may be private because this file is ignored.
- `category` should match an entry under `categories`.
- `enabled: false` keeps a source documented without processing it.
- Avoid broad roots. Prefer exact project or notes directories.
