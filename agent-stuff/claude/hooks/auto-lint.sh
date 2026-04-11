#!/bin/bash
# PostToolUse hook: auto-run linters after Claude edits web/ or api/ files
# Fixes lint issues inline so they don't pile up until commit time

set -e

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# Only trigger on Edit/Write
if [[ "$TOOL_NAME" != "Edit" && "$TOOL_NAME" != "Write" ]]; then
  exit 0
fi

# Skip if no file path
if [[ -z "$FILE_PATH" ]]; then
  exit 0
fi

# Find project root by walking up from the file
find_project_root() {
  local dir="$1"
  while [[ "$dir" != "/" ]]; do
    if [[ -d "$dir/web" && -d "$dir/api" ]]; then
      echo "$dir"
      return
    fi
    # Also check if we're inside web/ or api/ directly
    if [[ -f "$dir/package.json" && -d "$dir/src" ]]; then
      dirname "$dir"
      return
    fi
    if [[ -f "$dir/Gemfile" && -d "$dir/app" ]]; then
      dirname "$dir"
      return
    fi
    dir="$(dirname "$dir")"
  done
}

# Web files: run eslint --fix
if echo "$FILE_PATH" | grep -qE '/web/.*\.(ts|tsx|js|jsx)$'; then
  PROJECT_ROOT=$(find_project_root "$(dirname "$FILE_PATH")")
  if [[ -n "$PROJECT_ROOT" && -d "$PROJECT_ROOT/web" ]]; then
    cd "$PROJECT_ROOT/web"
    npx eslint --fix "$FILE_PATH" 2>/dev/null || true
  fi
fi

# API files: run rubocop -a
if echo "$FILE_PATH" | grep -qE '/api/.*\.rb$'; then
  PROJECT_ROOT=$(find_project_root "$(dirname "$FILE_PATH")")
  if [[ -n "$PROJECT_ROOT" && -d "$PROJECT_ROOT/api" ]]; then
    cd "$PROJECT_ROOT/api"
    eval "$(rbenv init -)" 2>/dev/null || true
    bundle exec rubocop -a --force-exclusion "$FILE_PATH" 2>/dev/null || true
  fi
fi

exit 0
