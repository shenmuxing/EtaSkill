# Skill Catalog

This page summarizes the reusable skills in MetaSkill and when to use them. Each skill's `SKILL.md` remains the source of truth for trigger wording, operating procedure, scripts, and resource requirements.

## Proof Pipeline

The proof skills form a staged pipeline for turning source papers into reusable proof help:

```text
source PDFs / notes
  -> proof-finder
  -> proof-material
  -> proof-cooker
  -> proof-usage
```

Use `proof-finder` to mine source-grounded items, `proof-material` to preserve stable IDs and evidence anchors, `proof-cooker` to synthesize reusable categories, and `proof-usage` as the final lookup playbook for theorem-proving work. This catalog only explains routing; detailed procedure belongs in each skill's own `SKILL.md` and references.

## Core Repository Skills

| Skill | Path | Use When | Notes |
| --- | --- | --- | --- |
| Skill Management | `skill-management/` | Inventory, audit, normalize, migrate, test, or prepare reusable skills. | Owns skill lifecycle workflows inside this repository. |
| Publication Review | `publication-review/` | Review a skill before publishing, importing, or promoting it into a public collection. | Focuses on privacy, structure, public-safe examples, and truthful contracts. |

## Skill Examples

| Skill | Path | Use When | Notes |
| --- | --- | --- | --- |
| Codex-DeepSeek Paper Protocol | `skill-examples/codex-deepseek-paper-protocol/` | Coordinate Codex planning and review with DeepSeek manuscript drafting or revision. | Uses the companion DeepSeek calling skill and can include explicit style review. |
| DeepSeek Agent | `skill-examples/deepseek-agent/` | Delegate bounded writing or revision tasks to the DeepSeek CLI/TUI while Codex remains the controller. | Provides the operating contract and wrapper workflow for DeepSeek delegation. |
| Literature Idea Planner | `skill-examples/literature-idea-planner/` | Browse academic sources through the Codex Chrome plugin and write a `planNN.md` explaining which papers to borrow from for a research idea. | Plans only; PDF fetching and BibTeX creation belong to Literature Reference Builder. |
| Literature Reference Builder | `skill-examples/literature-reference-builder/` | Use a literature plan or paper list to fetch accessible PDFs and create or update `references.bib`. | Prefers published versions, uses arXiv as fallback, and records sources in `paper-sources.md`. |
| Muxing Style Review | `skill-examples/muxing-style-review/` | Review technical or academic prose against a bundled 21-rule style contract, optionally with a dedicated Codex review subagent. | Combines `agent-style` automatic evidence with local manual/model checks; points upstream audit/polish requests to the sibling Style Review package. |
| Proof Material | `skill-examples/proof-material/` | Store source-indexed proof material with stable IDs, paper locations, reusable abstractions, tags, and public attribution. | Intermediate layer between Proof Finder and Proof Cooker; organized one source per file. |
| Proof Finder | `skill-examples/proof-finder/` | Mine proof-heavy papers or notes into Proof Material source files and backtest candidate value/self-containedness. | Uses DeepSeek for independent first-pass screening and blind backtests; does not write directly to Proof Usage. |
| Proof Cooker | `skill-examples/proof-cooker/` | Synthesize Proof Material into the final Proof Usage taxonomy. | Clusters, de-duplicates, updates category files, and preserves material-ID links. |
| Proof Usage | `skill-examples/proof-usage/` | Look up cooked proof moves and strategies while proving a theorem or planning a proof. | Starts from `references/index.md` and maps entries back to Proof Material through `source-map.md`; old flat files are compatibility-only. |
| Skill Creator | `skill-examples/skill-creator/` | Create or update Codex skills. | Serves as a public-safe example of a fuller skill package with references, scripts, assets, and license text. |
| Skill Installer | `skill-examples/skill-installer/` | List, install, or update Codex skills from the OpenAI skills repository or a GitHub repo path. | Bundles helper scripts and surfaces per-skill `install.md` guidance after copy/update. |
| Skill Tester | `skill-examples/skill-tester/` | Record observable skill test runs for debugging. | Produces local, non-certifying reports of visible actions, artifacts, and blockers. |
| Style Review | `skill-examples/style-review/` | Run the upstream `agent-style` post-hoc Markdown audit, optional beside-file polish, or A/B comparison workflow. | Vendored from `yzhao062/agent-style`; requires the `agent-style` CLI for its deterministic audit and compare paths. |

## Routing Rules

- Use `skill-management/` for lifecycle work such as inventory, cleanup, migration, validation, and publication planning.
- Use `publication-review/` before claiming that a skill is public-ready or moving it into a public collection.
- Use `skill-examples/<skill-name>/` for mature reusable skills that have been generalized and checked for public safety.
- Keep detailed procedures in the relevant `SKILL.md`, `references/`, `scripts/`, or `assets/` files rather than duplicating them in this catalog.
