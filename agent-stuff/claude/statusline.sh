#!/bin/bash
input=$(cat)

# shellcheck disable=SC2034
MODEL=$(echo "$input" | jq -r '.model.display_name // "Claude"')
PERCENT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | xargs printf "%.0f")

# Color based on usage
if [ "$PERCENT" -ge 80 ]; then
  COLOR="\033[31m"  # Red
elif [ "$PERCENT" -ge 60 ]; then
  COLOR="\033[33m"  # Yellow
else
  COLOR="\033[32m"  # Green
fi
RESET="\033[0m"

echo -e "${COLOR}${PERCENT}%${RESET} context"
