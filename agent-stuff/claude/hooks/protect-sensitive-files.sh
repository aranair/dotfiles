#!/bin/bash
# PreToolUse hook to protect sensitive files from Write/Edit operations
# Prevents accidental modification of credentials, configs, and system files

set -euo pipefail

input=$(cat)

tool_name=$(echo "$input" | jq -r '.tool_name // ""')
file_path=$(echo "$input" | jq -r '.tool_input.file_path // ""')

# Only check Write and Edit tools
if [[ ! "$tool_name" =~ ^(Write|Edit)$ ]]; then
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
# PATH TRAVERSAL PROTECTION
# =============================================================================

if [[ "$file_path" == *".."* ]]; then
    deny "Path traversal (..) is blocked"
fi

# =============================================================================
# CREDENTIALS & SECRETS
# =============================================================================

# .env files (contain secrets)
if [[ "$file_path" == *".env"* ]]; then
    deny ".env files are protected - contains secrets"
fi

# AWS credentials
if [[ "$file_path" == *".aws/credentials"* ]] || [[ "$file_path" == *".aws/config"* ]]; then
    deny "AWS credential files are protected"
fi

# SSH keys
if [[ "$file_path" == *".ssh/"* ]]; then
    deny "SSH directory is protected"
fi

# GPG keys
if [[ "$file_path" == *".gnupg/"* ]]; then
    deny "GPG directory is protected"
fi

# Kubernetes configs
if [[ "$file_path" == *".kube/config"* ]]; then
    deny "Kubeconfig is protected"
fi

# Generic secret patterns
if [[ "$file_path" =~ (secret|credential|password|token|private.?key|\.pem|\.key)$ ]]; then
    deny "Files matching secret patterns are protected"
fi

# =============================================================================
# GIT INTERNALS
# =============================================================================

if [[ "$file_path" == *"/.git/"* ]]; then
    deny ".git directory internals are protected"
fi

# =============================================================================
# LOCK FILES
# =============================================================================

if [[ "$file_path" == *"package-lock.json" ]] || \
   [[ "$file_path" == *"yarn.lock" ]] || \
   [[ "$file_path" == *"pnpm-lock.yaml" ]] || \
   [[ "$file_path" == *"Gemfile.lock" ]] || \
   [[ "$file_path" == *"Cargo.lock" ]] || \
   [[ "$file_path" == *"poetry.lock" ]] || \
   [[ "$file_path" == *"composer.lock" ]] || \
   [[ "$file_path" == *"go.sum" ]]; then
    deny "Lock files are protected - regenerate via package manager"
fi

# =============================================================================
# SYSTEM PATHS (should never be edited by Claude)
# =============================================================================

if [[ "$file_path" =~ ^/(etc|usr|var|boot|bin|sbin|lib|opt)/ ]]; then
    deny "System directories are protected"
fi

if [[ "$file_path" =~ ^/Users/[^/]+/\.(bashrc|zshrc|bash_profile|zprofile|profile)$ ]]; then
    deny "Shell RC files are protected"
fi

# =============================================================================
# CLAUDE'S OWN CONFIG (prevent self-modification exploits)
# =============================================================================

if [[ "$file_path" == *"/.claude/settings"* ]] || [[ "$file_path" == *"/.claude/hooks/"* ]]; then
    deny "Claude config files are protected from self-modification"
fi

# =============================================================================
# All checks passed - allow write/edit
# =============================================================================
exit 0
