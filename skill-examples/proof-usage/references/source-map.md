# Proof Usage Source Map

This map connects cooked playbook entries to stable `proof-material` IDs and public sources.

## Sources

| Material prefix | Public source | Material file |
| --- | --- | --- |
| `CR24` | Cassel and Rosenberg, "Warm-up Free Policy Optimization: Improved Regret in Linear Markov Decision Processes" (2024) | `proof-material/references/cassel-rosenberg-2024-warm-up-free-policy-optimization.md` |
| `GGSXY25` | Gao, Ge, Sun, Xue, and Ye, "Beyond O(sqrt(T)) Regret: Decoupling Learning and Decision-making in Online Linear Programming" (2025) | `proof-material/references/gao-ge-sun-xue-ye-2025-online-linear-programming.md` |
| `RLB23` | Lu, Van Roy, Dwaracherla, Ibrahimi, Osband, and Wen, "Reinforcement Learning, Bit by Bit" (2023) | `proof-material/references/lu-et-al-2023-reinforcement-learning-bit-by-bit.md` |

## Cooked Entries

| Cooked entry | Category file | Material sources | Public attribution |
| --- | --- | --- | --- |
| Sigmoid-gated uncertainty cap | `local-moves/concentration-and-self-normalization.md` | `CR24-D01` | Cassel and Rosenberg 2024 |
| Quadratic gate to self-normalized residue | `local-moves/concentration-and-self-normalization.md` | `CR24-D02`, `CR24-D03` | Cassel and Rosenberg 2024 |
| Determinant-doubling epoch control | `local-moves/epoch-and-restart-controls.md` | `CR24-D03` | Cassel and Rosenberg 2024 |
| Error-bound localization from empirical optimality | `local-moves/convex-error-bounds.md` | `GGSXY25-D01` | Gao, Ge, Sun, Xue, and Ye 2025 |
| Constant-stepsize noise ball | `local-moves/convex-error-bounds.md` | `GGSXY25-D02` | Gao, Ge, Sun, Xue, and Ye 2025 |
| Localized dual-regret decomposition | `local-moves/convex-error-bounds.md` | `GGSXY25-D03` | Gao, Ge, Sun, Xue, and Ye 2025 |
| Error-bound rate balancing | `local-moves/convex-error-bounds.md` | `GGSXY25-D04` | Gao, Ge, Sun, Xue, and Ye 2025 |
| Contract uncertain features instead of warm-up | `strategies/auxiliary-models-and-contractions.md` | `CR24-S01`, `CR24-D01`, `CR24-D02`, `CR24-D03` | Cassel and Rosenberg 2024 |
| Auxiliary model regret decomposition | `strategies/auxiliary-models-and-contractions.md` | `CR24-S02` | Cassel and Rosenberg 2024 |
| Controlled surrogate before full regret accounting | `strategies/auxiliary-models-and-contractions.md` | `CR24-S02`, `GGSXY25-S02` | Cassel and Rosenberg 2024; Gao, Ge, Sun, Xue, and Ye 2025 |
| Learn then localize | `strategies/dual-learning-vs-decision-making.md` | `GGSXY25-S01`, `GGSXY25-D01`, `GGSXY25-D02`, `GGSXY25-D03` | Gao, Ge, Sun, Xue, and Ye 2025 |
| Decouple learning from decision-making | `strategies/dual-learning-vs-decision-making.md` | `GGSXY25-S02`, `GGSXY25-D04` | Gao, Ge, Sun, Xue, and Ye 2025 |
| Shortfall telescoping against a baseline policy | `local-moves/information-ratio-bounds.md` | `RLB23-D01` | Lu et al. 2023 |
| Tau-step retained-information telescope | `local-moves/information-ratio-bounds.md` | `RLB23-D02`, `RLB23-S01` | Lu et al. 2023 |
| Quantized posterior concentration from information gain | `local-moves/information-ratio-bounds.md` | `RLB23-D03` | Lu et al. 2023 |
| Two-action support for IDS ratio objectives | `local-moves/information-ratio-bounds.md` | `RLB23-D04` | Lu et al. 2023 |
| Variance lower bound for pseudo-information gain | `local-moves/information-ratio-bounds.md` | `RLB23-D05` | Lu et al. 2023 |
| Information-ratio regret from retained target information | `strategies/information-ratio-regret-and-ids.md` | `RLB23-S01`, `RLB23-D01`, `RLB23-D02` | Lu et al. 2023 |
| Targeted learning tradeoff | `strategies/information-ratio-regret-and-ids.md` | `RLB23-S02`, `RLB23-S01` | Lu et al. 2023 |
| Quantized target for posterior-sampling regret | `strategies/information-ratio-regret-and-ids.md` | `RLB23-S03`, `RLB23-D03`, `RLB23-S01` | Lu et al. 2023 |
| Conditional IDS ratio induction | `strategies/information-ratio-regret-and-ids.md` | `RLB23-S04`, `RLB23-D04`, `RLB23-D05`, `RLB23-S01` | Lu et al. 2023 |

## Legacy Compatibility

The older flat files `techniques.md` and `strategies.md` are retained for compatibility. Their valuable entries have been migrated into the indexed category files above and can be traced through this map.
