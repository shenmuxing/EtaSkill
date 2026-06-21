# Analysis Idea Rubric

Score each candidate from 1 to 5 on each axis.

| Axis | 1 | 3 | 5 |
| --- | --- | --- | --- |
| Formal clarity | Vague intuition | Statement shape exists | Assumptions, conclusion, and objects are precise |
| Novelty signal | Likely known | Differentiable but close | Opens a new theorem, lower bound, or unification |
| Proof plausibility | No route | One plausible lever | Multiple local obligations with a credible main lever |
| Field value | Cosmetic | Useful clarification | Changes how researchers understand or analyze a method |
| Negative-result value | Failure is uninteresting | Some diagnostic use | Counterexample or impossibility would be publishable |
| Scope control | Too broad | Manageable after pruning | Clean first theorem with clear extensions |

## Ranking Rule

Prefer an idea with a precise formal target and high negative-result value over a broad idea that only promises empirical upside.

## Red Flags

- The "method" is only "try this algorithm and see".
- The theorem target cannot be stated without inventing missing definitions.
- The contribution depends on outperforming baselines rather than proving a new relation.
- The proof plan silently assumes the desired conclusion.
- The plan claims a parameterization-only convergence rate while ignoring MDP-dependent advantage gaps, occupancies, initialization, or oracle assumptions.
- The plan advertises an impossibility or lower-bound theorem without specifying the oracle model and hard instance family.
