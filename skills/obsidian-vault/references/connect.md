# /connect [domain A] [domain B]

Surfaces unexpected bridges between unrelated domains.

## Usage

```
/connect [domain A] [domain B]
```

## Process

### Phase 1: Domain Mapping

Search each domain thoroughly via backlinks, forward links, tags, and context queries. Explore 2-3 hops from hub notes in each domain.

```bash
obsidian search:context query="<domain-A>"
obsidian backlinks file="<domain-A-hub>"
obsidian links file="<domain-A-hub>"
obsidian tags counts sort=count
obsidian search:context query="<domain-B>"
obsidian backlinks file="<domain-B-hub>"
obsidian links file="<domain-B-hub>"
```

**Depth asymmetry handling**: when one domain has significantly more vault material than the other, dig deeper into the smaller domain to compensate. Search for indirect references, adjacent topics, and implied connections.

### Phase 2: Overlap Detection

Identify shared elements between the two domains:

- **Shared references/people**: notes or sources cited in both domains
- **Recurring themes**: similar ideas expressed in different language
- **Structural similarities**: parallel patterns, processes, or frameworks
- **Common tags**: tags that appear in notes from both domains

```bash
obsidian search:context query="<shared-keyword>"
obsidian backlinks file="<shared-reference>"
```

### Phase 3: Bridge Tracing

For each potential connection, determine whether it is surface-level (same word used coincidentally) or structural (same underlying pattern applied differently).

Trace intermediary notes that sit between domain hubs. These bridge notes often reveal the actual mechanism of connection.

```bash
obsidian backlinks file="<bridge-candidate>"
obsidian links file="<bridge-candidate>"
```

**Temporal analysis**: determine whether the connection between domains is converging (becoming more connected over time), diverging (separating), or stable.

### Phase 4: Synthesis

Produce a connection map showing:

- All identified bridges with strength ratings
- The strongest connection with full evidence chain
- Missing links (connections that should exist but do not)
- A central question the connection raises

## Output Format

```
## Domain A: <domain-A>
Hub Notes: [[<note-1>]], [[<note-2>]]
Key Themes: <themes>
Depth: <note count>

## Domain B: <domain-B>
Hub Notes: [[<note-1>]], [[<note-2>]]
Key Themes: <themes>
Depth: <note count>

## Bridges

### Bridge 1: <title>
Type: Surface | Structural
Strength: Weak | Moderate | Strong
Evidence:
- [[<note>]], <connection in domain A>
- [[<note>]], <connection in domain B>
Mechanism: <how the connection works>
Temporal Trend: Converging | Diverging | Stable

### Bridge 2: <title>
...

## Strongest Connection
<detailed analysis of the most significant bridge>

## Missing Links
<connections that logically should exist but are absent from the vault>

## Central Question
<the question this connection raises for both domains>
```

## Guidelines

- Every connection claim requires specific note citations.
- The best output makes you see both domains differently.
- Do not force connections where none exist; report sparse results honestly.
- Distinguish coincidental overlap from genuine structural parallels.
