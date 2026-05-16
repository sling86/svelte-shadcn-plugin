---
description: Scaffold a shadcn-svelte data-table (TanStack Table) for a given model — columns, table component, route wiring
argument-hint: <model-name> <route-path>
---

Scaffold a shadcn-svelte `data-table` for a model.

## Arguments

`$ARGUMENTS` — `<model-name> <route-path>` (e.g. `user admin/users`, `invoice finance/invoices`).

- `model-name` — singular camelCase identifier. PascalCase used for type names.
- `route-path` — folder under `src/routes/` (no spaces).

## Placeholders

- `MODEL` — camelCase argument (e.g. `user`)
- `MODEL_PASCAL` — PascalCase (e.g. `User`)
- `MODELS` — plural camelCase (e.g. `users`) — derive by appending `s` unless user overrides
- `ROUTE` — route-path argument

> **Substitution rule** — replace every `MODEL`, `MODEL_PASCAL`, `MODELS`, `ROUTE` token (and the `(MODELS)` / `(ROUTE)` path placeholders) with the resolved values **before** writing any file. Never emit the literal tokens — TypeScript will fail to compile.

## Steps

1. Verify `components.json` exists. If missing → instruct `/svelte-shadcn:init` and stop.
2. Install primitives:
   ```bash
   bunx shadcn-svelte@latest add data-table button input dropdown-menu checkbox
   ```
3. Install TanStack Table if missing:
   ```bash
   bun add @tanstack/table-core
   ```
4. Write `src/lib/components/(MODELS)/columns.svelte.ts` (substitute `(MODELS)`) — column definitions:
   ```ts
   import type { ColumnDef } from '@tanstack/table-core';

   export type MODEL_PASCAL = {
     id: string;
     // fill real fields
   };

   export const columns: ColumnDef<MODEL_PASCAL>[] = [
     // stub — add real columns
     { accessorKey: 'id', header: 'ID' },
   ];
   ```
   Delegate write to `svelte:svelte-file-editor` (it handles `.svelte.ts` correctly).
5. Write `src/lib/components/(MODELS)/data-table.svelte` (substitute `(MODELS)`) — generic wrapper around shadcn-svelte `<DataTable>` primitive. Delegate to `svelte:svelte-file-editor`. Brief:
   - Imports: `Table.*` primitives, `getCoreRowModel`, `getSortedRowModel`, `getFilteredRowModel`, `getPaginationRowModel` from TanStack
   - Props: `data: MODEL_PASCAL[]`, `columns: ColumnDef<MODEL_PASCAL>[]` via `$props`
   - State: `let sorting = $state([])`, filter state, pagination state
   - Render: header → filter input → table → pagination
   - Rules: runes-only, Tailwind v4, British English
6. Write `src/routes/(ROUTE)/+page.server.ts` (substitute `(ROUTE)`) directly:
   ```ts
   import type { PageServerLoad } from './$types';

   export const load: PageServerLoad = async () => {
     // TODO: real loader
     return { items: [] as MODEL_PASCAL[] };
   };
   ```
7. Dispatch `svelte:svelte-file-editor` for `src/routes/(ROUTE)/+page.svelte` (substitute `(ROUTE)`). Brief:
   - Path + imports (`DataTable` from `$lib/components/<MODELS>/data-table.svelte`, `columns` from columns module, `PageData`)
   - Renders `<DataTable {data} {columns} />` after destructuring `data.items`
8. Report files written + reminder to fill columns + loader.
