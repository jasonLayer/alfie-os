# Using Storybook for Quick Interactive Prototypes

## Context

Your project (Wardrobe Copilot) is at Milestone 1 — skeleton pages exist but have stub UIs. Storybook is installed (v10.2.9, `@storybook/nextjs-vite`). The goal is to use Storybook to rapidly prototype and validate UI components **before** wiring them to the backend.

---

## How It Works

Storybook renders your React components in isolation, outside of Next.js routing. Each **story** is one state of a component. You build components bottom-up: atoms (buttons, inputs) → molecules (cards, forms) → pages.

### Your setup at a glance

| What | Where |
|------|-------|
| Config | `frontend/.storybook/main.ts` |
| Story glob | `frontend/src/**/*.stories.@(js\|jsx\|ts\|tsx)` |
| Run | `cd frontend && npm run storybook` → http://localhost:6006 |
| Example stories | `frontend/src/stories/Button.stories.ts` (good reference) |

---

## The Prototyping Workflow

### 1. Build a component

Create the component as a normal React file. Use props for all variable data — **no API calls, no hooks that hit the backend**. This keeps it renderable in Storybook.

```tsx
// src/components/ItemCard.tsx
type Props = {
  imageUrl: string;
  brand: string;
  description: string;
  category: string;
  itemId: string;
};

export function ItemCard({ imageUrl, brand, description, category, itemId }: Props) {
  return (
    <div className="border rounded-lg p-3">
      <img src={imageUrl} alt={description} className="w-full h-48 object-cover rounded" />
      <p className="font-semibold mt-2">{brand}</p>
      <p className="text-sm text-gray-600">{description}</p>
      <span className="text-xs bg-blue-100 text-blue-800 px-2 py-0.5 rounded">{category}</span>
    </div>
  );
}
```

### 2. Write stories (= prototype states)

A story file sits next to the component (or in `src/stories/`). Each named export is one state you want to see and click through.

```ts
// src/components/ItemCard.stories.ts
import type { Meta, StoryObj } from "@storybook/nextjs-vite";
import { ItemCard } from "./ItemCard";

const meta: Meta<typeof ItemCard> = {
  title: "Wardrobe/ItemCard",        // folder/name in sidebar
  component: ItemCard,
  tags: ["autodocs"],                 // auto-generates a docs page
};
export default meta;

type Story = StoryObj<typeof ItemCard>;

export const Default: Story = {
  args: {
    imageUrl: "https://picsum.photos/seed/shirt/400/400",
    brand: "Uniqlo",
    description: "Supima Cotton Crew Neck T-Shirt",
    category: "Tops",
    itemId: "ITEM-0001",
  },
};

export const LongDescription: Story = {
  args: {
    ...Default.args,
    description: "Premium Lambswool V-Neck Sweater with Ribbed Cuffs and Hem in Heather Grey",
  },
};

export const MissingImage: Story = {
  args: {
    ...Default.args,
    imageUrl: "",
  },
};
```

### 3. Use Controls to explore interactively

When you run Storybook and select a story, the **Controls** panel at the bottom lets you live-edit every prop — change the brand name, swap the image URL, try long text. No code changes needed. This is the fastest way to stress-test a design.

### 4. Compose into larger prototypes

Once atoms work, compose them into larger views:

```ts
// src/components/WardrobeGrid.stories.ts
import type { Meta, StoryObj } from "@storybook/nextjs-vite";
import { WardrobeGrid } from "./WardrobeGrid";

const sampleItems = [
  { itemId: "ITEM-0001", brand: "Uniqlo", description: "Cotton Tee", category: "Tops", imageUrl: "..." },
  { itemId: "ITEM-0002", brand: "Levi's", description: "501 Original", category: "Bottoms", imageUrl: "..." },
  // ...more mock data
];

const meta: Meta<typeof WardrobeGrid> = {
  title: "Pages/WardrobeGrid",
  component: WardrobeGrid,
};
export default meta;

export const WithItems: StoryObj<typeof WardrobeGrid> = { args: { items: sampleItems } };
export const Empty: StoryObj<typeof WardrobeGrid> = { args: { items: [] } };
export const Loading: StoryObj<typeof WardrobeGrid> = { args: { items: [], loading: true } };
```

---

## Techniques for Prototyping Specific Features

### Mock data instead of API calls
Create a `src/stories/mockData.ts` file with realistic wardrobe items from your CSV schema. Reuse it across all stories.

### Interactive actions (button clicks, form submissions)
Use Storybook's `action()` to log interactions without real handlers:

```ts
import { action } from "storybook/actions";

export const Default: Story = {
  args: {
    onDelete: action("delete-item"),
    onEdit: action("edit-item"),
  },
};
```

Clicks show up in the **Actions** panel so you can verify the right callbacks fire.

### Decorators for layout context
Wrap stories in your app's layout (sidebar, theme) without needing Next.js routing:

```ts
// .storybook/preview.ts — add a decorator
const preview = {
  decorators: [
    (Story) => (
      <div style={{ padding: "1rem", maxWidth: "1200px" }}>
        <Story />
      </div>
    ),
  ],
};
```

### Interaction tests (validate workflows)
The scaffolded `Page.stories.ts` already shows this pattern — use `play()` to script user interactions:

```ts
export const UploadFlow: Story = {
  play: async ({ canvasElement }) => {
    const canvas = within(canvasElement);
    await userEvent.click(canvas.getByText("Upload Photos"));
    await expect(canvas.getByText("Drop files here")).toBeInTheDocument();
  },
};
```

---

## Suggested Prototype Order for Your Project

Based on your PRD and page stubs, here's a practical order to prototype:

| Priority | Component | Why |
|----------|-----------|-----|
| 1 | `ItemCard` | Core atom — used in wardrobe grid, review, look builder |
| 2 | `PhotoUploadZone` | Import page — drag/drop area, file preview thumbnails |
| 3 | `WardrobeTable` | Wardrobe page — table with sort/filter, the main data view |
| 4 | `ReviewItemRow` | Review & Confirm — editable fields, dedup flag indicator |
| 5 | `FitCheckResult` | Fit Check — score display with metaphor, rating bar |
| 6 | `OutfitSuggestion` | Look Builder — outfit card with multiple items |

Each of these can be prototyped in Storybook with mock data **today**, before any backend exists.

---

## Quick Reference Commands

```bash
cd frontend
npm run storybook          # dev server at :6006
npm run build-storybook    # static build (for sharing/CI)
npx vitest                 # run story-based tests
```
