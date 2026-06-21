# ChatGPT Project Route

Use this route when the user has a logged-in ChatGPT web account with GPT
Pro-capable model access and ChatGPT Projects are available. Treat the project
as the remote long-lived reasoning container, not as a one-off paste target.
Because this route relies on the user's real logged-in browser profile, use the
Chrome plugin/skill surface for all browser work. Do not use Playwright, the
in-app browser, or another fresh browser context as a substitute for Chrome.

The local workspace remains the source of truth. Codex maintains prompts,
source files, sync status, outputs, and safe transcript metadata under
`.agents/pro-manage/`; Chrome is used only to synchronize the visible ChatGPT
Project, paste the next prompt, capture the answer, and return control to the
workspace.

## Local Layout

Create or reuse this workspace-local layout:

```text
.agents/pro-manage/
  project-record.md
  sources/
    manifest.md
    mutable/
    permanent/
  prompts/
  outputs/
  transcripts/
```

Use `scripts/manage_pro_sources.ps1` to initialize the layout or create a prompt
skeleton when the workspace has no existing convention. If Chrome-side direct
file upload is unavailable or the Project is intentionally using one text
source, run the script with `-Action NewBundle` to create a local
`sources/*-source-bundle.txt` file before adding that text source to ChatGPT.

## Source Classes

Maintain two source classes. In this skill, the class changes only the file
name and manifest label; it does not change how the model should trust or use
the source:

- Mutable sources: changing drafts, current theorem statements, notes, active
  proof attempts, or other files that should be snapshotted with a time suffix
  such as `source-name-YYMMDDHH.md`.
- Permanent sources: stable definitions, accepted assumptions, bibliographic
  excerpts, or finalized statements. Keep stable names without a time suffix,
  such as `source-name.md`,`xxxpaper.pdf`.

Record every source in `sources/manifest.md` with local path, class, remote
status, and notes. Remote status should be one of `synced`, `needs-sync`,
`blocked`, or `unknown`.

## Project Record

Before opening Chrome, write or update `.agents/pro-manage/project-record.md`
using the shared field contract in `../SKILL.md`.

The prompt file is the next-turn instruction, not the full source package. It
may reference synchronized project sources by their manifest names.

Prompt hygiene rules:

- Keep route metadata out of the prompt. `PROJECT_NAME`, `MODEL`,
  `SOURCE_MANIFEST`, `OUTPUT_FILE`, `TRANSCRIPT_FILE`, and local filesystem
  paths belong in `project-record.md` or `TRANSCRIPT_FILE`, not in the pasted
  ChatGPT message.
- Do not describe local manifest entries as "attached files" unless those exact
  files are visibly attached as separate Project sources in ChatGPT.
- If several local sources are synchronized through one combined Project text
  source, name that visible bundle source and explain that it contains the
  listed local source snapshots; do not claim the snapshots are separate remote
  attachments.
- Before sending, inspect `PROMPT_FILE` for false attachment claims or local
  bookkeeping. Rewrite and save the prompt if any are present.

## Project Isolation

For stress tests, evaluations, or proof-orchestrator benchmark runs, use a fresh
ChatGPT Project for the run. Configure the Project so it does not share memory
with the user's general ChatGPT context when the UI exposes that setting. Then
add only the resources listed in the run manifest and ask the intended prompt.

Do not mix unrelated stress tests, benchmark prompts, or proof runs in the same
Project conversation. If a run needs a materially different source set or task,
create a new isolated Project and record its name, memory-isolation setting, and
source manifest in `.agents/pro-manage/project-record.md`.

## Remote Sync

Use the Chrome skill/plugin for visible browser work. If Chrome browser control
is not currently available, follow the Chrome skill's extension troubleshooting
flow and record the route as blocked until Chrome is connected.

If Chrome is not running, do not start it from Codex. Tell the user that Chrome
must be started first, then stop and wait for the user to report that Chrome is
running before continuing this route.

1. Open or claim the logged-in ChatGPT Web tab.
2. Open the target ChatGPT Project, or create it when not exist.
3. Confirm the visible account and Project state is usable without inspecting
   cookies, passwords, storage, or other private browser internals.
4. Compare the visible Project source list with `sources/manifest.md`.
5. Upload or replace only sources marked `needs-sync` and covered by the current
   authorization.
6. If the remote source is a combined text bundle, confirm the visible Project
   source name exactly matches the local `sources/*-source-bundle.txt` file,
   record `REMOTE_PROJECT_STATE: synced-via-bundle`, and record in the manifest
   notes that each included source was synced through that bundle.
7. Update `sources/manifest.md` and `project-record.md` after visible sync is
   confirmed.

If the web UI does not expose enough source metadata to prove exact equality,
record the remote state as `unknown` or `blocked` rather than claiming `synced`.

## Prompt Turn

After sources are synchronized:

1. Before opening or continuing the conversation, confirm the visible model
   picker is set to the strongest available GPT Pro reasoning tier covered by
   the current authorization, such as GPT Pro with advanced thinking when the
   UI exposes that option. If the tier is unavailable or cannot be confirmed,
   stop and report the blocker instead of sending under a weaker or default
   model silently.
2. Open a new or appropriate existing conversation inside the ChatGPT Project.
3. Re-check `PROMPT_FILE` against the prompt hygiene rules above.
4. Paste the exact contents of the checked `PROMPT_FILE` into the composer.
5. Send the prompt under the current `call-gpt-pro` authorization.
6. Wait until the response is complete or visibly failed.
7. Save the full returned answer to `OUTPUT_FILE`.
8. Do a formatting-only cleanup pass on `OUTPUT_FILE`: repair obvious web-copy
   artifacts such as broken inline/display math, split subscripts and
   superscripts, `argmax`/`argmin` layouts, Greek-symbol formulas, stray tabs,
   and zero-width characters into Obsidian-compatible Markdown math (`$...$` or
   `$$...$$`). Preserve the proof order, claims, constants, assumptions, and
   wording except for unmistakable typos; if a formula is ambiguous, flag it
   locally instead of guessing.
9. Write `TRANSCRIPT_FILE` with safe metadata: timestamp, route
   `chatgpt-web`, Project name, visible model label when available, prompt file,
   output file, source manifest, completion status, and any non-sensitive
   failure details.

After capture, Codex resumes as controller: audit the answer against the prompt
contract and synchronized sources, then integrate only verified parts into the
active project.

## Browser Safety

- Do not inspect Chrome cookies, local storage, saved passwords, account
  settings, or payment details.
- Do not upload files, paste private data, or send a changed source set unless
  the current authorization covers that exact data and destination.
- Stop for login prompts, account changes, CAPTCHA, permission prompts, payment
  gates, model entitlement failures, or source upload uncertainty.
- Keep browser-side operational details out of the skill directory. Store only
  safe route metadata in the active workspace.

## Failure Handling

- Login, entitlement, UI, upload, sync, or model-selection failures block the
  web route; they do not justify inventing a GPT Pro answer.
- If Project sources cannot be proven synchronized, either sync them visibly or
  treat the prompt as blocked.
- If the response is truncated, missing a requested completion marker, or
  ignores the prompt contract, save what was returned and treat the delegation
  as incomplete.
- If follow-up is needed, write a smaller prompt that references the already
  synchronized sources or records any new source to sync, then get fresh
  authorization before a second independent dispatch.
