#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
echo "Installing Pi settings from $SCRIPT_DIR..."

# Create directories
mkdir -p ~/.pi/agent/{agents,extensions,prompts}

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

# Packages
if [ -f "$SCRIPT_DIR/packages.txt" ]; then
  echo ""
  echo "Installing pi packages..."
  while IFS= read -r pkg; do
    # Skip blank lines and comments
    [[ -z "$pkg" || "$pkg" =~ ^# ]] && continue
    echo "  → pi install $pkg"
    pi install "$pkg"
  done < "$SCRIPT_DIR/packages.txt"
fi

echo ""
echo "✅ Pi settings installed!"
echo ""
echo "Installed:"
echo "  ~/.pi/agent/agents/ ($(find ~/.pi/agent/agents/ -name '*.md' | wc -l | tr -d ' ') agents)"
echo "  ~/.pi/agent/settings.json"
echo "  ~/.pi/agent/extensions/"
echo "  ~/.pi/agent/prompts/"
echo "  packages ($(grep -cv '^\s*#\|^\s*$' "$SCRIPT_DIR/packages.txt" 2>/dev/null || echo 0) packages)"
