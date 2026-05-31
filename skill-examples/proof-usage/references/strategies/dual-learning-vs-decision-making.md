# Dual Learning Vs Decision-Making

Use these macro strategies when a dual or control variable is asked to serve both as a statistically accurate learner and as an adaptive online decision state.

### Learn then localize

- Category: `macro-strategy`
- Use when: The population dual optimum is unknown, but an error-bound condition lets a first-order learner localize it from samples.
- Required assumptions: Error-bound condition, a learning algorithm with objective or distance guarantees, and a decision-phase analysis that improves when initialized near the optimal set.
- Core move: Explore long enough to learn a dual anchor, then exploit with a decision update localized around that anchor.
- Self-contained statement or template: Choose a target localization radius, set exploration length from the learner's sample complexity, then run the decision method from the learned point with a stepsize tuned to the localized regret bound.
- How to adapt: Keep exploration cost and exploitation benefit in the same inequality. If the learned point is only close to a set, use distance-to-set language and preserve any diameter term.
- Failure modes: Using the learner's own iterates for online decisions can be suboptimal; pair this strategy with the decoupling check below.
- Related entries: Error-bound localization from empirical optimality; Localized dual-regret decomposition; Decouple learning from decision-making.
- Material sources: `GGSXY25-S01`, `GGSXY25-D01`, `GGSXY25-D02`, `GGSXY25-D03`.
- Public attribution: Gao, Ge, Sun, Xue, and Ye 2025.

### Decouple learning from decision-making

- Category: `macro-strategy`
- Use when: The stepsize or update schedule that learns a high-accuracy parameter is too slow, too aggressive, or otherwise wrong for online decisions.
- Required assumptions: A cheap enough first-order update to maintain two sequences, a learning guarantee for the anchor, and a decision regret decomposition that can restart from the anchor.
- Core move: Maintain separate paths: one optimized for learning accuracy and one optimized for decision adaptivity. At handoff, restart or anchor the decision path near the learned point.
- Self-contained statement or template: A single sequence can fail because pure learning wants small steps near convergence, while online decisions need enough movement to correct noise and adapt to arrivals. Split the roles and tune the decision stepsizes to the regret decomposition.
- How to adapt: Identify the conflicting objectives before adding a second path. Prove the decision path controls exploration-phase regret, then prove the learned anchor improves exploitation.
- Failure modes: Two paths do not help if the final regret bound cannot use the learned anchor or if exploration regret is uncontrolled.
- Related entries: Constant-stepsize noise ball; Error-bound rate balancing; Controlled surrogate before full regret accounting.
- Material sources: `GGSXY25-S02`, `GGSXY25-D04`.
- Public attribution: Gao, Ge, Sun, Xue, and Ye 2025.
