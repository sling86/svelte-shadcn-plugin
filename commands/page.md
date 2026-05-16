---
description: Scaffold a SvelteKit route with `+page.svelte` + `+page.server.ts` using shadcn-svelte primitives
argument-hint: <route-path> [primitives...]
---

Scaffold a new SvelteKit route.

## Arguments

`$ARGUMENTS` — first token is the route path under `src/routes/` (e.g. `admin/users`). Remaining tokens are shadcn-svelte primitive names to install for the page (e.g. `card button data-table`).

## Steps

1. Parse `$ARGUMENTS`: `<route-path> [<primitive>...]`.
2. Verify `components.json` exists. If not, instruct user to run `/svelte-shadcn:init` and stop.
3. Install any requested primitives:
   ```bash
   bunx shadcn-svelte@latest add <primitives>
   ```
4. Create the route folder under `src/routes/<route-path>/`.
5. Write `+page.server.ts` directly (non-Svelte file) with a `load` function stub returning typed data.
6. Dispatch the **`svelte:svelte-file-editor` agent** to write `+page.svelte`. Brief:
   - Path: `src/routes/<route-path>/+page.svelte`
   - Imports: `PageData` from `./$types`, each installed primitive from `$lib/components/ui/<name>`
   - Skeleton: Svelte 5 runes (`let { data }: { data: PageData } = $props()`), heading, container, primitives in sensible flow
   - Rules: runes-only, Tailwind v4 utilities, British English
   The agent auto-runs `svelte-autofixer` and resolves issues.
7. Report files written + svelte-file-editor's findings + suggested next edits.
