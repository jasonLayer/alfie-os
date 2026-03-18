# Plan: Wire up frontend pages to real APIs (Tasks 1-5)

## Context
The Wardrobe Copilot has all backend endpoints and Spotify-themed frontend pages built, but several pages use placeholder/hardcoded data instead of calling real APIs. This plan connects them.

**Key discovery:** Image serving (Task 3) already works — `main.py:46` mounts `/api/uploads`. `GET /batches/{id}/items` also already exists (`batches.py:51`). Only one backend change is needed.

## Task A: Add `GET /catalog/{id}` endpoint (backend)
**File:** `backend/app/routes/catalog.py`
- Add route **at end of file** (after `/catalog/export` and `/catalog/import-csv` to avoid greedy path matching)
- Query `items` table by `unique_item_id`, return dict or 404
- No new imports needed (`get_db`, `JSONResponse` already imported)

## Task B: Make ItemCard clickable → `/wardrobe/[id]`
**File:** `frontend/src/components/ItemCard.tsx`
- Add `import Link from "next/link"`
- Add `itemId` to destructured props (it's in the type but not destructured at line 23)
- Wrap the `<motion.div>` in `<Link href={/wardrobe/${itemId}}>`

**File:** `frontend/src/components/WardrobeTable.tsx`
- Add `"use client"` directive, `useRouter` import
- Add `onClick={() => router.push(/wardrobe/${item.unique_item_id})}` and `cursor-pointer` to each `<tr>`

## Task C: Wire up Review page to real batch data
**File:** `frontend/src/app/review/page.tsx` (major rewrite)
- Read `batchId` from `useSearchParams()` (URL: `/review?batchId=3`)
- Fetch `GET /batches/{batchId}/items` → `{items, duplicate_candidates}`
- Map batch items into card-swipe UI (keep ConfidenceRing, nav arrows, editable fields)
- Image URL: `${API_BASE}/uploads/${item.image_filename}`
- Confidence: average of `confidence_category/subcategory/brand * 100`
- Show real duplicate candidates instead of hardcoded section
- Wire "Commit Batch" → `POST /batches/{batchId}/commit` with decisions array
- After commit, redirect to `/wardrobe`
- Handle missing `batchId` with redirect to `/import`

## Task D: Wire up Fit Check page
**File:** `frontend/src/app/fit-check/page.tsx`
- Add state: `loading`, `result`, `error`, `category`, `brand`
- Add category dropdown and brand input fields
- Wire "Check Fit" button → `POST /api/fit-check` with `{description, category, brand}`
- Replace hardcoded score with `result.score * 10` (API returns 1-10, UI shows /100)
- Replace hardcoded reasoning with `result.reasoning`
- Replace hardcoded redundancy bars with `result.redundancy[]` items (risk badges)
- Replace hardcoded icon section with `result.style_icon_alignment` and `result.recommended_style_fit`
- Show `result.metaphor_line` under score
- Add error display

## Task E: Wire up Look Builder page
**File:** `frontend/src/app/look-builder/page.tsx`
- Remove `PLACEHOLDER_OUTFITS` and `setTimeout` mock
- Add state: `outfits[]`, `building`, `error`, `season`
- Add season dropdown (Cold / Not-so-cold / Both)
- Wire "Build Looks" → `POST /api/look-builder` with `{anchor_description, season}`
- Render real outfit cards: look_name, mood, style_icons, season, pieces table, brainy_note
- Add error display

## Implementation order
1. Task A (backend endpoint — unblocks Task B's detail page)
2. Task B (ItemCard + WardrobeTable clickable)
3. Task C (Review page)
4. Task D (Fit Check)
5. Task E (Look Builder)

## Verification
- `curl http://localhost:8000/api/catalog/ITEM-0001` returns item JSON or 404
- Click an item in wardrobe grid → navigates to `/wardrobe/[id]` detail page with real data
- Navigate to `/review?batchId=1` → shows real batch items (or import a new batch to test)
- Fit Check: enter description, click Check Fit → see real score/analysis from API
- Look Builder: enter anchor, click Build → see real outfit suggestions from API
- `npm run build` in frontend passes cleanly
