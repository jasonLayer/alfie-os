#!/bin/bash
# Alfie Setup — installs the shared Claude Code config for the team
# Usage: bash <(curl -fsSL https://raw.githubusercontent.com/jasonLayer/alfie-os/team/setup.sh)

set -euo pipefail

REPO="jasonLayer/alfie-os"
BRANCH="team"
CLAUDE_DIR="$HOME/.claude"
TMP_DIR=$(mktemp -d)

echo ""
echo "  ✦ Alfie Setup"
echo "  Installing shared Claude Code config..."
echo ""

# --- Backup existing ~/.claude if present ---
if [ -d "$CLAUDE_DIR" ] && [ "$(ls -A $CLAUDE_DIR 2>/dev/null)" ]; then
  BACKUP="$HOME/.claude-backup-$(date +%Y%m%d%H%M%S)"
  echo "  Backing up existing ~/.claude to $BACKUP"
  cp -r "$CLAUDE_DIR" "$BACKUP"
fi

# --- Clone the team branch ---
echo "  Cloning config from github.com/$REPO (branch: $BRANCH)..."
git clone --depth 1 --branch "$BRANCH" "git@github.com:$REPO.git" "$TMP_DIR/claude-config" 2>/dev/null \
  || git clone --depth 1 --branch "$BRANCH" "https://github.com/$REPO.git" "$TMP_DIR/claude-config"

PORTABLE="$TMP_DIR/claude-config/portable"

# --- Install CLAUDE.md ---
echo "  [1/4] Installing CLAUDE.md (Alfie identity + dev flow)..."
cp "$PORTABLE/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"

# --- Install skills ---
echo "  [2/4] Installing skills..."
mkdir -p "$CLAUDE_DIR/skills"
for skill_dir in "$PORTABLE/skills/"*/; do
  skill_name=$(basename "$skill_dir")
  mkdir -p "$CLAUDE_DIR/skills/$skill_name"
  cp -r "$skill_dir"* "$CLAUDE_DIR/skills/$skill_name/"
  echo "       /$(basename $skill_name)"
done

# --- Install shared memory (Alfie identity, document types) ---
echo "  [3/4] Installing shared memory..."
mkdir -p "$CLAUDE_DIR/memory"
for f in "$PORTABLE/shared-memory/"*.md; do
  cp "$f" "$CLAUDE_DIR/memory/"
  echo "       $(basename $f)"
done

# --- Install per-user memory template ---
echo "  [4/4] Installing memory templates..."
USERNAME=$(whoami)
USER_MEMORY_DIR="$CLAUDE_DIR/projects/-Users-$USERNAME/memory"
mkdir -p "$USER_MEMORY_DIR"
for f in "$PORTABLE/memory/"*.md; do
  fname=$(basename "$f")
  if [ ! -f "$USER_MEMORY_DIR/$fname" ]; then
    cp "$f" "$USER_MEMORY_DIR/$fname"
    echo "       $fname (new)"
  else
    echo "       $fname (skipped — already exists)"
  fi
done

# --- Install hooks ---
if [ -d "$PORTABLE/../hooks" ]; then
  echo "  Installing hooks..."
  mkdir -p "$CLAUDE_DIR/hooks"
  cp "$PORTABLE/../hooks/"*.sh "$CLAUDE_DIR/hooks/"
  chmod +x "$CLAUDE_DIR/hooks/"*.sh
fi

# --- Install settings.json if not present ---
if [ ! -f "$CLAUDE_DIR/settings.json" ] && [ -f "$PORTABLE/../settings.json" ]; then
  echo "  Installing settings.json..."
  cp "$PORTABLE/../settings.json" "$CLAUDE_DIR/settings.json"
fi

# --- CCStatusLine config symlink ---
if [ -f "$TMP_DIR/claude-config/config/ccstatusline/settings.json" ]; then
  echo "  Linking CCStatusLine config..."
  mkdir -p "$HOME/.config/ccstatusline"
  # Copy into ~/.claude so the symlink target exists on this machine
  mkdir -p "$CLAUDE_DIR/config/ccstatusline"
  cp "$TMP_DIR/claude-config/config/ccstatusline/settings.json" "$CLAUDE_DIR/config/ccstatusline/settings.json"
  ln -sf "$CLAUDE_DIR/config/ccstatusline/settings.json" "$HOME/.config/ccstatusline/settings.json"
  echo "       ~/.config/ccstatusline/settings.json symlinked"
fi

# --- Cleanup ---
rm -rf "$TMP_DIR"

echo ""
echo "  ✦ Done! Next steps:"
echo ""
echo "  1. Install plugins:"
echo "     claude plugins install compound-engineering@every-marketplace"
echo "     claude plugins install skill-creator@claude-plugins-official"
echo "     claude plugins install notion-workspace-plugin@notion-plugin-marketplace"
echo ""
echo "  2. Add the Notion personal MCP:"
echo "     claude mcp add notion-personal --transport http https://mcp.notion.com/mcp"
echo "     (then open claude and authenticate with your Notion account)"
echo ""
echo "  3. Tell Alfie who you are:"
echo "     Open ~/.claude/projects/-Users-$USERNAME/memory/who-is-user.md"
echo "     and fill in your role, projects, and working style."
echo ""
echo "  Start a new Claude Code session to pick up all changes."
echo ""
