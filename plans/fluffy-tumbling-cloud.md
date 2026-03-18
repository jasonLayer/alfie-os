# Plan: Rename Guide → Directory + Add Explore Tab

## Context
The main view currently has two arcade buttons: "Guide" (card grid) and "Map". The user wants:
- **Guide → Directory**: All approved places grouped alphabetically by first letter (A, B, C... sections)
- **Explore** (new): Last 9 most recently added places as a card grid
- **Map**: Unchanged

## Files to Modify

### 1. `src/components/ViewToggle.tsx`
- Change type from `"list" | "map"` → `"directory" | "explore" | "map"`
- Rename "Guide" label to "Directory"
- Add third "Explore" arcade button between Directory and Map

### 2. `src/components/ExploreShell.tsx`
- Update `viewTab` state type: `"list" | "map"` → `"directory" | "explore" | "map"`
- Change default from `"list"` to `"directory"`
- Update guards that check `viewTab === "map"` — these stay the same (they gate map-specific behavior)
- No other logic changes needed — just the type and default

### 3. `src/components/PlaceList.tsx`
- Update Props type for `viewTab` and `onViewTabChange`
- **Directory view** (`viewTab === "directory"`):
  - Sort `filtered` alphabetically by `name`
  - Group by first letter
  - Render letter headers (styled as retro section dividers) with card grid under each
- **Explore view** (`viewTab === "explore"`):
  - Sort by `created_at` desc
  - Take first 9
  - Render as flat card grid (same card component, no grouping)
- **Map view**: Unchanged (still renders `<PixelMap>`)

## Implementation Details

### Directory alphabetical grouping
```
const grouped = Map<string, Place[]>  // "A" => [place1, place2], "B" => [place3], ...
```
- Sort filtered places by `name.toUpperCase()`
- Group by first character
- Render: for each letter, show a sticky/bold letter header, then the 2-col/3-col card grid

### Explore recent 9
- Sort `filtered` by `created_at` desc (ISO string comparison works)
- `.slice(0, 9)`
- Same card grid layout, no letter headers

### Card rendering
Both views reuse the exact same card markup (image, name, neighborhood, tags). Extract to avoid duplication if warranted, but inline is fine since it's the same file.

## Verification
- Open the app at localhost
- Click "Directory" button — should show all places grouped A-Z with letter headers
- Click "Explore" button — should show last 9 places added
- Click "Map" button — should show the pixel map (unchanged)
- Search bar should still filter within Directory and Explore views
- Clicking a card should still open the PlaceDetailSheet
