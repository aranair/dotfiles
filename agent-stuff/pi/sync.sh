#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
echo "Syncing live Pi config → dotfiles repo..."

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
echo "Agents:"
mkdir -p "$SCRIPT_DIR/agents"
if [ -d ~/.pi/agent/agents ]; then
  for f in ~/.pi/agent/agents/*.md; do
    [ -e "$f" ] && cp_if_exists "$f" "$SCRIPT_DIR/agents/$(basename "$f")"
  done
  # Remove agents from repo that no longer exist locally
  for repo_agent in "$SCRIPT_DIR/agents/"*.md; do
    [ -e "$repo_agent" ] || continue
    agent_name=$(basename "$repo_agent")
    if [ ! -e ~/.pi/agent/agents/"$agent_name" ]; then
      rm -f "$repo_agent"
      echo "  ✗ $agent_name (removed, no longer installed)"
    fi
  done
fi

echo ""
echo "Settings:"
cp_if_exists ~/.pi/agent/settings.json "$SCRIPT_DIR/settings.json"

echo ""
echo "Extensions:"
if [ -d ~/.pi/agent/extensions ]; then
  mkdir -p "$SCRIPT_DIR/extensions"
  rsync -a --delete ~/.pi/agent/extensions/ "$SCRIPT_DIR/extensions/"
  for f in ~/.pi/agent/extensions/*; do
    [ -e "$f" ] && echo "  ✓ $(basename "$f")"
  done
fi

echo ""
echo "Prompts:"
if [ -d ~/.pi/agent/prompts ]; then
  mkdir -p "$SCRIPT_DIR/prompts"
  rsync -a --delete ~/.pi/agent/prompts/ "$SCRIPT_DIR/prompts/"
  for f in ~/.pi/agent/prompts/*; do
    [ -e "$f" ] && echo "  ✓ $(basename "$f")"
  done
fi

echo ""
echo "Packages (in settings.json):"
if command -v jq &>/dev/null; then
  # Collect installed packages into an array (bash 3 compatible)
  pkgs=()
  while IFS= read -r line; do
    pkgs+=("$line")
  done < <(pi list 2>/dev/null | grep '^\s*npm:' | sed 's/^[[:space:]]*//')
  # Build JSON array and update settings.json in place
  pkg_json=$(printf '%s\n' "${pkgs[@]}" | jq -R . | jq -s .)
  tmp=$(mktemp)
  jq --argjson pkgs "$pkg_json" '.packages = $pkgs' "$SCRIPT_DIR/settings.json" > "$tmp" && mv "$tmp" "$SCRIPT_DIR/settings.json"
  for pkg in "${pkgs[@]}"; do
    echo "  ✓ $pkg"
  done
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Show what changed
cd "$SCRIPT_DIR/.."
if git diff --quiet -- pi/ && git diff --cached --quiet -- pi/; then
  echo "No changes detected."
else
  echo "Changes detected:"
  echo ""
  git diff --stat -- pi/
  git diff --stat --cached -- pi/
  echo ""
  echo "Review with: cd $(pwd) && git diff -- pi/"
  echo "Commit with: git add pi/ && git commit -m 'Update pi config'"
fi
