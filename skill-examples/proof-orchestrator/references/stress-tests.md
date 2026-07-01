# GPT Pro Stress Tests

For proof-orchestrator stress tests that use the ChatGPT web route, keep every
test run isolated:

1. Create a fresh ChatGPT Project for the run.
2. Add only the resource files required by the run.
3. Ask the test prompt in a new conversation/chat inside that Project.
4. Keep different stress tests and unrelated proof conversations in separate
   Projects and run directories.

Record the Project name and source manifest in the handoff or ledger before
treating the run as reproducible.

For a direct continuation of the same stress-test lineage, the Project may be
reused only when the source set still matches, but the prompt must still be sent
in a new Project conversation/chat. Prior conversations are evidence to read
from local artifacts or retrieve from Chrome, not live context to extend.

If a stress test names PDFs or other primary documents as sources, those files
are required direct Project sources. They must be uploaded and confirmed as
separate visible files unless the user explicitly approves a fallback after an
upload blocker is observed. Use the Project-source upload procedure in
`call-gpt-pro/references/chatgpt-web.md`; do not satisfy a required PDF through
the normal chat attachment control, extracted text, or a bundle unless the user
approves that degraded route after the direct upload blocker is recorded.
