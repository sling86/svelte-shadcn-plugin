---
description: Apply a shadcn-svelte base theme (slate, gray, zinc, neutral, stone) or define a custom palette — writes CSS variables to the project's app.css
argument-hint: <preset> | custom
---

Apply or customise the shadcn-svelte theme. Updates the CSS variables in the project's global stylesheet (path read from `components.json`).

## Arguments

`$ARGUMENTS` — one of:

- `slate` · `gray` · `zinc` · `neutral` · `stone` — built-in presets
- `custom` — interactive picker (AskUserQuestion) for primary, accent, radius

## Steps

1. Verify `components.json` exists. Read `tailwind.css` (or equivalent CSS path) from it.
2. Read the current CSS file. Locate the existing `:root { --background: ... }` + `.dark { ... }` blocks (or `@theme` block in Tailwind v4 CSS-first config).
3. **Preset path** (`slate`/`gray`/`zinc`/`neutral`/`stone`):
   - **Use inlined known-good HSL values from the shadcn-svelte docs first** (preserved in this command's reference table below or in the skill). Do not depend on a remote fetch.
   - *Optionally* WebFetch `https://www.shadcn-svelte.com/docs/theming` to confirm the values are still current. If the fetch fails (404, network error, page restructured), **proceed with inlined values — do not abort**. Log the fetch failure as a warning in the report.
   - Replace `--background`, `--foreground`, `--primary`, `--primary-foreground`, `--secondary`, `--secondary-foreground`, `--accent`, `--accent-foreground`, `--muted`, `--muted-foreground`, `--destructive`, `--destructive-foreground`, `--border`, `--input`, `--ring`, `--chart-1` through `--chart-5`, and the `--sidebar*` set (`--sidebar`, `--sidebar-foreground`, `--sidebar-primary`, `--sidebar-primary-foreground`, `--sidebar-accent`, `--sidebar-accent-foreground`, `--sidebar-border`, `--sidebar-ring`). Update both light and `.dark` blocks.
4. **Custom path**:
   - Use AskUserQuestion to collect:
     - Primary HSL or hex
     - Accent HSL or hex
     - Border radius (`0`, `0.25rem`, `0.5rem`, `0.75rem`, `1rem`)
   - Derive foreground colours via contrast heuristic (white on dark, near-black on light). Surface them for user approval before writing.
5. Write the updated CSS file. Preserve any non-theme blocks (custom utilities, plugins).
6. Run `mcp__plugin_svelte_svelte__svelte-autofixer` if any `.svelte` file references theme tokens (usually not — but check for inline overrides).
7. Report:
   - Preset / custom values applied
   - File path written
   - Reminder to clear any inline `style:` overrides that fight the new theme
   - Note: dark mode toggle (`mode-watcher` package or manual `class="dark"` on `<html>`)

## Notes

- Tailwind v4 uses `@theme { --color-primary: ... }` syntax in CSS-first config — match the project's existing style rather than forcing one.
- Don't touch user-defined CSS variables that aren't in the shadcn-svelte token set.
