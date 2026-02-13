#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
PI_DIR="$REPO_DIR/pi"
echo "Syncing live Claude/Pi config → dotfiles repo..."

# Core config
cp_if_exists() {
  if [ -e "$1" ]; then
    mkdir -p "$(dirname "$2")"
    cp -r "$1" "$2"
    echo "  ✓ $1"
  else
    echo "  ✗ $1 (not found, skipping)"
  fi
}

echo ""
echo "Core config:"
cp_if_exists ~/.claude/CLAUDE.md "$SCRIPT_DIR/CLAUDE.md"
cp_if_exists ~/.claude/settings.json "$SCRIPT_DIR/settings.json"
cp_if_exists ~/.claude/statusline.sh "$SCRIPT_DIR/statusline.sh"

echo ""
echo "Hooks:"
mkdir -p "$SCRIPT_DIR/hooks"
for f in ~/.claude/hooks/*.sh; do
  [ -e "$f" ] && cp_if_exists "$f" "$SCRIPT_DIR/hooks/$(basename "$f")"
done

echo ""
echo "Skills:"
if [ -d ~/.claude/skills ]; then
  for skill_dir in ~/.claude/skills/*/; do
    [ -d "$skill_dir" ] || continue
    skill_name=$(basename "$skill_dir")
    mkdir -p "$SCRIPT_DIR/skills/$skill_name"
    rsync -a --delete "$skill_dir" "$SCRIPT_DIR/skills/$skill_name/"
    echo "  ✓ $skill_name"
  done
  # Remove skills from repo that no longer exist locally
  for repo_skill in "$SCRIPT_DIR/skills/"/*/; do
    [ -d "$repo_skill" ] || continue
    skill_name=$(basename "$repo_skill")
    if [ ! -d ~/.claude/skills/"$skill_name" ]; then
      rm -rf "$repo_skill"
      echo "  ✗ $skill_name (removed, no longer installed)"
    fi
  done
fi

echo ""
echo "Plugins:"
cp_if_exists ~/.claude/plugins/installed_plugins.json "$SCRIPT_DIR/plugins/installed_plugins.json"

echo ""
echo "Pi agents:"
mkdir -p "$PI_DIR/agents"
if [ -d ~/.pi/agent/agents ]; then
  for f in ~/.pi/agent/agents/*.md; do
    [ -e "$f" ] && cp_if_exists "$f" "$PI_DIR/agents/$(basename "$f")"
  done
  # Remove agents from repo that no longer exist locally
  for repo_agent in "$PI_DIR/agents/"*.md; do
    [ -e "$repo_agent" ] || continue
    agent_name=$(basename "$repo_agent")
    if [ ! -e ~/.pi/agent/agents/"$agent_name" ]; then
      rm -f "$repo_agent"
      echo "  ✗ $agent_name (removed, no longer installed)"
    fi
  done
fi

echo ""
echo "Pi settings:"
cp_if_exists ~/.pi/agent/settings.json "$PI_DIR/settings.json"

echo ""
echo "Pi extensions:"
if [ -d ~/.pi/agent/extensions ]; then
  mkdir -p "$PI_DIR/extensions"
  rsync -a --delete ~/.pi/agent/extensions/ "$PI_DIR/extensions/"
  for f in ~/.pi/agent/extensions/*; do
    [ -e "$f" ] && echo "  ✓ $(basename "$f")"
  done
fi

echo ""
echo "Pi prompts:"
if [ -d ~/.pi/agent/prompts ]; then
  mkdir -p "$PI_DIR/prompts"
  rsync -a --delete ~/.pi/agent/prompts/ "$PI_DIR/prompts/"
  for f in ~/.pi/agent/prompts/*; do
    [ -e "$f" ] && echo "  ✓ $(basename "$f")"
  done
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Show what changed
cd "$SCRIPT_DIR/.."
if git diff --quiet && git diff --cached --quiet; then
  echo "No changes detected."
else
  echo "Changes detected:"
  echo ""
  git diff --stat
  git diff --stat --cached
  echo ""
  echo "Review with: cd $(pwd) && git diff"
  echo "Commit with: git add claude/ pi/ && git commit -m 'Update claude/pi config'"
fi
