# /ghost [question]

Answers any question as the vault owner by reading their notes, beliefs, and writing style.

## Usage

```
/ghost [question]
```

## Process

### Step 1: Load Full Context

Read all context files, recent daily notes (14+ days), essays, and key notes.

```bash
obsidian search:context query="<Context-File-A>"
obsidian daily:read
obsidian files folder="Essays"
obsidian tags counts sort=count
```

Build comprehensive understanding of voice, values, priorities, and thinking patterns.

### Step 2: Analyze Writing Style

Identify characteristic patterns:
- Sentence structure (short and punchy vs long and complex)
- Vocabulary preferences (technical vs casual, specific terms they favor)
- Metaphor usage (what domains they draw analogies from)
- Humor style (dry, self-deprecating, observational, absent)
- Directness level (hedging vs assertive)
- How they handle uncertainty (acknowledge vs avoid)
- How they frame arguments (evidence-first vs intuition-first)

### Step 3: Map Relevant Knowledge

For the specific question, search the vault for all relevant content.

```bash
obsidian search:context query="<question keywords>"
obsidian backlinks file="<related notes>"
obsidian tags counts sort=count
```

### Step 4: Generate Answer

Respond to the question AS the vault owner, using:
- Their vocabulary and tone
- Their frameworks and mental models
- Their actual positions on related topics
- Their confidence markers
- Their characteristic way of handling ambiguity

### Step 5: Verify Fidelity

Check the answer against vault evidence. Flag claims that extrapolate beyond what the vault supports.

Use confidence markers:
- **[solid]**: well-evidenced positions backed by multiple vault sources
- **[extrapolated]**: reasonable inferences from vault patterns
- **[speculative]**: best guesses based on limited evidence

## Output Format

```
## Answer

<the answer written in the vault owner's voice>

## Fidelity Report

Sources Used:
- [[<note-1>]], <what it contributed>
- [[<note-2>]], <what it contributed>

Confidence:
- <claim-1>: [solid], based on <evidence>
- <claim-2>: [extrapolated], inferred from <pattern>
- <claim-3>: [speculative], limited vault evidence
```

## Guidelines

- Never fabricate positions the vault does not support.
- Prefer saying "I don't have a clear view on this" over inventing a position.
- Match the emotional register of the vault owner's actual writing.
- Use their real examples and stories where relevant.
- The fidelity report is mandatory; the answer alone is not enough.
