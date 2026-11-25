# /backlinks: Wire Missing Connections

Find notes that should be linked but aren't and wire new connections across the vault.

## Instructions

1. Load the obsidian-vault skill for CLI reference
2. Read the detailed workflow from the skill's [backlinks.md](~/.claude/skills/obsidian-vault/references/backlinks.md) reference
3. Target the vault specified by the user (ask which one if it is unclear)
4. Execute this workflow:

### Phase 1: Structural Inventory
```bash
obsidian.com orphans vault="$VAULT"
obsidian.com deadends vault="$VAULT"
obsidian.com unresolved vault="$VAULT"
obsidian.com tags counts sort=count vault="$VAULT"
```

### Phase 2: Priority Context
Read MOCs, context files, and recent daily notes to understand what connections matter most.

### Phase 3: Identify Connections
For each orphan worth rescuing:
- Score on Conceptual Strength (1-5), Structural Impact (1-5), Priority Alignment (1-5)
- Only recommend connections scoring 15+ (composite)

### Phase 4: Present Recommendations
Present a table of recommended connections with scores and one-sentence explanations. Cap at 30 recommendations.

### Phase 5: Execute
On confirmation, append backlinks to notes and create stub notes for high-frequency unresolved links.

$ARGUMENTS
