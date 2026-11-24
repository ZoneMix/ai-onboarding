# /backlinks: Wire Missing Connections

Finds notes that should be linked but aren't and wires new connections across the vault. Your job is to make the graph traversable, not to generate understanding.

## Usage

```
/backlinks
```

## Philosophy

Users should think; the system should wire connections between existing thoughts without synthesizing new content.

## Process

### Phase 1: Structural Inventory

Map the vault without reading content:

```bash
obsidian orphans
obsidian deadends
obsidian unresolved
obsidian backlinks file="<Hub-A>"
obsidian backlinks file="<Hub-B>"
```

### Phase 2: Priority Context

Read 5-6 context files and recent daily notes to filter which connections matter most:

```bash
obsidian read file="<Context-File-A>"
obsidian daily:read
```

### Phase 3: Rescue Orphans

Selectively read meaningful orphaned notes based on:
- Priority relevance
- Question marks in titles
- Semantic relationship to active clusters

Hard cap: 100 notes total.

### Phase 4: Bridge Clusters

Search for shared themes and vocabulary across cluster territories:

```bash
obsidian search:context query="<shared theme>"
```

### Phase 5: Triage Unresolved Links

- **3+ references**: Warrant stub creation
- **2 references**: Check for duplicates first
- **1 reference**: Skip unless priority-critical

### Phase 6: Score Candidates

Score multiplicatively across three dimensions (1-5 each):
- **Conceptual Strength**: How real is this connection?
- **Structural Impact**: Does this bridge isolated areas?
- **Priority Alignment**: Does this serve current goals?

Tiers by composite score:
- **Critical (75+)**: Must connect
- **High (40-74)**: Strong recommendation
- **Medium (15-39)**: Worth doing
- **Low (<15)**: Skip

### Phase 7: Execute

With approval, execute connections with precise placement:

```bash
obsidian append file="<Note>" content="\n\nSee also: [[Connected Note]], [reason]"
```

Create stub notes for unresolved links:

```bash
obsidian create name="<Stub>" content="Linked from: [[Source A]], [[Source B]]"
```

## Connection Types

1. **Orphan to Hub**: Isolated note connected to a central theme
2. **Cluster Bridge**: Link between two separate clusters
3. **Internal Gap**: Missing link within a cluster
4. **Empty Hub**: Flagged but not filled (never synthesize content)
5. **Semantic Twin**: Notes about the same thing, differently named
6. **Person to Concept**: Linking people to their areas of relevance
7. **Temporal Bridge**: Connecting ideas that evolved from each other
8. **Unresolved Worth Creating**: Referenced ideas that deserve their own note

## Quality Controls

- Minimum conceptual strength of 2
- Maximum 30 recommendations per run
- Every connection must be explainable in one sentence
- Never fill empty hub notes with synthesized content
