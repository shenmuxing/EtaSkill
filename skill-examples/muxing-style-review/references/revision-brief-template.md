# Revision Brief Template

Use this template when `muxing-style-review` feeds a writing agent such as
DeepSeek. The reviewer reports problems; the writing agent revises the prose.

## Header

- Target file or excerpt:
- Manuscript position:
- Reader and venue:
- Output contract:
- Scope boundary:

## Non-Negotiable Invariants

- Preserve meaning, notation, citations, labels, equations, and technical
  claims unless a finding explicitly says they are wrong.
- Do not add new citations, metrics, definitions, theorem claims, experiments,
  or source facts.
- Do not remove source-supported claims merely to make the prose shorter.
- Keep the same file format. For LaTeX, preserve commands and environments
  unless the finding is about malformed markup.
- Fix the listed findings first. Do not perform broad style rewrites outside
  the scoped excerpt.

## Findings to Fix

Use one block per finding:

```text
Finding: <BLOCKER|MAJOR|MINOR> <RULE-ID>
Location: <line, paragraph, heading, or excerpt anchor>
Problem: <what fails>
Impact: <why it matters for the reader or manuscript>
Required revision: <concrete instruction>
Preserve: <terms, citations, equations, labels, or claims that must stay>
```

## Acceptance Criteria

- BLOCKER findings are resolved or explicitly marked as requiring missing
  source material.
- MAJOR findings are resolved without introducing new unsupported claims.
- Remaining MINOR issues are localized and acceptable for the current round.
- The revised text still fits the surrounding manuscript context.
