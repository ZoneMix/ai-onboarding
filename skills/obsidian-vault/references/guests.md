# /guests

Derives interview subjects from active vault questions rather than existing guest pipelines.

## Usage

```
/guests
```

## Core Principle

"The best episodes happen when the host is already living inside the question the guest has spent years on."

## Process

### Step 1: Extract Live Questions

```bash
obsidian daily:read
obsidian search:context query="question"
obsidian search:context query="wondering"
obsidian search:context query="curious about"
obsidian search:context query="<Context-File-A>"
```

Identify 5-10 most active questions. Prioritize by recency, emotional energy, cross-domain patterns, and unresolved tensions.

### Step 2: Map Question Landscape

For each question, trace existing knowledge, identify gaps, map adjacent territories, and check previous episodes.

```bash
obsidian search:context query="<question keywords>"
obsidian backlinks file="<question-related-note>"
```

### Step 3: Find People

For each active question, identify candidates in 3 tiers:
- **Deep practitioners**: people who have spent years on this exact question
- **Adjacent explorers**: people working on related problems from different angles
- **Emerging voices**: newer thinkers with fresh perspectives

### Step 4: Score and Rank

Rate each candidate on 5 dimensions (1-5 scale):
- **Question alignment**: how directly they address the vault's active question
- **Vault depth**: how much existing context enables deeper conversation
- **Energy exchange**: predicted conversational chemistry
- **Discovery potential**: likelihood of genuinely new insights
- **Accessibility**: realistic chance of booking them

16+ points = strong candidate.

### Step 5: Preparation Paths

For strong candidates, provide:
- **Curiosity maps**: what to explore based on vault knowledge
- **Opening artifact**: a specific vault note or idea to open with
- **Dangerous questions**: questions that risk real disagreement
- **Conversation sequences**: suggested topic flow

### Step 6: Meta View

Analyze: question relationships, natural episode sequences, remaining gaps after proposed guests.

## Disqualify

- No authentic vault connection to the person's work
- Already featured
- The question has been resolved
- Would require faking interest
- Suggested purely for audience metrics

## Anti-Patterns

- Rolodex-building (inviting for status, not questions)
- Brief repackaging (restating their public talking points)
- Category-filling (one tech person, one creative, etc.)
- Safe suggestions (guaranteed pleasant but shallow)
- Audience optimization (who would get clicks vs who would produce insight)
- Repeats without new questions
- Flat conversationalists (interesting work, boring to talk to)
- Forced diversity without genuine alignment
