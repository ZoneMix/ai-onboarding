# /weekly-learnings

Compiles the week's insights from daily notes into a writing-ready summary for a team email.

## Usage

```
/weekly-learnings
```

## Process

### Step 1: Review Previous Emails

Read the previous 2 weekly emails to extract tone, unresolved threads, and promised follow-ups.

```bash
obsidian search query="weekly-email"
obsidian search:context query="weekly update"
```

### Step 2: Mine Daily Notes

Read all daily notes from the past 7 days.

```bash
obsidian daily:read
```

Extract: work completed, conversations had, ideas generated, decisions made, surprises encountered.

### Step 3: Load Context Files

```bash
obsidian search:context query="<Context-File-A>"
```

Connect daily findings to strategic context.

### Step 3.5: Trace Idea Evolution

Look for patterns across days: recurring themes, conversation ripples, ideas that evolved.

### Step 4: Review Social Media

Check publicly posted topics and high-engagement content from the week.

### Step 5: Review Calendar

Analyze meetings and time allocation for the week.

### Step 6: Review Messages

Check for important decisions made in conversations.

### Step 7: Synthesize to Terminal

Output directly to terminal. Do not create files.

## Output Format

```
## Previous Threads
- <thread from last email and its status>

## Candidate Topics (ranked)
1. <topic>, <why it matters>, <source>
2. <topic>, <why it matters>, <source>
...5-8 candidates

## Connecting Thread
<the theme that ties this week together>

## Operational Updates
<brief status items>

## Suggested Structure (3-4 sections, ~1 hour to write)
1. <section title>, <what to cover>
2. <section title>, <what to cover>
3. <section title>, <what to cover>
```

## Key Principle

Surface patterns, connect specifics to broader ideas, deliver insights over recaps. Output to terminal only -- no files created.
