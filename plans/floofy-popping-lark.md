# Fix: App not loading on localhost:3000

## Context
The Next.js app fails to load. The root `/` route hits `(dashboard)/page.tsx`, whose layout calls `await auth()` which requires both a working database connection (via Prisma) and a valid `AUTH_SECRET` env var. Any failure in this chain prevents the page from rendering.

## Steps

1. **Check terminal error** — Run `npm run dev` and capture the actual error
2. **Check `.env`** — Verify `AUTH_SECRET` and `DATABASE_URL` are present and correct
3. **Generate `AUTH_SECRET`** if missing — `npx auth secret` or `openssl rand -base64 32`
4. **Test DB connection** — Verify Prisma can connect to PostgreSQL
5. **Run migrations if needed** — `npx prisma migrate dev`
6. **Verify** — Confirm localhost:3000 loads (should redirect to `/login` since no session)

## Key files
- `.env` — environment variables
- `src/auth.ts` — NextAuth config, requires AUTH_SECRET + DB
- `src/lib/prisma.ts` — Prisma client, requires DATABASE_URL
- `src/app/(dashboard)/layout.tsx` — calls `auth()` on every request

## Verification
- `npm run dev` starts without errors
- localhost:3000 loads (redirects to /login page)
