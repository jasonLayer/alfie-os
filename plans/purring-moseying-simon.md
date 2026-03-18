# Ship Sketch Pipeline

## Context
The sketch pipeline (Claude Vision describe → OpenAI gpt-image-1 generate → Cloudinary upload) is already ~95% built across main and the `feat/sketch-pipeline-e2e` branch. Goal: finalize, test, and merge.

## What Already Exists
- **Service:** `backend/app/services/fashion_sketch_service.py` (on main)
- **Prompt:** `backend/prompts/DESCRIBE_ITEM_FOR_SKETCH.md` (on main)
- **Endpoint:** `POST /items/{id}/generate-sketch` in `catalog.py` (on branch)
- **Frontend:** sketch section on wardrobe detail page + ItemCard display (on branch + main)
- **Tests:** 7 service tests + 9 endpoint tests
- **Tier enforcement:** `ai_fashion_sketches` feature flag
- **Enrichment + commit integration** (on main)

## Steps

### 1. Rebase branch on main
- Pick up the gitignore + backfill_illustrations.py commits from main
- Resolve any conflicts

### 2. Add Stella tool for `generate_sketch`
- **`backend/app/tools/registry.py`** — add tool entry (min_tier: "pro")
- **`backend/app/tools/executor.py`** — add handler that calls `process_item_sketch()`
- **`tests/test_executor.py`** — add test for the new tool
- Follows existing pattern (see `generate_illustration` tool if it exists, or other pro-tier tools)

### 3. Run full test suite
- `cd backend && python -m pytest tests/ -x -q`
- Ensure all existing + new tests pass

### 4. Apply migration to Supabase
- Run `20260303_sketch_columns.sql` against production DB
- Verify with `NOTIFY pgrst, 'reload schema'`

### 5. Create PR and merge
- Push branch, create PR, merge to main

## Verification
- All tests pass (including new Stella tool test)
- `POST /items/{id}/generate-sketch` returns 200 for pro tier with valid item
- Stella can invoke `generate_sketch` tool
- Frontend shows sketch section on item detail page
