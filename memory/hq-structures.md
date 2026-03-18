---
name: hq-structures
description: Layout patterns for each teamspace HQ page — where apps go, where docs go, icons, and ordering conventions
type: reference
---

## Standard Teamspace HQ Pattern

Every teamspace should have an HQ/index page with:

1. **Docs Database** — a DocsAndResource_DB for that teamspace (follows the 12-type system with Name, Type, Summary, File, URL properties)
2. **Apps section** — where project app pages live

**Two separate systems:**
- **Standalone documents** (when Jason asks to write or store a doc) → go into the teamspace's **docs database**, using the 12-document-type system and Alfie's writing conventions
- **App workflow outputs** (specs, plans, learnings, release notes from `/brainstorm`, `/plan`, `/codify`, `/done`) → go into **app containers** (Specs, Plans, etc.) as child pages

### Setting up a new teamspace

Alfie cannot create teamspaces — Jason must create them in Notion. When a teamspace doesn't have an HQ with a docs database:
1. Ask Jason to create the teamspace in Notion (if it doesn't exist)
2. Ask Jason to create the HQ page with a docs database (can duplicate from JR OS as template)
3. Once created, fetch the HQ page and docs database data_source_id
4. Update the registry's Teamspaces table with the HQ Page ID and Docs DB ID

---

## JR OS (8thday.io)

**HQ Page ID:** 78d0d32a-2816-82ac-bb6c-8102dd589ee1
**Icon:** compass (lightgray)
**Layout:** Two-column — Databases (left) | Apps (right)

- **Databases column:** `JROS_DocsAndResource_DB` (data_source: `1d1c5dbc-8d59-45ba-ba60-05d6d4fbdf86`)
- **Apps column:** Project app pages go here (e.g., Alfie OS)

### Alfie OS (app page)
**Page ID:** 3240d32a-2816-81c6-9ebb-f6927dfca033
**Icon:** folder (orange)
**Child page order:**
1. Plan: Roadmap
2. Reference: Release Notes
3. Reference: Patterns & Learnings
4. Explanation: Architecture
5. Explanation: Product Vision
6. Playbook: Features
7. Guide: Deployment & Operations
8. Specs
9. Plans

## Icon

**Page ID:** 31e0d32a-2816-8114-824a-d7208341ee85
**Icon:** none (default)
**Layout:** Callout header + toggle sections
**Docs DB:** None yet — needs setup

- Product (toggle)
- Engineering (toggle)
- Operations (toggle)
- Knowledge Base (toggle) — contains all doc-type pages
- Specs (top-level child page)
- Plans (top-level child page)

### Key difference from JR OS
Icon uses toggle-based organization. Docs live under the Knowledge Base toggle. Specs and Plans are standalone child pages outside the toggles. Icon needs a docs database added to match the standard pattern.

## Default App Template

**Template page ID:** `3250d32a-2816-813f-9568-efefe5455866`
**Location:** Master HQ → Apps & Dev toggle

**Structure:**
- **Databases:** Specs, Plans, Release Notes, Learnings
- **Pages:** Roadmap, Architecture, Product Vision, Features, Deployment & Operations

No type prefixes on names (not "Plan: Roadmap", just "Roadmap").

When `/project-setup` creates a new app, it duplicates this template, renames it, moves it to the target teamspace, then fetches the deployed page to discover all child database data_source_ids and page IDs.

## Pattern for /project-setup

When scaffolding a new project:
1. Check the target teamspace in the registry
2. **If teamspace has no Docs DB** (`—` in registry) → tell user the teamspace needs an HQ with a docs database first
3. **If teamspace has no HQ Page ID** → teamspace doesn't exist yet, ask user to create it in Notion first
4. **Duplicate the Default App template** (`3250d32a-2816-813f-9568-efefe5455866`) using `mcp__notion-personal__notion-duplicate-page`
5. Rename the duplicate to the app name
6. Move it to the target teamspace's Apps & Dev section
7. Fetch the new app page — discover which children are databases (capture data_source_ids) vs. pages (capture page IDs)
8. Update the project registry with all IDs
