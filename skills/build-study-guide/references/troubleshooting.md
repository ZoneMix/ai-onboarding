# Troubleshooting Reference

Failure modes seen during real runs and how to recover.

## Agent hits 32K output token limit

**Symptom**: Agent reports `API Error: Claude's response exceeded the 32000 output token maximum.` after many tool calls. Output file may or may not exist.

**Cause**: Agent finished reading all images but the Write tool call plus the final summary response together exceed the output budget.

**Recovery**:
1. Check if the output file actually got written: `ls -la /tmp/study-guide-part*.md`
2. If written but content looks truncated/wrong: re-launch with smaller workload (split the file group in half)
3. If not written: re-launch with stronger write-first instruction and smaller workload

**Prevention**: Always include in agent prompt:
```
CRITICAL: Write the output file FIRST using the Write tool, BEFORE composing your final response.
Keep your final response under 200 words.
```

## Agent stalls after context compaction

**Symptom**: Background agent from a previous context never reports completion. JSONL file stops growing.

**Cause**: Context compaction in the parent session can sever the link to background agents. They may keep running but lose the ability to report back.

**Recovery**:
```bash
# Find the agent's JSONL
ls -la /Users/<user>/.claude/projects/<project>/subagents/agent-*.jsonl

# Check last modification time
stat -f '%Sm' <jsonl_path>

# Compare to current time: if >5 minutes stale, agent is stuck
date
```

If stalled: stop the agent (`TaskStop` with the agent ID) and re-launch with a fresh ID.

**Prevention**: Avoid spawning long-running agents right before a likely compaction point. If you must, split into smaller workloads.

## Output filename collision

**Symptom**: A part file you expected to contain section X.Y actually contains section A.B. Concatenated guide has wrong order or duplicate sections.

**Cause**: When you stop a stalled agent and re-launch, both the old (zombie) agent and the new agent target the same `/tmp/study-guide-partN.md`. Whichever finishes last wins. The old agent often finishes minutes later and overwrites the new agent's correct output.

**Recovery**:
1. Check filename and starting section: `head -3 /tmp/study-guide-part*.md`
2. If wrong content, re-launch the new agent with a unique suffix: `/tmp/study-guide-part4-new.md`
3. Update concat command to use the suffixed file

**Prevention**: When relaunching any agent, always change the output filename. Don't reuse paths that a stalled agent might still be holding.

## Image not found on disk

**Symptom**: Agent reports cannot find image file. Output keeps the original `![](...)` reference.

**Causes**:
1. Image filename is URL-encoded in markdown but the file on disk has the decoded form (or vice versa)
2. Obsidian wikilink (`![[name.png]]`) resolves to a different path than the markdown reference suggests
3. Image was deleted or moved without updating references

**Recovery**:
```bash
# List all image references in the content
grep -hoE '!\[\]\([^)]+\)|!\[\[[^\]]+\]\]' content/*.md | sort -u

# Find images that exist
ls imgs/ 99\ -\ Meta/assets/  # whatever directories the project uses

# Diff to find missing
```

If images genuinely missing: replace with a placeholder slide block noting the missing image, don't fail the whole build.

## Section ordering wrong after concat

**Symptom**: `2.10` appears before `2.2` in the final guide.

**Cause**: Shell glob expansion or `sort` without `-V` (version sort) sorts alphabetically.

**Recovery**: Use `sort -V` or explicit `cat file1 file2 ...` listing.

```bash
# Wrong
cat /tmp/study-guide-part*.md > final.md   # alphabetical, broken for 2.10 vs 2.2

# Right
cat /tmp/study-guide-part1.md /tmp/study-guide-part2.md ... > final.md
# or
ls /tmp/study-guide-part*.md | sort -V | xargs cat > final.md
```

## Headers inside slides render as document headers in PDF

**Symptom**: PDF outline shows hundreds of "List all VMs" entries pulled from inside slide blocks. Document outline is unusable.

**Cause**: `> # text` and `> ## text` inside blockquotes render as actual H1/H2 in most markdown-to-PDF tools.

**Recovery**: Run `scripts/postprocess.py` which converts these to `> **text**` (bold, doesn't pollute the outline).

## Partial concat: missing sections

**Symptom**: Final guide is missing whole sections (e.g., 2.6-2.8 don't appear).

**Cause**: One of the parallel agents failed silently, the part file was never written, and the concat skipped it.

**Recovery**:
1. Check which parts exist: `ls /tmp/study-guide-part*.md`
2. Compare against expected count
3. Re-launch agents for the missing groups
4. Re-concatenate

**Prevention**: After spawning all agents, list expected output files and verify all exist before concat.
