#!/bin/bash
# Autopilot — SessionStart hook that nudges for /standup and /weekly
# Checks last-run timestamps and suggests when they're due.
#
# Kill switch: export AUTOPILOT_SKIP=1

set -euo pipefail

[ "${AUTOPILOT_SKIP:-0}" = "1" ] && exit 0
[ "${QUALITY_GATE_SKIP:-0}" = "1" ] && exit 0

HOOKS_DIR="$HOME/.claude/hooks"
PROJECT_KEY=$(echo "$PWD" | shasum | cut -c1-8)
STANDUP_FILE="$HOOKS_DIR/.last-standup-$PROJECT_KEY"
WEEKLY_FILE="$HOOKS_DIR/.last-weekly"
TODAY=$(date +%Y-%m-%d)
DOW=$(date +%u)  # 1=Monday, 7=Sunday

instructions=()

# --- Session start image ---
instructions+=("Show the Alfie greeting image at ~/.claude/memory/alfie-character/alfie-at-desk.png using the Read tool as part of your session greeting.")

# --- Standup check (per-project) ---
last_standup=$(cat "$STANDUP_FILE" 2>/dev/null || echo "")
if [ "$last_standup" != "$TODAY" ]; then
  instructions+=("Run /standup now as your first action before responding to the user. Do not wait to be asked.")
fi

# --- Weekly check ---
last_weekly=$(cat "$WEEKLY_FILE" 2>/dev/null || echo "")
weekly_due=false
if [ -z "$last_weekly" ]; then
  weekly_due=true
elif command -v python3 &>/dev/null; then
  days_since=$(python3 -c "
from datetime import date
last = date.fromisoformat('$last_weekly')
print((date.today() - last).days)
" 2>/dev/null || echo "999")
  if [ "$days_since" -ge 7 ]; then
    weekly_due=true
  fi
fi

if [ "$weekly_due" = true ]; then
  instructions+=("After standup completes (or if standup already ran today), also run /weekly to update all HQ pages.")
fi

# --- Output ---
if [ ${#instructions[@]} -gt 0 ]; then
  combined=""
  for inst in "${instructions[@]}"; do
    combined+="$inst "
  done
  jq -n --arg ctx "$combined" '{
    "hookSpecificOutput": {
      "hookEventName": "SessionStart",
      "additionalContext": $ctx
    }
  }'
fi

exit 0
