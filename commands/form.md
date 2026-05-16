---
description: Scaffold a Formsnap + sveltekit-superforms form against a Zod schema
argument-hint: <route-path> <schema-name>
---

Scaffold a form using Formsnap + sveltekit-superforms + Zod.

## Arguments

`$ARGUMENTS` — `<route-path> <schema-name>` (e.g. `admin/users/new user`).

- `route-path` — path under `src/routes/`. No spaces.
- `schema-name` — camelCase identifier. The PascalCase form (first letter uppercased) is used for the type alias.

## Placeholders used below

- `SCHEMA` — replace with the `schema-name` argument (camelCase, e.g. `user`).
- `SCHEMA_PASCAL` — PascalCase of the same (e.g. `User`).
- `ROUTE` — replace with the `route-path` argument.

## Steps

1. Verify `components.json` exists. If not, run `/svelte-shadcn:init` and stop.
2. Install required primitives:
   ```bash
   bunx shadcn-svelte@latest add button form input label
   ```
3. Install runtime deps if missing:
   ```bash
   bun add sveltekit-superforms zod
   ```
4. Write the schema to `src/lib/schemas/SCHEMA.ts` — substitute `SCHEMA` / `SCHEMA_PASCAL`:
   ```ts
   import { z } from 'zod';

   export const SCHEMA = z.object({
     // stub fields — fill in real shape
     name: z.string().min(1),
     email: z.string().email(),
   });

   export type SCHEMA_PASCAL = z.infer<typeof SCHEMA>;
   ```
5. Write `src/routes/ROUTE/+page.server.ts` with:
   - `load` returning `{ form: await superValidate(zod(SCHEMA)) }`
   - `actions.default` calling `superValidate`, validating, returning `fail(400, { form })` on error or a success payload.
6. Dispatch the **`svelte:svelte-file-editor` agent** to write `+page.svelte`. Brief:
   - Path: `src/routes/ROUTE/+page.svelte`
   - Imports: `superForm` from `sveltekit-superforms`, `zodClient` adapter, `SCHEMA` from `$lib/schemas/SCHEMA`, Formsnap `Form.*` blocks, shadcn-svelte `Input` / `Label` / `Button`
   - Layout: `<Form.Field>` block per schema key, submit button, error display
   - Rules: runes-only, Tailwind v4, British English
   Agent auto-validates with `svelte-autofixer`.
7. Report files + svelte-file-editor findings + remind user to fill in real schema fields + action body.
