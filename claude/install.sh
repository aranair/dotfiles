#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
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
cp "$SCRIPT_DIR/pi-agents/"*.md ~/.pi/agent/agents/

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
