# Information Ratio Regret And IDS

Use these strategies when a regret proof is organized around learning a target, paying regret per retained bit, or selecting actions with information-directed sampling.

### Information-ratio regret from retained target information

- Category: `macro-strategy`
- Use when: Per-time expected shortfall can be related to information gained about a target `chi`, possibly over a delayed `tau`-step window.
- Required assumptions: A retained-information process `I(chi;E|P_t)` that is nonincreasing, a shortfall decomposition, and per-time bounds on `Gamma_{tau,epsilon,t}`.
- Core move: Decompose regret into local shortfalls, convert each shortfall into `sqrt(Gamma * information_gain)`, and use Cauchy-Schwarz plus the retained-information telescope.
- Self-contained statement or template: Prove `Regret <= sqrt(I(chi;E) * sum_t Gamma_t) + slack` by showing that the learner pays at most `Gamma_t` squared shortfall per retained bit of target information.
- How to adapt: Choose `chi` and `P_t` first. Then prove a local information-ratio bound in the model at hand. Use the `tau` version when actions reveal their useful information only after delayed transitions.
- Failure modes: The strategy fails if `P_t` forgets target-relevant information or if the denominator counts information not retained in the epistemic state. A small master bound still requires source-specific `Gamma_t` estimates.
- Related entries: Shortfall telescoping against a baseline policy; Tau-step retained-information telescope; Targeted learning tradeoff.
- Material sources: `RLB23-S01`, `RLB23-D01`, `RLB23-D02`.
- Public attribution: Lu, Van Roy, Dwaracherla, Ibrahimi, Osband, and Wen 2023.

### Targeted learning tradeoff

- Category: `macro-strategy`
- Use when: The optimal policy or full environment is too information-heavy, but a compressed, satisficing, or task-specific target may be enough.
- Required assumptions: A target policy `pi_chi`, a way to estimate information `I(chi;E)`, and a bound on the target policy's own regret.
- Core move: Split regret into bits-to-learn, cost-per-bit, and target-policy suboptimality.
- Self-contained statement or template: Bound the learner by `sqrt(I(chi;E) * sum_t Gamma_{tau,pi_chi,t}) + Regret(T|pi_chi)`. Then tune the target so reducing entropy does not create too much target-policy regret.
- How to adapt: Compare candidate targets by their entropy or mutual information, their induced baseline regret, and how easily actions reveal them. Use compressed value functions, satisficing actions, or generalized value functions when they lower the total bound.
- Failure modes: A low-entropy target can be useless if its policy has large regret. A good target can still be hard to learn if the information ratio is large.
- Related entries: Information-ratio regret from retained target information; Variance lower bound for pseudo-information gain.
- Material sources: `RLB23-S02`, `RLB23-S01`.
- Public attribution: Lu, Van Roy, Dwaracherla, Ibrahimi, Osband, and Wen 2023.

### Quantized target for posterior-sampling regret

- Category: `macro-strategy`
- Use when: A Thompson-sampling or posterior-sampling proof needs a discrete target for entropy accounting while the model parameters are continuous.
- Required assumptions: A quantized target whose residual error can be charged, posterior concentration controlled by information gain, and an optimism or comparison argument that orients sampled-model values against true values.
- Core move: Quantize the model component that matters for regret, prove sampled-model error is information-controlled, and feed the resulting slack-adjusted shortfall bound into the information-ratio master theorem.
- Self-contained statement or template: Define `chi` as a grid approximation of the relevant posterior parameter. Show `shortfall - quantization_bias` is controlled by information gained about `chi`; then apply the master theorem and balance the grid size.
- How to adapt: Identify the parameter that actually drives the value error. Reprove the posterior concentration and Bellman-error recursion in the new model. Make the optimism or comparator condition explicit before invoking the master theorem.
- Failure modes: Optimism may be false outside the source's special structure. Quantization constants and residuals can dominate. Continuous targets with strong coupling across coordinates may not admit the same union-bound accounting.
- Related entries: Quantized posterior concentration from information gain; Information-ratio regret from retained target information.
- Material sources: `RLB23-S03`, `RLB23-D03`, `RLB23-S01`.
- Public attribution: Lu, Van Roy, Dwaracherla, Ibrahimi, Osband, and Wen 2023.

### Conditional IDS ratio induction

- Category: `macro-strategy`
- Use when: An IDS-style action rule minimizes a conditional shortfall-information ratio and the proof needs a global regret bound.
- Required assumptions: Conditional formulas for action shortfall and information gain, a way to lift conditional information gains to retained target information, and a terminal or backward-recursive state structure.
- Core move: Bound the conditional ratio state by state, often by backward induction, then use the uniform conditional bound as the global `Gamma` in the master regret theorem.
- Self-contained statement or template: Condition on the agent state, analyze the ratio minimized by IDS, prove `Gamma_cond(x) <= G` for every reachable state, and conclude the unconditional information ratio is also at most `G` by total expectation and mutual-information chain rules.
- How to adapt: Solve the per-state IDS ratio algebra first; use the two-action support lemma to simplify mixtures. If exact mutual information is hard, use a variance lower bound for pseudo-information gain.
- Failure modes: Conditional and unconditional denominators must refer to the same retained information. If the action chosen now affects future information in ways not captured by the conditional objective, the induction needs extra state variables.
- Related entries: Two-action support for IDS ratio objectives; Variance lower bound for pseudo-information gain; Information-ratio regret from retained target information.
- Material sources: `RLB23-S04`, `RLB23-D04`, `RLB23-D05`, `RLB23-S01`.
- Public attribution: Lu, Van Roy, Dwaracherla, Ibrahimi, Osband, and Wen 2023.
