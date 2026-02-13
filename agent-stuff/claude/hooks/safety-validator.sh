#!/bin/bash
# Claude Code Safety Validator Hook
# Blocks or prompts for dangerous commands

set -e

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')
# shellcheck disable=SC2034
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# Helper: output JSON to prompt user for confirmation
prompt_user() {
  local reason="$1"
  cat << EOF
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "ask",
    "permissionDecisionReason": "$reason"
  }
}
EOF
  exit 0
}

# Helper: hard block with message
block() {
  local reason="$1"
  echo "BLOCKED: $reason" >&2
  exit 2
}

# Only validate Bash commands
if [[ "$TOOL_NAME" != "Bash" ]]; then
  exit 0
fi

# =============================================================================
# HARD BLOCKS (no prompt, just deny)
# =============================================================================

# Terraform apply - always blocked
if echo "$COMMAND" | grep -qE '\bterraform\s+(apply|destroy)'; then
  block "terraform apply/destroy is not allowed via Claude"
fi

# =============================================================================
# DESTRUCTIVE GIT COMMANDS - prompt
# =============================================================================

# Force push
if echo "$COMMAND" | grep -qE 'git\s+push\s+.*(-f|--force)'; then
  prompt_user "Force push detected. This can overwrite remote history."
fi

# Push to main/master
if echo "$COMMAND" | grep -qE 'git\s+push\s+.*(main|master)'; then
  prompt_user "Pushing directly to main/master branch. Are you sure?"
fi

# Reset --hard
if echo "$COMMAND" | grep -qE 'git\s+reset\s+--hard'; then
  prompt_user "git reset --hard will discard uncommitted changes permanently."
fi

# Clean -f (force delete untracked files)
if echo "$COMMAND" | grep -qE 'git\s+clean\s+.*-f'; then
  prompt_user "git clean -f will permanently delete untracked files."
fi

# Branch delete with -D (force)
if echo "$COMMAND" | grep -qE 'git\s+branch\s+.*-D'; then
  prompt_user "git branch -D force-deletes a branch even if not merged."
fi

# Checkout . or restore . (discard all changes)
if echo "$COMMAND" | grep -qE 'git\s+(checkout|restore)\s+\.'; then
  prompt_user "This will discard all uncommitted changes in the working directory."
fi

# Rebase onto main/master
if echo "$COMMAND" | grep -qE 'git\s+rebase\s+.*(main|master|origin/main|origin/master)'; then
  prompt_user "Rebasing onto main/master. This rewrites history."
fi

# =============================================================================
# FILE DELETION - prompt
# =============================================================================

# rm -rf or rm -r (recursive delete)
if echo "$COMMAND" | grep -qE '\brm\s+.*-[a-zA-Z]*r[a-zA-Z]*\s'; then
  prompt_user "Recursive file deletion detected. This cannot be undone."
fi

# rm with force flag
if echo "$COMMAND" | grep -qE '\brm\s+.*-[a-zA-Z]*f'; then
  prompt_user "Force file deletion detected (rm -f). Files will be deleted without confirmation."
fi

# Delete multiple files
if echo "$COMMAND" | grep -qE '\brm\s+.*\*'; then
  prompt_user "Wildcard deletion detected. Multiple files may be deleted."
fi

# =============================================================================
# SYSTEM MODIFICATIONS - prompt
# =============================================================================

# sudo commands
if echo "$COMMAND" | grep -qE '^\s*sudo\s'; then
  prompt_user "sudo command detected. This runs with elevated privileges."
fi

# Modifying system directories
if echo "$COMMAND" | grep -qE '(^|\s)/etc/|/usr/local/|/var/|/opt/'; then
  prompt_user "Command targets system directories. Proceed with caution."
fi

# chmod/chown commands
if echo "$COMMAND" | grep -qE '\b(chmod|chown)\s'; then
  prompt_user "Permission change detected. This affects file access."
fi

# =============================================================================
# DATABASE OPERATIONS - prompt
# =============================================================================

# SQL destructive commands (case-insensitive)
if echo "$COMMAND" | grep -qiE '\b(DROP\s+(TABLE|DATABASE|INDEX)|DELETE\s+FROM|TRUNCATE|ALTER\s+TABLE.*DROP)'; then
  prompt_user "Destructive database operation detected. This may be irreversible."
fi

# Rails db:drop or db:reset
if echo "$COMMAND" | grep -qE 'rails\s+(db:drop|db:reset|db:schema:load)'; then
  prompt_user "Database drop/reset command. This will destroy data."
fi

# Production database operations
if echo "$COMMAND" | grep -qiE '(RAILS_ENV|NODE_ENV)=production.*(migrate|db:|seed)'; then
  prompt_user "Production database operation detected. Double-check before proceeding."
fi

# psql/mysql with production indicators
if echo "$COMMAND" | grep -qE '(psql|mysql).*prod'; then
  prompt_user "Database command appears to target production. Verify the connection."
fi

# =============================================================================
# NETWORK / SECRETS EXPOSURE - prompt
# =============================================================================

# curl/wget with auth tokens or secrets
if echo "$COMMAND" | grep -qE '(curl|wget|http).*(-H|--header).*(auth|token|bearer|api.?key)'; then
  prompt_user "HTTP request with authentication headers. Verify no secrets are exposed."
fi

# Commands that might leak env vars
if echo "$COMMAND" | grep -qE '(printenv|env\s*$|echo\s+\$)'; then
  prompt_user "Command may expose environment variables including secrets."
fi

# Accessing .env files
if echo "$COMMAND" | grep -qE '(cat|less|more|head|tail|nano|vim|vi|code)\s+.*\.env'; then
  prompt_user "Accessing .env file which may contain secrets."
fi

# Sending data to external services
if echo "$COMMAND" | grep -qE '(curl|wget|nc|netcat).*\|\s*(bash|sh|zsh)'; then
  prompt_user "Piping remote content to shell. This is a security risk."
fi

# =============================================================================
# PROTECTED FILES - prompt for Write/Edit tools
# =============================================================================

# This section handles file path checks (for Read/Write/Edit detection via command)
if echo "$COMMAND" | grep -qE '\.(env|env\.local|env\.production|env\.prod)(\s|$|")'; then
  prompt_user "Command involves .env files which may contain secrets."
fi

if echo "$COMMAND" | grep -qiE '(production|prod)\.(json|yml|yaml|config|conf)'; then
  prompt_user "Command involves production configuration files."
fi

# =============================================================================
# ALL CHECKS PASSED
# =============================================================================
exit 0
