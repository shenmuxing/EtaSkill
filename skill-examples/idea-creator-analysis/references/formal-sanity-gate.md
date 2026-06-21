# Formal Sanity Gate

Apply this gate before ranking a theory-first idea. It is a filter for mathematical plan quality, not a full proof.

## Hard Reject or Weaken

Reject the candidate as stated, or weaken it to a diagnostic/conjecture plan, if any item holds:

- The main theorem relies on an exact identity that has not been derived from definitions.
- A constrained RL object, such as an occupancy measure, is treated as an unconstrained simplex without flow constraints.
- A formula meant to unify two regimes is undefined, infinite, or vacuous in one of the advertised regimes.
- A proof lever assumes the target conclusion, such as using monotonic improvement to prove monotonic improvement.
- The idea's novelty is only a renamed version of policy mirror descent, regularized MDPs, natural policy gradient, TRPO/PPO trust-region analysis, or occupancy-measure optimization.
- A proposed convergence modulus is claimed to depend only on the parameterization while the rate actually depends on MDP rewards, advantage gaps, occupancy coverage, initialization, step size, or oracle model.
- A necessity theorem claims "no first-order algorithm" without a precise oracle model, algorithm class, MDP family, and information budget.
- A PG-vs-PI separation theorem does not explicitly define the hard MDP's states, actions, transitions, reward location, initial distribution, initial policy, update rule, and oracle access.
- A lower bound for exact PG is stated as a lower bound for all first-order methods. Keep exact-gradient PG/NPG lower bounds separate from information-theoretic or oracle lower bounds.

## Required Checks

For each top candidate, record:

1. **Definition check**: all objects in the theorem are defined and live in the right domain.
2. **Boundary check**: the theorem remains meaningful at the advertised limits or states separate limit theorems.
3. **Known-framework check**: explain why the idea is not merely an instance of policy mirror descent, regularized MDPs, or occupancy optimization.
4. **Derivation check**: mark every nonstandard equality as `proved`, `lemma candidate`, or `unsupported`.
5. **Failure value**: if the central lemma fails, state the publishable negative result or drop the idea.
6. **Scope check**: replace global iff claims with one of:
   - a sufficient condition with explicit MDP-dependent constants;
   - an impossibility theorem showing no parameterization-only modulus can exist;
   - a diagnostic theorem for a small, explicit MDP family.
7. **Oracle consistency check**: ensure the lower-bound algorithm class matches the provided oracle. If the oracle reveals per-state advantages for all states, do not claim the hidden action cannot be identified.

## Safer Theory Shapes

Prefer these shapes when an exact unifying identity is uncertain:

- A diagnostic theorem that characterizes exactly when a unification is valid.
- A counterexample showing why a tempting unification fails.
- A weaker inequality or variational bound with explicit slack terms.
- A two-regime theorem with a shared proof template, rather than one formula forced across incompatible limits.
- A small-family impossibility theorem, such as a two-state/two-action MDP construction showing which hidden constants any unified PG/PI analysis must include.
- A finite-step separation for a named algorithm class, such as exact softmax PG or exact NPG, with a fully specified chain MDP and a separate PI upper bound.
