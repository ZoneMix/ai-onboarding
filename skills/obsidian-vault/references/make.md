# /make

Identifies ideas ready to materialize into public work with readiness scoring.

## Usage

```
/make
```

## Process

### Step 1: Density Detection

Find topics with 10+ mentions across 5+ days.

```bash
obsidian search:context query="<candidate>"
obsidian tags counts sort=count
```

### Step 2: Originality Detection

Search for contrarian positions and unconventional frameworks.

```bash
obsidian search:context query="disagree"
obsidian search:context query="instead"
obsidian search:context query="actually"
```

### Step 3: Narrative Detection

Find documented arcs, belief changes, and turning points.

```bash
obsidian search:context query="realized"
obsidian search:context query="before"
obsidian search:context query="changed"
```

### Step 4: Tension Detection

Find unresolved questions with substance on both sides.

### Step 5: Resonance Detection

Find external validation through conversations, posts, feedback.

```bash
obsidian search:context query="conversation"
obsidian search:context query="feedback"
obsidian search:context query="resonated"
```

### Step 6: Cross-Reference

Check against published work and prior /make runs.

```bash
obsidian files folder="Essays"
obsidian search query="make-run"
```

### Step 7: Score

Rate each candidate on 4 dimensions (1-5 scale):
- **Depth**: enough material to sustain the piece
- **Originality**: a genuinely distinctive angle
- **Clarity**: the idea can be communicated clearly
- **Urgency**: timeliness or personal momentum

Total: /20

### Step 8: Natural Form Assessment

For each candidate, suggest 2-3 natural formats with reasoning:
- Essay, post, podcast episode, fiction, series, etc.

## Output Format

### Tiers

- **Ready** (16-20): can start writing today
- **Almost Ready** (11-15): needs one more thing
- **Developing** (6-10): worth tracking, not ready

## Anti-Patterns

- Do not inflate thin topics
- Do not assign single formats without considering alternatives
- Do not generate marketing hooks
- Do not conflate with other command outputs
- Do not produce vague candidates
- Every claim needs specific vault evidence
