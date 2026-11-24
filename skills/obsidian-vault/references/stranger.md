# /stranger

Writes a portrait of the vault owner as seen by someone who has never met them.

## Usage

```
/stranger
```

## Process

### Step 1: Structural Analysis First

Map vault shape before reading content.

```bash
obsidian search:orphans
obsidian search:deadends
obsidian tags counts sort=count
obsidian files
```

Analyze: folder organization, note count distribution, orphan patterns, tag hierarchies, link density.

### Step 2: Content Reading

Read context files, daily notes, essays, and follow the most-linked notes.

```bash
obsidian daily:read
obsidian search:context query="<Context-File-A>"
obsidian backlinks file="<most-linked-note>"
```

### Step 3: Seven Forced Analyses

1. **Topic Frequency**: what is lived vs merely theorized about. Count mentions and daily presence.
2. **Stated vs Revealed Priorities**: gaps between what is declared important and where time actually goes. The gaps matter most.
3. **Emotional Frequency**: which emotions appear most often in writing. What is the baseline emotional register.
4. **Relationship Mapping**: who appears, how often, in what contexts. Network shape matters.
5. **Recurring Questions as Obsessions**: questions asked repeatedly reveal what the person cannot resolve. These are obsessions, not curiosity.
6. **Writing Style Fingerprints**: sentence length, vocabulary range, metaphor patterns, humor presence, directness level.
7. **Conspicuous Absences**: what a person of this profile would normally write about but does not. The silence is data.

### Step 4: Portrait Composition

Write in 5 sections:

1. **Immediate Impression**: what strikes you first about this person from their notes
2. **What They Care About**: the actual priorities revealed by attention, not declaration
3. **Trajectory**: where they appear to be heading based on momentum
4. **Patterns Invisible From Inside**: things the vault owner likely cannot see about themselves
5. **The Unasked Question**: the question the vault seems to be circling without asking directly

## Output Format

The portrait should be written in third person, as if by a perceptive stranger. Every observation must trace to specific vault evidence cited in parentheses.

```
## Portrait

### Immediate Impression
<what strikes a stranger first>

### What They Care About
<revealed priorities with evidence>

### Trajectory
<where they are heading>

### Patterns Invisible From Inside
<blind spots, with vault evidence>

### The Unasked Question
<the question the vault circles but never asks>
```

## Rejects

- Flattery: the portrait must be honest, not kind
- Therapy-speak: observations, not diagnoses
- Summarization: insight, not recap
- Genericity: every claim must be specific to this vault
- Judgment: describe without moralizing
- Diplomatic hedging: be direct about what the evidence shows
