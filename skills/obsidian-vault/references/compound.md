# /compound [question]

Asks the same question at different vault time periods to show how context compounds.

## Usage

```
/compound [question]
```

## Process

### Step 1: Question Validation

Assess whether the question benefits from temporal analysis.

**Suitable**: questions that depend on personal context, strategy, accumulated experience, or evolving beliefs.

**Unsuitable**: context-independent questions with stable, factual answers that do not change with personal growth.

If unsuitable, explain why and answer directly instead.

### Step 2: Temporal Mapping

Examine the vault to understand its timeline:

```bash
obsidian daily:list
obsidian search:context query="<question keywords>"
obsidian tags counts sort=count
```

Assess daily note density, context file timelines, backlink presence, and modification dates to establish the vault's temporal boundaries.

### Step 3: Period Selection

Choose 3 inflection points, early, middle, and present, based on when available material roughly doubled, not at fixed time intervals. The periods should reflect genuine knowledge accumulation milestones.

### Step 4: Context Inventory

For each period, exhaustively list all available materials with counts:

- Daily notes written by that point
- Context files that existed
- Relevant backlinks present
- Key notes and essays available

### Step 5: Predictions

Before generating answers, record expected quality changes between periods. What should improve? Where might compound effects appear? This creates a testable hypothesis.

### Step 6: Three Answers

Generate three equal-length responses (within ±20% of each other), one per period. Each answer uses ONLY the context available at that time.

Tag every claim with its source: `[from: <Context-File-A>]`, `[from: daily note <date>]`, etc.

**Hard context boundaries**: do not use information from a later period when answering an earlier one.

### Step 7: Verification

Check each answer for anachronisms, references to knowledge or events that did not exist during that period. Compare predictions from Step 5 against actual results.

### Step 8: Scorecard

Rate each period's answer on four dimensions (1-5 scale):

| Dimension | Period 1 | Period 2 | Period 3 |
|-----------|----------|----------|----------|
| Specificity | | | |
| Actionability | | | |
| Personal Relevance | | | |
| Cross-Domain Connections | | | |

## Output Format

```
Question: <question>
Validation: <suitable/unsuitable and why>

## Period 1: <date range> (<N> notes, <N> context files)
Context Available: <inventory>
Answer: <response with source tags>

## Period 2: <date range> (<N> notes, <N> context files)
Context Available: <inventory>
Answer: <response with source tags>

## Period 3: <date range> (<N> notes, <N> context files)
Context Available: <inventory>
Answer: <response with source tags>

## Scorecard
<table>

## Compound Effect Analysis
<where context accumulation made the biggest difference>
<what remained unchanged across periods>
<surprises vs predictions>
```

## Constraints

- Hard context boundaries: never bleed information across periods.
- Equal length ±20%: no period gets a longer answer simply because it has more context.
- Source tagging: every substantive claim must trace to a specific vault source.
- Null results are valid findings: if a period cannot answer the question, that silence is informative.
