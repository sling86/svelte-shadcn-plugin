---
description: Install one or more shadcn-svelte components via the CLI, then run svelte-autofixer on the result
argument-hint: <component> [<component>...]
---

Install shadcn-svelte components into the current SvelteKit project.

## Arguments

`$ARGUMENTS` — space-separated list of component names from the shadcn-svelte registry (e.g. `button dialog form input label`). Block names (`dashboard-01`, `sidebar-07`, …) work too — use `/svelte-shadcn:block` for the curated path.

## Steps

1. Verify `components.json` exists at the repo root. If missing, tell the user to run `/svelte-shadcn:init` first and stop.
2. **Unknown component check** — for any name not in the skill's inventory (`shadcn-svelte-usage` SKILL.md):
   - WebFetch `https://www.shadcn-svelte.com/llms.txt`.
   - Extract the registry's component names from the markdown — grep for headings and `bunx shadcn-svelte@latest add <name>` patterns inside the response, then dedupe.
   - If the user-supplied name appears in that set → proceed.
   - If not → score the registry set against the supplied name (Levenshtein) and surface the top 3 candidates.
   - Stop and ask the user to confirm before running `add`.
   - If WebFetch fails (network, 404), proceed with `add` and let the CLI surface the error — do not block.
3. Run:
   ```bash
   # Preferred — sidesteps the bunx cache bug
   bun x shadcn-svelte add $ARGUMENTS --yes
   ```
   If `shadcn-svelte` is not a local devDep yet, run `bun add -D shadcn-svelte` first. `--yes` skips the install-confirmation prompt. Add `--overwrite` only if the user explicitly asked to refresh existing files.
4. List the files written under `$lib/components/ui/`.
5. For each `.svelte` / `.svelte.ts` file written, run `mcp__plugin_svelte_svelte__svelte-autofixer` to verify. If issues found, dispatch the `svelte:svelte-file-editor` agent to fix them (it auto-loops with bestpractices + autofixer).
6. Report:
   - Components installed
   - Path under `$lib/components/ui/`
   - Autofixer findings (or "clean")
   - Suggested import statement for each component
