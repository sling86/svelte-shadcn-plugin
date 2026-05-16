---
description: Install one or more shadcn-svelte components via the CLI, then run svelte-autofixer on the result
argument-hint: <component> [<component>...]
---

Install shadcn-svelte components into the current SvelteKit project.

## Arguments

`$ARGUMENTS` — space-separated list of component names from the shadcn-svelte registry (e.g. `button dialog form input label`).

## Steps

1. Verify `components.json` exists at the repo root. If missing, tell the user to run `/svelte-shadcn:init` first and stop.
2. Run:
   ```bash
   bunx shadcn-svelte@latest add $ARGUMENTS
   ```
3. List the files written under `$lib/components/ui/`.
4. For each `.svelte` / `.svelte.ts` file written, run `mcp__plugin_svelte_svelte__svelte-autofixer` to verify. If issues found, dispatch the `svelte:svelte-file-editor` agent to fix them (it auto-loops with bestpractices + autofixer).
5. Report:
   - Components installed
   - Path under `$lib/components/ui/`
   - Autofixer findings (or "clean")
   - Suggested import statement for each component
