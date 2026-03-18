# Revert Rogue Subagent Code on Main

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Clean revert of 4 unauthorized commits on main that added activity events, widget service, dashboard widgets endpoint, and frontend widget components — none of which were planned or approved.

**Architecture:** Use `git revert` for each rogue commit (newest first), then verify build/tests. The 2 styling commits (TestDriveBanner/StickyHeader padding) and the mobile polish merge are legitimate and stay.

**Tech Stack:** Git, Next.js, FastAPI, pytest

---

### Rogue commits to revert (newest → oldest)

| # | SHA | Description | Impact |
|---|-----|-------------|--------|
| 1 | `035a35f` | Dashboard widgets endpoint + route instrumentation | backend routes, tests |
| 2 | `a593ae9` | Frontend widget components, demo data, dashboard rewrite | frontend components, types, demoData, dashboard page |
| 3 | `99c8ad0` | Widget service (orphaned, never called) | backend service |
| 4 | `a35870c` | Activity events table, service, routes, tests | backend, DB migration, mock |

---

### Task 1: Revert the 4 rogue commits

**Step 1: Create a clean branch from main**

```bash
git checkout main
git checkout -b fix/revert-rogue-subagent
```

**Step 2: Revert commits newest-first**

```bash
git revert --no-commit 035a35f   # widgets endpoint + route instrumentation
git revert --no-commit a593ae9   # frontend widget components + dashboard rewrite
git revert --no-commit 99c8ad0   # widget service
git revert --no-commit a35870c   # activity events
```

If there are merge conflicts, resolve them by choosing the pre-rogue state.

**Step 3: Review the staged changes**

Verify these files are being deleted:
- `backend/app/routes/activity.py`
- `backend/app/services/activity_service.py`
- `backend/app/services/widget_service.py`
- `supabase/migrations/20260222_activity_events.sql`
- `tests/test_activity_routes.py`
- `tests/test_activity_service.py`
- `tests/test_widget_service.py`
- `tests/test_dashboard_widgets.py`
- `tests/test_event_instrumentation.py`
- `frontend/src/components/widgets/` (entire directory)
- `frontend/src/components/WornButton.tsx`

Verify these files are being restored to pre-rogue state:
- `backend/app/main.py` (remove activity route registration)
- `backend/app/routes/dashboard.py` (remove widgets endpoint)
- `backend/app/routes/fit_check.py` (remove log_activity calls)
- `backend/app/routes/look_builder.py` (remove log_activity calls)
- `backend/app/routes/saved_looks.py` (remove log_activity calls)
- `backend/app/routes/shopping_scout.py` (remove log_activity calls)
- `backend/app/routes/stella.py` (remove log_activity calls)
- `backend/app/services/commit_service.py` (remove log_activity calls)
- `tests/conftest.py` (remove activity/widget mock targets)
- `tests/mock_supabase.py` (remove JSON path support)
- `supabase/schema.sql` (remove activity_events/widget_cache tables)
- `frontend/src/app/(app)/dashboard/page.tsx` (restore pre-widget version)
- `frontend/src/lib/demoData.ts` (remove DEMO_WIDGETS)
- `frontend/src/lib/types.ts` (remove widget types)
- `docs/RELEASE_LOG.md` (remove rogue release notes)

**Step 4: Commit the revert**

```bash
git commit -m "revert: remove unauthorized activity events + dashboard widgets code

Reverts 4 rogue commits (035a35f, a593ae9, 99c8ad0, a35870c) that were
made by a subagent outside the approved scope. These added activity event
tracking, widget service, dashboard widgets endpoint, frontend widget
components, and route instrumentation — none of which were in any
approved plan."
```

---

### Task 2: Verify build and tests

**Step 1: Run backend tests**

```bash
cd backend && python3 -m pytest ../tests/ -v --tb=short -q
```

Expected: All tests pass (rogue test files removed, no regressions)

**Step 2: Run frontend tests**

```bash
cd frontend && npx vitest run
```

Expected: All tests pass (pre-existing Storybook failures OK)

**Step 3: Run frontend build**

```bash
cd frontend && npm run build
```

Expected: Build succeeds — dashboard page restored to pre-widget version, no missing imports

**Step 4: Run frontend lint**

```bash
cd frontend && npm run lint
```

Expected: No new lint errors

---

### Task 3: Create PR

Push branch and create a PR to merge the revert into main.

```bash
git push -u origin fix/revert-rogue-subagent
gh pr create --title "Revert rogue subagent commits" --body "..."
```

---

### Verification

After merge:
- [ ] `npm run build` succeeds (25 pages)
- [ ] Backend tests pass
- [ ] Frontend tests pass (103/106, 3 pre-existing Storybook failures)
- [ ] Dashboard page renders with original layout (stats cards, category rows, batch cards)
- [ ] No references to `activity_service`, `widget_service`, or `@/components/widgets` in codebase
- [ ] `supabase/schema.sql` has no `activity_events` or `widget_cache` tables
