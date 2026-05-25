# Subagent Review Prompt

Use this prompt when Codex can delegate the intelligent part of
`muxing-style-review` to a dedicated review subagent. For complete checks, this
prompt covers the manual/model half from `check-human.md`; the parent Codex
thread remains responsible for `agent-style review --audit-only FILE`.

## Prompt

```text
Use the muxing-style-review manual rule contract below to review the provided
prose. Prioritize by the upstream severity rubric in the rule contract
(`critical`, `high`, `medium`, `low`), then by the issue's local impact on
trust, reader comprehension, claim support, and manuscript fit.

Inputs:
- Target excerpt:
<paste excerpt>

- Manuscript or document context:
<reader, venue, position in manuscript, nearby definitions, notation, citation
expectations, or "not provided">

- Rule contract:
<paste references/check-human.md or the relevant full content>

Tasks:
1. Review the target excerpt against the manual rules in the pasted contract.
2. Focus on issues that materially affect trust, clarity, evidence, citation
   discipline, terminology, and manuscript fit.
3. Do not rewrite the prose.
4. Do not invent missing citations, metrics, definitions, or source facts.
5. If context is missing, say which rule cannot be judged and what context is
   needed.

Output:
- Verdict: ready | usable with minor edits | needs revision | not usable
- Scorecard: counts by BLOCKER, MAJOR, MINOR, grouped by upstream severity
- Findings: ordered list with:
  - severity
  - upstream_severity
  - rule_id
  - location
  - evidence
  - impact
  - revision_instruction
  - confidence: high | medium | low
- Checked-no-issue: manual rule ids that were considered and did not produce findings
- Context gaps: missing information that limits the review
```

## Parent Codex Responsibilities

After the subagent returns:

- Verify findings against the actual file or excerpt.
- Remove false positives caused by missing context.
- Add issues the subagent missed because it did not see enough surrounding
  manuscript state.
- Convert accepted findings into a user report or a DeepSeek revision brief.
- Do not let the subagent edit files directly for this review task.
