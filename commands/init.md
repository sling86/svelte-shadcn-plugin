---
description: Run shadcn-svelte init in the current SvelteKit project with sensible defaults
---

Initialise shadcn-svelte in the current SvelteKit project.

## Preconditions

- `svelte.config.js` or `vite.config.ts` exists (SvelteKit / Vite project).
- Bun is installed (`bun --version`).

If preconditions fail, stop and tell the user what to run first.

## Defaults to propose

- Base colour: `slate`
- CSS file: `src/app.css`
- Tailwind: v4 (CSS-first, no `tailwind.config.js`)
- Component path: `$lib/components/ui`
- Utility path: `$lib/utils`
- TypeScript: yes

## Steps

1. Confirm the defaults with the user (one AskUserQuestion grouping all four choices). Accept overrides.
2. Run:
   ```bash
   bunx shadcn-svelte@latest init
   ```
   Pipe answers from step 1.
3. Verify `components.json` was created.
4. Verify `src/app.css` was updated with theme variables.
5. **Deps sanity** — read `package.json` and verify the init flow installed:
   - `bits-ui` · `tailwind-merge` · `tailwind-variants` · `clsx`
   - `lucide-svelte` (icon set) — install if missing: `bun add -D lucide-svelte`
   - `mode-watcher` — only if user plans dark-mode toggle; suggest, don't auto-install
   - `tailwindcss` v4 — flag if v3 detected
6. **Bun lockfile** — confirm `bun.lock` present. Flag any `package-lock.json` / `yarn.lock` / `pnpm-lock.yaml` for removal.
7. Report:
   - Path of `components.json`
   - Theme vars added
   - Deps verified / missing
   - Suggest first components to install (`button input label` for a typical app).
   - Suggest `/svelte-shadcn:theme` if user wants a non-default palette.
