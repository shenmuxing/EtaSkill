# Reinforcement Learning, Bit by Bit

## Source Metadata

- Source kind: `PDF`
- Public title: Reinforcement Learning, Bit by Bit
- Authors: Xiuyuan Lu, Benjamin Van Roy, Vikranth Dwaracherla, Morteza Ibrahimi, Ian Osband, and Zheng Wen
- Year: 2023
- Source file name: `arxiv-2103.04047v8.pdf`
- Public citation: Lu, Van Roy, Dwaracherla, Ibrahimi, Osband, and Wen, "Reinforcement Learning, Bit by Bit" (arXiv:2103.04047v8, 2023).

## Local Index

| ID | Paper location | Type | Short name | Tags | Value |
| --- | --- | --- | --- | --- | --- |
| `RLB23-D01` | Theorem 4.1 and Corollary 4.2 / PDF pp. 35-36 | `DETAIL` | Shortfall telescoping | regret-decomposition, shortfall, Bellman, telescoping | high |
| `RLB23-S01` | Sections 4.3-4.4, Theorem 4.3 / PDF pp. 37-40 | `STRATEGY` | Information-ratio master regret bound | information-ratio, delayed-information, regret-bound, Cauchy-Schwarz | high |
| `RLB23-S02` | Corollary 4.4 and discussion / PDF pp. 40-41 | `STRATEGY` | Target-policy three-factor split | learning-target, proxy-design, target-policy, regret-decomposition | high |
| `RLB23-D02` | Theorem 4.3 proof / PDF pp. 39-40 | `DETAIL` | Tau-step information-gain telescope | information-gain, telescoping, mutual-information, delayed-information | medium |
| `RLB23-D03` | Lemmas A.1-A.4 / PDF pp. 95-102 | `DETAIL` | Quantized beta information concentration | beta-posterior, quantization, concentration, mutual-information | high |
| `RLB23-S03` | Appendix A.2-A.3, Lemma A.5 and Theorem A.6 / PDF pp. 103-111 | `BOTH` | Quantized-target TS episodic regret | Thompson-sampling, episodic-MDP, optimism, quantized-target | medium |
| `RLB23-S04` | Appendix B / PDF pp. 112-115 | `STRATEGY` | Conditional IDS ratio induction | IDS, information-ratio, backward-induction, episodic | medium |
| `RLB23-D04` | Theorem C.1 / PDF pp. 116-118 | `DETAIL` | Two-action support for IDS ratios | IDS, convexity, two-sparse, KKT | medium |
| `RLB23-D05` | Lemmas D.1-D.2 / PDF pp. 119-122 | `DETAIL` | Mutual information to variance lower bound | information-variance, Pinsker, covariance, pseudo-observation | high |

## Items

### RLB23-D01: Shortfall telescoping

- Type: `DETAIL`
- Paper location: Section 4.1, Theorem 4.1 and Corollary 4.2, PDF pp. 35-36.
- Depends on: finite-horizon value definitions `V_pi`, `Q_pi`, an agent policy generating actions, and Bellman consistency for the baseline policy.
- Local statement: The performance gap between a baseline policy and the agent can be written as a sum of expected one-step shortfalls `V_pi(H_t) - Q_pi(H_t, A_t)` along the agent trajectory. Taking the baseline as an optimal policy gives the corresponding regret decomposition.
- Reusable abstraction: Convert a global policy-regret statement into local shortfall terms that can be bounded by bonuses, information gain, optimism, or online-learning errors.
- Proof skeleton: Expand `V_pi(H_0) - sum_t R_{t+1}`. Add and subtract `V_pi(H_{t+1})` across time, telescope the value terms, and use the definition of `Q_pi(H_t,A_t)` as the conditional expectation of immediate reward plus next value.
- Why it is valuable: It is the entry point for information-ratio regret proofs: once regret is written as local shortfall, each term can be paired with an information-gain denominator.
- Backtest signal: Standard telescoping lemma; self-contained given Bellman definitions; no source-specific content beyond sign convention.
- Candidate tags: regret-decomposition, shortfall, telescoping, Bellman.
- Cooker hints: Cook as a local move. Keep the sign convention explicit because some papers write the performance-difference lemma in the opposite direction.

### RLB23-S01: Information-ratio master regret bound

- Type: `STRATEGY`
- Paper location: Sections 4.3-4.4, Theorem 4.3, PDF pp. 37-40.
- Depends on: `RLB23-D01`, `RLB23-D02`, nonincreasing retained uncertainty `I(chi;E|P_t)`, and per-time information-ratio bounds.
- Local statement: With a `tau`-step information ratio defined as squared positive shortfall divided by retained information gain per step, cumulative regret is bounded by `sqrt(I(chi;E) * sum_t Gamma_{tau,epsilon,t}) + sum_t epsilon_t`.
- Reusable abstraction: To prove a regret bound, define a learning target `chi`, show that the agent's shortfall is cheap per retained bit, and then combine local information-ratio bounds through Cauchy-Schwarz and an information telescope.
- Proof skeleton: Use `RLB23-D01` to write regret as a sum of shortfalls. Replace each positive slack-adjusted shortfall by `sqrt(Gamma_t * Delta I_t / tau)`. Apply Cauchy-Schwarz to separate `sum Gamma_t` from the total information decrease. Use `RLB23-D02` to upper-bound the information decrease by `I(chi;E)`.
- Why it is valuable: It gives a reusable master theorem for delayed exploration, suboptimal baselines, and target-dependent regret analysis.
- Backtest signal: Core information-ratio framework; the Cauchy-Schwarz plus telescoping skeleton is self-contained; deriving each per-step `Gamma` is environment-dependent.
- Candidate tags: information-ratio, delayed-information, regret-bound, Cauchy-Schwarz, master-theorem.
- Cooker hints: Cook as a macro strategy. State clearly that the theorem does not itself prove a small `Gamma`; that is the source-specific work.

### RLB23-S02: Target-policy three-factor split

- Type: `STRATEGY`
- Paper location: Corollary 4.4 and surrounding discussion, PDF pp. 40-41.
- Depends on: `RLB23-S01`, `RLB23-D01`, a target policy `pi_chi`, and a learning target `chi`.
- Local statement: Choosing the slack sequence to compare optimal shortfall with target-policy shortfall yields `Regret(agent) <= sqrt(I(chi;E) * sum_t Gamma_{tau,pi_chi,t}) + Regret(pi_chi)`.
- Reusable abstraction: Separate an agent-design proof into three factors: how many bits the target requires, how expensive the agent makes each useful bit, and how much regret remains after the target is known.
- Proof skeleton: Apply the master bound with the baseline-induced slack. The slack sum is exactly the target policy's regret by the shortfall decomposition, leaving the information-ratio term against `pi_chi`.
- Why it is valuable: It turns target selection, proxy design, and action selection into separately checkable proof obligations.
- Backtest signal: Clean three-way decomposition; proof logic is self-contained given the master bound; the identity of the target policy is the source-dependent variable.
- Candidate tags: learning-target, proxy-design, target-policy, information-ratio, regret-decomposition.
- Cooker hints: Cook as a macro strategy for proof planning. It is especially useful when an optimal policy is too information-heavy and a satisficing or compressed target is acceptable.

### RLB23-D02: Tau-step information-gain telescope

- Type: `DETAIL`
- Paper location: Theorem 4.3 proof, PDF pp. 39-40.
- Depends on: nonnegative mutual information and monotonicity of `I_t = I(chi;E|P_t)`.
- Local statement: For `tau >= 1`, `(1/tau) * sum_{t=0}^{T-1} (I_t - I_{t+tau}) <= I_0` when `I_t` is nonincreasing and nonnegative.
- Reusable abstraction: Delayed information-gain denominators can be averaged over overlapping `tau`-windows without paying an extra factor of `tau`.
- Proof skeleton: Expand `I_t - I_{t+tau}` as `sum_{k=0}^{tau-1} (I_{t+k} - I_{t+k+1})`, swap sums, telescope each shifted chain from `P_k` to `P_{T+k}`, drop the nonnegative tail, and use monotonicity to bound each `I_k` by `I_0`.
- Why it is valuable: It is the subtle accounting move that makes `tau`-step information ratios usable in regret bounds for delayed exploration.
- Backtest signal: Trivial index-shift proof; monotonicity is the assumption to verify; the `tau`-generalized form is the valuable part.
- Candidate tags: information-gain, telescoping, mutual-information, delayed-information.
- Cooker hints: Cook as a local move and cross-link to information-ratio regret entries.

### RLB23-D03: Quantized beta information concentration

- Type: `DETAIL`
- Paper location: Appendix A.1, Lemmas A.1-A.4, PDF pp. 95-102.
- Depends on: independent Beta posterior components with parameters at least one, Bernoulli observations, a quantization grid `delta = 1/m`, and mutual information measured in nats.
- Local statement: In a Beta-Bernoulli posterior, information from a Bernoulli observation controls the deviation between an independent posterior sample and the true posterior parameter; after quantization and union bounding over components, the deviation is bounded by a square-root information term plus quantization residuals.
- Reusable abstraction: When a Thompson-sampling proof needs a finite-entropy target, quantize continuous posterior parameters and pay an explicit residual while keeping information-gain control over sampled-model error.
- Proof skeleton: Use a Beta-specific sub-Gaussian tail to bound `|p - p_hat|` by information `I(p;b)`. Union-bound across `N` components. Quantize `p` to `q = delta ceil(p/delta)`, compare `I(q;b)` to `I(p;b)` through data processing plus a quantization KL loss, and add the `delta` residual.
- Why it is valuable: It is a reusable bridge from continuous posterior sampling to discrete learning targets that can be charged through entropy.
- Backtest signal: Concentration backbone is generic; the Beta-specific constants are source-derived; the proof skeleton is clear without them.
- Candidate tags: beta-posterior, quantization, concentration, mutual-information, Thompson-sampling.
- Cooker hints: Cook as a local move with strong warnings about prior family and constants. Do not reuse the Beta constants for arbitrary posteriors.

### RLB23-S03: Quantized-target TS episodic regret

- Type: `BOTH`
- Paper location: Appendix A.2-A.3, Conjecture A.2.1, Lemma A.5, and Theorem A.6, PDF pp. 103-111.
- Depends on: `RLB23-S01`, `RLB23-D03`, a ring-like episodic MDP, a quantized transition target `chi`, and the source's optimism conjecture for posterior-sampled values.
- Local statement: For the ring MDP analyzed in the source, a quantized transition target plus an optimism condition lets Thompson sampling bound slack-adjusted shortfall by information gained about the target, then invoke the master information-ratio theorem for an episodic regret bound.
- Reusable abstraction: In posterior-sampling regret proofs, isolate a finite-entropy learning target, prove a sampled-model Bellman-error recursion controlled by information gain, and use a slack term to absorb quantization bias.
- Proof skeleton: Quantize transition probabilities to define `chi`. Use `RLB23-D03` to control sampled transition error by information gain plus residual. Propagate the transition error through a Bellman recursion over the episode. Invoke the optimism conjecture to orient the comparison against optimal values. Convert the resulting squared positive shortfall bound into a `tau`-information-ratio bound and apply `RLB23-S01`.
- Why it is valuable: It demonstrates how to assemble local information-concentration lemmas into a full Thompson-sampling regret argument.
- Backtest signal: Proof architecture is clear, but the optimism mechanism, quantization tuning, and ring-MDP algebra are source-dependent; reconstructing the full bound from the abstraction alone is unreliable.
- Candidate tags: Thompson-sampling, episodic-MDP, optimism, quantized-target, regret-bound.
- Cooker hints: Cook as a conditional macro strategy. The optimism conjecture must remain visible as an assumption, not a proven generic fact.

### RLB23-S04: Conditional IDS ratio induction

- Type: `STRATEGY`
- Paper location: Appendix B, PDF pp. 112-115.
- Depends on: value-IDS action probabilities, per-state shortfall and information-gain formulas, and `RLB23-S01`.
- Local statement: In the episodic IDS example, bounding conditional information ratios by backward induction over states gives a uniform bound on the global `tau`-information ratio, which then yields regret through the master theorem.
- Reusable abstraction: Prove IDS regret by first conditioning on the agent state, bounding the ratio that the action distribution minimizes, and only then lifting the conditional bound to the unconditional information ratio.
- Proof skeleton: Express conditional shortfall and information gain as functions of the IDS action probability. Solve or bound the one-step ratio. Start at the terminal state and induct backward, splitting cases according to whether the informative action is selected with probability one or mixed. Use law of total expectation and mutual-information chain rules to lift the conditional ratio bound.
- Why it is valuable: It gives a proof template for converting an IDS one-step optimization objective into a global delayed-information regret bound.
- Backtest signal: Conditional-ratio induction is reusable, but the shortfall and information-gain algebra is environment-specific.
- Candidate tags: IDS, information-ratio, backward-induction, episodic, regret-bound.
- Cooker hints: Cook as a macro strategy. Keep the environment-specific algebra separate from the reusable conditional-to-global structure.

### RLB23-D04: Two-action support for IDS ratios

- Type: `DETAIL`
- Paper location: Appendix C, Theorem C.1, PDF pp. 116-118.
- Depends on: vectors `alpha`, `beta`, simplex action distributions `nu`, and positivity `nu^T beta > 0`.
- Local statement: The IDS objective `psi(nu) = (nu^T alpha)^2 / (nu^T beta)` is convex over its positive-denominator domain, and a simplex minimizer exists with support size at most two.
- Reusable abstraction: Fractional IDS objectives that depend only on expected shortfall and expected information gain can be optimized by searching over action pairs rather than arbitrary mixtures.
- Proof skeleton: View `psi` as the convex quadratic-over-linear map `(x,y) -> x^2/y` composed with the affine statistics `(nu^T alpha, nu^T beta)`. For support reduction, compare minimizers through the equivalent quadratic residual objective and use KKT conditions to move mass onto at most two support points preserving the relevant linear statistic.
- Why it is valuable: It turns an apparently high-dimensional action-mixture optimization into a tractable two-action search and supports computational IDS arguments.
- Backtest signal: Fully self-contained convex-analysis lemma; no source-specific content; belongs in a general-purpose proof-usage reference.
- Candidate tags: IDS, convexity, two-sparse, KKT, fractional-program.
- Cooker hints: Cook as a local move under IDS optimization. State that positivity of the information denominator is required.

### RLB23-D05: Mutual information to variance lower bound

- Type: `DETAIL`
- Paper location: Appendix D, Lemmas D.1-D.2, PDF pp. 119-122.
- Depends on: pseudo-observations `Y = Q_dagger(H,a) + W`, componentwise bounded span for `Q_dagger` and `W`, chain rule for mutual information, and Pinsker's inequality.
- Local statement: Conditional mutual information about a target policy or GVF is lower-bounded by a constant times the trace of a conditional covariance of `Q_dagger` expectations, with scale set by the squared span of the pseudo-observation components.
- Reusable abstraction: Replace hard-to-compute pseudo-information gain in value-IDS by a variance proxy when bounded-span assumptions let Pinsker convert distributional separation into mean-separation variance.
- Proof skeleton: Use the mutual-information chain rule and nonnegativity to reduce to componentwise KL terms. Apply Pinsker in nats, then use bounded span to lower-bound total variation by normalized mean separation. Average over the target variable to obtain a conditional variance, sum components, and rewrite the sum as a covariance trace.
- Why it is valuable: It justifies variance-IDS as a proof-compatible surrogate for information-directed action selection.
- Backtest signal: The Pinsker-to-variance chain is generic; the constant and bounded-span verification for pseudo-observations are the source-dependent checks.
- Candidate tags: information-variance, Pinsker, covariance, pseudo-observation, variance-IDS.
- Cooker hints: Cook as a local move and cross-link to IDS macro entries. Keep the span constant and log-base convention explicit.
