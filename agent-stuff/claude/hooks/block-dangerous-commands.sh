#!/bin/bash
# PreToolUse hook to block dangerous commands when running with --dangerously-skip-permissions
# This is your last line of defense!

set -euo pipefail

# Read hook input from stdin
input=$(cat)

# Extract tool name and command
tool_name=$(echo "$input" | jq -r '.tool_name // ""')
command=$(echo "$input" | jq -r '.tool_input.command // ""')

# Exit early if not a Bash tool
if [ "$tool_name" != "Bash" ]; then
    exit 0
fi

# Helper function to deny with reason
deny() {
    local reason="$1"
    cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "deny",
    "permissionDecisionReason": "$reason"
  }
}
EOF
    exit 0
}

# =============================================================================
# DESTRUCTIVE FILE OPERATIONS
# =============================================================================

# rm -rf (with various flag orderings)
if echo "$command" | grep -qE 'rm\s+(-[a-zA-Z]*r[a-zA-Z]*f|(-[a-zA-Z]*f[a-zA-Z]*\s+)?-[a-zA-Z]*r|-rf|-fr)\b'; then
    deny "rm -rf is blocked for safety"
fi

# rm on sensitive paths
if echo "$command" | grep -qE 'rm\s+.*(/etc/|/usr/|/var/|/boot/|/home/|/root/|\~/)'; then
    deny "rm on system/home paths is blocked"
fi

# dd command (disk destroyer)
if echo "$command" | grep -qE '\bdd\s+'; then
    deny "dd command is blocked - can destroy disks"
fi

# mkfs (format filesystem)
if echo "$command" | grep -qE '\bmkfs'; then
    deny "mkfs is blocked - can format disks"
fi

# shred (secure delete)
if echo "$command" | grep -qE '\bshred\b'; then
    deny "shred is blocked for safety"
fi

# =============================================================================
# INFRASTRUCTURE / DEPLOYMENT
# =============================================================================

# terraform apply/destroy
if echo "$command" | grep -qE 'terraform\s+(apply|destroy)'; then
    deny "terraform apply/destroy is blocked - use terraform plan first"
fi

# --auto-approve flag
if echo "$command" | grep -qE '\-\-auto-approve'; then
    deny "--auto-approve is blocked - manual confirmation required"
fi

# just apply (your custom task runner)
if echo "$command" | grep -qE 'just\s+apply'; then
    deny "just apply is blocked - use just plan first"
fi

# kubectl delete (except specific resources)
if echo "$command" | grep -qE 'kubectl\s+delete\s+(namespace|ns|pv|pvc|node|crd)'; then
    deny "kubectl delete on critical resources is blocked"
fi

# helm uninstall/delete
if echo "$command" | grep -qE 'helm\s+(uninstall|delete)'; then
    deny "helm uninstall is blocked for safety"
fi

# docker system prune
if echo "$command" | grep -qE 'docker\s+(system\s+prune|volume\s+prune|image\s+prune\s+-a)'; then
    deny "docker prune commands are blocked"
fi

# =============================================================================
# PERMISSION / OWNERSHIP CHANGES
# =============================================================================

# chmod 777 (world-writable)
if echo "$command" | grep -qE 'chmod\s+(-R\s+)?777'; then
    deny "chmod 777 is blocked - too permissive"
fi

# chown to root
if echo "$command" | grep -qE 'chown\s+.*root'; then
    deny "chown to root is blocked"
fi

# =============================================================================
# CODE EXECUTION FROM INTERNET
# =============================================================================

# curl/wget piped to shell
if echo "$command" | grep -qE '(curl|wget)\s+.*\|\s*(bash|sh|zsh|python|perl|ruby)'; then
    deny "Piping downloaded content to shell is blocked"
fi

# eval with variables (command injection risk)
if echo "$command" | grep -qE '\beval\s+.*\$'; then
    deny "eval with variables is blocked - command injection risk"
fi

# =============================================================================
# GIT DESTRUCTIVE OPERATIONS
# =============================================================================

# git push --force to main/master
if echo "$command" | grep -qE 'git\s+push\s+.*(-f|--force).*\s+(main|master)\b'; then
    deny "Force push to main/master is blocked"
fi

if echo "$command" | grep -qE 'git\s+push\s+.*\s+(main|master)\b.*(-f|--force)'; then
    deny "Force push to main/master is blocked"
fi

# git reset --hard
if echo "$command" | grep -qE 'git\s+reset\s+--hard'; then
    deny "git reset --hard is blocked - can lose uncommitted work"
fi

# git clean -fd (removes untracked files)
if echo "$command" | grep -qE 'git\s+clean\s+(-[a-zA-Z]*f|-fd|-df)'; then
    deny "git clean -f is blocked - removes untracked files permanently"
fi

# =============================================================================
# DATABASE OPERATIONS
# =============================================================================

# DROP DATABASE/TABLE
if echo "$command" | grep -qiE '(drop\s+(database|table|schema)|truncate\s+table)'; then
    deny "DROP/TRUNCATE commands are blocked"
fi

# =============================================================================
# SECRETS / CREDENTIALS
# =============================================================================

# Sending secrets to external services
if echo "$command" | grep -qE '(curl|wget|http).*(-d|--data).*(\$[A-Z_]+|password|secret|token|key)'; then
    deny "Sending potential secrets via HTTP is blocked"
fi

# =============================================================================
# SYSTEM MODIFICATIONS
# =============================================================================

# Modifying system files
if echo "$command" | grep -qE '(>|>>)\s*(/etc/|/usr/|/var/|/boot/)'; then
    deny "Writing to system directories is blocked"
fi

# kill -9 (ungraceful termination)
if echo "$command" | grep -qE 'kill\s+-9'; then
    deny "kill -9 is blocked - use graceful termination"
fi

# pkill/killall without specific process
if echo "$command" | grep -qE '(pkill|killall)\s+-9'; then
    deny "pkill/killall -9 is blocked"
fi

# =============================================================================
# All checks passed - allow command
# =============================================================================
exit 0
