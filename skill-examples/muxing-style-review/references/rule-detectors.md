# Automatic Detector Coverage

Use this file to separate automatic `agent-style review --audit-only FILE`
coverage from the manual/model rules in `check-human.md`.

## CLI command

```powershell
agent-style review --audit-only FILE
```

The CLI is useful for repeatable evidence on mechanical and structural issues,
but it does not replace the manual/model review in `check-human.md`.

## Automatic coverage

| Rule | Typical CLI coverage | How to use it here |
| --- | --- | --- |
| RULE-05 | Prefabricated or cliche phrase patterns. | Supporting evidence for AI-tell surface findings. |
| RULE-06 | Avoidable jargon phrase patterns. | Supporting evidence; still judge whether a term is technical and necessary. |
| RULE-12 | Long sentences. | Supporting evidence; long equations or citation-heavy sentences may be false positives. |
| RULE-A | Short or unnecessary bullet groups. | Supporting evidence for over-bulleting. |
| RULE-B | Casual em/en dash punctuation. | Supporting evidence. |
| RULE-C | Repeated sentence starts. | Supporting evidence; judge whether the repetition is intentional parallelism. |
| RULE-D | Transition crutches. | Supporting evidence. |
| RULE-E | Summary/restatement paragraph closers. | Supporting evidence. |
| RULE-G | Markdown heading title case. | Supporting evidence for Markdown only. |
| RULE-I | Contractions. | Supporting evidence for formal prose. |

## Manual coverage

`check-human.md` contains only the rules not covered by the automatic detector
pass:

- RULE-01: reader state and tacit knowledge.
- RULE-02: passive voice when agent naming matters.
- RULE-03: concrete language beyond simple phrase matching.
- RULE-04: needless words not handled by the installed detector set.
- RULE-07: affirmative form.
- RULE-08: claim calibration.
- RULE-09: parallel structure.
- RULE-10: related-word placement.
- RULE-11: stress position.
- RULE-F: term consistency and abbreviation drift.
- RULE-H: citation discipline and evidence support.

A clean CLI result must be reported as "no automatic detector findings", not as
"no style findings".
