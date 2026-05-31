# Proof Strategies

This legacy compatibility module stores reusable macro proof architectures from the earlier flat library.

New proof agents should start at [index.md](index.md). The entries below have been migrated into indexed category files and linked from [source-map.md](source-map.md); keep this file only for compatibility while older prompts still reference it.

<!-- Entries mined by proof-finder belong below. -->

### Contract Uncertain Features Instead Of Running Warm-Up Exploration

- Type: `STRATEGY`
- Use when: A linear estimator or linear MDP algorithm needs bounded value estimates before the covariance matrix has explored all relevant directions.
- Idea: Replace each feature `phi` by a contracted feature `bar_phi = g(u(phi)) phi`, where `u(phi)=sqrt(phi^T Lambda^{-1} phi)` and `g` decreases for large uncertainty, such as `g(u)=sigma(-beta u + log K)`. Prove estimates using the contracted model, then bound the bias from replacing `phi` by `bar_phi` using a sigmoid cap and an elliptical potential or determinant argument.
- Why it is non-obvious: It avoids a separate reward-free warm-up phase by deliberately degenerating the model in poorly explored regions while keeping the analysis inside the main online algorithm.
- Transfer note: Make the card quantitative before use: specify `g`, the target value-error metric, and the self-normalized sum that controls total contraction bias.
- Source: Cassel and Rosenberg, "Warm-up Free Policy Optimization: Improved Regret in Linear Markov Decision Processes" (2024).

### Bias, Online-Learning, And Optimism Regret Decomposition

- Type: `STRATEGY`
- Use when: A policy optimization or online control proof combines an estimated model, optimistic values, and online mirror descent policy updates.
- Idea: Decompose regret into three separately controlled terms: the bias or cost of optimism between the real and estimated/contracted models, the local online mirror descent regret of the policy updates, and an optimism term showing the estimated values are favorable enough relative to the comparator.
- Why it is non-obvious: The model-estimation error is not treated as a single confidence bonus; it is routed through a contracted auxiliary model so the online-learning regret can be analyzed with simpler bounded values.
- Transfer note: Use this when a direct value-difference lemma gives a messy error term; create an auxiliary model where the policy update is clean, then pay an explicit bias term.
- Source: Cassel and Rosenberg, "Warm-up Free Policy Optimization: Improved Regret in Linear Markov Decision Processes" (2024).

### Decouple Dual Learning From Online Decision-Making

- Type: `STRATEGY`
- Use when: An online allocation, online LP, or constrained online learning proof uses a dual variable both to learn the population optimum and to make irrevocable online decisions.
- Idea: Maintain separate dual sequences. A learner sequence uses a statistically efficient schedule to localize near the dual optimal set. A decision sequence uses a stepsize suitable for online adaptivity, periodically restarting or anchoring near the learner's current estimate once localization is accurate enough.
- Why it is non-obvious: The best stepsize for identifying the dual optimum can be the wrong stepsize for decisions; a single sequence may optimize one role while failing the other.
- Transfer note: Prove the need for separation with a low-dimensional counterexample when possible, then analyze the final algorithm by splitting regret into learning/localization cost and decision-phase adaptive cost.
- Source: Gao, Ge, Sun, Xue, and Ye, "Beyond O(sqrt(T)) Regret: Decoupling Learning and Decision-making in Online Linear Programming" (2025).

### Error-Bound Accelerated Learn-Then-Localize Regret

- Type: `STRATEGY`
- Use when: A convex dual objective for an online decision problem satisfies a Holder error bound around its optimal set.
- Idea: First learn an approximate dual optimizer. Use the error bound `f(y)-f* >= mu dist(y,Y*)^gamma` to convert objective accuracy into distance-to-solution localization. Then restart the online decision process from that localized region, balancing exploration cost, localization error, and exploitation stepsize error.
- Why it is non-obvious: The proof improves regret by using geometry of the dual optimum set, not by merely sharpening the online gradient bound.
- Transfer note: This strategy is strongest when the proof can verify the error-bound exponent from problem structure, such as polyhedral weak sharpness or quadratic growth.
- Source: Gao, Ge, Sun, Xue, and Ye, "Beyond O(sqrt(T)) Regret: Decoupling Learning and Decision-making in Online Linear Programming" (2025).
