#!/bin/bash
# PreToolUse hook: block git commit if tsc fails on web/ changes
# Catches type errors before commit instead of failing at pre-commit hook time

set -e

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# Only check Bash commands
if [[ "$TOOL_NAME" != "Bash" ]]; then
  exit 0
fi

# Only trigger on git commit commands
if ! echo "$COMMAND" | grep -qE '^\s*git\s+commit'; then
  exit 0
fi

# Block --no-verify
if echo "$COMMAND" | grep -qE '\-\-no-verify'; then
  cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "deny",
    "permissionDecisionReason": "--no-verify is blocked. Fix the issues instead of skipping hooks."
  }
}
EOF
  exit 0
fi

# Check if any web/ files are staged
STAGED_WEB=$(git diff --cached --name-only 2>/dev/null | grep -E '^web/.*\.(ts|tsx)$' || true)

if [[ -n "$STAGED_WEB" ]]; then
  # Find the web directory relative to git root
  GIT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
  WEB_DIR="$GIT_ROOT/web"

  if [[ -d "$WEB_DIR" ]]; then
    # Run tsc check
    TSC_OUTPUT=$(cd "$WEB_DIR" && npx tsc --noEmit 2>&1) || {
      cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "deny",
    "permissionDecisionReason": "TypeScript errors found in web/. Fix before committing:\n${TSC_OUTPUT}"
  }
}
EOF
      exit 0
    }
  fi
fi

exit 0
