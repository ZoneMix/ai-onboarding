# /xarticle

Finds writing topics by scanning for graph density, current energy, and synthesis potential.

## Usage

```
/xarticle
```

## Process

### Step 1: Graph Density Analysis

Find topics with the highest concentration of interconnected notes.

```bash
obsidian tags counts sort=count
obsidian backlinks file="<top-tag-hub>"
```

Identify clusters where 5+ notes interconnect within 2 hops. These represent areas with enough material to write from.

### Step 2: Energy Detection

Scan recent daily notes (14 days) for topics with emotional charge, repeated returns, evolving confidence.

```bash
obsidian daily:read
obsidian search:context query="<recurring-theme>"
```

Look for: exclamation marks, extended passages, "I keep thinking about", debates with self, topics that appear unprompted.

### Step 3: Synthesis Potential

For each candidate, assess whether the vault contains enough opposing perspectives, examples, and frameworks to create genuine synthesis rather than summary.

```bash
obsidian search:context query="<candidate-topic>"
obsidian backlinks file="<candidate-hub-note>"
obsidian links file="<candidate-hub-note>"
```

Score each on: depth (note count), freshness (recent mentions), tension (opposing views present), audience (would others care), uniqueness (not already written).

### Step 4: Cross-Reference Published Work

Check existing essays to avoid repetition.

```bash
obsidian files folder="Essays"
obsidian search query="<candidate>" path="Essays"
```

### Step 5: Present Candidates

| Topic | Density | Energy | Synthesis | Angle | Est. Length |
|-------|---------|--------|-----------|-------|-------------|
| <topic-1> | High | High | Ready | <angle> | 1500w |
| <topic-2> | Medium | High | Needs work | <angle> | 800w |

For top 3 candidates, include:
- **Opening hook idea**
- **The non-obvious claim the vault supports**
- **Which notes form the backbone**

## Output Format

Ranked candidates with scores, top 3 with detailed writing briefs, recommended first article with reasoning.
