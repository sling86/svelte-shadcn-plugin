---
description: Scan the project for violations of the shadcn-svelte + Svelte 5 stack rules — Svelte 4 syntax, raw bits-ui imports, hand-rolled primitives, missing deps
---

Audit the current SvelteKit project for violations of this plugin's rules.

## Steps

1. Verify a Svelte project context. If `svelte.config.{js,ts}` missing → stop.

2. **Scan for Svelte 4 syntax** via Grep over `src/`:
   - `export let ` — should be `$props()`
   - `^\s*\$:` — should be `$derived` / `$effect`
   - `on:\w+=` — should be `on<event>=`
   - `<slot/?>` — should be `{#snippet}` + `{@render}`
   - `<svelte:component\s+this=` — should be `<DynamicComponent>`
   - `<svelte:self` — should be self-import + `<Self>`

3. **Scan for raw `bits-ui` imports** in `src/` (excluding `$lib/components/ui/`):
   ```
   from ['"]bits-ui['"]
   ```
   These should go through the shadcn-svelte wrapper at `$lib/components/ui/<name>`.

4. **Scan for hand-rolled primitives** — components named `Button`, `Dialog`, `Modal`, `Dropdown`, `Tooltip`, `Popover`, `Sheet`, `Drawer`, `Tabs`, `Accordion`, `Toast`, `Alert`, `Card`, `Badge`, `Input`, `Select`, `Checkbox`, `Switch`, `Slider`, `Calendar`, `Combobox`, `Table` outside `$lib/components/ui/`. Flag any — shadcn-svelte likely ships an equivalent.

5. **Scan for direct edits to `$lib/components/ui/*`** — diff against pristine registry version. If files differ in ways beyond CLI-generated tweaks, flag. Wrappers in `$lib/components/<feature>/` are the correct surface.

6. **Deps check** — read `package.json`. Verify presence of:
   - `bits-ui`
   - `tailwind-merge`
   - `tailwind-variants` (or `class-variance-authority` for older registries)
   - `clsx`
   - `lucide-svelte` (icon set commonly used)
   - `mode-watcher` if a dark-mode toggle is needed
   Flag missing ones with install commands.

7. **Tailwind version check** — locate `@import "tailwindcss"` or `tailwindcss` dep. Flag if v3 detected (this plugin targets v4).

8. **Bun lockfile check** — `bun.lock` should exist. `package-lock.json` / `yarn.lock` / `pnpm-lock.yaml` → flag as violation.

9. **`components.json` sanity** — verify it exists, parses, points at real paths (`tailwind.css`, alias targets).

10. **Report** — group findings by severity:
    - **Error** — Svelte 4 syntax, npm/yarn lockfile, missing `components.json`
    - **Warning** — hand-rolled primitives, raw bits-ui imports, missing deps, Tailwind v3
    - **Nit** — edits to `ui/*` files, missing optional deps

    Per finding: file:line, snippet, suggested fix. End with a numbered remediation plan.

## Notes

Read-only scan — do not auto-fix. User confirms each remediation before action.
