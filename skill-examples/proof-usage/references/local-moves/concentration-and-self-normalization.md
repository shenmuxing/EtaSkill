# Concentration And Self-Normalization

Use these local moves when nonlinear gates, confidence radii, or frozen uncertainty objects must be converted into self-normalized sums.

### Sigmoid-gated uncertainty cap

- Category: `local-move`
- Use when: A proof gates a feature, bonus, or value contribution by a decreasing sigmoid of an uncertainty radius.
- Required assumptions: `K >= 1`, `beta > 0`, nonnegative uncertainty radius `y`, and a gate of the form `sigma(-beta y + log K)`.
- Core move: Bound the product of uncertainty and gate scale by `O(log(eK) / beta)`.
- Self-contained statement or template: For `sigma(x)=1/(1+exp(-x))`, `max_{y >= 0} y * sigma(-beta y + log K) <= 2 log(eK) / beta`.
- How to adapt: Use this inside bounded-value or bounded-estimator induction when the term has the form "uncertainty times contracted feature scale." Choose `beta` large enough that the resulting cap is below the target value budget.
- Failure modes: The gate must decrease in the same uncertainty radius that multiplies the term. This does not control an unrelated error term.
- Related entries: Quadratic gate to self-normalized residue; Contract uncertain features instead of warm-up.
- Material sources: `CR24-D01`.
- Public attribution: Cassel and Rosenberg 2024.

### Quadratic gate to self-normalized residue

- Category: `local-move`
- Use when: A clipped or contracted sigmoid term must be charged to squared self-normalized uncertainty plus a small residual.
- Required assumptions: Shifted sigmoid tail `sigma(z - log K)`, `z >= 0`, `K >= 1`, and an elliptical-potential or determinant-growth bound for the resulting squared radii.
- Core move: Replace the sigmoid tail by `O(z^2 + K^{-1})`, then sum the quadratic terms through self-normalized geometry.
- Self-contained statement or template: Use a bound of the form `sigma(z - log K) <= 2(z^2 + K^{-1})`. When `z` is an uncertainty radius, the contraction error becomes a squared-radius term plus a residual that sums to a constant or lower-order term.
- How to adapt: Identify the exact normalized radius, prove the shifted sigmoid inequality, and check that the proof has a potential lemma for the squared radii. Keep the residual visible until summing over time.
- Failure modes: A linear radius sum can be too large. The move needs either squared radii or a separate determinant/epoch argument.
- Related entries: Determinant-doubling epoch control; Sigmoid-gated uncertainty cap.
- Material sources: `CR24-D02`, `CR24-D03`.
- Public attribution: Cassel and Rosenberg 2024.
