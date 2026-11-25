# /vault-map: Vault Topology Analysis

Generate a topological view of vault clusters, themes, and relationships.

## Instructions

1. Load the obsidian-vault skill for CLI reference
2. Read the detailed workflow from the skill's [map.md](~/.claude/skills/obsidian-vault/references/map.md) reference
3. Target the vault specified by the user (ask which one if it is unclear)
4. Execute this workflow:

### Step 1: Structural Analysis
```bash
obsidian.com tags counts sort=count vault="$VAULT"
obsidian.com orphans vault="$VAULT"
obsidian.com deadends vault="$VAULT"
obsidian.com unresolved vault="$VAULT"
obsidian.com files vault="$VAULT"
```

### Step 2: Identify Clusters
Trace backlink chains from most-connected notes. For each cluster: central node, size, density, health.

### Step 3: Find Gaps
- Missing connections between clusters
- Orphaned value worth rescuing
- Tag-to-priority ratio analysis
- Dead zones (stated priority but few notes)

### Step 4: Synthesize
Output: vault overview, cluster map, shape narrative, tag analysis, gaps, recommended actions.

$ARGUMENTS
