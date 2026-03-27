---
name: plan
description: Create a new implementation plan from a spec or idea. Use when the user says "plan this", "create a plan", "let's plan", or provides a spec and wants a structured plan. Runs pre-flight registry check, calls CE plan engine, then auto-publishes to Notion Plans DB.
argument-hint: "[feature or topic to plan]"
---

Create a new plan for: $ARGUMENTS

## Pre-Flight: Project Registry Check

Before starting:
1. Read `~/.claude/memory/project-registry.md` and look up the current working directory
2. If found: note the project name and section IDs for auto-publishing at the end

## Core Engine

**Invoke the Compound Engineering plan skill now:**

```
skill: compound-engineering:ce-plan
args: $ARGUMENTS
```

Follow the CE plan process completely — idea refinement, parallel research agents, SpecFlow analysis, detail level selection, plan writing, and post-generation options. The CE engine handles all of this.

## Post-Plan: Alfie Additions

After the CE plan completes and a plan file has been written:

### Auto-Publish to Notion

If the project registry (from pre-flight) had a match:
1. Confirm briefly: "Publishing to [Project] Plans."
2. Create a database row in the project's Plans DB using `mcp__notion-personal__notion-create-pages` with `data_source_id` parent
3. Title: `[Topic]`, Status: `Active`
4. Include the Notion link in the completion message

If NOT found in the registry: skip silently.

### TDD Reminder

When presenting next steps, remind: "Remember — TDD Iron Law applies during `/work`. No production code without a failing test first."
