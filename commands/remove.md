---
description: Remove a shadcn-svelte component from the project — checks usages first, then deletes the ui/ directory
argument-hint: <component> [<component>...]
---

Remove one or more shadcn-svelte components from the project.

## Arguments

`$ARGUMENTS` — space-separated component names matching directories under `$lib/components/ui/`.

## Steps

1. Verify `components.json` exists. Resolve the component path alias (default `$lib/components/ui`).
2. For each component:
   a. Check the directory exists at `<ui-path>/<component>/`. If not → report missing and skip.
   b. **Grep usages** across `src/` (excluding the ui directory itself):
      ```
      from .*['"][^'"]*components/ui/<component>['"]
      ```
   c. List every file + line that imports the component.
3. If usages > 0 → **stop and ask** (AskUserQuestion). Options:
   - Show usages and abort
   - Delete anyway (user is removing imports manually)
   - Delete + replace imports with a placeholder comment
4. Once confirmed safe:
   a. Delete `<ui-path>/<component>/`.
   b. If the component had registry deps (e.g. `dialog` brings `portal`), check whether other ui components still need them. Don't remove shared deps without confirmation.
5. Run `bun run check` to surface any remaining type errors from broken imports.
6. Report:
   - Components removed
   - Files deleted
   - Files that still import the removed component (must be cleaned by user / `/svelte-shadcn:audit`)
   - Suggestion to commit before further changes

## Notes

- shadcn-svelte has no native `remove` CLI — this is a project-local operation.
- Wrappers in `$lib/components/<feature>/` that imported the removed primitive will break. The audit step at end surfaces these.
