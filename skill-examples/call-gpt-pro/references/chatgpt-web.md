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
skeleton when the workspace has no existing convention. Text bundles are a
fallback or supplement, not a replacement for user-required direct files.
If Chrome-side direct file upload is unavailable for optional extracted notes or
for a Project intentionally using one text source, run the script with
`-Action NewBundle` to create a local `sources/*-source-bundle.txt` file before
adding that text source to ChatGPT.

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

## Required Direct Sources

When the user explicitly names source files, or the run manifest marks files as
source PDFs or other primary documents, treat those files as required direct
Project sources. Required direct sources must appear in ChatGPT as separate
visible Project files with their own filenames. Do not silently replace them
with extracted text, summaries, screenshots, or a combined text bundle.

For required direct sources:

- record them in `REQUIRED_DIRECT_SOURCES` and `sources/manifest.md`;
- set their remote status to `needs-sync` until the visible Project source list
  shows each required file separately;
- upload or replace each required file as its own Project source;
- record `synced-direct` or equivalent notes only after the filename is visible
  in the Project source list;
- if upload is blocked by browser permissions, file-access restrictions, size
  limits, UI errors, or uncertainty, mark the source and route as `blocked` and
  stop for user intervention or explicit approval of a fallback.

A combined text bundle may still be used for extracted notes, OCR snippets,
case briefs, or optional convenience context, but it cannot satisfy a required
direct source unless the user explicitly approves that fallback after seeing the
upload blocker.

## Project Source File Uploads

For PDF and other required direct Project files, use the Project `Sources`
surface, not the chat-composer attachment control:

This scoped Project-source chooser flow is the verified path after Chrome's
Codex extension has been granted local file access.

1. Open the target ChatGPT Project home page and switch to the `Sources` /
   `来源` tab. The URL should be the Project page, normally ending in
   `/project?tab=sources`, not an individual chat attachment flow.
2. Click `Add source` / `添加源`.
3. In the `Add source` dialog, use the dialog-scoped file control. Do not use a
   global `input[type="file"]` selector: ChatGPT pages can contain several file
   inputs for chat attachments, photos, camera, and Project sources. With the
   Chrome Playwright wrapper, the stable target observed for Project sources is
   equivalent to:

   ```js
   const chooserPromise = tab.playwright.waitForEvent("filechooser", { timeoutMs: 10000 });
   const chooseFile = tab.playwright
     .getByTestId("modal-project-add-source-dialog")
     .getByRole("button", { name: "Choose File" });
   if (await chooseFile.count() !== 1) throw new Error("Project source file control not unique");
   await chooseFile.click({});
   const chooser = await chooserPromise;
   if (!(await chooser.isMultiple())) {
     // Pass one file for single-file controls.
   }
   await chooser.setFiles(["C:/example-sources/source.pdf"]);
   ```

4. Use absolute local paths. For multiple files, first confirm
   `chooser.isMultiple()` is true.
5. Wait for the upload to finish, close the add-source dialog if needed, and
   confirm the exact filename is visible in the Project source list before
   marking the source `synced`.

If `chooser.setFiles(...)` fails, hangs, or reports `Not allowed` / file access
restrictions, treat the direct upload route as blocked until the Chrome Codex
extension has local file access. The user must enable Chrome extension file
access in `chrome://extensions` -> Codex extension `Details` -> `Allow access
to file URLs`, then Codex can retry the scoped Project-source upload flow. Do
not replace a required PDF with `Text input` unless the user explicitly approves
that fallback after the blocker is reported.

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
ChatGPT Project for the run. Add only the resources listed in the run manifest
and ask the intended prompt.

Do not mix unrelated stress tests, benchmark prompts, or proof runs in the same
Project conversation. If a run needs a materially different source set or task,
create a new isolated Project and record its name and source manifest in
`.agents/pro-manage/project-record.md`.

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
6. For every required direct source, confirm that the separate filename is
   visible in the Project source list. If any required direct source cannot be
   confirmed, mark the route `blocked` and do not send the prompt.
7. If the remote source is a combined text bundle, confirm the visible Project
   source name exactly matches the local `sources/*-source-bundle.txt` file,
   record `REMOTE_PROJECT_STATE: synced-via-bundle`, and record in the manifest
   notes that each included source was synced through that bundle.
8. Update `sources/manifest.md` and `project-record.md` after visible sync is
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
2. Open the correct conversation surface inside the ChatGPT Project:
   - For proof-orchestrator runs, stress tests, benchmark runs, and project
     continuations, always open a new chat/conversation inside the selected
     Project for the new prompt, even when reusing the same Project and source
     set.
   - Use an existing Project conversation only for an explicitly authorized
     follow-up to the same GPT-pro answer, or to retrieve/verify prior output.
   - Record the choice in `CONVERSATION_MODE` and the transcript metadata.
3. Re-check `PROMPT_FILE` against the prompt hygiene rules above.
4. Paste the exact contents of the checked `PROMPT_FILE` into the composer.
5. Send the prompt under the current `call-gpt-pro` authorization.
6. Wait under the response waiting protocol below until the response is
   complete or visibly failed.
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

## Response Waiting Protocol

Default to patient polling for GPT Pro web answers. After sending a prompt,
mark the run as waiting in the workspace record when useful, then sleep for 15
minutes before each status check. Do not use a short browser wait timeout, an
unchanged body-text tail, or a partial visible paragraph as evidence that GPT
Pro has finished.

At each 15-minute check, inspect the actual conversation controls and the last
assistant message, not just `document.body.innerText`. Treat the answer as
still in progress when any of the following are visible:

- `Pro thinking`, `Pro 思考中`, `Thinking`, or similar active reasoning text.
- A `Stop generating` / `停止生成` control, progress spinner, streaming cursor,
  disabled composer due to generation, or any continue-generating control.
- A network retry, reconnecting, or generation-failed banner that has not been
  resolved.

Only treat the web answer as complete when all of these hold:

- no active thinking/generation/failure controls are visible;
- the composer is available for a new user turn, or normal completed-message
  actions such as copy/regenerate are visible for the last assistant turn;
- the last assistant message has been extracted from an assistant-message node
  and remains stable across two consecutive checks separated by 15 minutes, or
  it contains the requested explicit output end marker;
- there is no visible `Continue generating` control.

If the browser-control tool call times out while the page is still thinking,
reconnect to the same Chrome tab and continue the 15-minute polling loop. A tool
timeout, interrupted Codex turn, or stale tab handle is not a GPT Pro failure
and is not evidence of a short or incomplete answer.

Do not judge whether the answer is mathematically good, incomplete, or prompt
non-compliant until the completion criteria above are met. If completion is
confirmed but the answer violates the prompt contract, save the returned text as
an incomplete or non-compliant output artifact and ask for authorization before
sending a follow-up or redo prompt.

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
