#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
echo "Installing Claude settings from $SCRIPT_DIR..."

# Create directories
mkdir -p ~/.claude/{skills,hooks,plugins}

# Core config
cp "$SCRIPT_DIR/CLAUDE.md" ~/.claude/
cp "$SCRIPT_DIR/settings.json" ~/.claude/
cp "$SCRIPT_DIR/statusline.sh" ~/.claude/
chmod +x ~/.claude/statusline.sh

# Hooks
cp "$SCRIPT_DIR/hooks/"*.sh ~/.claude/hooks/
chmod +x ~/.claude/hooks/*.sh

# Skills
rsync -a "$SCRIPT_DIR/skills/" ~/.claude/skills/

# Plugins registry
cp "$SCRIPT_DIR/plugins/installed_plugins.json" ~/.claude/plugins/

echo "✅ Claude settings installed!"
echo ""
echo "Installed:"
echo "  ~/.claude/CLAUDE.md"
echo "  ~/.claude/settings.json"
echo "  ~/.claude/statusline.sh"
echo "  ~/.claude/hooks/ ($(find ~/.claude/hooks/ -name '*.sh' | wc -l | tr -d ' ') hooks)"
echo "  ~/.claude/skills/ ($(find ~/.claude/skills/ -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ') skills)"
echo "  ~/.claude/plugins/installed_plugins.json"
