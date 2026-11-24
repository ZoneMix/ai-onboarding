# /emerge

Finds ideas strongly implied by vault patterns but never explicitly written.

## Usage

```
/emerge
```

## What Qualifies as an Emergence

An emergence qualifies when:

- Conclusions follow from scattered premises, but the conclusion was never drawn
- Unnamed patterns recur across 3+ domains
- Beliefs are revealed through behavior but never articulated
- Directions that multiple threads indicate without naming

## Process

### Detection Method 1: Structural

Analyze vault architecture for signals.

```bash
obsidian search:orphans
obsidian search:deadends
obsidian tags counts sort=count
```

Look for orphan notes, dead-end paths, and unusual tag distributions that suggest unexplored connections.

### Detection Method 2: Thematic

Search for unnamed patterns that recur across 3+ domains.

```bash
obsidian search:context query="<pattern-keyword>"
obsidian backlinks file="<domain-A-hub>"
obsidian backlinks file="<domain-B-hub>"
obsidian backlinks file="<domain-C-hub>"
```

Identify common structures, approaches, or principles that appear in multiple areas without being named or unified.

### Detection Method 3: Logical

Find premises from different notes whose conclusion remains unstated.

```bash
obsidian search:context query="<premise-A-keyword>"
obsidian search:context query="<premise-B-keyword>"
```

Search for beliefs, facts, or observations that, combined, imply a conclusion the vault owner has not yet drawn.

### Detection Method 4: Behavioral

Search for recurring decisions that reveal unarticulated beliefs.

```bash
obsidian search:context query="decided"
obsidian search:context query="chose"
obsidian search:context query="cancelled"
obsidian search:context query="stopped"
```

Requires 3+ instances of the same behavioral pattern to qualify. Look for consistent choices that reveal an unstated principle or preference.

### Detection Method 5: Convergence

Identify multiple independent threads pointing to an unnamed destination. This is the most speculative method and requires 3+ independent threads converging.

```bash
obsidian search:context query="<thread-A>"
obsidian search:context query="<thread-B>"
obsidian search:context query="<thread-C>"
obsidian links file="<convergence-candidate>"
```

### Detection Method 6: Verification (Mandatory)

For every candidate emergence, confirm it is not already stated somewhere in the vault.

```bash
obsidian search query="<candidate emergence keywords>"
obsidian search:context query="<candidate emergence rephrased>"
```

If the idea already exists explicitly, it is not an emergence. Discard it.

## Confidence Levels

- **High**: 5+ data points, confirmed by 2+ detection methods
- **Medium**: 3-4 data points, confirmed by 1-2 methods
- **Low**: 1-2 data points, single method only

## Output Format

For each emergence:

```
## Emergence: <title>

**Statement**: <plain language statement of the unstated idea>
**Detection Method**: <which method(s) found it>

**Evidence**:
1. [[<note-1>]], <what it contributes>
2. [[<note-2>]], <what it contributes>
3. [[<note-3>]], <what it contributes>

**Why Unstated**: <explanation of why this has remained implicit>
**Confidence**: High | Medium | Low
**Data Points**: <count>

**Recommended Action**:
- Articulate: write it as a standalone note
- Investigate: gather more evidence before committing
- Name: give the pattern a name for future reference
- Leave Unstated: some ideas work better as implicit operating principles
```

## Anti-Patterns to Reject

- **Connection disguises**: presenting obvious links between related topics as emergences
- **Forced emergences**: stretching thin evidence to manufacture insights
- **Obvious/already-stated ideas**: ideas the vault owner clearly knows, just phrased differently
- **Vague generalizations**: "you care about quality" is not an emergence
- **Over-interpretation**: reading too much into casual mentions
- **Imposed frameworks**: projecting external theories onto vault patterns
- **Novelty disguised as discovery**: ideas that sound interesting but lack vault evidence
