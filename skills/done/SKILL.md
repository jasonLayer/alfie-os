---
name: done
description: Close the loop on a completed plan — runs Definition of Done checklist, writes release notes, cleans up plan file, auto-publishes to Notion Release Notes DB, and gives a session recap. Use when the user says "we're done", "close this out", "ship it", or after all tasks are complete.
argument-hint: "[plan name or topic]"
---

Complete the plan and close the loop: $ARGUMENTS

There is no CE equivalent for this step — this is Alfie's own closure process.

## Steps

1. **Find the matching plan file** in `docs/plans/` (search by slug or keyword from $ARGUMENTS).

2. **Run the Definition of Done checklist:**
   - [ ] All plan checkboxes checked off?
   - [ ] Tests added/updated and passing?
   - [ ] TDD was followed? (failing test first for all production code)
   - [ ] Auth/access constraints verified (if applicable)?
   - [ ] At least 1 learning codified via `/codify` (if applicable)?
   - [ ] Release notes ready?
   - [ ] Code is readable for team onboarding?

3. If anything is missing, tell the user what's left before we can close.

4. **Ask for a one-line release note.**

5. **Close the plan:**
   - If `scripts/complete_plan.sh` exists, run it: `./scripts/complete_plan.sh <plan_path> "<release note>"`
   - Otherwise:
     - Append the release note to `docs/RELEASE_LOG.md` (create if needed)
     - Update the plan's YAML frontmatter status to `completed` (if it has one)
     - Remove the plan file from `docs/plans/`

6. **Auto-Publish to Notion:**
   - Read `~/.claude/memory/project-registry.md` and look up the current working directory
   - If found:
     - Create a database row in the project's Release Notes DB using `mcp__notion-personal__notion-create-pages` with `data_source_id` parent
     - Title: `Release [today's date] — [Name]`, Date: today
     - Include the Notion link in the completion message
   - If NOT found in the registry: skip silently.

7. **Chat recap:**
   - What we did
   - What went well
   - Amendments for next plan
   - Plain English "what you can do now"

8. Remind to commit, push, and open/merge the PR.
