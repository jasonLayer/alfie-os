# Storybook Cleanup & New Stories

## Context

The Storybook was initialized with default template files (Button, Header, Page, Configure.mdx, assets/) that are unrelated to our app. Meanwhile, several new UI components were built during the Spotify-inspired redesign but never got stories. The existing component stories are fine and just need to be kept as-is.

## Part 1: Delete Unused Template Files

Delete the entire `frontend/src/stories/` directory **except** `mockData.ts` (imported by 4 component stories).

Files to delete:
- `src/stories/Button.tsx`, `Button.stories.ts`, `button.css`
- `src/stories/Header.tsx`, `Header.stories.ts`, `header.css`
- `src/stories/Page.tsx`, `Page.stories.ts`, `page.css`
- `src/stories/Configure.mdx`
- `src/stories/assets/` (all 13 image/svg files)

**Keep:** `src/stories/mockData.ts` (used by WardrobeTable, ItemCard, OutfitSuggestion, ReviewItemRow stories)

Also remove `@storybook/addon-onboarding` from `.storybook/main.ts` addons (it powers the template onboarding flow we no longer need).

## Part 2: Add Stories for New UI Components

Create stories for 5 components that currently lack them:

### 1. `src/components/ui/Button.stories.ts`
- Title: `UI/Button`
- Stories: Primary, Secondary, Ghost, Pill, Disabled

### 2. `src/components/ui/FilterChip.stories.ts`
- Title: `UI/FilterChip`
- Stories: Active, Inactive

### 3. `src/components/ui/Skeleton.stories.ts`
- Title: `UI/Skeleton`
- Stories: Default (Skeleton), CardSkeleton, Row of CardSkeletons

### 4. `src/components/ui/ScrollRow.stories.tsx`
- Title: `UI/ScrollRow`
- Stories: WithSeeAll (with seeAllHref + CardSkeleton children), WithoutSeeAll

### 5. `src/components/BottomBar.stories.tsx`
- Title: `Layout/BottomBar`
- Stories: Empty, WithLastViewed, WithBatchProgress, WithBoth

**Not adding stories for:** PageTransition (trivial wrapper), StickyHeader (requires scroll context/DOM element), Nav (complex with routing, better tested as integration).

## Part 3: Update Preview Dark Background

Update `.storybook/preview.tsx` to set the decorator background to `var(--bg-base)` so stories render on the correct dark background instead of transparent.

## Verification

```bash
cd frontend && npx storybook build
```

Build should succeed with no warnings about missing files. Template stories should no longer appear.
