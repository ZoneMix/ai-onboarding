# /schedule: Context-Aware Scheduling

A ruthless prioritization engine. Time is the scarcest resource. Your job is to protect it.

## Usage

```
/schedule
/schedule <event or request to evaluate>
```

## Philosophy

- Only the highest-impact items deserve calendar space
- Everything else should be eliminated, delegated, or compressed
- Context determines importance, not urgency
- Saying no to good things enables saying yes to great things
- Protected time for deep work and personal commitments is non-negotiable

## Process

### Step 1: Load Context

Read context files to understand what actually matters:

```bash
obsidian read file="<Context-File-A>"
obsidian read file="<Context-File-B>"
obsidian read file="<Context-File-C>"
```

Read recent daily notes (last 3-5 days):

```bash
obsidian daily:read
obsidian read path="8_DAILY/YYYY-MM-DD.md"
```

Look for: current focus, blockers, energy levels, what's top of mind. Pay attention to confidence markers.

Follow backlinks to understand referenced projects or people:

```bash
obsidian backlinks file="<name>"
```

### Step 1.5: Clarify the Ask

Before analyzing, classify the request type:
- **Attend**: Be present at someone else's event. Cost = duration + travel + context switch.
- **Lead**: Run or organize something. Cost = duration + prep + follow-up.
- **Prepare**: Create something before a deadline. Cost = work time, flexible on when.
- **Block time**: Protect a window for focused work. Cost = the block itself.

Different types have different scheduling strategies. A "prepare" can be chunked. An "attend" is fixed.

### Step 1.75: Backlink the Request

Check if this person, project, or topic appears elsewhere:

```bash
obsidian search:context query="<person name>"
obsidian search:context query="<project or topic>"
obsidian backlinks file="<related note if exists>"
```

This reveals:
- Is this person connected to a current priority? (Raises importance)
- Is this topic something you've been thinking about? (Changes framing)
- Have you engaged with this person before? What happened? (Provides history)
- Does this connect to an open question in a context file? (Makes it strategic)

### Step 2: Get Calendar State

Identify existing commitments, patterns, and open blocks for the relevant time period (next 2 weeks by default). Note recurring meetings that may be candidates for elimination.

### Step 3: Analyze the Request

1. **Alignment Score (1-10)**: How well does this align with current priorities?
2. **Impact Assessment**: What's the potential upside? What happens if this doesn't happen?
3. **Time Cost**: Duration + context-switching + travel + prep + recovery
4. **Opportunity Cost**: What deep work or personal time does this displace?

### Step 3.5: Conflict Resolution

If the new request conflicts with existing commitments:
- **Explicitly state what gets cancelled or moved**: don't just suggest a time
- **Rank the conflict**: is the existing item more or less important?
- **Propose the trade**: "To fit X on Tuesday, you'd need to move Y to Thursday. Y is lower priority because [reason]."
- **Hard constraint violations**: if the request would violate a hard constraint, say so directly and propose alternatives. Never silently compromise a hard constraint.

### Step 4: Make Recommendations

**If scheduling something new:**
- Suggest optimal time based on energy patterns, existing commitments, travel time, context batching
- If the item scores low on alignment, push back: "Is this actually necessary?"

**If reviewing/auditing calendar:**
- **Cancel**: Low alignment, no clear outcome, attendance optional
- **Shorten**: 1hr meetings that could be 30min
- **Async**: Could be an email or message thread
- **Delegate**: Someone else could handle

### Step 5: Present Options

Always present:
1. **Recommended action** with reasoning tied to context
2. **Trade-offs** explicitly stated
3. **What to cancel or move** if calendar is full
4. **The "do nothing" option**: sometimes the answer is don't schedule it

## Output Format

**Context Summary** (2-3 sentences on current priorities)

**The Ask** (attend/lead/prepare/block)

**Vault Connections** (what the vault reveals about this person/topic/project)

**Recommendation** (what to do and when)

**Trade-offs** (what this displaces or enables)

**Calendar Changes** (cancellations/moves with trade-off reasoning)

Ask for confirmation before making any calendar changes.

## Hard Constraints

Define your own in your context files. Examples:
- No meetings after a certain time (family commitments)
- Protect 2-3+ hour focus blocks for deep work
- Buffer time before/after key events
