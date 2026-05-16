---
name: muxing-style-review
description: Deterministic Markdown prose review using the installed agent-style CLI. Use when the user asks for muxing-style-review, wants a post-hoc style audit of Markdown, wants implemented agent-style checks only, or wants an A/B comparison between two drafts. This skill reports unsupported semantic/deferred rules as skipped and does not promise semantic judging, automatic polish, or writing reviewed copies.
---

# Muxing Style Review

Audit Markdown prose with the implemented `agent-style review` CLI detectors. Keep the contract narrower than upstream `style-review`: report what the CLI can actually verify, and do not advertise or perform unfinished semantic/polish workflows.

## Contract

Implemented:

- Single-file deterministic audit with `agent-style review --audit-only FILE`.
- A/B draft comparison with `agent-style review --compare A.md B.md` or `agent-style review --mechanical-only --compare A.md B.md` when strict mechanical-only parity is desired.
- Clear reporting of skipped rules and detector limitations.

Not implemented:

- No host-model semantic judging for RULE-01, 03, 04, 08, 11, F, H.
- No automatic polish pass.
- No prompt to create `FILE.reviewed.md`.
- No in-place edits to the source file.

## Single-File Audit

1. Run:

   ```powershell
   agent-style review --audit-only FILE
   ```

2. Parse the JSON output.
3. Report:
   - total deterministic violations;
   - per-rule counts for rules whose count is greater than zero;
   - first 3 violations per firing rule, with line/column, detail, and excerpt;
   - skipped rules grouped by reason.
4. If there are zero deterministic violations, say that no implemented-rule violations were found, then still mention skipped semantic/deferred coverage if present.
5. Do not ask whether to polish and do not write any new file unless the user explicitly asks for a separate manual rewrite.

## A/B Compare

For normal deterministic comparison, run:

```powershell
agent-style review --compare A.md B.md
```

For byte-stable mechanical-only benchmark comparison, run:

```powershell
agent-style review --mechanical-only --compare A.md B.md
```

Report the per-rule delta table. Positive delta means B has more violations than A; negative delta means B has fewer violations than A. Do not polish or write files in compare mode.

## Detector Coverage

Use `references/rule-detectors.md` for the detector matrix and status notes. Treat the installed CLI output as the source of truth when it differs from the reference file.

Expected implemented deterministic detectors in the current upstream package:

- Mechanical: RULE-05, RULE-06, RULE-12, RULE-B, RULE-D, RULE-G, RULE-I.
- Structural: RULE-A, RULE-C, RULE-E.

Expected skipped or partial coverage:

- Semantic-only or semantic bucket: RULE-01, RULE-03, RULE-04, RULE-08, RULE-11, RULE-F, RULE-H, plus semantic buckets for RULE-02, RULE-05, RULE-06.
- Deferred structural: RULE-02, RULE-07, RULE-09, RULE-10.

## Fixtures

Use `references/fixture-prose/` only for validation or regression checks. The expected JSON files summarize intended fixture totals and per-rule counts, not full canonical CLI output.

## Publication and Sharing Notes

When copying this skill into a public repository or shared skill collection, keep the contract limited to implemented `agent-style review` behavior. Remove private examples, local transcripts, account details, unpublished project names, and personal absolute paths. Fixtures should stay generic and reproducible, and skipped semantic/deferred rules must remain explicit instead of being presented as implemented review coverage.

## Self-Verification

When asked "is muxing-style-review active?", reply on one line using this exact format:

`muxing-style-review active: deterministic agent-style audit only (implemented mechanical/structural CLI detectors); semantic judging and polish are intentionally not promised; workflow at skills/muxing-style-review/SKILL.md.`
