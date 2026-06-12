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
| Regret can be charged to information learned about a target | Retained target information is monotone; local shortfall admits an information-ratio bound | Convert shortfall into cost per retained bit | [strategies/information-ratio-regret-and-ids.md](strategies/information-ratio-regret-and-ids.md), [local-moves/information-ratio-bounds.md](local-moves/information-ratio-bounds.md) | Information-ratio regret from retained target information; Shortfall telescoping against a baseline policy; Tau-step retained-information telescope | `RLB23-S01`, `RLB23-D01`, `RLB23-D02` |
| Learning the exact optimum is too information-heavy | A target policy or compressed target has bounded regret and lower entropy | Trade target entropy against target-policy regret and information ratio | [strategies/information-ratio-regret-and-ids.md](strategies/information-ratio-regret-and-ids.md) | Targeted learning tradeoff | `RLB23-S02`, `RLB23-S01` |
| Posterior-sampling proof has continuous parameters but needs entropy accounting | Quantization residual is controllable; posterior concentration is information-controlled; optimism/comparator holds | Quantize the learning target and route sampled-model error through information gain | [strategies/information-ratio-regret-and-ids.md](strategies/information-ratio-regret-and-ids.md), [local-moves/information-ratio-bounds.md](local-moves/information-ratio-bounds.md) | Quantized target for posterior-sampling regret; Quantized posterior concentration from information gain | `RLB23-S03`, `RLB23-D03` |
| IDS action selection needs a tractable proof or computable information surrogate | Ratio objective has linear shortfall/information statistics; pseudo-observations have bounded span | Reduce mixtures to two actions or lower-bound information by variance | [strategies/information-ratio-regret-and-ids.md](strategies/information-ratio-regret-and-ids.md), [local-moves/information-ratio-bounds.md](local-moves/information-ratio-bounds.md) | Conditional IDS ratio induction; Two-action support for IDS ratio objectives; Variance lower bound for pseudo-information gain | `RLB23-S04`, `RLB23-D04`, `RLB23-D05` |

## Route By Assumption

| Assumption or structure | Useful entries |
| --- | --- |
| Linear MDP, bounded features, self-normalized least squares | Sigmoid-gated uncertainty cap; Quadratic gate to self-normalized residue; Contract uncertain features instead of warm-up |
| Determinant growth or covariance design matrices | Determinant-doubling epoch control |
| Holder error bound, sharpness, quadratic growth, weak sharp minima | Error-bound localization from empirical optimality; Error-bound rate balancing |
| Online linear programming, dual subgradient update | Constant-stepsize noise ball; Localized dual-regret decomposition; Decouple learning from decision-making |
| Auxiliary model or conservative surrogate | Auxiliary model regret decomposition; Controlled surrogate before full regret accounting |
| Monotone retained target information, information-ratio bound | Information-ratio regret from retained target information; Tau-step retained-information telescope |
| Compressed learning target or target policy baseline | Targeted learning tradeoff |
| Beta-Bernoulli posterior, quantized continuous parameter | Quantized posterior concentration from information gain; Quantized target for posterior-sampling regret |
| IDS fractional objective, bounded pseudo-observation span | Two-action support for IDS ratio objectives; Variance lower bound for pseudo-information gain; Conditional IDS ratio induction |

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
| Telescope delayed target-information gain | Tau-step retained-information telescope |
| Convert regret to local shortfall terms | Shortfall telescoping against a baseline policy |
| Prove regret from cost per retained bit | Information-ratio regret from retained target information |
| Quantize posterior targets for entropy bounds | Quantized target for posterior-sampling regret |
| Optimize IDS over action mixtures efficiently | Two-action support for IDS ratio objectives |
| Replace pseudo-information gain by a variance proxy | Variance lower bound for pseudo-information gain |

## Tag Index

| Tag | Open |
| --- | --- |
| `sigmoid-gate`, `uncertainty-cap`, `quadratic-residue`, `self-normalized` | [local-moves/concentration-and-self-normalization.md](local-moves/concentration-and-self-normalization.md) |
| `determinant-doubling`, `epoching`, `restart` | [local-moves/epoch-and-restart-controls.md](local-moves/epoch-and-restart-controls.md) |
| `error-bound`, `holder-growth`, `dual-localization`, `parameter-balancing` | [local-moves/convex-error-bounds.md](local-moves/convex-error-bounds.md) |
| `auxiliary-model`, `contracted-mdp`, `optimism`, `OMD` | [strategies/auxiliary-models-and-contractions.md](strategies/auxiliary-models-and-contractions.md) |
| `dual-learning`, `decision-making`, `decoupling`, `adaptivity` | [strategies/dual-learning-vs-decision-making.md](strategies/dual-learning-vs-decision-making.md) |
| `information-ratio`, `delayed-information`, `target-policy`, `learning-target` | [strategies/information-ratio-regret-and-ids.md](strategies/information-ratio-regret-and-ids.md), [local-moves/information-ratio-bounds.md](local-moves/information-ratio-bounds.md) |
| `quantization`, `beta-posterior`, `Thompson-sampling` | [strategies/information-ratio-regret-and-ids.md](strategies/information-ratio-regret-and-ids.md), [local-moves/information-ratio-bounds.md](local-moves/information-ratio-bounds.md) |
| `IDS`, `variance-IDS`, `two-sparse`, `pseudo-observation` | [strategies/information-ratio-regret-and-ids.md](strategies/information-ratio-regret-and-ids.md), [local-moves/information-ratio-bounds.md](local-moves/information-ratio-bounds.md) |

## Source Material IDs

For source-level detail, follow IDs through [source-map.md](source-map.md) and then open the matching `proof-material` file.
