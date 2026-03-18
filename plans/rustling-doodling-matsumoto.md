# TL-Incendent: Phase 1 — "The Memory" Implementation Plan

## Context

Building the foundational incident management system for TrustLayer's Risk Learning Agent. This is Phase 1 of 3 — capturing, structuring, and linking incident data to vendors, projects, and insurance policies. The app is a fresh Next.js 16 scaffold at `/Users/jasonmacbookair/Code/TL-Incendent`.

**Stack:** Next.js 16 + TypeScript + Tailwind v4 + PostgreSQL + Prisma + NextAuth.js + shadcn/ui

---

## Milestone 0: Foundation & Tooling

1. **Install & start PostgreSQL via Homebrew**
   ```
   brew install postgresql@17
   brew services start postgresql@17
   createdb tl_incident
   ```

2. **Install dependencies**
   ```
   npm install @prisma/client next-auth@beta @auth/prisma-adapter react-hook-form @hookform/resolvers zod lucide-react date-fns
   npm install -D prisma tsx
   ```

3. **Initialize shadcn/ui** — `npx shadcn@latest init` (New York style, Slate base)
   - Add components: button, input, label, select, textarea, card, badge, table, dialog, dropdown-menu, command, popover, calendar, form, tabs, separator, avatar, sheet, skeleton, toast

4. **Initialize Prisma** — `npx prisma init`

5. **Configure `next.config.ts`** — set `serverActions.bodySizeLimit: "10mb"` for photo uploads

6. **Create `.env`** — DATABASE_URL (`postgresql://localhost:5432/tl_incident`), AUTH_SECRET, AUTH_URL

---

## Milestone 1: Database Schema & Prisma

**File:** `prisma/schema.prisma`

**14 models:**
- `User`, `Account`, `Session`, `VerificationToken` (Auth.js)
- `Incident` — title, dateTime, location, type, severity, description
- `Vendor` — name, contact info, status, specialty (seeded)
- `Project` — name, location, status, dates (seeded)
- `Policy` — policyNumber, type, carrier, dates, limits, linked to Vendor (seeded)
- `IncidentVendor` — join table with `role` (Primary/Contributing/Affected/Witness)
- `IncidentPolicy` — join table with `coverageStatus`
- `RootCause` — category, specificCause, notes, isPrimary
- `CorrectiveAction` — description, type, status, dueDate, assignedTo, verification
- `Attachment` — fileName, filePath, mimeType, fileSize

**Enums:** IncidentType (6), Severity (5), VendorRole (4), CoverageStatus (4), PolicyType (8), RootCauseCategory (7), CorrectiveActionType (7), CorrectiveActionStatus (5), VendorStatus (4), ProjectStatus (4)

**Supporting files:**
- `src/lib/prisma.ts` — singleton client
- `src/lib/constants.ts` — enum labels & color mappings
- `src/types/index.ts` — derived Prisma types with includes

Run: `npx prisma migrate dev --name init && npx prisma generate`

---

## Milestone 2: Authentication

- `src/auth.ts` — Auth.js v5 config with Credentials provider + Prisma adapter (JWT sessions)
- `src/app/api/auth/[...nextauth]/route.ts` — route handler
- `src/app/(auth)/layout.tsx` — minimal centered layout
- `src/app/(auth)/login/page.tsx` — email/password login form
- `src/app/layout.tsx` — wrap with SessionProvider

---

## Milestone 3: App Shell & Layout

- `src/app/(dashboard)/layout.tsx` — auth-gated layout with sidebar + header
- `src/components/layout/sidebar.tsx` — nav links: Dashboard, Incidents, Vendors, Projects (lucide icons, active state)
- `src/components/layout/header.tsx` — app title + user menu + sign-out
- `src/components/layout/mobile-nav.tsx` — Sheet-based mobile nav
- `src/components/shared/page-header.tsx` — reusable page title + action buttons
- `src/components/shared/data-table.tsx` — reusable sortable table wrapper
- `src/components/shared/empty-state.tsx` — empty list placeholder

---

## Milestone 4: Seed Data & Read-Only Views

**File:** `prisma/seed.ts`
- 3 users (Sarah Chen, Marcus Johnson, Emily Rodriguez)
- 10 vendors (construction companies with realistic names/specialties)
- 6 projects (building sites across US cities)
- ~20 policies (2-3 per vendor, mix of GL/Auto/WC, some expired)
- 3-5 sample incidents with root causes and corrective actions

**Vendor pages:**
- `src/lib/queries/vendors.ts` — getVendors, getVendorById
- `src/app/(dashboard)/vendors/page.tsx` — list view
- `src/app/(dashboard)/vendors/[id]/page.tsx` — detail + incident history + policies

**Project pages:**
- `src/lib/queries/projects.ts` — getProjects, getProjectById
- `src/app/(dashboard)/projects/page.tsx` — list view
- `src/app/(dashboard)/projects/[id]/page.tsx` — detail + incident summary

---

## Milestone 5: Incident CRUD (Core Feature)

### Validation (Zod schemas in `src/lib/validations/`)
- `incident.ts` — per-step schemas + combined schema
- `corrective-action.ts`, `root-cause.ts`

### Server Actions (`src/lib/actions/`)
- `incident-actions.ts` — createIncident (with auto policy linkage), updateIncident, deleteIncident
- `corrective-action-actions.ts` — add, update status, verify
- `root-cause-actions.ts` — add, remove
- `attachment-actions.ts` — upload (to `public/uploads/`), delete

### Queries (`src/lib/queries/`)
- `incidents.ts` — getIncidents (filtered, paginated), getIncidentById (full relations)
- `policies.ts` — getPoliciesForVendors

### Incident Intake Form (Hero Feature)
- `src/components/incidents/incident-form.tsx` — multi-step wizard (react-hook-form)
  - Step 1: `basic-info-step.tsx` — title, dateTime, location, type, severity, description
  - Step 2: `parties-step.tsx` — project picker, vendor picker (multi) with role assignment
  - Step 3: `root-cause-step.tsx` — category + specific cause (multiple, primary flag)
  - Step 4: `corrective-step.tsx` — actions with type, due date, assignee (optional step)

### Pickers
- `src/components/shared/vendor-picker.tsx` — searchable combobox (Command + Popover)
- `src/components/shared/project-picker.tsx` — searchable combobox

### Pages
- `src/app/(dashboard)/incidents/page.tsx` — filterable, sortable list
- `src/app/(dashboard)/incidents/new/page.tsx` — intake form
- `src/app/(dashboard)/incidents/[id]/page.tsx` — detail view with all linked data
- `src/app/(dashboard)/incidents/[id]/edit/page.tsx` — edit form (reuses IncidentForm)

### Detail View Sub-Components
- `incident-detail.tsx` — layout with all sections
- `incident-policies-panel.tsx` — auto-linked COIs with coverage status
- `corrective-action-list.tsx` — action list with status management
- `corrective-action-form.tsx` — dialog form for adding actions
- `root-cause-display.tsx` — root cause cards
- `attachment-upload.tsx` — file drop zone
- `attachment-gallery.tsx` — thumbnails + download
- `severity-badge.tsx` — color-coded severity indicator

### Auto-Linkage Logic
When vendors are linked to an incident, `createIncident` automatically finds their active policies at the incident date and creates `IncidentPolicy` records with `PENDING_VERIFICATION` status.

---

## Milestone 6: Dashboard

- `src/lib/queries/dashboard.ts` — stats aggregations, recent incidents, overdue actions
- `src/app/(dashboard)/page.tsx` — dashboard page
- `src/components/dashboard/stats-cards.tsx` — 4 stat cards (total incidents, last 30 days, open actions, overdue)
- `src/components/dashboard/recent-incidents.tsx` — 5 most recent incidents
- `src/components/dashboard/overdue-actions.tsx` — overdue corrective actions list

---

## Milestone 7: Polish

- `loading.tsx` files for skeleton loading states
- `error.tsx` and `not-found.tsx` error boundaries
- Toast notifications on mutations
- Page metadata/titles
- Responsive design verification

---

## Architecture Patterns

- **Server Components by default** — Client Components only for forms, filters, dropdowns
- **Server Actions for mutations** — no API routes layer; Zod validation on both sides
- **Data Access Layer** — all queries in `src/lib/queries/`, all mutations in `src/lib/actions/`
- **URL-driven filters** — list view filters use search params, not React state
- **Auth at every boundary** — session check in layout + every Server Action

---

## Verification

1. `npm run dev` — app starts without errors
2. Navigate to `/login` — sign in with seeded user (sarah@trustlayer.com)
3. Dashboard shows stats, recent incidents, overdue actions
4. `/vendors` and `/projects` show seeded data with detail pages
5. `/incidents/new` — complete multi-step form in under 2 minutes
6. After creating incident with vendors, verify policies auto-linked on detail page
7. Add corrective actions, update statuses, verify overdue detection
8. Upload an attachment, verify it appears in gallery
9. Filter/sort incident list by type, severity, date range
10. Test on mobile viewport — sidebar collapses, form is usable
