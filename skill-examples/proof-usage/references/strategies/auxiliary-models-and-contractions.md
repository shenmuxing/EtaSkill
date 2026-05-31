# Auxiliary Models And Contractions

Use these macro strategies when the direct proof object is too unstable, too complex, or insufficiently explored, but a conservative auxiliary object can carry the analysis.

### Contract uncertain features instead of warm-up

- Category: `macro-strategy`
- Use when: A linear estimator or linear MDP algorithm needs bounded value estimates before the covariance matrix has explored all relevant directions.
- Required assumptions: Known feature map, self-normalized uncertainty radii, a decreasing gate, and a way to bound contraction bias along the learner trajectory.
- Core move: Replace each feature by a contracted feature `bar_phi = g(u(phi)) phi`, analyze the auxiliary contracted model, and charge the true-versus-contracted gap through sigmoid and elliptical-potential bounds.
- Self-contained statement or template: If high uncertainty makes value estimates or policy classes too complex, shrink the contribution of high-uncertainty directions instead of running a separate warm-up. The proof then needs a bounded-value induction plus a cumulative contraction-bias bound.
- How to adapt: Specify the gate, the matrix defining uncertainty, the object frozen within epochs, and the potential bound that pays for contraction. Keep the contraction conservative enough for optimism or comparator arguments.
- Failure modes: The gate must not destroy the comparator argument. If contraction bias is only controlled for the learner trajectory, the regret decomposition must avoid requiring uniform comparator control under the true model.
- Related entries: Sigmoid-gated uncertainty cap; Quadratic gate to self-normalized residue; Determinant-doubling epoch control.
- Material sources: `CR24-S01`, `CR24-D01`, `CR24-D02`, `CR24-D03`.
- Public attribution: Cassel and Rosenberg 2024.

### Auxiliary model regret decomposition

- Category: `macro-strategy`
- Use when: A direct value-difference or regret decomposition has an uncontrolled comparator or invalid model term, but a safer auxiliary model is conservative.
- Required assumptions: Auxiliary values lower-bound or conservatively compare to true comparator values, and a value-difference lemma or equivalent decomposition is available in the auxiliary model.
- Core move: Route regret through cost of optimism, online-learning regret, and optimism terms in the auxiliary model, then separately pay the bias between auxiliary and true learner performance.
- Self-contained statement or template: Prove `aux_value(comparator) <= true_value(comparator)`, decompose `true_learner - aux_comparator`, and bound the pieces with online-learning and optimism arguments.
- How to adapt: Identify the exact conservative relation first. Then choose the expectation/model under which each term is valid and ensure the bias term is charged only where it can be controlled.
- Failure modes: If the auxiliary model is not conservative for the comparator, the decomposition can prove regret to the wrong benchmark.
- Related entries: Contract uncertain features instead of warm-up; Controlled surrogate before full regret accounting.
- Material sources: `CR24-S02`.
- Public attribution: Cassel and Rosenberg 2024.

### Controlled surrogate before full regret accounting

- Category: `source-bridge`
- Use when: A proof cannot safely run the main online update over the full, uncertain object from the beginning.
- Required assumptions: There is a surrogate that is either conservative for the comparator or localizes decisions near the right object, and the cost of using the surrogate can be bounded.
- Core move: Introduce a controlled surrogate before final regret accounting, but choose the surrogate type according to the failure mode.
- Self-contained statement or template: Cassel and Rosenberg contract uncertain features to make a linear MDP policy-optimization proof stable without warm-up. Gao, Ge, Sun, Xue, and Ye separate dual learning from decision-making so the learner can obtain an accurate anchor while the decision path keeps an adaptive stepsize. Both patterns delay or modify direct use of the full object, but one changes the model geometry and the other separates algorithmic roles.
- How to adapt: If the obstacle is unbounded estimates or unsafe model geometry, consider a contracted auxiliary model. If the obstacle is conflicting update schedules, consider separate learning and decision paths with a restart or handoff.
- Failure modes: Do not merge these strategies blindly. Contraction needs bias control; dual decoupling needs a localized regret decomposition and a rate balance.
- Related entries: Auxiliary model regret decomposition; Decouple learning from decision-making.
- Material sources: `CR24-S02`, `GGSXY25-S02`.
- Public attribution: Cassel and Rosenberg 2024; Gao, Ge, Sun, Xue, and Ye 2025.
