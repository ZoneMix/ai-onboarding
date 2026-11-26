# Vault scripts

## vault-daily-push

A once-a-day backstop for a git-backed vault. Agents commit and push their own edits; the Obsidian Git plugin commits on a timer only while the app is open. This script catches whatever was committed but never pushed. It never stages or commits anything, so it can't sweep up someone's half-finished work.

For each vault in its config it takes the same `.git/memory.lock` the agents use, pulls with rebase, pushes, and releases the lock. On a rebase conflict it aborts and reports. It also reports files that have sat uncommitted for over an hour, which is what a commit blocked by the pre-commit hook looks like.

Install:

```bash
cp vault-daily-push ~/.local/bin/ && chmod +x ~/.local/bin/vault-daily-push
mkdir -p ~/.config/vault-daily-push
echo "$HOME/Documents/MyVault" >> ~/.config/vault-daily-push/vaults
~/.local/bin/vault-daily-push --force && tail ~/.local/state/vault-daily-push/vault-daily-push.log
```

Then schedule it: `launchd/` on macOS, `systemd/` on Linux. Settings are environment variables, listed at the top of the script: a log path, a time zone, a weekday to skip, and an outbox folder that gets one note per day when something needs a person (point it at wherever your agents pick up messages).

## The pre-commit hook

Each vault starter ships `.githooks/pre-commit`. Turn it on per clone with `git config core.hooksPath .githooks`. It runs `gitleaks` on the staged changes, blocks files over 10 MB, and in a vault with an `_agents/` folder blocks scratch and `working/` files outside it. It looks for gitleaks in the usual Homebrew paths too, because Obsidian starts hooks with a thin PATH. Install gitleaks first (`brew install gitleaks`), or every commit is blocked with a message saying so.
