#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
echo "Installing Pi settings from $SCRIPT_DIR..."

# Create directories
mkdir -p ~/.pi/agent/{agents,extensions,prompts,skills}

# Agents
cp "$SCRIPT_DIR/agents/"*.md ~/.pi/agent/agents/

# Settings
cp "$SCRIPT_DIR/settings.json" ~/.pi/agent/settings.json

# Extensions
if [ -d "$SCRIPT_DIR/extensions" ]; then
  cp -r "$SCRIPT_DIR/extensions/"* ~/.pi/agent/extensions/
fi

# Prompts
if [ -d "$SCRIPT_DIR/prompts" ]; then
  cp -r "$SCRIPT_DIR/prompts/"* ~/.pi/agent/prompts/
fi

# Skills
if [ -d "$SCRIPT_DIR/skills" ]; then
  rsync -a "$SCRIPT_DIR/skills/" ~/.pi/agent/skills/
fi

# Packages (from settings.json)
if command -v jq &>/dev/null && [ -f "$SCRIPT_DIR/settings.json" ]; then
  echo ""
  echo "Installing pi packages..."
  # Get already-installed packages
  installed=$(pi list 2>/dev/null | grep '^\s*npm:' | sed 's/^[[:space:]]*//')
  while IFS= read -r pkg; do
    [ -z "$pkg" ] && continue
    if echo "$installed" | grep -qxF "$pkg"; then
      echo "  ✓ $pkg (already installed)"
    else
      echo "  → pi install $pkg"
      pi install "$pkg"
    fi
  done < <(jq -r '.packages[]? // empty' "$SCRIPT_DIR/settings.json")
fi

echo ""
echo "✅ Pi settings installed!"
echo ""
echo "Installed:"
echo "  ~/.pi/agent/agents/ ($(find ~/.pi/agent/agents/ -name '*.md' | wc -l | tr -d ' ') agents)"
echo "  ~/.pi/agent/settings.json"
echo "  ~/.pi/agent/extensions/"
echo "  ~/.pi/agent/prompts/"
echo "  ~/.pi/agent/skills/ ($(find ~/.pi/agent/skills/ -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ') skills)"
echo "  packages ($(jq -r '.packages | length' "$SCRIPT_DIR/settings.json" 2>/dev/null || echo 0) packages)"
