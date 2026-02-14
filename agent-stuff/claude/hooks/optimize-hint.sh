#!/bin/bash
# UserPromptSubmit hook: suggest optimization when last response used 8+ tool calls.
# Skips exploratory prompts (questions, reviews, investigations).
set -e

INPUT=$(cat)
USER_PROMPT=$(echo "$INPUT" | jq -r '.user_prompt // empty')
TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path // empty')

# Skip if prompt looks exploratory (questions, reading, investigating)
if echo "$USER_PROMPT" | grep -qiE '^\s*(what|how|why|where|who|which|explain|tell me|show me|describe|walk me through|help me understand|look at|explore|investigate|dig into|read|check|review|summarize|overview|compare|difference|thoughts on|is there|are there|does |do |can you)'; then
  exit 0
fi

# Skip if no transcript available
if [[ -z "$TRANSCRIPT_PATH" || ! -f "$TRANSCRIPT_PATH" ]]; then
  exit 0
fi

# Count tool_use blocks in last assistant message
TOOL_COUNT=$(jq '
  [.[] | select(.role == "assistant")] | last |
  [.content[]? | select(.type == "tool_use")] | length
' "$TRANSCRIPT_PATH" 2>/dev/null || echo 0)

# Only hint at 8+ tool calls
if [[ "$TOOL_COUNT" -lt 8 ]]; then
  exit 0
fi

# Pick one hint based on seconds (cheap rotation)
HINTS=(
  "Consider extracting this repeated multi-step pattern into a reusable skill or shell script to cut future tool calls."
  "High tool-call count — a CLAUDE.md note or memory pattern could front-load context and skip the exploration phase next time."
  "This workflow could be a single bash script or Makefile target instead of ${TOOL_COUNT} individual tool calls."
  "Look for a reusable skill that batches this pattern; ${TOOL_COUNT} tool calls suggests an automatable workflow."
  "Consider a project note capturing the file layout or conventions discovered here so the next run skips redundant reads."
)
INDEX=$(( $(date +%S) % ${#HINTS[@]} ))

cat << EOF
{
  "systemMessage": "[⚡ ${TOOL_COUNT} tool calls last turn] ${HINTS[$INDEX]}"
}
EOF

exit 0
