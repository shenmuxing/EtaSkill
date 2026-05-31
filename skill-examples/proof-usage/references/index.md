# Proof Usage Index

Start here when proving a theorem. Search by task shape, assumptions, desired move, tags, or material source ID, then open only the matching category file.

## Route By Task Shape

| Problem shape | Assumptions to check | Desired move | Open | Candidate entries | Material IDs |
| --- | --- | --- | --- | --- | --- |
| High-uncertainty linear estimates need bounded values before full exploration | Linear features, self-normalized covariance, uncertainty radius, bounded horizon or value target | Gate uncertain directions and charge contraction bias | [strategies/auxiliary-models-and-contractions.md](strategies/auxiliary-models-and-contractions.md), [local-moves/concentration-and-self-normalization.md](local-moves/concentration-and-self-normalization.md) | Contract uncertain features instead of warm-up; Sigmoid-gated uncertainty cap; Quadratic gate to self-normalized residue | `CR24-S01`, `CR24-D01`, `CR24-D02`, `CR24-D03`, `CR24-S02` |
| Regret proof needs auxiliary model, optimism, and online-learning terms | Comparator can be evaluated in a conservative surrogate; value-difference lemma or equivalent available | Decompose through bias, online-learning regret, and optimism | [strategies/auxiliary-models-and-contractions.md](strategies/auxiliary-models-and-contractions.md) | Auxiliary model regret decomposition | `CR24-S02` |
| Epochs or restarts freeze a changing confidence or policy object | Determinant or potential growth controls geometry changes | Bound restart count and norm conversion | [local-moves/epoch-and-restart-controls.md](local-moves/epoch-and-restart-controls.md) | Determinant-doubling epoch control | `CR24-D03` |
| Empirical or learned convex objective must localize a population optimizer | Uniform objective error and Holder/error-bound growth | Convert objective gap into distance to solution set | [local-moves/convex-error-bounds.md](local-moves/convex-error-bounds.md) | Error-bound localization from empirical optimality | `GGSXY25-D01` |
| Online primal-dual proof has a learned anchor and adaptive decisions | Online subgradient update, dual optimal set, error-bound condition | Use noise-ball and localized regret decomposition | [local-moves/convex-error-bounds.md](local-moves/convex-error-bounds.md), [strategies/dual-learning-vs-decision-making.md](strategies/dual-learning-vs-decision-making.md) | Constant-stepsize noise ball; Localized dual-regret decomposition; Learn then localize | `GGSXY25-D02`, `GGSXY25-D03`, `GGSXY25-S01` |
| One algorithmic sequence seems to need both high-accuracy learning and online adaptivity | Learning stepsize conflicts with decision stepsize | Split roles or restart from a learned anchor | [strategies/dual-learning-vs-decision-making.md](strategies/dual-learning-vs-decision-making.md) | Decouple learning from decision-making | `GGSXY25-S02`, `GGSXY25-D04` |
| Two papers suggest using a safer surrogate before the final proof object | Surrogate is conservative or localizing; source-specific costs can be bounded | Compare auxiliary model contraction with dual localization | [strategies/auxiliary-models-and-contractions.md](strategies/auxiliary-models-and-contractions.md) | Controlled surrogate before full regret accounting | `CR24-S02`, `GGSXY25-S02` |

## Route By Assumption

| Assumption or structure | Useful entries |
| --- | --- |
| Linear MDP, bounded features, self-normalized least squares | Sigmoid-gated uncertainty cap; Quadratic gate to self-normalized residue; Contract uncertain features instead of warm-up |
| Determinant growth or covariance design matrices | Determinant-doubling epoch control |
| Holder error bound, sharpness, quadratic growth, weak sharp minima | Error-bound localization from empirical optimality; Error-bound rate balancing |
| Online linear programming, dual subgradient update | Constant-stepsize noise ball; Localized dual-regret decomposition; Decouple learning from decision-making |
| Auxiliary model or conservative surrogate | Auxiliary model regret decomposition; Controlled surrogate before full regret accounting |

## Route By Desired Move

| Desired move | Entry |
| --- | --- |
| Cap `y * sigmoid(-beta y + log K)` | Sigmoid-gated uncertainty cap |
| Replace sigmoid tail by squared uncertainty plus residual | Quadratic gate to self-normalized residue |
| Sum self-normalized radii across epochs | Determinant-doubling epoch control |
| Turn objective accuracy into optimizer distance | Error-bound localization from empirical optimality |
| Keep iterates near an optimal set with constant stepsize | Constant-stepsize noise ball |
| Balance exploration length and exploitation stepsize exponents | Error-bound rate balancing |
| Split estimation from decision control | Decouple learning from decision-making |

## Tag Index

| Tag | Open |
| --- | --- |
| `sigmoid-gate`, `uncertainty-cap`, `quadratic-residue`, `self-normalized` | [local-moves/concentration-and-self-normalization.md](local-moves/concentration-and-self-normalization.md) |
| `determinant-doubling`, `epoching`, `restart` | [local-moves/epoch-and-restart-controls.md](local-moves/epoch-and-restart-controls.md) |
| `error-bound`, `holder-growth`, `dual-localization`, `parameter-balancing` | [local-moves/convex-error-bounds.md](local-moves/convex-error-bounds.md) |
| `auxiliary-model`, `contracted-mdp`, `optimism`, `OMD` | [strategies/auxiliary-models-and-contractions.md](strategies/auxiliary-models-and-contractions.md) |
| `dual-learning`, `decision-making`, `decoupling`, `adaptivity` | [strategies/dual-learning-vs-decision-making.md](strategies/dual-learning-vs-decision-making.md) |

## Source Material IDs

For source-level detail, follow IDs through [source-map.md](source-map.md) and then open the matching `proof-material` file.
