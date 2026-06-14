# Proof Usage Taxonomy Template

Use this contract for cooked entries in `proof-usage`.

```markdown
### <Reusable Cooked Name>

- Category:
- Use when:
- Required assumptions:
- Core move:
- Self-contained statement or template:
- How to adapt:
- Worked mini-example:
- Technique usage:
- Failure modes:
- Related entries:
- Material sources:
- Public attribution:
```

## Concrete Example Requirement

Every cooked entry should include a small worked example that demonstrates the
proof move with named assumptions, a short derivation, source or material
attribution, and the exact technique being used. The example may be toy-sized
when the real proof shape is complex, but it must show the move rather than
describe it abstractly.

Example:

```markdown
### Direct substitution from known values

- Category: `local-move`
- Use when: A target expression contains variables whose values are already known.
- Required assumptions: The current task supplies `x = 1` and `y = 2`.
- Core move: Substitute known values into the target expression and simplify.
- Self-contained statement or template: If `x = a` and `y = b`, then `x + y = a + b`.
- How to adapt: Replace each known variable by its supplied value before doing any higher-level algebra.
- Worked mini-example: Given `x = 1` and `y = 2`, substitute into `x + y` to get `x + y = 1 + 2 = 3`.
- Technique usage: Direct substitution.
- Failure modes: This proves the target only under the stated assumptions; it does not prove `x + y = 3` for arbitrary `x,y`.
- Related entries: None.
- Material sources: Supplied assumptions in the current task.
- Public attribution: None needed for task-local assumptions.
```

## Category Hints

- `local-move`: local lemma, estimate, concentration step, convexity conversion, coupling, parameter balance, or deterministic algebra.
- `macro-strategy`: proof architecture, auxiliary model, staged algorithm, restart schedule, decomposition, or taxonomy-level template.
- `source-bridge`: entry that deliberately compares or distinguishes similar source items.

## Naming Hints

- Name the reusable proof shape, not the source paper.
- Avoid names that hide the mathematical object, such as "Main Lemma" or "Cool Trick".
- Prefer names that remain useful in search, such as "Error-bound localization from empirical optimality".
