# Proof Audit Output Contract

Use this format for saved audits. Keep chat-only audits shorter but preserve
the same verdict and issue semantics.

## Markdown Audit

```md
# Proof Audit

Target: <file/section/task>
Verdict: PASS | WARN | FAIL | BLOCKED | NOT_APPLICABLE
Claim status: PROVABLE AS STATED | PROVABLE AFTER WEAKENING / EXTRA ASSUMPTION | NOT CURRENTLY JUSTIFIED
Reviewer backend: llm-chat-deepseek | deepseek-agent | local-codex-fallback
Reviewer model: <model name or unknown>

## Claim Restatement

<explicit statement with assumptions, quantifiers, domains, and conclusion>

## Obligation Ledger

| ID | Obligation | Location | Status | Notes |
|----|------------|----------|--------|-------|

## Issues

| ID | Severity | Category | Location | Summary | Minimal repair |
|----|----------|----------|----------|---------|----------------|

## Counterexample Pass

<attempts, successful counterexamples, or candidates>

## Recommended Repair

<minimal honest fix: add derivation, add assumption, weaken claim, add reference, or split lemma>

## Remaining Risks

<what was not checked or still depends on external material>
```

## Issue Record

For each serious issue, include:

```md
### I<n>: <short title>

- Severity: FATAL | CRITICAL | MAJOR | MINOR
- Category: <taxonomy label>
- Status: INVALID | UNJUSTIFIED | UNDERSTATED | OVERSTATED | UNCLEAR
- Impact: GLOBAL | LOCAL | COSMETIC
- Location: <file:line or section>
- Claimed step: <what the proof asserts>
- Problem: <why it does not follow>
- Counterexample: YES | NO | CANDIDATE, with details
- Downstream effect: <what breaks>
- Minimal repair: <add derivation / add assumption / weaken claim / cite result and verify conditions>
```

## Optional JSON Artifact

Write `<paper-dir>/PROOF_AUDIT.json` only when a caller or formal workflow
requests a machine-readable audit.

Use paths relative to the paper directory for files inside the paper directory.
Use absolute paths for files outside it.

```json
{
  "audit_skill": "proof-checker-v2",
  "verdict": "PASS | WARN | FAIL | NOT_APPLICABLE | BLOCKED | ERROR",
  "reason_code": "all_proofs_complete | minor_gaps | critical_gap | no_theorems | source_unreadable | reviewer_error",
  "summary": "One-line verdict summary.",
  "audited_input_hashes": {
    "main.tex": "sha256:..."
  },
  "generated_at": "<UTC ISO-8601>",
  "reviewer_backend": "llm-chat-deepseek | deepseek-agent | local-codex-fallback",
  "reviewer_model": "deepseek-v4-pro | deepseek-chat | deepseek-reasoner | unknown",
  "details": {
    "theorems_audited": 0,
    "issues": [
      {
        "id": "I1",
        "severity": "FATAL|CRITICAL|MAJOR|MINOR",
        "category": "QUANTIFIER_ERROR",
        "location": "sections/theory.tex:L182",
        "note": "..."
      }
    ]
  }
}
```

## Verdict Mapping

- `NOT_APPLICABLE`: no theorem, lemma, proposition, corollary, or proof content.
- `BLOCKED`: required source is unreadable or missing.
- `PASS`: all proof obligations discharged.
- `WARN`: only minor issues, or major issues with explicit justification that the main conclusion survives.
- `FAIL`: any fatal or critical issue, or a major issue that may affect the main conclusion.
- `ERROR`: audit machinery failed.
