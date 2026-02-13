#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
echo "Installing Claude/Pi settings from $SCRIPT_DIR..."

# Create directories
mkdir -p ~/.claude/{skills,hooks,plugins}
mkdir -p ~/.pi/agent/agents

# Core config
cp "$SCRIPT_DIR/CLAUDE.md" ~/.claude/
cp "$SCRIPT_DIR/settings.json" ~/.claude/
cp "$SCRIPT_DIR/statusline.sh" ~/.claude/
chmod +x ~/.claude/statusline.sh

# Hooks
cp "$SCRIPT_DIR/hooks/"*.sh ~/.claude/hooks/
chmod +x ~/.claude/hooks/*.sh

# Skills
cp -r "$SCRIPT_DIR/skills/"* ~/.claude/skills/

# Plugins registry
cp "$SCRIPT_DIR/plugins/installed_plugins.json" ~/.claude/plugins/

# Pi agents
cp "$REPO_DIR/pi/agents/"*.md ~/.pi/agent/agents/

# Pi settings
cp "$REPO_DIR/pi/settings.json" ~/.pi/agent/settings.json

# Pi extensions
if [ -d "$REPO_DIR/pi/extensions" ]; then
  mkdir -p ~/.pi/agent/extensions
  cp -r "$REPO_DIR/pi/extensions/"* ~/.pi/agent/extensions/
fi

# Pi prompts
if [ -d "$REPO_DIR/pi/prompts" ]; then
  mkdir -p ~/.pi/agent/prompts
  cp -r "$REPO_DIR/pi/prompts/"* ~/.pi/agent/prompts/
fi

echo "✅ Claude & Pi settings installed!"
echo ""
echo "Installed:"
echo "  ~/.claude/CLAUDE.md"
echo "  ~/.claude/settings.json"
echo "  ~/.claude/statusline.sh"
echo "  ~/.claude/hooks/ ($(ls ~/.claude/hooks/*.sh | wc -l | tr -d ' ') hooks)"
echo "  ~/.claude/skills/ ($(ls -d ~/.claude/skills/*/ | wc -l | tr -d ' ') skills)"
echo "  ~/.claude/plugins/installed_plugins.json"
echo "  ~/.pi/agent/agents/ ($(ls ~/.pi/agent/agents/*.md | wc -l | tr -d ' ') agents)"
echo "  ~/.pi/agent/settings.json"
echo "  ~/.pi/agent/extensions/"
echo "  ~/.pi/agent/prompts/"
