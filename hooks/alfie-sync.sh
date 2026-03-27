#!/bin/bash
# alfie-sync.sh — Auto-commit and push ~/.claude changes at session end.
# Fires on the Stop hook. Stages only Alfie config files (never personal
# project dirs or image-cache). Pushes to whichever branch is checked out.
#
# Kill switch: export ALFIE_SYNC_SKIP=1

set -euo pipefail

[ "${ALFIE_SYNC_SKIP:-0}" = "1" ] && exit 0

ALFIE_DIR="$HOME/.claude"

# Must be a git repo
if ! git -C "$ALFIE_DIR" rev-parse --is-inside-work-tree &>/dev/null; then
  exit 0
fi

# Stage only the files we care about (safe subset — no personal project dirs)
git -C "$ALFIE_DIR" add \
  skills/ \
  memory/ \
  CLAUDE.md \
  hooks/ \
  settings.json \
  settings.local.json \
  .gitignore \
  keybindings.json \
  2>/dev/null || true

# Nothing staged? Nothing to do.
if git -C "$ALFIE_DIR" diff --cached --quiet; then
  exit 0
fi

# Commit with a timestamp so it's easy to spot in git log
TIMESTAMP=$(date '+%Y-%m-%d %H:%M')
git -C "$ALFIE_DIR" commit -m "auto: sync Alfie config ($TIMESTAMP)" \
  --no-verify \
  2>/dev/null

# Push to current branch
BRANCH=$(git -C "$ALFIE_DIR" rev-parse --abbrev-ref HEAD)
git -C "$ALFIE_DIR" push origin "$BRANCH" --quiet 2>/dev/null || true

exit 0
