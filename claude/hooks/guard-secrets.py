#!/usr/bin/env python3
"""guard-secrets: Claude Code PreToolUse hook (matchers Write|Edit|MultiEdit and Bash).

Write/Edit/MultiEdit: scans the new text for secret values.
Bash: on a path-limited `git commit ... -- <paths>`, scans the added lines of
`git diff HEAD -- <paths>`.
Blocks with exit 2 and names the pattern and file, never the value. Unparseable input fails
closed. A commit whose paths or folder are built from shell variables is not scanned (it cannot
be resolved beforehand); run a full scanner such as gitleaks before pushing.
"""
import json
import os
import re
import shlex
import subprocess
import sys

PATTERNS = [
    ("private key block", r"-----BEGIN (RSA |EC |DSA |OPENSSH |PGP )?PRIVATE KEY"),
    ("AWS access key", r"\bAKIA[0-9A-Z]{16}\b"),
    ("GitHub token", r"\b(ghp|gho|ghu|ghs|ghr)_[A-Za-z0-9]{36}\b|\bgithub_pat_[A-Za-z0-9_]{40,}"),
    ("Anthropic/OpenAI key", r"\bsk-(ant-)?[A-Za-z0-9_-]{24,}"),
    ("Slack token", r"\bxox[abprs]-[A-Za-z0-9-]{10,}"),
    ("JWT", r"\beyJ[A-Za-z0-9_-]{10,}\.eyJ[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}"),
    ("assigned secret", (r"(?i)\b(api[_-]?key|api[_-]?token|access[_-]?token|auth[_-]?token|secret|password|passwd|"
                        r"recovery[_-]?code|totp|otp[_-]?secret)\b\s*[:=]\s*[\"']?(?!REDACTED|CHANGEME|<|\$|\{)"
                        r"[A-Za-z0-9+/_=.-]{12,}")),
]
SKIP_SUFFIXES = (".png", ".jpg", ".jpeg", ".gif", ".pdf", ".m4a", ".wav", ".zip")
SEG = r"[^|;&\n]*"


def find(text):
    for name, pattern in PATTERNS:
        if re.search(pattern, text):
            return name
    return None


def block(msg):
    sys.stderr.write(f"BLOCKED by guard-secrets: {msg}. Keep the value in a keychain or password"
                     " manager and refer to the item by name instead.\n")
    return 2


def edit_text(tool, ti):
    if tool == "Write":
        return ti.get("content", "")
    if tool == "Edit":
        return ti.get("new_string", "")
    if tool == "MultiEdit":
        return "\n".join(e.get("new_string", "") for e in ti.get("edits", []))
    return ""


def unresolved(text):
    return "$" in text or "`" in text


def commit_paths(cmd):
    """Literal paths after `git commit ... --`; None when absent or built from shell variables."""
    m = re.search(rf"\bgit\b{SEG}\bcommit\b{SEG}\s--\s+([^|;&\n<>]*)", cmd)
    if not m or unresolved(m.group(1)):
        return None
    return shlex.split(m.group(1)) or None


def git_dir(cmd, cwd):
    """Folder the commit runs in (last `cd X`, or `git -C X`); None when it holds a variable."""
    base = cwd
    targets = re.findall(r"(?:^|[;&|]\s*)cd\s+(\"[^\"]*\"|'[^']*'|[^\s;&|]+)", cmd)
    c_flag = re.search(r"\bgit\s+-C\s+(\"[^\"]*\"|'[^']*'|\S+)", cmd)
    for target in targets + ([c_flag.group(1)] if c_flag else []):
        if unresolved(target):
            return None
        base = os.path.join(base or os.path.expanduser("~"), os.path.expanduser(target.strip("'\"")))
    return base


def staged_added_lines(paths, cwd):
    res = subprocess.run(["git", "diff", "HEAD", "--", *paths], cwd=cwd or None,
                         capture_output=True, text=True, timeout=20, check=False)
    if res.returncode != 0:
        raise RuntimeError(res.stderr.strip()[:200])
    return "\n".join(ln[1:] for ln in res.stdout.splitlines() if ln.startswith("+") and not ln.startswith("+++"))


def check_commit(cmd, cwd):
    paths = commit_paths(cmd)
    repo = git_dir(cmd, cwd)
    if not paths or repo is None:
        return 0  # paths or folder built at run time cannot be checked beforehand
    try:
        text = staged_added_lines(paths, repo)
    except (RuntimeError, OSError, subprocess.SubprocessError) as exc:
        sys.stderr.write(f"guard-secrets: commit not scanned ({exc}).\n")
        return 0  # an unreadable diff is reported, not blocked
    hit = find(text)
    return block(f"{hit} in the lines this commit adds") if hit else 0


def main():
    try:
        data = json.load(sys.stdin)
        tool = data["tool_name"]
        ti = data["tool_input"]
    except (ValueError, KeyError, TypeError):
        return block("cannot parse hook input (fail closed)")
    if tool == "Bash":
        return check_commit(ti.get("command", ""), data.get("cwd"))
    path = ti.get("file_path", "")
    if path.lower().endswith(SKIP_SUFFIXES):
        return 0
    hit = find(edit_text(tool, ti))
    return block(f"{hit} in {path}") if hit else 0


if __name__ == "__main__":
    sys.exit(main())
