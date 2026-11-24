# /today: Generate a Daily Plan

Pulls from recent notes, calendar, and open threads to generate a daily plan grounded in what's actually happening, not generic productivity advice.

## Usage

```
/today
```

## Process

### Step 1: Load Calendar + Tasks

Check today's commitments and outstanding tasks:

```bash
obsidian daily:read
obsidian tasks daily
obsidian tasks
```

### Step 2: Read Recent Messages

Check for outstanding commitments and requests from recent communications.

### Step 3: Review Recent Daily Notes

Read the last 3-5 daily notes for patterns and unfinished threads:

```bash
obsidian read path="8_DAILY/YYYY-MM-DD.md"
```

Extract:
- Unfinished tasks carried forward
- Open questions and blockers
- Energy patterns and momentum

### Step 4: Load Context Files

Read core context files to understand ongoing projects and strategic focus:

```bash
obsidian read file="<Context-File-A>"
obsidian read file="<Context-File-B>"
```

### Step 4 (Preliminary Priorities): Build Initial Priority List

Based on Steps 1-4, draft preliminary priorities before deeper vault exploration.

### Step 4.5: Vault Exploration

Test preliminary priorities against deeper vault patterns:

```bash
obsidian search:context query="<preliminary priority A>"
obsidian backlinks file="<related note>"
obsidian tags counts sort=count
```

This two-pass approach surfaces disconnects between what feels urgent and what your thinking actually centers on.

### Step 5: Check Hard Constraints

Before finalizing, check for structural changes to the day:
- Solo parenting or family commitments
- Travel or recording sessions
- Meeting density that overrides normal ranking
- Energy or health constraints noted in recent daily notes

### Step 6: Synthesize

Produce:

1. **Core theme**: One sentence capturing the day's throughline
2. **Top 2 priorities**: Ranked with vault context explaining why these matter now
3. **5 quick wins**: Small tasks that clear mental space
4. **Meeting audit**: For each meeting: keep/cancel/shorten recommendation with reasoning

## Output Format

Present as a clear, actionable daily brief. If data is sparse, expand search ranges rather than defaulting to "nothing today."

Optionally generate an interactive HTML dashboard with:
- localStorage persistence for progress tracking
- Clickable task completion toggles
- Real-time progress indicators

## Guidelines

- Prioritize clarity and actionability over exhaustiveness
- Treat sparse data as a signal to expand search, not to give up
- Ground every recommendation in specific vault evidence
- Flag when stated urgency conflicts with vault-evidence importance
