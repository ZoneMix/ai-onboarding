# /drift

Identifies topics, projects, or commitments quietly being avoided based on gaps in notes (30-60 days).

## Usage

```
/drift
```

## Process

### Step 1: Extract Stated Intentions

Read context files and daily notes to build a list of commitments.

```bash
obsidian search:context query="goal"
obsidian search:context query="priority"
obsidian search:context query="project"
obsidian search:context query="commitment"
obsidian daily:read
```

Extract: goals, recurring items, active projects, stated priorities, and ongoing commitments.

### Step 2: Gather Actual Behavior

Analyze where time and attention actually went.

```bash
obsidian search:context query="completed"
obsidian search:context query="finished"
obsidian search:context query="worked on"
obsidian tags counts sort=count
```

Look at: calendar analysis, task completion patterns, daily note topics, vault activity frequency per topic.

### Step 3: Review Commitment Language

Search for unfulfilled promises in recent messages and notes.

```bash
obsidian search:context query="I'll"
obsidian search:context query="following up"
obsidian search:context query="I owe"
obsidian search:context query="need to"
obsidian search:context query="should"
```

Identify commitments to others that remain open.

### Step 4: Synthesize

Build an alignment scoring table comparing stated priorities against actual effort.

For each drifting item, apply the avoidance decision tree:
1. **Recent mentions?** If yes, not drifting. If no, continue.
2. **Capacity constraints?** Overwhelm vs avoidance looks different.
3. **Clarity of next steps?** Unclear tasks drift naturally.
4. **Relational blocks?** Waiting on someone else or avoiding a conversation.

## Output Format

```
## Alignment Scoring

| Priority | Stated Importance | Actual Effort (30d) | Gap |
|----------|-------------------|---------------------|-----|
| <item-1> | High | Low | Significant |
| <item-2> | Medium | High | Inverted |
| <item-3> | High | High | Aligned |

## Commitments to Others

| Commitment | To Whom | Date Made | Status |
|------------|---------|-----------|--------|
| <commitment-1> | <person> | <date> | Unfulfilled |

## Recurring Push Patterns

Items showing cyclical postponement (mentioned, deferred, mentioned again):
- <item>: mentioned on <dates>, never completed
- <item>: rescheduled <N> times

## Unexpected Time Drains

Activities consuming significant time without being listed as priorities:
- <activity>: <evidence>

## Recommendations

### Drop
<items consistently avoided, likely no longer important>

### Schedule (within 48 hours)
<urgent items that need immediate attention>

### Delegate
<items better suited for someone else>

### Reframe
<unclear tasks with suggested concrete next actions>
```

## Guidelines

- Cite specific dates and data for every observation.
- Compassion over criticism: drift is human, not failure.
- Distinguish intentional deprioritization from costly avoidance.
- Do not judge the vault owner; present facts and let them decide.
