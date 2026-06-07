# ChatGPT Project Route

Use this route when the user has a logged-in ChatGPT web account with GPT
Pro-capable model access and ChatGPT Projects are available. Treat the project
as the remote long-lived reasoning container, not as a one-off paste target.

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
skeleton when the workspace has no existing convention.

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

## Remote Sync

Use the Chrome skill/plugin for visible browser work:

1. Open or claim the logged-in ChatGPT Web tab.
2. Open the target ChatGPT Project, or create it when not exist.
3. Confirm the visible account and Project state is usable without inspecting
   cookies, passwords, storage, or other private browser internals.
4. Compare the visible Project source list with `sources/manifest.md`.
5. Upload or replace only sources marked `needs-sync` and covered by the current
   authorization.
6. Update `sources/manifest.md` and `project-record.md` after visible sync is
   confirmed.

If the web UI does not expose enough source metadata to prove exact equality,
record the remote state as `unknown` or `blocked` rather than claiming `synced`.

## Prompt Turn

After sources are synchronized:

1. Select the intended Pro-capable model. If unavailable, stop and report the
   blocker instead of switching silently.
2. Open a new or appropriate existing conversation inside the ChatGPT Project.
3. Paste the exact contents of `PROMPT_FILE` into the composer.
4. Send the prompt under the current `call-gpt-pro` authorization.
5. Wait until the response is complete or visibly failed.
6. Save the full returned answer to `OUTPUT_FILE`.
7. Write `TRANSCRIPT_FILE` with safe metadata: timestamp, route
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
