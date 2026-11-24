# /contradict

Finds places where incompatible beliefs are held simultaneously.

## Usage

```
/contradict
```

## Process

### Step 1: Extract Beliefs

Read context files and 14-21 days of daily notes. Identify belief markers:

```bash
obsidian search:context query="I believe"
obsidian search:context query="I think"
obsidian search:context query="decided"
obsidian search:context query="should"
obsidian search:context query="always"
obsidian search:context query="never"
obsidian daily:read
```

Look for: strong assertions, advice given to others, decisions made, priorities stated, positions rejected. Extract a minimum of 15-20 beliefs.

Format each belief as:
- **Belief**: the stated or implied position
- **Source**: `[[<note>]]` with date
- **Implied inverse**: what the belief implicitly rejects

### Step 2: Detection

**Method 1, Explicit Contradictions**:
- Within-domain: beliefs about the same topic that conflict
- Cross-domain: beliefs from different areas that imply incompatible principles

**Method 2, Implicit Contradictions**:
- Stated values vs revealed preferences (what is said vs what is done)
- Advice given to others vs own behavior

**Method 3, Priority Contradictions**:
- Compare priority language across context files
- Look for areas where multiple things are each described as "most important"

### Step 3: Evolution Filter

Apply 4 mandatory tests to each candidate contradiction:

1. **Temporal Currency**: are both beliefs still active? If one is clearly outdated, it is evolution, not contradiction.
2. **Domain Compartmentalization**: can both be true in separate domains? "Move fast" in personal projects and "be careful" in client work is not a contradiction.
3. **Confidence Markers**: compare `[solid]` vs `[hypothesis]` vs `[evolving]`. Two hypotheses coexisting is exploration, not contradiction.
4. **Cannot Both Be True**: is there a reasonable interpretation where both positions coexist? If yes, it is not a genuine contradiction.

### Step 4: Classification

For each surviving contradiction:

**Category**:
- **Resolve**: one must be wrong; needs active decision
- **Hold**: productive tension worth maintaining deliberately
- **Celebrate**: contradictions that reflect healthy complexity

**Weight**:
- **Trivial**: low-stakes preferences
- **Moderate**: affects decisions but not identity
- **Significant**: shapes major life/work choices
- **Foundational**: touches core identity or worldview

### Step 5: Output

For each contradiction:

```
## Contradiction: <title>

**Belief A**: <statement>
Source: [[<note>]], Confidence: <level>

**Belief B**: <statement>
Source: [[<note>]], Confidence: <level>

**Why Incompatible**: <explanation>
**Category**: Resolve | Hold | Celebrate
**Weight**: Trivial | Moderate | Significant | Foundational
**Action**: <recommended next step>
```

### Synthesis

```
Total Contradictions: <N>
By Category: Resolve (<N>), Hold (<N>), Celebrate (<N>)
By Weight: Trivial (<N>), Moderate (<N>), Significant (<N>), Foundational (<N>)

Deepest Contradiction: <the one that touches the most fundamental level>

Pattern Analysis: <what the contradictions reveal about the vault owner's thinking style>
```

## Anti-Patterns

- **Evolution Trap**: labeling natural growth as contradiction (old belief replaced by new one)
- **Nuance Destroyer**: forcing binary where nuance exists
- **Contradiction Factory**: manufacturing conflicts from ambiguous language
- **Problem Frame**: presenting all contradictions as problems to fix
- **Surface Scanner**: only finding obvious conflicts while missing structural ones
- **The Therapist**: psychoanalyzing the vault owner instead of reporting findings
