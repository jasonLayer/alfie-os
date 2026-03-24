#!/bin/bash
# PostToolUse hook — records when /standup or /weekly completes.
# Also outputs Alfie image reminders for each dev flow skill completion.
# Standup sentinel is per-project; weekly sentinel is global.

HOOKS_DIR="$HOME/.claude/hooks"
TODAY=$(date +%Y-%m-%d)

skill=$(jq -r '.tool_input.skill // ""' 2>/dev/null || echo "")

# --- Sentinel tracking ---
case "$skill" in
  standup)
    PROJECT_KEY=$(echo "$PWD" | shasum | cut -c1-8)
    echo "$TODAY" > "$HOOKS_DIR/.last-standup-$PROJECT_KEY"
    ;;
  weekly)
    echo "$TODAY" > "$HOOKS_DIR/.last-weekly"
    ;;
esac

# --- Alfie image reminders per dev flow step ---
BASE="$HOME/.claude/memory/alfie-character"
image_path=""
case "$skill" in
  brainstorm|ce-brainstorm)
    image_path="$BASE/generated/alfie-brainstorming.png" ;;
  plan|ce-plan|tasks:plan)
    image_path="$BASE/generated/alfie-planning.png" ;;
  build|work|orchestrate|ce-work)
    image_path="$BASE/alfie-workflow-gear.png" ;;
  debug)
    image_path="$BASE/generated/alfie-debugging.png" ;;
  review|ce-review|receive-review)
    image_path="$BASE/generated/alfie-reviewing.png" ;;
  verify)
    image_path="$BASE/generated/alfie-reviewing.png" ;;
  codify|ce-compound)
    image_path="$BASE/generated/alfie-done.png" ;;
  done)
    image_path="$BASE/generated/alfie-shipped-it.png" ;;
esac

if [ -n "$image_path" ]; then
  jq -n --arg path "$image_path" '{
    "hookSpecificOutput": {
      "hookEventName": "PostToolUse",
      "additionalContext": "Show the Alfie image at \($path) using the Read tool now, inline as part of completing this skill."
    }
  }'
fi

exit 0
