#!/bin/bash
# Claude Code Portable Setup Script
# Copies Jason's dev methodology, skills, and memory to a new machine.
# Run this on the NEW machine after installing Claude Code.
#
# Usage:
#   1. Copy this script to the new machine
#   2. Copy the ~/.claude/portable/ folder to the new machine (same path)
#   3. Run: bash ~/.claude/setup-new-machine.sh

set -euo pipefail

CLAUDE_DIR="$HOME/.claude"
PORTABLE_DIR="$CLAUDE_DIR/portable"
USERNAME=$(whoami)
HOME_PROJECT_DIR="$CLAUDE_DIR/projects/-Users-$USERNAME/memory"

echo "=== Claude Code Setup for $(whoami) ==="
echo ""

# --- Step 1: Global instructions ---
echo "[1/4] Installing global CLAUDE.md..."
if [ -f "$PORTABLE_DIR/CLAUDE.md" ]; then
  cp "$PORTABLE_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
  echo "  -> $CLAUDE_DIR/CLAUDE.md"
else
  echo "  ERROR: $PORTABLE_DIR/CLAUDE.md not found"
  exit 1
fi

# --- Step 2: Custom skills ---
echo "[2/4] Installing custom skills..."
for skill_dir in "$PORTABLE_DIR/skills/"*/; do
  skill_name=$(basename "$skill_dir")
  mkdir -p "$CLAUDE_DIR/skills/$skill_name"
  cp "$skill_dir"* "$CLAUDE_DIR/skills/$skill_name/"
  echo "  -> /$skill_name"
done

# --- Step 3: Global memory ---
echo "[3/4] Installing global memory..."
mkdir -p "$HOME_PROJECT_DIR"
for mem_file in "$PORTABLE_DIR/memory/"*.md; do
  cp "$mem_file" "$HOME_PROJECT_DIR/"
  echo "  -> $(basename "$mem_file")"
done

# --- Step 4: Shared memory (document types, etc.) ---
echo "[4/4] Installing shared memory files..."
mkdir -p "$CLAUDE_DIR/memory"
for mem_file in "$PORTABLE_DIR/shared-memory/"*.md; do
  if [ -f "$mem_file" ]; then
    cp "$mem_file" "$CLAUDE_DIR/memory/"
    echo "  -> $(basename "$mem_file")"
  fi
done

# --- Step 5: CCStatusLine config symlink ---
echo "[5/5] Linking CCStatusLine config..."
mkdir -p "$HOME/.config/ccstatusline"
if [ -f "$CLAUDE_DIR/config/ccstatusline/settings.json" ]; then
  ln -sf "$CLAUDE_DIR/config/ccstatusline/settings.json" "$HOME/.config/ccstatusline/settings.json"
  echo "  -> ~/.config/ccstatusline/settings.json -> ~/.claude/config/ccstatusline/settings.json"
else
  echo "  SKIP: config/ccstatusline/settings.json not found in repo"
fi

echo ""
echo "=== Setup complete! ==="
echo ""
echo "Global instructions:  $CLAUDE_DIR/CLAUDE.md"
echo "Skills installed to:  $CLAUDE_DIR/skills/"
echo "Global memory:        $HOME_PROJECT_DIR/"
echo ""
echo "--- Install plugins manually ---"
echo "Run these commands:"
echo ""
echo "  claude plugins install compound-engineering@every-marketplace"
echo "  claude plugins install skill-creator@claude-plugins-official"
echo ""
echo "Optional (if you still want these):"
echo "  claude plugins install superpowers@claude-plugins-official"
echo "  claude plugins install notion-workspace-plugin@notion-plugin-marketplace"
echo ""
echo "--- Project-specific memory ---"
echo "Project memory (Supabase config, deployment details, etc.) stays"
echo "in each project's repo. It's NOT portable — it gets rebuilt per project."
echo ""
echo "Done! Start a new Claude Code session to pick up the changes."
