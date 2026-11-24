# /map: Vault Topology & Intellectual Landscape

Generates a topological view of everything in the vault, showing clusters, themes, and how ideas relate. Reveals the shape of your thinking.

## Usage

```
/map
```

## Process

### Step 1: Structural Analysis

Get the full picture of vault structure:

```bash
obsidian tags counts sort=count
obsidian orphans
obsidian deadends
obsidian unresolved
```

Get link density for key notes:

```bash
obsidian backlinks file="<Hub-Note-A>"
obsidian backlinks file="<Hub-Note-B>"
obsidian links file="<Hub-Note-A>"
```

Count and categorize:

```bash
obsidian files folder="8_DAILY"
obsidian files folder="Essays"
obsidian files
```

### Step 2: Identify Clusters

Trace major clusters by following backlink chains from the most connected notes:

```bash
obsidian backlinks file="<highly connected note>"
obsidian links file="<highly connected note>"
```

For each cluster determine:
- Central node (most connected note)
- Approximate size (number of notes)
- Internal connection density
- Isolation level (does it connect to other clusters?)

#### Cluster Relationship Narrative

Don't just list clusters. Describe relationships:
- Which clusters should be connected but aren't? (Biggest structural gaps)
- Which clusters are bridged by a single note? (Critical junctions)
- Which clusters are appropriately separate?
- Where are superclusters (groups forming larger meta-themes)?

### Step 3: Find the Gaps

#### Missing Connections

Notes sharing themes but not linked:

```bash
obsidian search:context query="<theme from cluster A>"
```

#### Orphaned Value

For each orphaned note, apply decision logic:
- **(a) Genuinely unrelated?** Skip.
- **(b) Not connected yet?** Contains ideas relevant to current priorities but never linked. High-value rescues.
- **(c) Forgotten insight?** Written months ago, surprisingly relevant now. Flag for attention.
- **(d) Intentionally isolated or accidentally abandoned?** Check date and context.

#### Unresolved Links

Review unresolved `[[links]]`:
- Which ones are worth creating notes for?
- Which represent important thinking that never got its own space?

#### Dead Zones

Areas of stated interest with very few notes. Compare stated priorities against actual note density.

#### Tag-to-Priority Ratio

| Tag | Note Count | Stated Priority? | Ratio |
|-----|-----------|-------------------|-------|
| ... | ... | High/Medium/Low/None | ... |

- High priority + low count = **dead zones** (areas you say matter but aren't developing)
- High count + low priority = **attention sinks** (absorbing energy without being strategic)

### Step 4: Synthesize

#### Vault Overview
- Total notes, daily notes, essays, context files
- Most connected notes (hubs)
- Most isolated notes (orphans worth rescuing)
- Tag distribution

#### Cluster Map

For each cluster:
- **Name**: What it's about
- **Hub note**: Most connected note
- **Size**: Approximate note count
- **Density**: How interconnected
- **Health**: Active and growing / Stable / Stagnant / Neglected
- **Connections**: Which clusters it bridges to

#### The Shape of Your Thinking

Narrative describing where attention and intellectual energy are going. What dominates? What's underdeveloped relative to stated importance?

#### Recommended Actions
- Notes to create (from unresolved links)
- Connections to make (orphans to connect, clusters to bridge)
- Areas to develop (dead zones that matter)
- Notes to revisit (orphaned value worth rescuing)

## Output Format

```
VAULT MAP, [Date]

[Overview stats]
[Cluster map with relationship narrative]
[Shape narrative]
[Tag-to-priority analysis]
[Gaps and dead zones]
[Recommended actions]
```

## Guidelines

- Be specific: name actual notes, not abstractions
- The map should make you see the vault differently than before
- Focus on actionable insights, not just statistics
- The most valuable output is connections that should exist but don't
