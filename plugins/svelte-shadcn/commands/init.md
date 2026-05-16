---
description: Run shadcn-svelte init in the current SvelteKit project with sensible defaults
---

Initialise shadcn-svelte in the current SvelteKit project.

## Preconditions

- `svelte.config.js` or `vite.config.ts` exists (SvelteKit / Vite project).
- Bun is installed (`bun --version`).

If preconditions fail, stop and tell the user what to run first.

## Defaults to propose

- **Preset** — required by the CLI. No non-interactive flag yet. `vega` is the canonical default; answer the prompt in-session.
- **Base colour** — `neutral` by default. Valid set (v1.2+ CLI): `neutral`, `stone`, `zinc`, `mauve`, `olive`, `mist`, `taupe`. *(Legacy `slate` / `gray` are removed.)*
- **CSS file** — `src/app.css`, or `src/routes/layout.css` if the project was scaffolded via `sv create` with the `tailwindcss` add-on. Detect by grepping for `@import "tailwindcss"`.
- **Tailwind** — v4 (CSS-first, no `tailwind.config.js`).
- **Components alias** — `$lib/components`.
- **UI alias** — `$lib/components/ui`.
- **Lib alias** — `$lib`.
- **Utils alias** — `$lib/utils`.
- **Hooks alias** — `$lib/hooks`.
- **TypeScript** — yes.

## Steps

1. Detect the project's Tailwind CSS file under `src/`. Use that path for `--css`.
2. Confirm defaults with the user (one AskUserQuestion). Accept overrides.
3. **Install shadcn-svelte locally first** — the `bunx shadcn-svelte@latest` invocation fails on Windows + Bun with a `@jridgewell/sourcemap-codec` ESM resolve error. Local install sidesteps it:
   ```bash
   bun add -D shadcn-svelte
   ```
4. Run init. The `--preset` prompt is interactive — answer it in-session:
   ```bash
   bun x shadcn-svelte init \
     --base-color neutral \
     --css <css-path> \
     --components-alias '$lib/components' \
     --ui-alias '$lib/components/ui' \
     --lib-alias '$lib' \
     --utils-alias '$lib/utils' \
     --hooks-alias '$lib/hooks'
   ```
5. Verify `components.json` was created.
6. Verify the chosen CSS file was updated with theme variables (`--background`, `--foreground`, `--primary`, …).
7. **Critical**: verify `src/lib/utils.ts` was created with `cn` + `WithElementRef` / `WithoutChildren*` type helpers. If missing, init failed silently — surface to the user and stop. Without it, every shadcn-svelte component will fail `svelte-check`.
8. **Deps sanity** — read `package.json` and verify the init flow installed:
   - `bits-ui` · `tailwind-merge` · `tailwind-variants` · `clsx`
   - `@lucide/svelte` (icon set)
   - `tw-animate-css`
   - `mode-watcher` — only if user wants a dark-mode toggle; suggest, don't auto-install.
   - `tailwindcss` v4 — flag if v3 detected.
9. **Bun lockfile** — confirm `bun.lock` present. Flag any `package-lock.json` / `yarn.lock` / `pnpm-lock.yaml` for removal.
10. Report:
    - Path of `components.json`
    - Theme vars added
    - Deps verified / missing
    - Suggest first components to install (`button input label` for a typical app).
    - Suggest `/svelte-shadcn:theme` if user wants a non-default base colour.
