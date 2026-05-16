# Revision prompt status

`muxing-style-review` intentionally does not provide an automatic revision prompt.

The upstream `style-review` skill describes a polish workflow, but the installed `agent-style` package currently exposes only a stub for polish and exits from the plain CLI. To keep this skill's public contract accurate, do not use this file to generate `FILE.reviewed.md`.

If the user explicitly asks for a manual rewrite after seeing the deterministic audit, perform that as a separate editing task and make clear that it is not a verified `agent-style --polish` workflow.
