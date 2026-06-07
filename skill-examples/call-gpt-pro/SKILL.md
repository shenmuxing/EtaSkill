---
name: call-gpt-pro
description: "Use after the user has authorized GPT Pro help; manage a prompt-plus-sources workspace, route through ChatGPT Projects when available, and audit returned reasoning."
---

# Call GPT Pro

Use this skill to delegate expensive proof or reasoning work to a GPT
Pro-capable model while keeping Codex as controller. The default workflow is a
managed prompt-plus-sources workspace: maintain source files locally under
`.agents/pro-manage`, keep them synchronized with a ChatGPT Project when the web
route is available, paste a focused prompt for each turn, audit the answer, and
integrate only verified parts.

This skill is a route map. Detailed source-management and dispatch mechanics
live in sibling reference files and should be loaded only for the route being
used.

## Route Selection

Default to the ChatGPT web project route when the user has GPT Pro web access.
Use the scripted OpenRouter route only when the web route is blocked, the user
asks for API dispatch, or a project-backed source set is unavailable.

- **ChatGPT web**: read `references/chatgpt-web.md`.
- **Script/OpenRouter fallback**: read `references/openrouter-script.md`.

Do not silently switch routes after the route is selected. If the selected route
fails, report the blocker. Use OpenRouter fallback only when the user request or
project settings already authorize API credit spending.

## Shared Project Record

Write prompts, source manifests, and route metadata to workspace files under
`.agents/pro-manage/`. The record should make the concrete project state and
prompt turn reproducible:

1. `DEFAULT_ROUTE`: `chatgpt-web` unless the user or project overrides it.
2. `SELECTED_ROUTE`: `chatgpt-web` or `openrouter-script` for this handoff.
3. `PROJECT_NAME`: visible ChatGPT Project name when the web route is used.
4. `REMOTE_PROJECT_STATE`: `synced`, `needs-sync`, `blocked`, or `unknown`.
5. `MODEL`: web model label or OpenRouter model slug.
6. `PROMPT_FILE`: path to the exact prompt for the next turn.
7. `SOURCE_MANIFEST`: local source inventory and sync status.
8. `OUTPUT_FILE`: path where the answer should be saved.
9. `TRANSCRIPT_FILE`: path for web/API metadata.
10. `AUTHORIZATION_SOURCE`: the user request or project setting that authorized
    this route and any API spending.
11. `TASK`: the exact theorem, lemma, gap, or derivation target.
12. `PROHIBITIONS`: no invented citations, hidden assumptions, or workspace edits.

Use `scripts/manage_pro_sources.ps1` to initialize the local record or generate a
prompt skeleton when a workspace does not already have one.

## Dispatch Rule

Invoking this skill means the user has authorized GPT Pro assistance for the
current task. Ask only when execution would require an unselected paid route, a
different model family, uploading sources not covered by the current
authorization, or a second independent web/API dispatch.

## Output Handling

After any route returns:

1. Save the answer into the active workspace and treat that file as authoritative.
2. Confirm the answer follows the project record, prompt contract, and required
   end marker when one was requested.

Do not store API keys, account identifiers, private paths, unpublished source
excerpts, or live transcripts inside the skill directory.
