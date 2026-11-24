# /close-day: End-of-Day Processing

Reviews what happened today, captures what you learned, and flags anything unresolved for tomorrow. Processes the daily note into durable vault value.

## Usage

```
/close-day
```

## Process

### Step 1: Read Today's Daily Note

```bash
obsidian daily:read
```

### Step 2: Extract Action Items

Scan for:
- Completed tasks, acknowledge and archive
- Incomplete tasks, determine: carry forward, delegate, or drop
- New commitments made during the day
- Promises to others that need follow-up

### Step 3: Capture Learnings

Identify from today's note:
- Insights and realizations
- Changed perspectives
- New connections between ideas
- Surprising moments
- Solved problems worth documenting

### Step 4: Surface Vault Connections

For each learning or insight:

```bash
obsidian search:context query="<learning topic>"
obsidian backlinks file="<related note>"
```

Find:
- Existing notes that connect to today's insights
- Contradictions between today's thinking and earlier positions
- Patterns that confirm or challenge ongoing threads

### Step 5: Track Confidence Changes

Note any shifts in confidence markers:
- What moved from `[hypothesis]` to `[evolving]`?
- What moved from `[solid]` to `[questioning]`?
- What new hypotheses emerged?

### Step 6: Prepare for Tomorrow

Flag:
- Unresolved items requiring action
- Questions to sit with overnight
- Context needed for tomorrow's commitments
- Energy observations (high/low periods, what drained, what energized)

## Output

Append to today's daily note:

```bash
obsidian daily:append content="## End of Day\n\n### Completed\n- ...\n\n### Carry Forward\n- ...\n\n### Learned\n- ...\n\n### Tomorrow\n- ..."
```

Structure:
1. **Completed**: What got done
2. **Carry forward**: What moves to tomorrow (with reason)
3. **Learned**: Key insights with vault connections
4. **Confidence shifts**: What changed in certainty
5. **Tomorrow**: Setup for the next day

## Guidelines

- Be honest about what didn't happen, avoidance patterns are data
- Connect learnings to existing vault notes with `[[backlinks]]`
- Note recurring themes across multiple close-day entries
- Keep the tone reflective, not performative
