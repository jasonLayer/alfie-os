# Codebase A-Grade: Tests, Types, CI, Workflow

## Context

The codebase is a solid B+/A-. Four improvements bring it to an A:
1. **Frontend tests** — Vitest + RTL installed but no test script, CI doesn't run tests
2. **Type unification** — `DemoItem` ≠ `CatalogItem`, requiring unsafe `as unknown as` casts
3. **E2E smoke test** — Playwright installed, no E2E config or tests
4. **PR template + CI** — no PR template, frontend tests not wired into CI

## Step 1: Eliminate DemoItem — unify on CatalogItem

`DemoItem` has 14 fields; `CatalogItem` has 21. The only required field `DemoItem` lacks is `category_id: string`. The other 6 extras are all optional on `CatalogItem` and can be omitted.

| File | Change |
|------|--------|
| `lib/demoData.ts` | Delete `DemoItem` type. Import `CatalogItem` from `./types`. Change all array annotations to `CatalogItem[]`. Add `category_id: ""` to each of the 35 items. Update export types. |
| `app/(app)/dashboard/page.tsx` | Remove `as Record<string, CatalogItem[]>` cast (line ~123) |
| `app/(app)/wardrobe/page.tsx` | Remove `DemoItem` import. Change `filtered: DemoItem[]` to `CatalogItem[]`. Remove `as unknown as CatalogItem[]` cast. |
| `app/(app)/wardrobe/[id]/page.tsx` | Delete `demoItemToCatalogItem()` function. Remove `DemoItem` import. Use demo items directly (already `CatalogItem` now). |

**Verify:** `grep -r "DemoItem" frontend/src/` returns 0 results. `npx tsc --noEmit` passes.

## Step 2: Add test scripts to package.json

| File | Change |
|------|--------|
| `frontend/package.json` | Add `"test": "vitest run --project unit"` and `"test:watch": "vitest --project unit"` |

**Verify:** `cd frontend && npm test` runs the 7 existing test files and passes.

## Step 3: Write focused component tests (3 new files)

**`src/contexts/TestDriveContext.test.tsx`** — Tests:
- Starts with `isTestDrive = false`
- Toggles on/off via `setTestDrive`
- Throws when used outside provider

**`src/contexts/AuthContext.test.tsx`** — Mock `@/lib/supabase` and `next/navigation`. Tests:
- Unauthenticated when no session
- Authenticated when session exists
- `login()` returns error on failure
- Throws when used outside provider

**`src/lib/demoData.test.ts`** — Tests:
- 35 items total
- Every item has required `CatalogItem` fields (including `category_id`)
- 5 categories
- Dashboard count matches item count

**Verify:** `npm test` runs 10 test files (7 existing + 3 new), all pass.

## Step 4: Playwright E2E smoke test

Install `@playwright/test` (the test runner — `playwright` browser engine is already installed).

| File | Change |
|------|--------|
| `frontend/playwright.config.ts` | **Create** — testDir: `./e2e`, baseURL: `localhost:3000`, webServer starts `npm run dev`, chromium only |
| `frontend/e2e/login.spec.ts` | **Create** — one test: loads `/login`, asserts heading + email/password inputs + login button visible |
| `frontend/package.json` | Add `"test:e2e": "playwright test"` |

**Verify:** `npm run test:e2e` starts dev server, runs smoke test, passes.

## Step 5: PR template

| File | Change |
|------|--------|
| `.github/PULL_REQUEST_TEMPLATE.md` | **Create** — minimal: What, Why, How to test (checklist), Screenshots section |

## Step 6: Wire frontend tests into CI

| File | Change |
|------|--------|
| `.github/workflows/ci.yml` | Add `frontend-tests` job: checkout, setup node 22, npm ci, `npm test` |

No coverage gate yet (too few tests). No E2E in CI (requires running backend + Supabase).

**Verify:** Push to a branch, open PR — CI runs frontend tests alongside existing lint + build.

## Implementation order

1. Eliminate DemoItem (type fix — enables clean tests)
2. Add test scripts (enables running tests)
3. Write component tests
4. Playwright E2E setup
5. PR template
6. Wire CI

## Verification checklist

1. `grep -r "DemoItem" frontend/src/` — 0 results
2. `cd frontend && npx tsc --noEmit` — 0 errors
3. `cd frontend && npm test` — 10 test files pass
4. `cd frontend && npm run build` — succeeds
5. `cd frontend && npm run test:e2e` — smoke test passes
6. `cd frontend && npx eslint src/` — 0 errors, 0 warnings
