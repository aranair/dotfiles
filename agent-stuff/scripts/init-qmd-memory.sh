#!/bin/bash
set -euo pipefail

QMD_BIN="${QMD_BIN:-qmd}"
DROPBOX_ROOT="${DROPBOX_ROOT:-$HOME/Library/CloudStorage/Dropbox}"
MEMORY_ROOT="${MEMORY_ROOT:-$DROPBOX_ROOT/memory}"
DRY_RUN=0
RUN_UPDATE=1
RUN_EMBED=0

usage() {
  cat <<'EOF'
Initialize standard QMD memory collections on a new system.

Usage:
  scripts/init-qmd-memory.sh [options]

Options:
  --dry-run               Print actions without changing anything
  --no-update             Skip `qmd update` after creating collections
  --embed                 Run `qmd embed` after `qmd update`
  --memory-root PATH      Override the memory root (default: ~/Library/CloudStorage/Dropbox/memory)
  --dropbox-root PATH     Override the Dropbox root (used to derive --memory-root)
  -h, --help              Show this help

Environment overrides:
  QMD_BIN                 QMD executable to use (default: qmd)
  DROPBOX_ROOT            Dropbox root path
  MEMORY_ROOT             Memory root path

Collections created:
  coding-notes -> <dropbox-root>/notes   (Coding notes)
  lessons      -> <memory-root>/lessons  (Generic lessons from all agents)
  notes        -> <memory-root>/notes    (Personal notes)
  aboutme      -> <memory-root>/aboutme  (Context and information about me)
  ideas        -> <memory-root>/ideas    (Brainstorms and ideas)
  links        -> <memory-root>/links    (Saved links with descriptions)
  research     -> <memory-root>/research (Researched ideas)
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    --no-update)
      RUN_UPDATE=0
      shift
      ;;
    --embed)
      RUN_EMBED=1
      shift
      ;;
    --memory-root)
      MEMORY_ROOT="$2"
      shift 2
      ;;
    --dropbox-root)
      DROPBOX_ROOT="$2"
      MEMORY_ROOT="$DROPBOX_ROOT/memory"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

run() {
  if [[ "$DRY_RUN" -eq 1 ]]; then
    printf '[dry-run]'
    printf ' %q' "$@"
    printf '\n'
  else
    "$@"
  fi
}

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1" >&2
    exit 1
  fi
}

collection_exists() {
  "$QMD_BIN" collection show "$1" >/dev/null 2>&1
}

collection_has_root_context() {
  "$QMD_BIN" context list 2>/dev/null | awk -v target="$1" '
    $0 == target { in_target = 1; next }
    in_target && $0 ~ /^  \/ \(root\)$/ { found = 1; exit }
    in_target && /^[^[:space:]]/ { in_target = 0 }
    END { exit(found ? 0 : 1) }
  '
}

ensure_collection() {
  local name="$1"
  local path="$2"
  local description="$3"

  echo ""
  echo "==> $name"
  run mkdir -p "$path"

  if collection_exists "$name"; then
    echo "   Collection already exists: $name"
  else
    run "$QMD_BIN" collection add "$path" --name "$name"
  fi

  if collection_has_root_context "$name"; then
    echo "   Root context already exists for: $name"
  else
    run "$QMD_BIN" context add "qmd://$name/" "$description"
  fi
}

require_command "$QMD_BIN"

if [[ "$RUN_EMBED" -eq 1 ]]; then
  RUN_UPDATE=1
fi

echo "Initializing QMD memory collections"
echo "QMD binary:   $QMD_BIN"
echo "Dropbox root: $DROPBOX_ROOT"
echo "Memory root:  $MEMORY_ROOT"

while IFS='|' read -r name path description; do
  [[ -z "$name" ]] && continue
  ensure_collection "$name" "$path" "$description"
done <<EOF
coding-notes|$DROPBOX_ROOT/notes|Coding notes
lessons|$MEMORY_ROOT/lessons|Generic lessons from all agents
notes|$MEMORY_ROOT/notes|Personal notes
aboutme|$MEMORY_ROOT/aboutme|Context and information about me
ideas|$MEMORY_ROOT/ideas|Brainstorms and ideas
links|$MEMORY_ROOT/links|Saved links with descriptions
research|$MEMORY_ROOT/research|Researched ideas
EOF

if [[ "$RUN_UPDATE" -eq 1 ]]; then
  echo ""
  echo "==> Refreshing QMD index"
  run "$QMD_BIN" update
fi

if [[ "$RUN_EMBED" -eq 1 ]]; then
  echo ""
  echo "==> Generating embeddings"
  run "$QMD_BIN" embed
fi

echo ""
echo "Done."
echo ""
echo "Collections mapped to:"
echo "  coding-notes -> $DROPBOX_ROOT/notes"
echo "  lessons      -> $MEMORY_ROOT/lessons"
echo "  notes        -> $MEMORY_ROOT/notes"
echo "  aboutme      -> $MEMORY_ROOT/aboutme"
echo "  ideas        -> $MEMORY_ROOT/ideas"
echo "  links        -> $MEMORY_ROOT/links"
echo "  research     -> $MEMORY_ROOT/research"
