# Skill Catalog

This page summarizes the reusable skills in MetaSkill and when to use them. Each skill's `SKILL.md` remains the source of truth for trigger wording, operating procedure, scripts, and resource requirements.

## Core Repository Skills

| Skill | Path | Use When | Notes |
| --- | --- | --- | --- |
| Skill Management | `skill-management/` | Inventory, audit, normalize, migrate, test, or prepare reusable skills. | Owns skill lifecycle workflows inside this repository. |
| Publication Review | `publication-review/` | Review a skill before publishing, importing, or promoting it into a public collection. | Focuses on privacy, structure, public-safe examples, and truthful contracts. |

## Muxing Skills

| Skill | Path | Use When | Notes |
| --- | --- | --- | --- |
| Codex-DeepSeek Paper Protocol | `muxing-skills/codex-deepseek-paper-protocol/` | Coordinate Codex planning and review with DeepSeek manuscript drafting or revision. | Uses the companion DeepSeek calling skill and can include explicit style review. |
| DeepSeek Agent | `muxing-skills/deepseek-agent/` | Delegate bounded writing or revision tasks to the DeepSeek CLI/TUI while Codex remains the controller. | Provides the operating contract and wrapper workflow for DeepSeek delegation. |
| Literature Idea Planner | `muxing-skills/literature-idea-planner/` | Browse academic sources through the Codex Chrome plugin and write a `planNN.md` explaining which papers to borrow from for a research idea. | Plans only; PDF fetching and BibTeX creation belong to Literature Reference Builder. |
| Literature Reference Builder | `muxing-skills/literature-reference-builder/` | Use a literature plan or paper list to fetch accessible PDFs and create or update `references.bib`. | Prefers published versions, uses arXiv as fallback, and records sources in `paper-sources.md`. |
| Muxing Style Review | `muxing-skills/muxing-style-review/` | Run deterministic Markdown prose audits using implemented `agent-style` checks. | Keeps the public contract limited to implemented CLI-backed review behavior. |
| Skill Creator | `muxing-skills/skill-creator/` | Create or update Codex skills. | Serves as a public-safe example of a fuller skill package with references, scripts, assets, and license text. |

## Routing Rules

- Use `skill-management/` for lifecycle work such as inventory, cleanup, migration, validation, and publication planning.
- Use `publication-review/` before claiming that a skill is public-ready or moving it into a public collection.
- Use `muxing-skills/<skill-name>/` for mature reusable skills that have been generalized and checked for public safety.
- Keep detailed procedures in the relevant `SKILL.md`, `references/`, `scripts/`, or `assets/` files rather than duplicating them in this catalog.
