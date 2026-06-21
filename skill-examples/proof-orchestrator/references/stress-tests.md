# GPT Pro Stress Tests

For proof-orchestrator stress tests that use the ChatGPT web route, keep every
test run isolated:

1. Create a fresh ChatGPT Project for the run.
2. Disable memory sharing with the user's general ChatGPT context when the UI
   provides that setting.
3. Add only the resource files required by the run.
4. Ask the test prompt in that Project.
5. Keep different stress tests and unrelated proof conversations in separate
   Projects and run directories.

Record the Project name, source manifest, and memory-isolation status in the
handoff or ledger before treating the run as reproducible.
