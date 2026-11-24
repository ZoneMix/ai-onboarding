#!/usr/bin/env bash
# test-hooks.sh: regression tests for the hooks in this folder (or HOOK_DIR).
# Prints PASS/FAIL per case and exits 1 if any case fails. Needs python3, jq and git.
# Fake secrets are assembled at run time so this file never trips a secret scanner.
set -uo pipefail
HOOK_DIR="${HOOK_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"
FAILS=0

check() {  # expected-exit hook label json
  local want="$1" hook="$2" label="$3" json="$4" got
  printf '%s' "$json" | python3 "$HOOK_DIR/$hook" >/dev/null 2>&1
  got=$?
  if [ "$got" = "$want" ]; then echo "PASS $label"; else echo "FAIL $label (want $want, got $got)"; FAILS=$((FAILS + 1)); fi
}
bash_case() {  # expected cwd command
  check "$1" guard-bash.py "bash: $3 [cwd $2]" "$(jq -cn --arg c "$3" --arg d "$2" '{tool_input:{command:$c},cwd:$d}')"
}
heredoc_case() {  # expected command
  check "$1" no-heredoc.py "heredoc: $2" "$(jq -cn --arg c "$2" '{tool_input:{command:$c}}')"
}
edit_case() {  # expected label file text
  check "$1" guard-secrets.py "secrets: $2" "$(jq -cn --arg f "$3" --arg t "$4" '{tool_name:"Edit",tool_input:{file_path:$f,new_string:$t}}')"
}

LT2="$(printf '%s%s' '<' '<')"
heredoc_case 2 "cat ${LT2}EOF"
heredoc_case 2 "grep x ${LT2}${LT2:0:1} 'text'"
heredoc_case 0 "wc -l < file.txt"
heredoc_case 0 "ls -la"
check 2 no-heredoc.py "heredoc: bad json" "not json"

bash_case 2 /tmp "git push --force origin main"
bash_case 2 /tmp "git push -f"
bash_case 2 /tmp "git -C /tmp/repo push --force-with-lease"
bash_case 0 /tmp "git push origin main"
bash_case 2 /tmp "git reset --hard HEAD~1"
bash_case 0 /tmp "git reset HEAD file.txt"
bash_case 2 /tmp "git add -A"
bash_case 2 /tmp "git add ."
bash_case 2 /tmp "git add --all"
bash_case 0 /tmp "git add src/a.py"
bash_case 2 /tmp "git commit --no-verify -m 'fix: x'"
bash_case 2 /tmp "git commit -n -m 'fix: x'"
bash_case 0 /tmp "git commit -m 'fix: x' -- src/a.py"
bash_case 2 /tmp "cat ~/.ssh/id_ed25519"
bash_case 2 /tmp "cp \$HOME/.ssh/deploy_key /tmp"
bash_case 0 /tmp "cat ~/.ssh/config"
bash_case 2 /tmp "rm -rf ~"
bash_case 2 /tmp "rm -rf /"
bash_case 2 /tmp "rm -rf \$HOME/anything"
bash_case 2 /tmp/repo "rm -rf .git"
bash_case 2 /tmp "rm -rf /usr/local"
bash_case 0 /tmp "rm -rf /tmp/build/out/cache"
bash_case 0 /tmp/a/b/c "rm -rf node_modules"
check 2 guard-bash.py "bash: bad json" "not json"

FAKE_GH="ghp_$(printf 'A%.0s' $(seq 1 36))"
FAKE_PW="hunter2$(printf 'x%.0s' $(seq 1 8))"
KEY_NAME="API""_KEY"
edit_case 2 "github token" /tmp/x.md "token = $FAKE_GH"
edit_case 0 "keychain pointer" /tmp/x.md "Token lives in keychain item api-token."
edit_case 2 "password assign" /tmp/x.py "password = \"$FAKE_PW\""
edit_case 0 "placeholder" /tmp/x.env "${KEY_NAME}=CHANGEME_PLACEHOLDER"
check 0 guard-secrets.py "secrets: non-commit bash" "$(jq -cn '{tool_name:"Bash",tool_input:{command:"ls"}}')"
check 2 guard-secrets.py "secrets: bad json" "not json"

R="$(mktemp -d)"
git -C "$R" init -q
printf 'x\n' > "$R/a.md"
git -C "$R" add a.md
git -C "$R" -c user.name=t -c user.email=t@example.invalid commit -qm init
printf 'token = %s\n' "$FAKE_GH" >> "$R/a.md"
check 2 guard-secrets.py "secrets: commit adds token (cd)" "$(jq -cn --arg r "$R" '{tool_name:"Bash",cwd:"/tmp",tool_input:{command:("cd " + $r + " && git commit -m x -- a.md")}}')"
check 2 guard-secrets.py "secrets: commit adds token (-C)" "$(jq -cn --arg r "$R" '{tool_name:"Bash",cwd:"/tmp",tool_input:{command:("git -C " + $r + " commit -m x -- a.md")}}')"
rm -rf "$R"

echo "failures: $FAILS"
[ "$FAILS" = 0 ]
