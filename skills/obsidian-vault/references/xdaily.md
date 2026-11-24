# /xdaily

Pulls social media posts and threads into relevant daily notes.

## Usage

```
/xdaily
```

## Process

### Step 1: Read Today's Daily Note

```bash
obsidian daily:read
```

### Step 2: Extract Posts

Use browser automation to extract tweets from the vault owner's profile. Target tweet elements, extract text and timestamps, scroll for 5-7 days of content, retrieve full text for truncated tweets.

### Step 3: Filter Against Daily Note

Keep posts that contain:
- Unexplored ideas
- Creative concepts
- Pattern observations
- Strategic thinking
- High-engagement posts (indicates resonance)
- Public decisions or commitments

**Exclude**: casual jokes, duplicates of vault content, simple retweets, one-off reactions.

```bash
obsidian search query="<post keyword>"
```

Search vault for connections to each candidate post.

### Step 4: Present Filtered Suggestions

For each suggestion:
- **Title**: brief description
- **Text**: the post content
- **Rationale**: why it belongs in the daily note
- **Vault connections**: related notes found

### Step 5: Add Approved Items

For each approved item, add to the daily note with:
- Separators between entries
- First-person conversational tone
- Natural [[backlinks]] to related vault notes
- #idea tags where the post contains a genuinely new idea
- Preserved tweet energy enriched with vault context

## Guidelines

- Maintain the casual energy of the original post while adding vault depth.
- Do not over-formalize social media content.
- Backlinks should feel natural, not forced.
