# Bay Native — Robustness Improvements

## Context

After completing quick wins and functional gaps, the app still has no protection against component crashes, weak form validation UX, a cache with no TTL, and zero test coverage. These robustness items prevent the app from being production-ready.

## Plan (4 Streams)

### Stream 1: Error Boundary

**New file:** `src/components/ErrorBoundary.tsx`
- `"use client"` class component (~40 lines)
- `getDerivedStateFromError` + `componentDidCatch` with `console.error`
- Fallback UI: styled card matching `--bn-*` design system with "Try Again" button
- React 19 still requires class components for error boundaries

**Modify:** `src/app/layout.tsx`
- Import ErrorBoundary, wrap `{children}` inside `<ErrorBoundary>`
- Works fine: importing a `"use client"` component into a Server Component is standard Next.js

### Stream 2: Form Validation UX

**Modify:** `src/components/NominateModal.tsx`
- Add `FieldErrors` type and `fieldErrors` state object (per-field error map)
- Add `validate()` function:
  - Required: name, address, neighborhood, why, tags (with trim + length limits)
  - Optional format checks: website (URL regex), instagram/x (handle regex)
- Replace generic `statusMessage` validation with `fieldErrors` — keep `statusMessage` for API errors only
- Red border on errored fields using `border-[var(--bn-accent)]` (already `#e11d48`)
- Inline `<p>` error messages below each field
- Clear individual field errors on change for responsiveness
- Character counter on `why` textarea (1000 max)
- Disable submit button when form is incomplete (gray styling matching Surprise Me disabled state)
- Clear `sessionStorage.removeItem("bn_places_cache")` on successful submit (cache invalidation)

### Stream 3: Cache TTL

**Modify:** `src/components/ExploreShell.tsx`
- Define `CACHE_TTL_MS = 5 * 60 * 1000` and `CacheEnvelope = { ts: number; data: Place[] }`
- Change cache write to store `{ ts: Date.now(), data }` instead of bare array
- Change cache read to check `Date.now() - envelope.ts < CACHE_TTL_MS`
- Old bare-array caches silently fail the shape check → triggers fresh fetch (no migration needed)

### Stream 4: Test Infrastructure

**Install:** `vitest` (dev dependency)
**New file:** `vitest.config.ts` — node environment, `@` alias matching tsconfig
**Add script:** `"test": "vitest run"` in package.json

**New file:** `src/app/api/places/route.test.ts`
- Mock `@supabase/supabase-js` `createClient`
- Test GET: returns approved places, handles missing env vars, handles Supabase errors
- Test POST: valid submission returns ok, missing fields returns 400, missing service key returns 500

**New file:** `src/app/api/admin/places/route.test.ts`
- Test GET: 401 without token, 401 with wrong token, 200 with valid token
- Test POST: 401 unauthorized, 400 missing fields, 200 valid approve/reject

## Execution Order

1. Install vitest, create config, add test script
2. Create `ErrorBoundary.tsx`, wire into `layout.tsx`
3. Add cache TTL to `ExploreShell.tsx`
4. Add field-level validation to `NominateModal.tsx`
5. Write API route tests
6. Run `npm run build` + `npm run test` to verify

## Deliberately Excluded

- **Admin page route protection** — already shows token input, data only loads after auth. Adequate for MVP.
- **Component tests** — low ROI at this app size. API route tests cover critical paths.
- **Form library (zod/react-hook-form)** — overkill for one 8-field form.

## Verification

1. `npm run build` — no type or build errors
2. `npm run test` — all API route tests pass
3. Manual: open the app, trigger an error boundary (e.g., temporarily throw in a component)
4. Manual: submit nomination form with empty fields → see per-field red errors
5. Manual: check devtools sessionStorage → cache has `{ ts, data }` format
