---
name: shadcn-svelte-usage
description: Use shadcn-svelte components for any Svelte/SvelteKit UI work. Triggers on requests to "add a button/dialog/form/table/sidebar", "scaffold a page", "build a UI", "shadcn", "shadcn-svelte", "components.json", any UI primitive name (button, input, dialog, sheet, card, table, form, combobox, calendar, date picker, dropdown, popover, tooltip, alert, badge, toast, sonner, drawer, accordion, tabs, breadcrumb, navigation menu, sidebar, command palette, hover card, context menu, menubar, slider, switch, checkbox, radio, select, textarea, label, separator, skeleton, progress, avatar, aspect ratio, carousel, chart, data table, pagination, resizable, scroll area, toggle), or when the project contains components.json or svelte.config.js.
---

# shadcn-svelte-usage

Bias every Svelte/SvelteKit UI task toward the shadcn-svelte registry. Hand-roll only as last resort.

## Heuristic

1. **Check registry first** — `https://www.shadcn-svelte.com/llms.txt` enumerates every component. If a primitive matches the user's request, install it.
2. **Install via CLI**:
   ```bash
   bunx shadcn-svelte@latest add <component>
   ```
3. **Compose** — primitives drop into `$lib/components/ui/<component>/`. Re-export aggregated index from `$lib/components/ui/<component>/index.ts` (CLI does this).
4. **Extend, don't fork** — wrap shadcn-svelte components in `$lib/components/<feature>/` with project-specific props rather than editing the generated files.
5. **Hand-roll only** when no registry match (bespoke charts beyond shadcn-svelte chart, business-specific composites).

## Init in fresh SvelteKit project

```bash
bun create svelte@latest my-app   # or: bunx sv create my-app
cd my-app
bun install
bunx shadcn-svelte@latest init
```

Init flow asks for:
- Base colour (default: `slate`)
- CSS path (default: `src/app.css`)
- Tailwind config — v4 uses CSS-first config, no `tailwind.config.js` required.
- Component path (default: `$lib/components/ui`)
- Utility path (default: `$lib/utils`)

Result: writes `components.json`, seeds Tailwind v4 CSS variables, installs `clsx`, `tailwind-merge`, `tailwind-variants`, `bits-ui`.

## Component inventory (categories)

- **Form & input**: button, button-group, calendar, checkbox, combobox, date-picker, field, input, input-group, input-otp, label, native-select, radio-group, select, slider, switch, textarea, formsnap
- **Layout & nav**: accordion, breadcrumb, navigation-menu, resizable, scroll-area, separator, sidebar, tabs
- **Overlays**: alert-dialog, command, context-menu, dialog, drawer, dropdown-menu, hover-card, menubar, popover, sheet, tooltip
- **Feedback**: alert, badge, empty, progress, skeleton, sonner, spinner
- **Display**: aspect-ratio, avatar, card, carousel, chart, data-table, item, kbd, table, typography
- **Misc**: collapsible, pagination, range-calendar, toggle, toggle-group

Re-fetch `llms.txt` if a user asks for something not in this list — registry evolves.

## Stack rules (non-negotiable)

- **Svelte 5 runes only**: `$state`, `$derived`, `$effect`, `$props`, `$bindable`. No `export let`, no `$:`, no implicit stores.
- **Bun** runtime: `bun install`, `bun run dev`, `bun run build`, `bun run check`, `bunx shadcn-svelte@latest …`. Never npm/yarn/pnpm.
- **Tailwind v4** with CSS variables. Theme via `--background`, `--foreground`, `--primary`, etc. in `src/app.css`.
- **TypeScript strict**. `.svelte.ts` for runed modules outside `.svelte` files.
- **British English** in copy/comments (colour, behaviour, organisation).
- Co-locate data with route: `+page.server.ts` for loaders + actions, `$lib/server/` for server-only logic.

## Forms

Use Formsnap + sveltekit-superforms:

```bash
bunx shadcn-svelte@latest add formsnap
bun add sveltekit-superforms zod
```

`+page.server.ts` defines the schema + action, `+page.svelte` consumes via `superForm`.

## Data tables

Use shadcn-svelte `data-table` (wraps TanStack Table) for any list with sort/filter/pagination. Hand-rolled `<table>` only for static display.

## Theming

CSS variables in `src/app.css`:

```css
@import "tailwindcss";

@theme {
  --color-background: hsl(0 0% 100%);
  --color-foreground: hsl(222.2 84% 4.9%);
  --color-primary: hsl(222.2 47.4% 11.2%);
  /* ...etc */
}

@layer base {
  .dark {
    --color-background: hsl(222.2 84% 4.9%);
    --color-foreground: hsl(210 40% 98%);
  }
}
```

Toggle dark mode via `mode-watcher` package (registry-recommended) or manual `class="dark"` on `<html>`.

## Companion plugin — `svelte`

The `svelte` plugin is the canonical authority on Svelte 5 syntax + autofixing. Use it together with this one:

- **`svelte:svelte-file-editor` agent** — `permissionMode: acceptEdits`, MUST be invoked for any `.svelte` / `.svelte.ts` / `.svelte.js` write. Loads `svelte-core-bestpractices`, calls `svelte-autofixer`, retries until clean. Brief it with: target path, imports (from `$lib/components/ui/...`), layout, project rules (runes, Tailwind v4 utilities + theme vars, British English).
- **`svelte-core-bestpractices` skill** — reference for `$state` vs `$state.raw`, `$derived` vs `$effect`, snippets vs slots, keyed each blocks, CSS custom property styling. Load when explaining or deciding patterns.
- **`svelte-code-writer` skill** — CLI fallback (`npx @sveltejs/mcp@latest …`) when MCP tools aren't available.
- **Svelte MCP tools** (`mcp__plugin_svelte_svelte__*`): `list-sections`, `get-documentation`, `playground-link`, `svelte-autofixer`. Direct calls fine for lookups; for writes go via `svelte:svelte-file-editor`.

**Division of labour:**
- This plugin: registry lookup, `bunx shadcn-svelte@latest add`, route layout, form/data-table scaffolding, project rules.
- `svelte` plugin: actual `.svelte` file authoring + Svelte 5 idiom enforcement + autofixer loop.

## Validate after edits

- `svelte:svelte-file-editor` runs `svelte-autofixer` per file — trust its report.
- `bun run check` — project-wide `svelte-check`.

## Anti-patterns

- Editing files under `$lib/components/ui/*` directly (use wrappers instead — re-running `add` will overwrite).
- Importing from `bits-ui` directly when the shadcn-svelte wrapper exists.
- Inline `style=` for theme values (use Tailwind utilities + CSS vars).
- Custom `Button` component when `Button` from shadcn-svelte already covers the variant.
