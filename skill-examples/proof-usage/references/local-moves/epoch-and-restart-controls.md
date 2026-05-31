# Epoch And Restart Controls

Use these local moves when a proof freezes policies, confidence objects, bonuses, feature maps, or stepsizes and restarts only when a measurable geometry changes.

### Determinant-doubling epoch control

- Category: `local-move`
- Use when: An algorithm freezes an object inside an epoch and restarts when a covariance or design matrix determinant doubles.
- Required assumptions: Positive definite design matrices, bounded features or increments, and a restart rule based on determinant growth.
- Core move: Use determinant doubling to limit epoch count and determinant comparison to transfer norms between the epoch-start matrix and the current matrix.
- Self-contained statement or template: If `Lambda_k` grows by positive semidefinite updates and an epoch restarts only when `det(Lambda_k) >= 2 det(Lambda_start)`, then each coordinate/horizon can restart only logarithmically many times in total design growth. Within an epoch, determinant comparison bounds `||v||_{Lambda_start^{-1}}` by a constant multiple of `||v||_{Lambda_k^{-1}}`.
- How to adapt: Define the matrix whose geometry controls the frozen object, prove monotone PSD growth, and upper-bound the final determinant by trace or dimension. Use a standard elliptical-potential lemma for cumulative radii.
- Failure modes: The frozen object must depend only on the epoch-start geometry. If it changes continuously inside the epoch, determinant accounting no longer isolates complexity.
- Related entries: Quadratic gate to self-normalized residue; Contract uncertain features instead of warm-up.
- Material sources: `CR24-D03`.
- Public attribution: Cassel and Rosenberg 2024.
