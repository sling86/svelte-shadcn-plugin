---
description: Install a shadcn-svelte block (composed UI — dashboard, sidebar, login, signup, OTP, calendar) via the CLI
argument-hint: <block-name>
---

Install a shadcn-svelte **block** (full composed UI, not just a primitive).

## Arguments

`$ARGUMENTS` — single block name (e.g. `dashboard-01`, `sidebar-07`, `login-03`).

## Block categories

- `dashboard-NN` — dashboards with sidebar + charts + data tables
- `sidebar-NN` — sidebar layouts with collapse + submenu variants
- `login-NN`, `signup-NN` — auth page templates
- `otp-NN` — one-time-password input
- `calendar-NN` — date selection composites

Full catalogue: <https://www.shadcn-svelte.com/blocks>

## Steps

1. Verify `components.json` exists. If missing → tell user to run `/svelte-shadcn:init` first and stop.
2. Run:
   ```bash
   bunx shadcn-svelte@latest add $ARGUMENTS
   ```
   Blocks share the `add` command with primitives — the CLI fetches them from the same registry.
3. List every file written (blocks usually install many: components, hooks, types, sample data, sub-components).
4. For each `.svelte` / `.svelte.ts` written, run `mcp__plugin_svelte_svelte__svelte-autofixer`. If autofixer reports issues, dispatch `svelte:svelte-file-editor` to resolve them.
5. Report:
   - Block name installed
   - Files written (grouped by directory)
   - Suggested route/path to mount the block
   - Required follow-ups (replace sample data with real loader, wire up actions, swap icons, etc.)
   - Any primitive deps the block pulled in (so user knows what's now available)
