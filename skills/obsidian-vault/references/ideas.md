# /ideas

Generates new ideas from projects, interests, and open questions.

## Usage

```
/ideas
```

## Process

### Step 1: Vault Structure Exploration

```bash
obsidian search:orphans
obsidian search:deadends
obsidian search:unresolved
obsidian tags counts sort=count
```

Analyze orphans, deadends, unresolved links, tag distributions, backlink chains, and cross-domain patterns.

### Step 2: Deep Context Review

```bash
obsidian daily:read
obsidian search:context query="<Context-File-A>"
obsidian search:context query="frustrated"
obsidian search:context query="excited"
obsidian search:context query="idea"
obsidian search:context query="question"
```

Review: daily notes (30 days), context files, calendar (past/next 2 weeks), social media, messages, essays. Extract frustrations, energy sparks, recurring interests, unsolved problems, unanswered questions.

### Step 2.5: Temporal Tracking

Check previous /ideas runs to see what gained traction vs what was abandoned.

```bash
obsidian search query="ideas-run"
```

### Step 3: Pattern Analysis

Synthesize: what is working, what is frustrating, what is missing, what keeps recurring, what is bottlenecked.

### Step 4: Generate Ideas

3-5 ideas per category:
- Tools to build
- Tools to start using
- Systems to implement
- Products to purchase
- Habits to adopt
- Subjects to investigate
- Things to write
- Films to watch
- Conversations to have
- Experiments to run

### Step 5: Prioritize

- **Top 5 high-impact do-now**: can start today with existing resources
- **Top 5 needs setup**: requires preparation but high potential
- **Top 5 non-obvious**: surprising connections the vault owner likely has not considered
- **The one thing**: if only one idea could be pursued, which one

### Step 6: Connect to Exploration

- Tomorrow's exploration: one specific thing to try
- This week's investigation: a question to research
- This month's experiment: a longer commitment to test

## Guidelines

- Be specific, not generic. "Build a tool that..." not "Consider building something."
- Cite vault sources for every idea.
- Distinguish obvious-but-important from non-obvious ideas.
- Include effort estimates where possible.
