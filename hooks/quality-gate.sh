#!/bin/bash
# Quality Gate Hooks for Claude Code
# Usage: quality-gate.sh <mode>
#   Modes: destructive-guard, lint-on-save, stop-gate
#
# Kill switch: export QUALITY_GATE_SKIP=1

set -euo pipefail

# Kill switch — bypass everything
[ "${QUALITY_GATE_SKIP:-0}" = "1" ] && exit 0

# Read JSON from stdin
INPUT=$(cat)
MODE="${1:-}"
CWD=$(echo "$INPUT" | jq -r '.cwd // empty')

# Skip in worktrees — they lack node_modules, so tsc/lint/npm will fail spuriously
if echo "$CWD" | grep -q '\.claude/worktrees'; then
  exit 0
fi

# ---------------------------------------------------------------------------
# Mode: destructive-guard (PreToolUse → Bash)
# Blocks dangerous commands before they execute.
# Exit 2 = block. Exit 0 = allow.
# ---------------------------------------------------------------------------
destructive_guard() {
  local cmd
  cmd=$(echo "$INPUT" | jq -r '.tool_input.command // empty')
  [ -z "$cmd" ] && exit 0

  # Patterns that should be blocked
  # rm -rf with dangerous targets (/, ~, .)
  if echo "$cmd" | grep -qE 'rm\s+-[a-zA-Z]*r[a-zA-Z]*f[a-zA-Z]*\s+(/|~|\.)$'; then
    echo "BLOCKED: Destructive rm detected: \`$cmd\`. Run manually outside Claude Code if intentional." >&2
    exit 2
  fi

  # git push --force or -f (but not regular push)
  if echo "$cmd" | grep -qE 'git\s+push\s+.*(--force|-f\b)'; then
    echo "BLOCKED: Force push detected: \`$cmd\`. Run manually outside Claude Code if intentional." >&2
    exit 2
  fi

  # git reset --hard
  if echo "$cmd" | grep -qE 'git\s+reset\s+--hard'; then
    echo "BLOCKED: Hard reset detected: \`$cmd\`. Run manually outside Claude Code if intentional." >&2
    exit 2
  fi

  # git checkout . (discard all changes)
  if echo "$cmd" | grep -qE 'git\s+checkout\s+\.$'; then
    echo "BLOCKED: Checkout discard detected: \`$cmd\`. Run manually outside Claude Code if intentional." >&2
    exit 2
  fi

  # git clean -fd
  if echo "$cmd" | grep -qE 'git\s+clean\s+-[a-zA-Z]*f'; then
    echo "BLOCKED: git clean detected: \`$cmd\`. Run manually outside Claude Code if intentional." >&2
    exit 2
  fi

  # git branch -D (force delete)
  if echo "$cmd" | grep -qE 'git\s+branch\s+-D\b'; then
    echo "BLOCKED: Force branch delete detected: \`$cmd\`. Run manually outside Claude Code if intentional." >&2
    exit 2
  fi

  # DROP TABLE / DROP DATABASE (case-insensitive)
  if echo "$cmd" | grep -qiE 'DROP\s+(TABLE|DATABASE)'; then
    echo "BLOCKED: Destructive SQL detected: \`$cmd\`. Run manually outside Claude Code if intentional." >&2
    exit 2
  fi

  # All clear
  exit 0
}

# ---------------------------------------------------------------------------
# Mode: lint-on-save (PostToolUse → Edit|Write)
# Runs linter on the modified file. Async, non-blocking.
# Returns systemMessage with lint errors if any.
# ---------------------------------------------------------------------------
lint_on_save() {
  local file_path ext lint_output

  # Try file_path from tool_input (Write uses file_path, Edit uses file_path)
  file_path=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
  [ -z "$file_path" ] && exit 0

  ext="${file_path##*.}"

  case "$ext" in
    ts|tsx|js|jsx)
      # Check if eslint is available in the project
      if [ -n "$CWD" ] && [ -f "$CWD/node_modules/.bin/eslint" ]; then
        lint_output=$(cd "$CWD" && npx eslint --no-warn-ignored "$file_path" 2>/dev/null) || true
        if [ -n "$lint_output" ]; then
          jq -n --arg msg "Lint issues in $(basename "$file_path"):\n$lint_output" \
            '{"systemMessage": $msg}'
        fi
      fi
      ;;
    py)
      if command -v ruff &>/dev/null; then
        lint_output=$(ruff check "$file_path" 2>/dev/null) || true
        if [ -n "$lint_output" ]; then
          jq -n --arg msg "Ruff issues in $(basename "$file_path"):\n$lint_output" \
            '{"systemMessage": $msg}'
        fi
      fi
      ;;
    *)
      # No linter for this file type
      ;;
  esac

  exit 0
}

# ---------------------------------------------------------------------------
# Mode: stop-gate (Stop)
# Runs full quality checks when Claude is about to finish.
# Returns decision: "block" if checks fail, silent if all pass.
# ---------------------------------------------------------------------------
stop_gate() {
  [ -z "$CWD" ] && exit 0

  # Only run in git repos where files were actually modified
  if ! git -C "$CWD" rev-parse --is-inside-work-tree &>/dev/null; then
    exit 0
  fi

  # Check if any files were modified in this session (staged + unstaged)
  local changed_files
  changed_files=$(git -C "$CWD" diff --name-only HEAD 2>/dev/null || git -C "$CWD" diff --name-only 2>/dev/null || echo "")
  [ -z "$changed_files" ] && exit 0

  local errors=""

  # --- Node.js project checks ---
  if [ -f "$CWD/package.json" ]; then

    # TypeScript type check
    if [ -f "$CWD/tsconfig.json" ]; then
      local tsc_output
      tsc_output=$(cd "$CWD" && npx tsc --noEmit 2>&1) || {
        errors+="## TypeScript Errors\n\`\`\`\n$tsc_output\n\`\`\`\n\n"
      }
    fi

    # Run tests if configured
    local test_script
    test_script=$(cd "$CWD" && node -e "const p=require('./package.json'); console.log(p.scripts && p.scripts.test ? p.scripts.test : '')" 2>/dev/null || echo "")
    if [ -n "$test_script" ] && [ "$test_script" != "undefined" ]; then
      local test_output
      test_output=$(cd "$CWD" && npm test -- --run 2>&1) || {
        errors+="## Test Failures\n\`\`\`\n$test_output\n\`\`\`\n\n"
      }
    fi

    # Lint check
    local lint_script
    lint_script=$(cd "$CWD" && node -e "const p=require('./package.json'); console.log(p.scripts && p.scripts.lint ? p.scripts.lint : '')" 2>/dev/null || echo "")
    if [ -n "$lint_script" ] && [ "$lint_script" != "undefined" ]; then
      local lint_output
      lint_output=$(cd "$CWD" && npm run lint 2>&1) || {
        errors+="## Lint Errors\n\`\`\`\n$lint_output\n\`\`\`\n\n"
      }
    fi
  fi

  # --- Python project checks ---
  if [ -f "$CWD/pyproject.toml" ] || [ -f "$CWD/requirements.txt" ]; then
    if command -v pytest &>/dev/null; then
      local pytest_output
      pytest_output=$(cd "$CWD" && pytest --tb=short -q 2>&1) || {
        errors+="## Pytest Failures\n\`\`\`\n$pytest_output\n\`\`\`\n\n"
      }
    fi

    if command -v ruff &>/dev/null; then
      local ruff_output
      ruff_output=$(cd "$CWD" && ruff check . 2>&1) || {
        errors+="## Ruff Lint Errors\n\`\`\`\n$ruff_output\n\`\`\`\n\n"
      }
    fi
  fi

  # --- Monorepo: check subdirectories ---
  # If cwd is a monorepo root (has both frontend/ and backend/), check both
  if [ -f "$CWD/frontend/package.json" ] && [ ! -f "$CWD/package.json" ]; then
    local fe_tsc
    if [ -f "$CWD/frontend/tsconfig.json" ]; then
      fe_tsc=$(cd "$CWD/frontend" && npx tsc --noEmit 2>&1) || {
        errors+="## Frontend TypeScript Errors\n\`\`\`\n$fe_tsc\n\`\`\`\n\n"
      }
    fi
  fi
  if [ -f "$CWD/backend/pyproject.toml" ] && [ ! -f "$CWD/pyproject.toml" ]; then
    if command -v pytest &>/dev/null; then
      local be_pytest
      be_pytest=$(cd "$CWD/backend" && pytest --tb=short -q 2>&1) || {
        errors+="## Backend Pytest Failures\n\`\`\`\n$be_pytest\n\`\`\`\n\n"
      }
    fi
  fi

  # Report results
  if [ -n "$errors" ]; then
    jq -n --arg reason "$(echo -e "Quality gate failed. Fix these before finishing:\n\n$errors")" \
      '{"decision": "block", "reason": $reason}'
  fi

  exit 0
}

# ---------------------------------------------------------------------------
# Dispatch
# ---------------------------------------------------------------------------
case "$MODE" in
  destructive-guard) destructive_guard ;;
  lint-on-save)      lint_on_save ;;
  stop-gate)         stop_gate ;;
  *)
    echo "Unknown mode: $MODE. Use: destructive-guard, lint-on-save, stop-gate" >&2
    exit 0  # Don't block on unknown mode
    ;;
esac
