# Warm-up Free Policy Optimization: Improved Regret in Linear Markov Decision Processes

## Source Metadata

- Source kind: `PDF`
- Public title: Warm-up Free Policy Optimization: Improved Regret in Linear Markov Decision Processes
- Authors: Asaf Cassel and Aviv Rosenberg
- Year: 2024
- Source file name: `cassel-rosenberg-2024-warm-up-free-policy-optimization.pdf`
- Public citation: Cassel and Rosenberg, "Warm-up Free Policy Optimization: Improved Regret in Linear Markov Decision Processes" (2024).

## Local Index

| ID | Paper location | Type | Short name | Tags | Value |
| --- | --- | --- | --- | --- | --- |
| `CR24-S01` | Section 4 and Algorithm 1 / pp. 5-6 | `STRATEGY` | Contracted features replace warm-up | contracted-features, warm-up-free, uncertainty, PO | high |
| `CR24-D01` | Section 5 proof sketch / p. 10; Lemma 18 / p. 22 | `DETAIL` | Sigmoid uncertainty cap | sigmoid-gate, q-bound, uncertainty-cap | high |
| `CR24-D02` | Lemma 3 / pp. 7-8; Lemma 19 / p. 22 | `DETAIL` | Quadratic contraction residue | sigmoid-gate, quadratic-residue, elliptical-potential | high |
| `CR24-D03` | Algorithm 1 line 4 / p. 6; Lemmas 15-16 / p. 21 | `DETAIL` | Determinant epoch accounting | determinant-doubling, epoching, elliptical-potential | medium |
| `CR24-S02` | Section 5.1-5.2 / pp. 7-9; Lemmas 2, 4, 5 / pp. 7-10 | `BOTH` | Contracted-MDP regret decomposition | auxiliary-model, optimism, OMD, value-difference | high |

## Items

### CR24-S01: Contracted features replace warm-up

- Type: `STRATEGY`
- Paper location: Section 4 and Algorithm 1, pp. 5-6.
- Depends on: `CR24-D01`, `CR24-D02`, `CR24-D03`, `CR24-S02`.
- Local statement: CFPO resets epochs when a covariance determinant doubles and uses contracted features `bar_phi = phi * sigma(-beta_w ||phi||_{Lambda^{-1}} + log K)` inside the policy optimization update, avoiding a separate reward-free warm-up phase.
- Reusable abstraction: When unbounded or poorly explored directions would make value estimates too complex, shrink features as a decreasing function of uncertainty and analyze the auxiliary contracted model instead of forcing early uniform exploration.
- Proof skeleton: Freeze the contraction within an epoch, estimate rewards and dynamics with least squares, run OMD on contracted Q-values, and charge the difference between true and contracted models through sigmoid and elliptical-potential bounds.
- Why it is valuable: It gives a reusable pattern for replacing warm-up exploration with a proof-compatible uncertainty gate while preserving low-dimensional policy representations.
- Backtest signal: Legacy mined card marked high transfer value; rerun blind backtest before using as a publication gate.
- Candidate tags: contracted-features, warm-up-free, uncertainty-gate, linear-mdp, policy-optimization.
- Cooker hints: Cook as a macro strategy. Distinguish from restart-only methods: this strategy changes the model object, not just the step size.

### CR24-D01: Sigmoid uncertainty cap

- Type: `DETAIL`
- Paper location: Section 5 proof sketch, p. 10; Lemma 18, p. 22.
- Depends on: logistic gate definition in Algorithm 1 and bounded Q-value induction.
- Local statement: For `K >= 1` and `beta > 0`, the gated uncertainty term satisfies `max_{y >= 0} y * sigma(-beta y + log K) <= 2 log(eK) / beta`.
- Reusable abstraction: A decreasing sigmoid gate can cap the product of uncertainty magnitude and gated feature scale by a logarithmic factor, even before the design matrix explores every direction.
- Proof skeleton: Split on whether `y <= 2 log K / beta`. In the small case the bound is immediate. In the large case use monotonicity of the sigmoid and `1 + exp(u) >= u` to turn `y * sigma(-beta y + log K)` into a constant over `beta`.
- Why it is valuable: It converts a nonlinear gate into a deterministic cap that supports bounded-value induction and avoids a separate clipping operation.
- Backtest signal: Legacy card indicates this was non-obvious enough to preserve; not rerun during this migration.
- Candidate tags: sigmoid-gate, uncertainty-cap, q-bound, bounded-values.
- Cooker hints: Cook as a local move under concentration/self-normalization. Pair with `CR24-D02`.

### CR24-D02: Quadratic contraction residue

- Type: `DETAIL`
- Paper location: Lemma 3, pp. 7-8; Lemma 19, p. 22.
- Depends on: `CR24-D03` for epoch covariance comparison and a bound on `|phi^T v|`.
- Local statement: The contraction error can be bounded by a quadratic uncertainty term plus a `K^{-1}` residual, using a bound of the form `sigma(z - log K) <= 2(z^2 + K^{-1})` for `z >= 0`.
- Reusable abstraction: When a proof gates high-uncertainty directions by a shifted sigmoid, convert the lost mass into squared self-normalized radii so the total cost is controlled by an elliptical-potential sum.
- Proof skeleton: Express `phi - bar_phi` as a sigmoid tail times `phi`. Bound the shifted sigmoid by a quadratic in the normalized uncertainty plus `K^{-1}`. Use determinant stability inside the epoch to compare the epoch-start and current covariance norms.
- Why it is valuable: It is the key move that makes contraction cost logarithmic rather than accumulating like a linear uncertainty penalty.
- Backtest signal: Legacy card preserved as high value; source location verified during migration.
- Candidate tags: quadratic-residue, shifted-sigmoid, contraction-bias, elliptical-potential.
- Cooker hints: Cook as a local move. Keep the `K^{-1}` residual explicit because it prevents silent accumulation mistakes.

### CR24-D03: Determinant epoch accounting

- Type: `DETAIL`
- Paper location: Algorithm 1 line 4, p. 6; Lemma 15 and Lemma 16, p. 21.
- Depends on: self-normalized design matrices `Lambda_h^k`.
- Local statement: CFPO restarts an epoch when some horizon covariance determinant doubles; within an epoch, determinant comparison controls covariance-norm conversion, and across all episodes elliptical-potential bounds control the sum of uncertainty radii.
- Reusable abstraction: Freeze a complex object until determinant growth certifies that the geometry changed substantially. The number and cost of restarts is logarithmic in design growth.
- Proof skeleton: Use determinant doubling to limit epoch changes. Inside an epoch, apply the determinant comparison inequality to relate norms under old and new covariance matrices. Across the run, apply the elliptical-potential lemma to sum squared or linear self-normalized radii.
- Why it is valuable: It justifies epochwise freezing of gates, bonuses, policy classes, or confidence objects without letting restarts dominate regret.
- Backtest signal: Legacy card preserved as medium-high utility; routine determinant details are standard but the use with frozen contraction is transferable.
- Candidate tags: determinant-doubling, epoching, self-normalized, covariance-growth.
- Cooker hints: Cook into an epoch/restart control file and cross-link to `CR24-D02`.

### CR24-S02: Contracted-MDP regret decomposition

- Type: `BOTH`
- Paper location: Section 5.1-5.2, pp. 7-9; Lemmas 2, 4, and 5, pp. 7-10.
- Depends on: contracted MDP definition, `CR24-D01`, `CR24-D02`, `CR24-D03`.
- Local statement: The paper defines a contracted sub-MDP whose values lower-bound original values, then decomposes regret into cost of optimism, OMD regret, and optimism terms measured against the contracted model.
- Reusable abstraction: When the true model is hard to optimize against directly, introduce an auxiliary model with safer geometry, prove it is conservative for the comparator, and route regret through bias, online-learning, and optimism terms.
- Proof skeleton: Show contracted values are no larger than original values by backward induction. Use an extended value-difference lemma on the contracted model. Prove optimism in the contracted feature space and separately bound the cost of replacing true features by contracted features along the learner's trajectory.
- Why it is valuable: It separates the global comparator issue from learner-trajectory bias, making a contraction that only has observed-path control still usable in regret analysis.
- Backtest signal: Legacy strategy card marked high value; source-level dependencies added during migration.
- Candidate tags: auxiliary-model, contracted-mdp, regret-decomposition, optimism, OMD.
- Cooker hints: Cook as a macro strategy and compare with dual-localization surrogate strategies from `GGSXY25`.
