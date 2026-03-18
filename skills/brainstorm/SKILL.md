---
name: brainstorm
description: Explore what to build through collaborative dialogue before planning. Use before /plan for any new feature, component, or significant change. Triggers on "let's brainstorm", "I want to build", "what should we do about", ambiguous feature requests, or when requirements have multiple valid interpretations.
argument-hint: "[feature idea or problem to explore]"
---

# Brainstorm (Alfie + Compound Engineering)

This skill delegates to the full Compound Engineering brainstorm engine, then adds Alfie-specific steps.

## Pre-Flight: Project Registry Check

Before starting the brainstorm:
1. Read `~/.claude/memory/project-registry.md` and look up the current working directory
2. If NOT found: "This directory isn't registered as a project yet. Want me to run `/project-setup` first?" If the user says yes, invoke `/project-setup` before continuing.
3. If found: note the project name and section IDs for auto-publishing at the end.

## Core Engine

**Invoke the Compound Engineering brainstorm skill now:**

```
skill: compound-engineering:ce-brainstorm
args: $ARGUMENTS
```

Follow the CE brainstorm process completely — all phases, all interaction rules, all output formats. The CE engine handles scope assessment, product pressure testing, collaborative dialogue, approach exploration, requirements capture, and handoff.

## Post-Brainstorm: Alfie Additions

After the CE brainstorm completes and a requirements document has been written:

### Auto-Publish to Notion

If the project registry (from pre-flight) had a match:
1. Confirm briefly: "Publishing to [Project] Specs."
2. Create a database row in the project's Specs DB using `mcp__notion-personal__notion-create-pages` with `data_source_id` parent
3. Title: `[Topic] Design`, Status: `Draft`
4. Include the Notion link in the completion message

If NOT found in the registry: skip silently.

### Handoff Reminder

When presenting next steps, remind that the next step in the Alfie flow is:
- `/plan <name>` to turn the spec into an implementation plan
- The plan will reference this requirements document automatically
