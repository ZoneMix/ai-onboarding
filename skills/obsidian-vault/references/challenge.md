# /challenge

Argues against current thinking using vault evidence.

## Usage

```
/challenge
/challenge [topic]
```

## Process

### Step 1: Identify What to Challenge

Read context files for confidence markers: `[evolving]`, `[hypothesis]`, `[questioning]`.

```bash
obsidian search:context query="evolving"
obsidian search:context query="hypothesis"
obsidian search:context query="questioning"
obsidian daily:read
```

Review 1-2 weeks of daily notes. Extract beliefs explicitly, noting their stated confidence level.

### Step 2: Find Contradictions

Search for evidence against current positions:

- **Direct self-contradictions**: past statements that conflict with current ones
- **Abandoned positions**: beliefs once held strongly, now dropped without explanation
- **Unverified confidence**: positions stated as certain without supporting evidence
- **Blind spots**: areas where thinking has not evolved despite new information
- **Outdated thinking**: positions based on conditions that have changed

```bash
obsidian search:context query="<belief-keyword>"
obsidian search:context query="used to think"
obsidian search:context query="changed my mind"
obsidian search:context query="realized"
```

**Temporal weighting**: contradictions within the last 3 months suggest active confusion. Older contradictions are more likely natural growth.

### Step 3: Build Challenges

For each challenge:

```
### Challenge: <title>

**Current Position**: <what the vault owner currently believes>
Source: [[<note>]]

**The Problem**: <what's wrong or incomplete about this position>

**Evidence from Vault**:
- [[<note>]] says <contradicting evidence>
- [[<note>]] shows <undermining pattern>

**Question Raised**: <the uncomfortable question this evidence prompts>

**Severity**: Crack | Tension | Foundation Risk
```

- **Crack**: minor inconsistency, easily resolved
- **Tension**: meaningful conflict requiring deliberate thought
- **Foundation Risk**: challenges a core assumption that other beliefs depend on

### Step 4: Synthesize

```
Scope: <what was examined>
Beliefs Examined: <count>
Challenges Found: <count by severity>

## Patterns Across Challenges
<what the challenges collectively reveal>

## The Hardest Question
<single most uncomfortable question arising from all challenges>

## Recommended Actions
1. <concrete step>
2. <concrete step>
```

## Guidelines

- All claims require specific note citations.
- Challenges should prompt insight, not defensiveness.
- Be direct but not hostile; the goal is growth, not attack.
- Do not manufacture challenges where evidence does not support them.
- When a topic argument is provided, focus exclusively on that topic.
