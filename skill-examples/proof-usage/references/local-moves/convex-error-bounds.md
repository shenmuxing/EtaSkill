# Convex Error Bounds

Use these local moves when convex or dual objectives have growth around an optimal set and the proof needs localization, stepsize tuning, or rate balancing.

### Error-bound localization from empirical optimality

- Category: `local-move`
- Use when: A learned or empirical objective is uniformly close to a population objective and the population objective satisfies an error-bound condition.
- Required assumptions: Uniform objective error and a growth condition `F(y)-F* >= mu * dist(y,Y*)^gamma` on the relevant domain.
- Core move: Convert objective accuracy into distance-to-solution-set accuracy.
- Self-contained statement or template: If `sup_y |F_T(y)-F(y)| <= eps` and `y_T` minimizes `F_T`, then `F(y_T)-F* <= 2 eps`; hence `dist(y_T,Y*) <= (2 eps / mu)^(1/gamma)`.
- How to adapt: First prove the uniform or high-probability objective gap. Then apply the error bound on the same domain. State whether `Y*` is a singleton or a set.
- Failure modes: The conclusion is geometric only where the error bound holds. Non-singleton optimal sets require distance-to-set language.
- Related entries: Constant-stepsize noise ball; Learn then localize.
- Material sources: `GGSXY25-D01`.
- Public attribution: Gao, Ge, Sun, Xue, and Ye 2025.

### Constant-stepsize noise ball

- Category: `local-move`
- Use when: A decision algorithm starts near an optimal set and should remain adaptive rather than converge with a vanishing learning stepsize.
- Required assumptions: Projected subgradient-style update, bounded stochastic gradients, initial distance `Delta` to the optimal set, and an error-bound condition if distance control is needed.
- Core move: Bound the last iterate by a term like `Delta^2/(alpha T) + alpha log T`, then convert to distance under the error bound.
- Self-contained statement or template: A constant stepsize creates a noise ball whose size reflects the starting distance and the chosen adaptivity level. Smaller `alpha` reduces noise but can reduce online responsiveness.
- How to adapt: Choose `alpha` from the regret decomposition, not from pure optimization convergence alone. Use the final distance term only after checking the update stays in the valid domain.
- Failure modes: A stepsize schedule optimized for final objective accuracy can be too small for online decisions.
- Related entries: Localized dual-regret decomposition; Decouple learning from decision-making.
- Material sources: `GGSXY25-D02`.
- Public attribution: Gao, Ge, Sun, Xue, and Ye 2025.

### Localized dual-regret decomposition

- Category: `local-move`
- Use when: An online primal-dual regret proof can express performance through initial and final distances to a dual optimal set.
- Required assumptions: Projected dual update, regret and violation metrics tied to the dual sequence, and a way to bound `dist(y1,Y*)` and `dist(y_{T+1},Y*)`.
- Core move: Decompose performance into `alpha T + dist(y1,Y*)/alpha + E[dist(y_{T+1},Y*)]/alpha`, then use localization to improve the optimal stepsize.
- Self-contained statement or template: Standard `O(sqrt(T))` regret comes from bounded distances and `alpha = T^{-1/2}`. If localization gives `dist(y1,Y*)` and final distance `o(1)`, balance the smaller distance terms against `alpha T` for a better rate.
- How to adapt: Derive the exact distance-weighted inequality for the user's update. Substitute the available localization result before solving the exponent balance.
- Failure modes: The decomposition is fragile if the primal decision rule is not tied to the dual update or if constraint violation cannot be telescoped.
- Related entries: Constant-stepsize noise ball; Error-bound rate balancing.
- Material sources: `GGSXY25-D03`.
- Public attribution: Gao, Ge, Sun, Xue, and Ye 2025.

### Error-bound rate balancing

- Category: `local-move`
- Use when: Exploration length, learning accuracy, and exploitation stepsize exponents interact under a Holder error-bound condition.
- Required assumptions: A finite list of performance terms expressible as powers of horizon `T`, an error-bound exponent `gamma`, and tunable phase lengths or stepsizes.
- Core move: Convert every term to a `T` exponent and choose parameters by minimizing the maximum exponent.
- Self-contained statement or template: For singleton optimal sets under a `gamma`-error bound, a two-phase first-order OLP analysis can balance terms to obtain a rate of order `T^((gamma-1)/(2gamma-1))` up to logarithms.
- How to adapt: Write exploration length as `T^a`, learning accuracy as `T^{-b}`, and stepsizes as powers of `T`. Equate dominant exponents and keep residual/log factors separate.
- Failure modes: Constants and logs often depend on the domain and gradient bounds. Do not reuse the exponent if the decomposition terms differ.
- Related entries: Localized dual-regret decomposition; Decouple learning from decision-making.
- Material sources: `GGSXY25-D04`.
- Public attribution: Gao, Ge, Sun, Xue, and Ye 2025.
