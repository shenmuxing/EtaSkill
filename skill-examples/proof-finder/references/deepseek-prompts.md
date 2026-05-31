# DeepSeek Prompt Templates

## First-Pass Screening

Use a fresh DeepSeek session. Save this as a prompt file and call the `deepseek-agent` wrapper with `--auto`, `--use-prompt-file-reference`, `--result-file`, `--json`, and a required end marker.

```text
ROLE: answer-only proof-mining agent.

TASK: Read `<SOURCE_PATH>` and return a concise screening list of proof material candidates.

WORKSPACE: The only source document you may inspect is `<SOURCE_PATH>`.

CONTEXT: Valuable material includes proof ingredients that a strong Codex-like agent might not easily invent when solving a related proof task. Preserve source topology and evidence anchors. Do not assign final proof-usage categories.

CONSTRAINTS:
- Look for named theorems, lemmas, propositions, corollaries, claims, proof devices, decompositions, reductions, concentration steps, potential functions, coupling arguments, error-bound arguments, definitions, dependencies, and nonstandard proof templates.
- Mark each candidate as `DETAIL`, `STRATEGY`, `DEFINITION`, `DEPENDENCY`, or `BOTH`.
- Include the best available paper location: section, theorem, lemma, equation, page, algorithm line, appendix, or proof paragraph.
- Suggest tags and possible cooker hints, but do not flatten candidates into final techniques or strategies.
- Do not search the web. Do not inspect other local files. Do not edit files.

OUTPUT CONTRACT: answer-only. Write the result to the requested result file.

# Initial Proof Material Screen

## Source
<title or source identifier>

## Candidates
- Paper location: <section/theorem/page/etc.>
  Type: DETAIL/STRATEGY/DEFINITION/DEPENDENCY/BOTH
  Short name: <candidate name>
  Why valuable: <one sentence>
  Depends on: <local dependencies, if visible>
  Candidate tags: <comma-separated tags>
  Cooker hints: <possible later classification or warnings>

## Notes
- <extraction warnings, if any>

ACCEPTANCE CRITERIA: End with `END_DEEPSEEK_OUTPUT`.
```

## Blind Backtest

Use a new fresh DeepSeek session after Codex rewrites a candidate into a self-contained material abstraction. Do not provide source paths or surrounding paper context.

```text
ROLE: answer-only proof backtest agent.

TASK: Try to solve or reconstruct the key proof step below without using local files or web search.

MATERIAL CANDIDATE:
<candidate abstraction, local statement, and proof target>

CONSTRAINTS:
- Do not inspect local files.
- Do not search the web.
- If the problem is underspecified, list the missing definitions or assumptions instead of guessing.
- If you can solve it, give the shortest rigorous proof outline.
- Treat this as a value and self-containedness test, not as a final publication decision.

OUTPUT CONTRACT: answer-only. Write the result to the requested result file.

Return:
- Verdict: solved / partial / failed / underspecified
- Difficulty signal: easy / moderate / hard
- Key proof idea used:
- Missing self-contained information:
- Value signal for proof-material: high / medium / low
- Suggested `Backtest signal` text:

ACCEPTANCE CRITERIA: End with `END_DEEPSEEK_OUTPUT`.
```
