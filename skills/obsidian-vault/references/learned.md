# /learned

Turns recent learnings into polished posts or essays.

## Usage

```
/learned [topic]
/learned
```

## Process

### Step 1: Find Raw Material

**With argument**: search vault for the specified topic.

```bash
obsidian search:context query="<topic>"
obsidian backlinks file="<topic-note>"
```

**Without argument**: read today's note. If sparse, read the past 3 days. Extract insights, solved problems, perspective changes, surprising moments.

```bash
obsidian daily:read
```

### Step 2: Pull Supporting Context

```bash
obsidian search:context query="<insight keywords>"
obsidian backlinks file="<related note>"
obsidian tags counts sort=count
obsidian search:orphans
```

Search context files, essays, backlinks, tags, orphans.

**Temporal velocity check**:
- **Accelerating**: topic is gaining momentum -- ready to publish
- **Steady**: needs a new angle to feel fresh
- **Decelerating**: needs more experience before writing

### Step 3: Research Beyond Vault

Identify gaps that external research could fill: scientific research, frameworks from other disciplines, historical examples, counterintuitive findings.

### Step 4: Understand What Works

The best writing combines personal specificity with universal resonance, strong opinions with concrete details.

### Step 4.5: Identify Non-Obvious Angle

What would surprise readers? Where does the vault owner's experience diverge from standard advice?

### Step 5: Generate 3 Versions

1. **Short post** (1-3 paragraphs): sharp opening, one concrete detail, clean ending.
2. **Personal essay** (300-600 words): specific moment as entry point, concrete examples, question ending.
3. **Universal essay** (800-1500 words): define the reader first, diagnose then reframe, maintain momentum throughout.

### Step 6: Ask for Direction

Which version resonates? What changes? Post now or save as draft?

## Guidelines

- Voice: direct, curious, intense. Never preachy.
- No headers in prose pieces.
- Concrete details over abstract claims.
- End with questions, not conclusions.
