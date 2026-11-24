# /trace [topic]

Track how thinking about an idea evolved over time through daily notes.

## Usage

```
/trace [topic]
```

## Process

### Step 1: Synonym Discovery

Search multiple formulations of the topic across the vault. Cast a wide net for how the idea might be expressed.

```bash
obsidian search:context query="<topic>"
obsidian search:context query="<synonym-1>"
obsidian search:context query="<synonym-2>"
obsidian tags counts sort=count
```

### Step 2: Implicit Pattern Detection

When explicit mentions are scarce, look for decisions, emotions, and approaches that reflect the idea without naming it. Search for behavioral evidence: choices made, tools adopted, projects started or abandoned that imply the topic's influence.

### Step 3: Follow the Graph

From significant mentions, trace backlinks and forward links 2-3 hops outward.

```bash
obsidian backlinks file="<significant-mention>"
obsidian links file="<significant-mention>"
obsidian backlinks file="<hop-2-note>"
```

### Step 4: Build Timeline

Organize all findings chronologically. For each moment, record:

- **Date**: when it appeared
- **Context**: what was happening at the time
- **Thinking**: what the vault owner believed or explored
- **Confidence level**: how certain or tentative the position was
- **What prompted shifts**: events, conversations, or realizations that changed direction

Weight recent mentions more heavily than older ones.

### Step 5: Identify the Arc

Synthesize the timeline into a narrative arc:

- **First appearance**: when the topic first surfaced
- **Inflection points**: moments where thinking shifted meaningfully
- **Current position**: where thinking stands now
- **Confidence markers**: how certain vs exploratory the current stance is
- **Evolution pattern**: classify as linear deepening, pivots, convergence, divergence, or circular
- **Unresolved tensions**: contradictions or open questions that remain
- **Likely trajectory**: where thinking appears headed based on momentum

## Output Format

```
Topic: <topic>
First Appearance: <date>
Time Span: <duration>
Mention Count: <N>
Velocity: Accelerating | Steady | Dormant

## Timeline

### <date>: <context>
<thinking at this moment>
Confidence: <level>
Prompted by: <trigger>
Source: [[<note-name>]]

### <date>: <context>
...

## The Arc

<narrative describing how thinking evolved>

## Confidence Evolution

<how certainty changed over time>

## Unresolved Tensions

- <tension-1>
- <tension-2>

## Next Directions

- <likely-direction-1>
- <likely-direction-2>
```

## Guidelines

- Cite specific notes and dates for every claim.
- Distinguish between explicit mentions and implicit behavioral evidence.
- Do not invent evolution that the vault does not support.
- When the trail goes cold, say so rather than filling gaps with speculation.
- Weight recent data more heavily but do not ignore foundational early mentions.
