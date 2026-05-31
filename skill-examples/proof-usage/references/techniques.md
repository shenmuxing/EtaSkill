# Proof Techniques

This legacy compatibility module stores reusable local proof moves from the earlier flat library.

New proof agents should start at [index.md](index.md). The entries below have been migrated into indexed category files and linked from [source-map.md](source-map.md); keep this file only for compatibility while older prompts still reference it.

<!-- Entries mined by proof-finder belong below. -->

### Sigmoid-Gated Uncertainty Cap

- Type: `DETAIL`
- Use when: A proof gates an estimated feature, bonus, or value contribution by a decreasing sigmoid of an uncertainty radius.
- Self-contained statement: Let `sigma(x)=1/(1+exp(-x))`, `beta>0`, and `K>=1`. Then `sup_{y>=0} y sigma(-beta y + log K) <= C log(eK)/beta` for a universal constant `C`.
- Proof move: Substitute `t=beta y` and maximize `t/(1+K^{-1} exp(t))`. The derivative condition gives `K=exp(t)(t-1)` at an interior maximizer, so the maximum is comparable to `t-1`, which is at most logarithmic in `K`.
- Transfer note: Use this to show that high-uncertainty points cannot dominate a gated estimator, even before the design matrix has explored them well.
- Source: Cassel and Rosenberg, "Warm-up Free Policy Optimization: Improved Regret in Linear Markov Decision Processes" (2024).

### Shifted Sigmoid To Quadratic Residue

- Type: `DETAIL`
- Use when: A clipped sigmoid term must be converted into a quadratic self-normalized quantity plus a small residual.
- Self-contained statement: For `z>=0` and `K>=1`, bounds of the form `sigma(z-log K) <= C(z^2 + K^{-1})` hold with a universal constant `C`.
- Proof move: Split into small and large `z`. When `z` is small, the shifted sigmoid is controlled by the `K^{-1}` tail and a constant multiple of `z^2`; when `z` is large, the right side already dominates a constant.
- Transfer note: Pair this with an elliptical potential lemma to replace nonlinear gate probabilities by sums of squared uncertainty radii.
- Source: Cassel and Rosenberg, "Warm-up Free Policy Optimization: Improved Regret in Linear Markov Decision Processes" (2024).

### Determinant-Doubling Epoch Count

- Type: `DETAIL`
- Use when: An algorithm freezes a policy class, feature map, confidence bonus, or other complexity-controlling object inside epochs and restarts only after enough covariance growth.
- Self-contained statement: Let `Lambda_h^k = lambda I + sum_{t<k} x_{t,h} x_{t,h}^T` in `R^d`, with `||x_{t,h}||<=1`. If an epoch for horizon `h` restarts only when `det(Lambda_h^k) >= 2 det(Lambda_h^{k_e})`, then the total number of restarts over `H` horizons and `K` episodes is `O(d H log(1+K/lambda))`.
- Proof move: Each restart doubles the determinant, while the final determinant is bounded by AM-GM from the trace: `det(Lambda_h^K) <= (lambda + K/d)^d` up to constants. Taking logs bounds the number of doublings.
- Transfer note: Use this to justify epochwise freezing of objects that would otherwise make a policy or value class too complex for uniform concentration.
- Source: Cassel and Rosenberg, "Warm-up Free Policy Optimization: Improved Regret in Linear Markov Decision Processes" (2024).

### Population Distance From Empirical Optimality Under Error Bounds

- Type: `DETAIL`
- Use when: An empirical convex objective is uniformly close to a population objective and the population objective has a growth/error-bound condition.
- Self-contained statement: Let `F_T` and `F` be objectives on compact `Y`, let `y_T` minimize `F_T`, and assume `sup_y |F_T(y)-F(y)| <= eps`. If `F(y)-F* >= mu dist(y,Y*)^gamma`, then `dist(y_T,Y*) <= (2 eps / mu)^(1/gamma)`.
- Proof move: For any `y* in Y*`, empirical optimality gives `F_T(y_T)<=F_T(y*)`. Add and subtract `F_T` around `F(y_T)-F(y*)` to obtain `F(y_T)-F* <= 2 eps`, then apply the error bound.
- Transfer note: This is a compact way to turn epsilon-net uniform convergence into localization of empirical dual optimizers.
- Source: Gao, Ge, Sun, Xue, and Ye, "Beyond O(sqrt(T)) Regret: Decoupling Learning and Decision-making in Online Linear Programming" (2025).

### Error-Bound Parameter Balancing

- Type: `DETAIL`
- Use when: A regret proof has exploration length, learned accuracy, and exploitation stepsize exponents that must be balanced under a Holder error bound.
- Self-contained statement: Under an error bound with exponent `gamma>=1`, decompose regret into powers of `T` from exploration cost, localization error, exploitation drift, and error-bound conversion terms. Choose exponents by minimizing the maximum exponent across all terms.
- Proof move: Write each regret component as `T^a` after substituting `T_e=T^beta`, learned accuracy `Delta=T^{-rho}`, and stepsize `alpha=T^{-lambda}`. Solve the resulting finite min-max problem over exponent variables rather than tuning terms sequentially.
- Transfer note: Use this when a proof has several interacting rates and the final theorem needs a clean exponent such as `(gamma-1)/(2gamma-1)`.
- Source: Gao, Ge, Sun, Xue, and Ye, "Beyond O(sqrt(T)) Regret: Decoupling Learning and Decision-making in Online Linear Programming" (2025).
