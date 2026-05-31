# Beyond O(sqrt(T)) Regret: Decoupling Learning and Decision-making in Online Linear Programming

## Source Metadata

- Source kind: `PDF`
- Public title: Beyond O(sqrt(T)) Regret: Decoupling Learning and Decision-making in Online Linear Programming
- Authors: Wenzhi Gao, Dongdong Ge, Chunlin Sun, Chenyu Xue, and Yinyu Ye
- Year: 2025
- Source file name: `gao-ge-sun-xue-ye-2025-online-linear-programming.pdf`
- Public citation: Gao, Ge, Sun, Xue, and Ye, "Beyond O(sqrt(T)) Regret: Decoupling Learning and Decision-making in Online Linear Programming" (2025).

## Local Index

| ID | Paper location | Type | Short name | Tags | Value |
| --- | --- | --- | --- | --- | --- |
| `GGSXY25-D01` | Assumption A4 / p. 6; Lemma 3.1 / p. 7 | `DETAIL` | Error-bound objective-to-distance conversion | error-bound, dual-localization, uniform-convergence | high |
| `GGSXY25-D02` | Lemma 3.2 / p. 7 | `DETAIL` | Constant-stepsize noise ball | subgradient, noise-ball, localization | high |
| `GGSXY25-D03` | Lemmas 4.1-4.2 and eqs. (5)-(7) / pp. 8-9 | `DETAIL` | Localized regret decomposition | regret-decomposition, stepsize, dual-distance | high |
| `GGSXY25-S01` | Algorithm 2 and Lemma 4.3 / pp. 9-10 | `STRATEGY` | Learn then localize | exploration-exploitation, dual-learning, localization | high |
| `GGSXY25-S02` | Proposition 4.1 and Algorithm 3 / pp. 10-12 | `STRATEGY` | Decouple learning and decision-making | decoupling, restart, adaptivity, first-order | high |
| `GGSXY25-D04` | Theorem 4.1 / p. 12; proof outline / p. 31 | `DETAIL` | Error-bound exponent balancing | parameter-balancing, holder-growth, regret-rate | medium |

## Items

### GGSXY25-D01: Error-bound objective-to-distance conversion

- Type: `DETAIL`
- Paper location: Assumption A4, p. 6; Lemma 3.1, p. 7.
- Depends on: dual objective `f`, optimal set `Y*`, compact dual domain `Y`.
- Local statement: If `f(y) - f(y*) >= mu * dist(y, Y*)^gamma`, then a first-order learner that obtains objective gap `epsilon` also localizes to `dist(y, Y*)^gamma <= epsilon / mu` up to constants.
- Reusable abstraction: A Holder error bound turns uniform or stochastic objective accuracy into geometric localization around the solution set.
- Proof skeleton: Establish a high-probability objective gap for the learned dual point, then apply the error-bound inequality directly to convert objective growth into distance-to-solution control.
- Why it is valuable: It is the bridge from statistical learning of a dual objective to a smaller domain for online decision-making.
- Backtest signal: Legacy card preserved as high value; source assumptions verified in the migration.
- Candidate tags: error-bound, holder-growth, dual-localization, objective-gap.
- Cooker hints: Cook as a convex-error-bound local move. Keep singleton versus non-singleton `Y*` distinctions visible.

### GGSXY25-D02: Constant-stepsize noise ball

- Type: `DETAIL`
- Paper location: Lemma 3.2, p. 7.
- Depends on: Algorithm 1 subgradient update and initial distance `Delta = dist(y1, Y*)`.
- Local statement: With constant stepsize `alpha`, subgradient iterates satisfy an objective gap controlled by `Delta^2/(alpha T) + alpha log T`; under the error bound this yields a bound on expected `dist(y_{T+1}, Y*)^gamma`.
- Reusable abstraction: Once initialized near the optimal set, a constant-stepsize online method stays in a noise ball whose radius is governed by initialization error and stepsize.
- Proof skeleton: Apply a last-iterate stochastic subgradient bound, then convert objective gap to distance with the error bound.
- Why it is valuable: It explains why the decision phase should not drive the stepsize to zero as aggressively as a pure learner would.
- Backtest signal: Legacy material marked high; not rerun during migration.
- Candidate tags: noise-ball, constant-stepsize, last-iterate, localization.
- Cooker hints: Cook with localized regret decomposition. Mention that the bound is useful for decision adaptivity, not only optimization convergence.

### GGSXY25-D03: Localized regret decomposition

- Type: `DETAIL`
- Paper location: Lemmas 4.1-4.2 and equations (5)-(7), pp. 8-9.
- Depends on: `GGSXY25-D01`, `GGSXY25-D02`.
- Local statement: Regret plus violation can be bounded by terms of the form `alpha T + dist(y1,Y*)/alpha + E[dist(y_{T+1},Y*)]/alpha`; with `y1` localized, the noise-ball bound improves the stepsize tradeoff.
- Reusable abstraction: In online convex or primal-dual analysis, isolate the terms that depend on initial and final distance to the optimal set, then use localization to choose a smaller but still adaptive stepsize.
- Proof skeleton: Bound regret and constraint violation separately by telescoping the projected dual update. Substitute the last-iterate localization estimate, then balance the resulting powers of `alpha` and `T`.
- Why it is valuable: It creates the algebraic interface between a learning phase and a decision phase.
- Backtest signal: Legacy card preserved as high value; source locations added.
- Candidate tags: regret-decomposition, dual-distance, stepsize-balancing, localization.
- Cooker hints: Cook as a local move that feeds the dual-decoupling macro strategy.

### GGSXY25-S01: Learn then localize

- Type: `STRATEGY`
- Paper location: Algorithm 2 and Lemma 4.3, pp. 9-10.
- Depends on: `GGSXY25-D01`, `GGSXY25-D02`, `GGSXY25-D03`.
- Local statement: Use an exploration phase to learn an approximate dual optimizer within target distance `Delta`, then run a localized exploitation phase with a stepsize tuned to the error-bound exponent.
- Reusable abstraction: When an unknown population object controls online decisions, spend a bounded phase learning a location certificate and then exploit inside a smaller decision domain.
- Proof skeleton: Choose exploration length from the sample complexity needed for `Delta` localization. Analyze exploration cost separately. In exploitation, initialize from the learned dual point and use the localized regret decomposition to balance `alpha`, `Delta`, and horizon terms.
- Why it is valuable: It packages a common learn-then-act proof into a rate-sensitive template tied to geometric error bounds.
- Backtest signal: Legacy strategy preserved as high value; source-level dependencies added.
- Candidate tags: exploration-exploitation, dual-learning, localization, error-bound.
- Cooker hints: Cook as macro strategy but avoid presenting it as sufficient without `GGSXY25-S02`; naive reuse of the learning path for decisions can fail.

### GGSXY25-S02: Decouple learning and decision-making

- Type: `STRATEGY`
- Paper location: Section 4.3-4.4, Proposition 4.1, Algorithm 3, and Theorem 4.1, pp. 10-12.
- Depends on: `GGSXY25-S01`, `GGSXY25-D02`, `GGSXY25-D03`.
- Local statement: A first-order method tuned for accurate dual learning can be too sluggish for online decisions. The paper maintains separate learning and decision dual sequences, then restarts the decision path from the learned point for exploitation.
- Reusable abstraction: Split estimation and control roles when their optimal update schedules conflict. Use one path to learn a high-accuracy anchor and another path to remain adaptive during decisions.
- Proof skeleton: Show that a learning stepsize such as `1/t` can fail to achieve sub-`sqrt(T)` regret and violation simultaneously in a one-dimensional example. Use two sequences in exploration, hand the learned anchor to the decision sequence, and tune exploration length plus exploration/exploitation stepsizes in Theorem 4.1.
- Why it is valuable: It identifies a structural failure mode of single-sequence first-order algorithms and gives a reusable two-path remedy.
- Backtest signal: Legacy strategy card marked high value; not rerun during migration.
- Candidate tags: decoupling, restart, dual-learning, decision-making, adaptivity.
- Cooker hints: Cook as macro strategy. Cross-compare with `CR24-S02`: both use auxiliary structure, but this one separates algorithmic roles rather than contracting model features.

### GGSXY25-D04: Error-bound exponent balancing

- Type: `DETAIL`
- Paper location: Theorem 4.1, p. 12; proof outline, p. 31.
- Depends on: `GGSXY25-D03`, `GGSXY25-S02`.
- Local statement: Under singleton `Y*`, the paper balances exploration length and phase stepsizes to obtain `O(T^((gamma-1)/(2gamma-1)) log T)` regret plus violation for finite `gamma`, with special cases such as `O(T^(1/3))` for quadratic growth and `O(log T)` for sharp growth.
- Reusable abstraction: When a proof produces multiple horizon-dependent terms under a Holder error bound, choose exploration and stepsize exponents by minimizing the maximum power of `T` across all terms.
- Proof skeleton: Substitute symbolic exponents for exploration length, exploration stepsize, and exploitation stepsize into the bound from Lemma 4.6. Equate the dominant powers and select the horizon split that keeps exploration cost and exploitation localization cost at the same order.
- Why it is valuable: It avoids ad hoc parameter tuning in multi-phase regret proofs with interacting geometric rates.
- Backtest signal: Legacy card preserved as useful; exact constants are source-specific and should be rederived for new settings.
- Candidate tags: parameter-balancing, holder-growth, regret-rate, min-max-exponents.
- Cooker hints: Cook as local move under convex-error-bounds and link to the macro decoupling strategy.
