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

echo "✅ Pi settings installed!"
echo ""
echo "Installed:"
echo "  ~/.pi/agent/agents/ ($(ls ~/.pi/agent/agents/*.md | wc -l | tr -d ' ') agents)"
echo "  ~/.pi/agent/settings.json"
echo "  ~/.pi/agent/extensions/"
echo "  ~/.pi/agent/prompts/"
