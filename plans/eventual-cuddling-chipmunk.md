# Login Page — Implementation Plan

## Context

The marketing site is live. We need a login page at `(marketing)/login` that matches the editorial aesthetic and navigates users to the app (`/dashboard`). No real auth backend — just a styled form that redirects. Also add a "Log In" link to the marketing nav bar.

---

## Step 1: Add "Log In" link to marketing nav

**File:** `frontend/src/app/(marketing)/layout.tsx`

- Add a `Link` (from `next/link`) to `/login` in the header, positioned before the "Join Waitlist" button
- Style: subtle text link in `--text-secondary`, hover to `--text-primary`

---

## Step 2: Create login page

**File:** `frontend/src/app/(marketing)/login/page.tsx`

- Marketing-style editorial page matching the landing aesthetic
- Serif headline: "Welcome back." (large, centered)
- Subtext: "Log in to your wardrobe." (secondary text)
- Form with email + password fields (dark-styled like the waitlist input)
- "Log In" submit button in `--accent-primary`
- On submit: `router.push("/dashboard")` (no real auth — just navigates)
- Stagger animation on load reusing `heroStagger` / `heroChild` from `@/lib/animations`
- Grain overlay inherited from marketing layout
- Link back: "Don't have an account? Join the waitlist" pointing to `/#waitlist`

---

## Verification

1. Nav bar shows "Log In" link + "Join Waitlist" button
2. `/login` renders with serif headline, email/password form, grain texture
3. Submitting form navigates to `/dashboard`
4. `npm run build` — no errors
