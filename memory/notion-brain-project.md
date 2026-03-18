# Notion Brain Skill Suite — Complete

## Status
- Phase: V1 complete. TrustLayer fully mapped. Personal workspace pending crawl.
- Skills are live and showing in skill list.

## What Was Built
Three user-level skills at `~/.claude/skills/`:

1. **notion-brain** (`~/.claude/skills/notion-brain/SKILL.md`) — Discovery/mapping. Crawls workspaces, saves to memory, progressive learning.
2. **notion-read** (`~/.claude/skills/notion-read/SKILL.md`) — Smart lookups. Routes queries to the right database using brain knowledge.
3. **notion-do** (`~/.claude/skills/notion-do/SKILL.md`) — Actions. Create/update/move pages, add rows, manage databases.

## Memory Files
- `~/.claude/memory/notion-workspaces.md` — Master workspace map
- `~/.claude/memory/notion-personal-workspace-raw.md` — Full TrustLayer crawl (500+ lines, all DBs, schemas, patterns)
- `~/.claude/memory/notion-brain-project.md` — This file (project status)

## Workspace Mapping (corrected)
| MCP Server | Workspace | Email |
|---|---|---|
| `mcp__plugin_Notion_notion` | TrustLayer | jason@trustlayer.io (connected via jasonreichl@jasonreichl.com) |
| `mcp__notion-personal` | Personal | jasonreichl@jasonreichl.com (added, not yet connected in session) |

## MCP Tool Names (discovered)
All tools use prefix `mcp__plugin_Notion_notion__`:
- `notion-search` — Semantic search (workspace, database, page, teamspace scope)
- `notion-fetch` — Fetch page/database/data-source details
- `notion-create-pages` — Create pages (standalone or in database)
- `notion-update-page` — Update properties, content, verification
- `notion-move-pages` — Move pages between parents
- `notion-create-database` — Create database with SQL DDL schema
- `notion-update-data-source` — Alter database schema
- `notion-get-comments` — Get discussions on a page
- `notion-query-database-view` — Query a pre-built database view
- `notion-query-meeting-notes` — Query meeting notes with filters
- `notion-duplicate-page` — Duplicate a page

## TODO
- [ ] Crawl Personal workspace when `mcp__notion-personal` tools load
- [ ] Create `notion-databases.md` consolidated reference (currently in raw file)
- [ ] Create `notion-patterns.md` with cross-workspace patterns
- [ ] Run skill-creator evals to optimize trigger descriptions
