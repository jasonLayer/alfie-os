# API Key Management + Google Gemini Fallback

## Context

The LLM extraction pipeline currently requires `ANTHROPIC_API_KEY` as an environment variable — without it, users get mock data. We need:
1. A UI in Settings for users to enter API keys (Anthropic and/or Google Gemini)
2. Google Gemini Flash as a free-tier fallback when no Anthropic key is available
3. A link guiding users to get a free Google AI API key

## Architecture Decision

API keys are **secrets** — store them in a separate `api_keys` table, NOT in the versioned `config_versions` table. Return only masked values to the frontend.

**LLM priority chain:** Anthropic (if key exists) → Gemini Flash (if key exists) → Mock extraction

---

## Tasks

### Task 1: Add `api_keys` table to DB schema
**File:** `backend/app/db.py`

Add to `init_db()`:
```sql
CREATE TABLE IF NOT EXISTS api_keys (
    key_name TEXT PRIMARY KEY,
    key_value TEXT NOT NULL,
    updated_at TEXT NOT NULL DEFAULT (datetime('now'))
);
```

### Task 2: Add API key service
**File:** `backend/app/services/apikey_service.py` (new)

Three functions:
- `get_api_key(name: str) -> str | None` — returns raw key from DB, falls back to env var (`ANTHROPIC_API_KEY` or `GOOGLE_AI_API_KEY`)
- `set_api_key(name: str, value: str)` — upsert into `api_keys` table
- `get_masked_keys() -> dict` — returns `{"anthropic": "...ab1c", "gemini": "...xf2g"}` with last 4 chars visible, or `null` if not set. Checks both DB and env vars.

### Task 3: Add API key routes
**File:** `backend/app/routes/config.py` (extend existing)

Two new endpoints:
- `GET /api/api-keys` — returns masked keys via `get_masked_keys()`
- `PUT /api/api-keys` — accepts `{"anthropic": "sk-...", "gemini": "AI..."}`, calls `set_api_key()` for each provided key. Skips keys sent as empty string.

### Task 4: Add Google Gemini to LLM service
**Files:** `backend/app/services/llm_service.py`, `backend/requirements.txt`

- Import `get_api_key` from apikey service
- Replace `os.environ.get("ANTHROPIC_API_KEY")` with `get_api_key("anthropic")`
- Add `_call_gemini(api_key, prompt, filenames, batch_id)` function:
  - Uses `google.generativeai` SDK
  - Loads images from disk, sends with extraction prompt to `gemini-2.0-flash`
  - Parses JSON response same as `_call_claude`
- Update `process_batch_images` priority: try Anthropic → try Gemini → mock
- Add `google-generativeai>=0.8.0` to `requirements.txt`

### Task 5: Add API Keys section to Settings page
**File:** `frontend/src/app/settings/page.tsx`

Add a new **"AI API Keys"** collapsible section at the TOP of the settings page:
- Two input fields: Anthropic API Key, Google Gemini API Key
- Each shows masked value if key is set (e.g., "••••••ab1c")
- "Save" button to persist both keys
- Help link: "Get a free Google AI key" → `https://aistudio.google.com/apikey` (opens in new tab)
- Success/error toast on save
- Add `"apiKeys"` to the `SECTION_KEYS` array and `openSections` state

### Task 6: Add tests for API key management
**File:** `tests/test_batch_pipeline.py` (extend)

Tests:
- `GET /api/api-keys` returns null values when no keys set
- `PUT /api/api-keys` stores key, `GET` returns masked version
- Masking shows only last 4 characters
- LLM service falls back to mock when no keys set (already covered, verify)

---

## Execution Order

```
Task 1 (DB schema) ──┐
Task 2 (key service) ─┤── Task 4 (Gemini in LLM service)
Task 3 (key routes) ──┤── Task 5 (Settings UI)
                      └── Task 6 (tests)
```

Tasks 1-3 are independent backend foundations. Task 4 depends on 2. Task 5 depends on 3. Task 6 validates everything.

## Verification

1. `python3 -m pytest tests/ -v` — all pass
2. `cd frontend && npx next build` — builds clean
3. Open Settings → see API Keys section at top → enter a Gemini key → save → see masked value
4. Upload photos → process → verify Gemini extraction works (or mock if no key)
