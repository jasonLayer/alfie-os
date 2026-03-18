# Fix Google OAuth Login Redirect

## Context

After authenticating with Google, users land back on the marketing homepage (`/#`) instead of being logged in and redirected to `/dashboard`. This is a P0 bug — Google OAuth is completely broken.

**Screenshot evidence:** URL shows `icon-fashion-beta.vercel.app/#` — the `#` indicates Supabase appended hash-fragment tokens to the root URL, meaning either the redirect URL wasn't honored or tokens were lost during a server-side redirect.

## Root Cause (two issues)

### Issue 1: Login page bypasses AuthContext
`frontend/src/app/(marketing)/login/page.tsx:127-142` has a **local `handleGoogle()`** that calls `supabase.auth.signInWithOAuth()` directly, bypassing the correct `loginWithGoogle()` from AuthContext.

The local function sets `redirectTo: /dashboard` — but the **correct** function in `AuthContext.tsx:63-69` routes through `/auth/callback?next=/dashboard`.

Line 30 destructures `{ login, signup, loginWithApple, session }` — notably **missing `loginWithGoogle`**.

### Issue 2: Callback route is a server-side Route Handler
`frontend/src/app/auth/callback/route.ts` is a Next.js **Route Handler** (`route.ts`), which runs server-side. With Supabase's default implicit OAuth flow:
- Tokens come back as **URL hash fragments** (`#access_token=...`)
- Hash fragments are **never sent to the server**
- The Route Handler gets `code = null`, does nothing, then redirects to `/dashboard`
- The redirect **strips the hash fragment** — tokens are lost
- User arrives at `/dashboard` with no session → AuthGate kicks them to `/login`

Even the "correct" AuthContext flow would fail because the callback route can't handle implicit flow tokens.

## Fix Plan

### Step 1: Convert `/auth/callback` from Route Handler to client-side page
**File:** `frontend/src/app/auth/callback/route.ts` → **delete** and create `frontend/src/app/auth/callback/page.tsx`

The new client-side page:
- Lets the Supabase JS client auto-detect hash tokens (`detectSessionInUrl: true` is the default)
- Waits for session to be established via `onAuthStateChange`
- Reads the `next` query param and redirects via `router.replace(next)`
- Shows a brief loading state ("Signing in...")
- Has a timeout fallback that redirects to `/login` if auth fails after 10s

### Step 2: Fix login page to use AuthContext's `loginWithGoogle()`
**File:** `frontend/src/app/(marketing)/login/page.tsx`

- Line 30: Add `loginWithGoogle` to the `useAuth()` destructure
- Lines 127-142: Replace the local `handleGoogle()` body to call `loginWithGoogle()` instead of raw `supabase.auth.signInWithOAuth()`
- Remove the `import { supabase }` since it won't be needed after this change (verify no other usage first)

### Step 3: Update `loginWithGoogle()` to support query params
**File:** `frontend/src/contexts/AuthContext.tsx`

Update `loginWithGoogle()` to accept an optional `next` parameter so the login page can preserve test-drive and plan query params:

```typescript
async function loginWithGoogle(next: string = "/dashboard") {
  await supabase.auth.signInWithOAuth({
    provider: "google",
    options: {
      redirectTo: `${window.location.origin}/auth/callback?next=${encodeURIComponent(next)}`,
    },
  });
}
```

Also update `loginWithApple()` the same way for consistency, and update the `AuthContextType` type.

The login page's `handleGoogle()` will then call:
```typescript
const dest = searchParams.get("testdrive") === "true"
  ? "/dashboard?testdrive=true"
  : plan && plan !== "free"
    ? `/login?plan=${plan}&billing=${billing}`
    : "/dashboard";
await loginWithGoogle(dest);
```

### Step 4: Verify Supabase redirect URL config (manual)
In the Supabase dashboard → Authentication → URL Configuration:
- Ensure `https://icon-fashion-beta.vercel.app/auth/callback` is in the **Redirect URLs** list
- Also ensure `http://localhost:3000/auth/callback` for local dev

## Files Changed
| File | Action |
|------|--------|
| `frontend/src/app/auth/callback/route.ts` | **Delete** |
| `frontend/src/app/auth/callback/page.tsx` | **Create** (client-side callback page) |
| `frontend/src/app/(marketing)/login/page.tsx` | **Edit** (use AuthContext, remove local OAuth) |
| `frontend/src/contexts/AuthContext.tsx` | **Edit** (add `next` param to OAuth functions) |

## Verification
1. Run `npm run build` in frontend to verify no build errors
2. **Manual test — normal login:** Click "Continue with Google" → complete Google auth → verify landing on `/dashboard` authenticated
3. **Manual test — test drive:** Navigate to `/login?testdrive=true` → Google auth → verify landing on `/dashboard?testdrive=true`
4. **Manual test — plan upsell:** Navigate to `/login?plan=pro&billing=monthly` → Google auth → verify checkout confirmation page
5. Check Supabase dashboard redirect URLs include `/auth/callback`
