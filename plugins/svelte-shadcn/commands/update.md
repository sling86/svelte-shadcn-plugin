---
description: Update one or more shadcn-svelte components to the latest registry version (re-installs with --overwrite after diffing)
argument-hint: <component> [<component>...] | --all
---

Update shadcn-svelte components against the upstream registry. shadcn-svelte has no native `diff`/`update` — this command re-installs with `--overwrite` after surfacing local edits.

## Arguments

`$ARGUMENTS` — space-separated component names, or `--all` for every component in `$lib/components/ui/`.

## Steps

1. Verify `components.json` + git repo. If repo has uncommitted edits to `$lib/components/ui/*`, **stop and warn** — overwrite will lose them. Suggest `git stash` first.
2. Resolve target list:
   - Explicit names → use as-is.
   - `--all` → list directories under `$lib/components/ui/` and use those names.
3. For each target, run:
   ```bash
   bunx shadcn-svelte@latest add <name> --overwrite --yes
   ```
4. Capture `git diff -- $lib/components/ui/<name>/` per component. Summarise upstream changes.
5. For each touched `.svelte` / `.svelte.ts`, run `mcp__plugin_svelte_svelte__svelte-autofixer`. If issues → dispatch `svelte:svelte-file-editor` to resolve.
6. Report:
   - Components updated
   - Net diff size per component (lines added/removed)
   - Notable changes (new props, removed APIs)
   - Autofixer findings
   - Reminder: re-test any feature wrappers in `$lib/components/<feature>/` that imported these primitives.

## Anti-pattern

Don't run with uncommitted local edits to `ui/*`. Wrappers in `$lib/components/<feature>/` are the correct extension surface — files under `ui/*` are upstream-managed.
