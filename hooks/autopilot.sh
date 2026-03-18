#!/bin/bash
# Autopilot — SessionStart hook that nudges for /standup and /weekly
# Checks last-run timestamps and suggests when they're due.
#
# Kill switch: export AUTOPILOT_SKIP=1

set -euo pipefail

[ "${AUTOPILOT_SKIP:-0}" = "1" ] && exit 0
[ "${QUALITY_GATE_SKIP:-0}" = "1" ] && exit 0

HOOKS_DIR="$HOME/.claude/hooks"
STANDUP_FILE="$HOOKS_DIR/.last-standup"
WEEKLY_FILE="$HOOKS_DIR/.last-weekly"
TODAY=$(date +%Y-%m-%d)
DOW=$(date +%u)  # 1=Monday, 7=Sunday

messages=()

# --- Standup check ---
if [ -f "$STANDUP_FILE" ]; then
  last_standup=$(cat "$STANDUP_FILE" 2>/dev/null || echo "")
else
  last_standup=""
fi

if [ "$last_standup" != "$TODAY" ]; then
  if [ -z "$last_standup" ]; then
    messages+=("You haven't run /standup yet. Start your day with a quick briefing.")
  else
    messages+=("Last standup was $last_standup. Run /standup to catch up on what's happened since.")
  fi
fi

# --- Weekly check ---
if [ -f "$WEEKLY_FILE" ]; then
  last_weekly=$(cat "$WEEKLY_FILE" 2>/dev/null || echo "")
else
  last_weekly=""
fi

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
  if [ "$DOW" = "1" ]; then
    messages+=("It's Monday — time for /weekly to update all HQ pages.")
  elif [ -z "$last_weekly" ]; then
    messages+=("You haven't run /weekly yet. Run it to generate HQ updates across all teamspaces.")
  else
    messages+=("Last weekly update was $last_weekly (7+ days ago). Run /weekly when you're ready.")
  fi
fi

# --- Output ---
if [ ${#messages[@]} -gt 0 ]; then
  combined=""
  for msg in "${messages[@]}"; do
    combined+="- $msg\n"
  done
  jq -n --arg msg "$(echo -e "$combined")" '{"systemMessage": $msg}'
fi

exit 0
