# <Project name>

<One or two sentences: what this is, the stack, and who uses it.>

## Commands

```
<install>
<build>
<test>
<lint / format check>
```

All of these must pass before a commit lands. <Say where CI runs them, if it does.>

## Layout

| Path | Owns |
|---|---|
| `<dir>/` | <what lives here> |

## Rules for this project

<Only the non-obvious ones: data invariants, privacy rules, protected paths, ordering
constraints. Each rule says why, or points at the code that enforces it.>

## Deploy

<How a change reaches production, and which steps need a human go-ahead. Leave this out if the
project doesn't deploy.>

## Gotchas

<Things that have bitten someone before.>

<!--
Keep this file true: update it in the same change as the code it describes.
No version numbers, counts or dates that will go stale. Link instead of copying.
-->
