# /7plan: Reshape the Next 7 Days

Looks at what's most alive in your thinking right now and reshapes the next 7 days around it. Not a task planner, a thinking-priority allocator.

## Usage

```
/7plan
```

## Process

### Step 1: Identify What's Alive

Read recent daily notes and context files to find what has genuine energy:

```bash
obsidian daily:read
obsidian read path="8_DAILY/YYYY-MM-DD.md"   # past 5-7 days
obsidian read file="<Context-File-A>"
obsidian read file="<Context-File-B>"
```

Look for:
- Topics that keep appearing across multiple days
- Questions you return to unprompted
- Ideas with increasing confidence markers
- Projects where momentum is building
- Themes with emotional energy (excitement, frustration, curiosity)

### Step 2: Map Current Commitments

Get the existing shape of the week:
- Calendar events and meetings
- Deadlines and deliverables
- Recurring obligations
- Travel or location constraints

### Step 3: Identify the Gap

Compare what's alive in your thinking vs. what the week is currently shaped around:
- Where does calendar time align with thinking energy? (Good)
- Where does calendar time NOT align? (Candidates for restructuring)
- Where is thinking energy high but zero time allocated? (Biggest gap)

### Step 4: Reshape

For each day of the next 7:

1. **Protect**: Block time for what's most alive
2. **Move**: Shift flexible commitments to create space
3. **Cancel**: Remove low-alignment items
4. **Batch**: Group similar activities together
5. **Rest**: Ensure recovery time exists

### Step 5: Synthesize

Produce:

1. **The throughline**: What this week is really about (one sentence)
2. **Day-by-day plan**: For each day: primary focus, protected time, key commitments
3. **What got cut**: Items removed or deferred, with reasoning
4. **The bet**: The single highest-leverage thing to protect this week
5. **Risk factors**: What could derail this plan

## Output Format

```
7-DAY PLAN, [Start Date] to [End Date]

THROUGHLINE: [One sentence]

THE BET: [The one thing to protect above all else]

[Day-by-day breakdown]

CUT LIST: [What was removed and why]

RISKS: [What could derail this]
```

## Guidelines

- Energy and interest trump urgency, a week spent on the wrong things is worse than a week with gaps
- Don't over-schedule, leave 20-30% unstructured for thinking and serendipity
- Recent vault activity is the best signal for genuine priority, not stated goals
- If the same topic appears in 3+ daily notes, it deserves dedicated time this week
