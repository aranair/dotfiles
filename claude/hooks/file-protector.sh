#!/bin/bash
# Claude Code File Protection Hook
# Prompts when editing/writing protected files

set -e

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')
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

# Only validate Write and Edit tools
if [[ "$TOOL_NAME" != "Write" && "$TOOL_NAME" != "Edit" ]]; then
  exit 0
fi

# Skip if no file path
if [[ -z "$FILE_PATH" ]]; then
  exit 0
fi

# =============================================================================
# PROTECTED FILES - prompt
# =============================================================================

# .env files (any variant)
if echo "$FILE_PATH" | grep -qE '\.env($|\.[a-zA-Z]+$)'; then
  prompt_user "Modifying .env file which may contain secrets."
fi

# Production configuration files
if echo "$FILE_PATH" | grep -qiE '(production|prod)\.(json|yml|yaml|config|conf|rb|js|ts)$'; then
  prompt_user "Modifying production configuration file."
fi

# Deployment/infrastructure files
if echo "$FILE_PATH" | grep -qiE '(docker-compose\.prod|kubernetes|k8s|\.tf$|Procfile)'; then
  prompt_user "Modifying deployment/infrastructure file."
fi

# Credentials or secrets files
if echo "$FILE_PATH" | grep -qiE '(credentials|secrets|master\.key|\.pem$|\.key$)'; then
  prompt_user "Modifying file that may contain credentials or secrets."
fi

# CI/CD configuration
if echo "$FILE_PATH" | grep -qE '(\.github/workflows|\.gitlab-ci|Jenkinsfile|\.circleci)'; then
  prompt_user "Modifying CI/CD pipeline configuration."
fi

# =============================================================================
# ALL CHECKS PASSED
# =============================================================================
exit 0
