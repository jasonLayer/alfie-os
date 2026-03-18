# CSV Import Resilience — Accept Any CSV, Edit Inline, Import What Works

## Context

The CSV import currently fails entirely when column headers don't exactly match the verbose locked column names (e.g. `"Description (short, descriptive text)"` instead of just `"Description"`). Users with simple spreadsheets get "Unknown column(s)" errors and can't import anything. Additionally, the CSV review step shows read-only values — users can't fix data before committing. If any row fails during commit, the entire batch rolls back.

**Goal:** Accept any reasonable CSV, let users edit every field inline during review, import what works, and surface failures for retry.

---

## Changes

### 1. Smart column matching in `validate_csv_schema` + `parse_csv_content`

**File:** `backend/app/services/csv_service.py`

Add a `match_column_header(header) -> field_name | None` function that does fuzzy matching:
- Exact match against `LOCKED_COLUMNS` (existing behavior)
- Case-insensitive match against short field names (`description`, `brand`, `category`, etc.)
- Keyword match — if the header contains the short field name (e.g. `"Item Description"` → `description`)

Update `validate_csv_schema`:
- Instead of rejecting unknown columns, try to match them via `match_column_header`
- Only reject columns that can't be matched to any known field
- Still require at least `description`

Update `parse_csv_content`:
- Use matched column mapping instead of exact `COLUMN_TO_FIELD` lookup
- Fill unmatched fields with empty strings

### 2. Per-row import with failure tracking

**File:** `backend/app/services/csv_service.py` — `add_items_from_rows`

Change from all-or-nothing transaction to per-row try/catch:
- Try inserting each row individually
- On success: increment `added` counter
- On failure: capture row index + error message, continue to next row
- Return `{"added": N, "failed": [...failed row indices...], "errors": [...messages...]}`

**File:** `backend/app/routes/catalog.py` — `import_csv`

Update response to include failed rows so frontend can display them for retry.

### 3. Inline-editable CSV review cards

**File:** `frontend/src/app/(app)/import/page.tsx`

Replace the read-only `<p>` tags in the CSV review step with editable inputs/selects matching the photo import pattern:
- Category → `<select>` with CATEGORIES
- Season → `<select>` with SEASONS
- Style Fit → `<select>` with STYLE_FIT
- Subcategory, Brand, Description, Icons, Notes → `<input>` fields

Add a `handleCsvFieldEdit(rowIndex, field, value)` function that updates `csvRows` state and clears AI sparkle for that field.

### 4. Failed-rows retry flow

**File:** `frontend/src/app/(app)/import/page.tsx`

After commit, if there are failed rows:
- Show "N imported, M need attention" summary
- Display failed rows in the same editable review UI
- "Retry Import" button sends only failed rows back to commit endpoint
- On full success, transition to done step

---

## Files Modified

| File | Change |
|------|--------|
| `backend/app/services/csv_service.py` | Smart column matching, per-row insert |
| `backend/app/routes/catalog.py` | Return failed rows in import response |
| `frontend/src/app/(app)/import/page.tsx` | Editable review cards, retry flow |

## Tests

- Update `tests/test_csv_service.py` — test fuzzy column matching
- Update `tests/test_relaxed_csv.py` — test simple headers like "Description", "Brand"
- Add test for per-row failure handling (one bad row doesn't block others)
- Run full suite: `python3 -m pytest tests/ --ignore=tests/test_wishlist.py -v`
- TypeScript check: `cd frontend && npx tsc --noEmit`
