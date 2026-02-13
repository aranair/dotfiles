#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
echo "Syncing live Claude config → dotfiles repo..."

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
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Show what changed
cd "$SCRIPT_DIR/.."
if git diff --quiet -- claude/ && git diff --cached --quiet -- claude/; then
  echo "No changes detected."
else
  echo "Changes detected:"
  echo ""
  git diff --stat -- claude/
  git diff --stat --cached -- claude/
  echo ""
  echo "Review with: cd $(pwd) && git diff -- claude/"
  echo "Commit with: git add claude/ && git commit -m 'Update claude config'"
fi
