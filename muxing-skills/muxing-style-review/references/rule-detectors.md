# muxing-style-review detector coverage

This file documents the implemented behavior that `muxing-style-review` should rely on. The installed `agent-style review` CLI output is the source of truth.

## Implemented deterministic detectors

| Rule | Bucket | Status | Notes |
| --- | --- | --- | --- |
| RULE-05 | mechanical | implemented | Regex for cliche phrases and prefabricated expressions. The semantic bucket is still skipped. |
| RULE-06 | mechanical | implemented | Regex for banned jargon / AI-tell terms. The semantic bucket is still skipped. |
| RULE-12 | mechanical | implemented | Flags sentences over 30 words. |
| RULE-A | structural | implemented | Flags short or tiny bullet-list groups. |
| RULE-B | mechanical | implemented | Flags em/en dashes used as casual punctuation. |
| RULE-C | structural | implemented | Flags repeated sentence starts in a local window. |
| RULE-D | mechanical | implemented | Flags transition openers such as Additionally/Furthermore/Moreover/In addition. |
| RULE-E | structural | implemented | Flags summary/restatement paragraph closers. |
| RULE-G | mechanical | implemented | Checks Markdown heading title case. |
| RULE-I | mechanical | implemented | Flags contractions outside inline code. |

## Skipped or deferred detectors

| Rule | Bucket | Status | Notes |
| --- | --- | --- | --- |
| RULE-01 | semantic | skipped | Requires contextual LLM judgment; not implemented in the CLI. |
| RULE-02 | structural + semantic | skipped/deferred | Passive-voice structural detector is deferred; semantic agent-matters judgment is not implemented. |
| RULE-03 | semantic | skipped | Requires contextual LLM judgment; not implemented in the CLI. |
| RULE-04 | semantic | skipped | Requires contextual LLM judgment; not implemented in the CLI. |
| RULE-07 | structural | deferred | Positive-form detector is not implemented. |
| RULE-08 | semantic | skipped | Requires contextual LLM judgment; not implemented in the CLI. |
| RULE-09 | structural | deferred | Parallel-structure detector is not implemented. |
| RULE-10 | structural | deferred | Related-words detector is not implemented. |
| RULE-11 | semantic | skipped | Requires contextual LLM judgment; not implemented in the CLI. |
| RULE-F | semantic | skipped | Requires contextual LLM judgment; not implemented in the CLI. |
| RULE-H | semantic | skipped | Requires contextual LLM judgment; not implemented in the CLI. |

## Reporting guidance

- Say "implemented-rule violations" rather than "all style violations".
- Always mention skipped semantic/deferred rules when the user asks whether the review is complete.
- Do not infer semantic violations manually unless the user explicitly asks for a separate human-style editorial review.
- Do not promise `FILE.reviewed.md`; that is outside this skill's implemented contract.
