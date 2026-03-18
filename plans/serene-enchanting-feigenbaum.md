# Admin UX Improvements Plan

## Context

The user wants 4 improvements to the admin panel:
1. Use the 3-dot "window chrome" buttons for navigating between admin sections (Places/Memories) instead of plain tab buttons
2. Persist the admin token in a cookie so you don't re-authenticate each visit
3. Add a "View Card" link on each memory in admin, linking to its place
4. Add a "View Card" link on each place in admin, linking to `/place/[id]`

## Changes

### 1. Admin Section Navigation with 3-Dot Buttons

**File:** `src/app/admin/page.tsx` (lines 758-773)

Replace the current Places/Memories tab toggle buttons with a window-chrome style navigation bar. Each section gets its own 3-dot button row in the header area, similar to how the main app uses the pattern.

Approach: Replace the `tabBtn`-based toggle with a styled nav bar using the 3-dot aesthetic. The active section gets a highlighted/filled style, inactive gets the default white circles. Keep it in the existing header bar area.

### 2. Persistent Auth via Cookie

**File:** `src/app/admin/page.tsx` (lines 31-33, 738-755)

- On successful load (when `fetchPlaces` succeeds), save the token to a cookie: `document.cookie = "admin_token=...;max-age=86400;path=/admin;SameSite=Strict"`
- On mount, read the cookie and pre-fill `token` state — auto-trigger `fetchPlaces` if found
- Add a "Logout" button that clears the cookie and resets token state
- Cookie expires after 24 hours (reasonable session length)
- No server-side cookie validation needed — the token is still validated via `x-admin-token` header on every API call

### 3. "View Card" Link on Admin Memories

**File:** `src/components/AdminMemoriesTab.tsx` (lines 158-164)

The memory card already shows `m.place_name` (line 163) and has `m.place_id` available. Add a link icon/button next to the place name that navigates to `/place/${m.place_id}` (opens in new tab).

### 4. "View Card" Link on Admin Places

**File:** `src/app/admin/page.tsx` — in `renderCardView()` and `renderTableView()`

Add a small link button next to each place name that opens `/place/${p.id}` in a new tab. Same pattern as memories.

## Files to Modify

- `src/app/admin/page.tsx` — cookie auth, nav buttons, place links
- `src/components/AdminMemoriesTab.tsx` — memory place links

## Verification

1. `npm run build` — clean compile
2. Visit `/admin` → enter token → verify it persists on page refresh
3. Check Places tab has "View" link per place → opens correct place card
4. Check Memories tab has "View" link per memory → opens correct place card
5. Verify section navigation uses the new 3-dot style
6. Verify "Logout" clears cookie and returns to login prompt
