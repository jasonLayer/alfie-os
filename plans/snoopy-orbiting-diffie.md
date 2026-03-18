# Plan: Fix Settings Page — 404s, Broken Avatar, Frozen Tabs

## Context

After logging in and navigating to Settings, the user sees:
1. Toast errors on load (multiple API calls failing)
2. Broken avatar image (Google OAuth profile pic)
3. Subscription section showing 404 inline
4. Style tab never loads
5. Advanced tab does nothing
6. Clicking between tabs stops working entirely

**Root causes identified:**

- **Avatar broken**: Google avatar URLs (`lh3.googleusercontent.com`) not in Next.js `remotePatterns` or CSP `img-src`. The `<Image>` component throws a hard error.
- **Tabs freeze**: No error boundaries around tab content. When `<Image>` throws (avatar or style icon images), React crashes the AnimatePresence wrapper and ALL tabs become unresponsive.
- **Backend 404s**: The defensive backend changes we just pushed may not have deployed to Railway yet. Need to verify.
- **`--accent-gold` undefined**: Referenced 35 times across 8 files but never defined in CSS. Should be `#D4A843`. Buttons and focus rings silently render with no color.

## Files to Change

### Frontend
1. **`frontend/next.config.ts`** — Add `lh3.googleusercontent.com` to `remotePatterns` and CSP `img-src`
2. **`frontend/src/app/globals.css`** — Add `--accent-gold: #D4A843` to `:root`
3. **`frontend/src/app/(app)/settings/page.tsx`** — Wrap each tab's content in an ErrorBoundary
4. **`frontend/src/components/ui/ErrorBoundary.tsx`** (new) — Reusable React error boundary with retry button
5. **`frontend/src/app/(app)/settings/components/AccountTab.tsx`** — Add `onError` fallback to avatar `<Image>`

### Backend (verify only)
6. Confirm Railway has redeployed with the defensive billing/style-icons changes

## Work Breakdown

### Step 1: Define `--accent-gold` CSS variable
- Add `--accent-gold: #D4A843;` to `:root` in `globals.css`
- This fixes 35 invisible buttons/focus rings across the app

### Step 2: Fix avatar image domain
- Add `{ protocol: "https", hostname: "lh3.googleusercontent.com" }` to `next.config.ts` remotePatterns
- Add `https://lh3.googleusercontent.com` to CSP `img-src` directive
- Add `onError` handler to avatar `<Image>` in AccountTab to fall back to initials on broken URLs

### Step 3: Add ErrorBoundary component
- Create `frontend/src/components/ui/ErrorBoundary.tsx` — class component that catches render errors
- Shows error message + "Try Again" button that resets the boundary
- Matches existing design tokens (surface-2, text-secondary, accent-gold)

### Step 4: Wrap tab content in error boundaries
- In `settings/page.tsx`, wrap each tab (`AccountTab`, `StyleTab`, `AdvancedTab`) inside `<ErrorBoundary>`
- Each tab fails independently — one broken tab doesn't freeze the others

### Step 5: Verify Railway deployment
- Hit `https://backend-production-9c5f.up.railway.app/api/billing/tier` (or `/api/health`) to confirm the backend has our defensive changes
- If not deployed, trigger a manual redeploy

## Verification
1. `npm run build` — zero type/build errors
2. Run existing frontend tests
3. Manual smoke test on deployed site: Settings → Account (avatar, subscription), Style (icons), Advanced (API keys)
4. Verify tab switching works even when API calls fail
