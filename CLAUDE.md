# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Claude Code plugin that biases Svelte/SvelteKit development toward **shadcn-svelte** components, Svelte 5 runes, Bun, Tailwind v4, and TypeScript strict. Distributed via the Claude Code plugin system (`plugin.json` manifest with `commands/`, `agents/`, `skills/`, `hooks/`).

Repo is greenfield — scaffolding lives under this directory once built.

## Source of truth

- **shadcn-svelte llms.txt** — `https://www.shadcn-svelte.com/llms.txt` (machine-readable component index). Re-fetch when component list or CLI flags change.
- **shadcn-svelte docs** — `https://www.shadcn-svelte.com/docs` (theming, registry, migration).
- **Svelte plugin** — companion plugin (`svelte`). Provides:
  - `svelte:svelte-file-editor` agent (`permissionMode: acceptEdits`) — MUST handle every `.svelte` / `.svelte.ts` / `.svelte.js` write. Loads bestpractices + autofixer.
  - `svelte:svelte-core-bestpractices` skill — `$state`/`$derived`/`$effect`/snippets/each/styling reference.
  - `svelte:svelte-code-writer` skill — CLI fallback (`npx @sveltejs/mcp@latest`).
  - MCP tools: `mcp__plugin_svelte_svelte__{list-sections,get-documentation,svelte-autofixer,playground-link}`.
  This plugin's agent + commands delegate actual `.svelte` writes to `svelte:svelte-file-editor`.

## Plugin conventions (build target)

- **Manifest**: `plugin.json` at repo root. Components auto-discovered from `commands/`, `agents/`, `skills/`, `hooks/`. Paths inside the plugin → `${CLAUDE_PLUGIN_ROOT}`.
- **Skills** — progressive disclosure. Trigger phrases in `description:` frontmatter must mention real user phrasing ("add a button", "scaffold a form", "shadcn component").
- **Agents** — declare `model:` (haiku for lookup, sonnet for code edits, opus only for load-bearing judgement). Frontmatter `description:` carries the auto-trigger conditions.
- **Commands** — slash commands in `commands/*.md` with YAML frontmatter.
- **Hooks** — JSON in `hooks/hooks.json`, scripts under `hooks/scripts/` referenced via `${CLAUDE_PLUGIN_ROOT}`.

Plugin-dev plugin is enabled in this session — use its skills (`plugin-structure`, `skill-development`, `agent-development`, `command-development`, `hook-development`, `mcp-integration`) before hand-writing manifests.

## Core behavioural rules this plugin must encode

- **shadcn-svelte first**. Any UI primitive that exists in the shadcn-svelte registry must be installed via the CLI rather than hand-rolled. Preferred install path (sidesteps a `bunx` cache bug on Windows + Bun):
  ```bash
  bun add -D shadcn-svelte
  bun x shadcn-svelte add <component> --yes
  ```
  Init in a fresh SvelteKit repo (the preset prompt is interactive in v1.2+ — Claude answers it in-session):
  ```bash
  bun x shadcn-svelte init --base-color neutral --css <css-path>
  ```
  Valid base colours: `neutral`, `stone`, `zinc`, `mauve`, `olive`, `mist`, `taupe` (legacy `slate` / `gray` removed in v1.2).
- **Svelte 5 runes only** (`$state`, `$derived`, `$effect`, `$props`, `$bindable`). No Svelte 4 syntax (`export let`, `$:`, stores-as-default).
- **Bun** for install/run/test. Never npm/yarn/pnpm.
- **Tailwind v4** with CSS variables for theming. `components.json` declares `tailwind.css` path + base colour.
- **TypeScript strict**. `.svelte.ts` for runed modules.
- **British English** in code/comments/docs.
- Co-locate components with route data; server-only code under `$lib/server/`.

## Component selection heuristic (encode in skill)

1. User asks for UI → check shadcn-svelte registry first.
2. If primitive exists → `bunx shadcn-svelte@latest add <name>`, then compose.
3. If only a variation exists → install the closest primitive and extend in `$lib/components/`.
4. Hand-roll only when no registry match (chart variants, business-specific).
5. Data tables → use shadcn-svelte `data-table` (TanStack Table wrapper) over custom grids.
6. Forms → `Formsnap` integration (already in registry) + `sveltekit-superforms`.

## Commands

- `/svelte-shadcn:init` — `shadcn-svelte init` with sensible defaults + post-install deps check.
- `/svelte-shadcn:add <component>...` — wraps `add`, validates unknown names against `llms.txt`, runs autofixer.
- `/svelte-shadcn:block <name>` — installs composed blocks (dashboard, sidebar, login, signup, otp, calendar variants).
- `/svelte-shadcn:remove <component>...` — usage check + delete.
- `/svelte-shadcn:update <component>... | --all` — re-add with `--overwrite` to sync upstream, surface diffs.
- `/svelte-shadcn:theme <preset|custom>` — applies one of slate / gray / zinc / neutral / stone, or custom HSL via picker.
- `/svelte-shadcn:page <route> [primitives...]` — scaffolds a SvelteKit route. Delegates `+page.svelte` write to `svelte:svelte-file-editor`.
- `/svelte-shadcn:form <route> <schema>` — Formsnap + sveltekit-superforms + Zod scaffold.
- `/svelte-shadcn:data-table <model> <route>` — TanStack Table columns + wrapper + route wiring.
- `/svelte-shadcn:audit` — scans for Svelte 4 syntax, raw `bits-ui` imports, hand-rolled primitives, missing deps, wrong Tailwind version, non-Bun lockfiles. Read-only.

## Agent

`svelte-shadcn-builder` (sonnet) — invoked for any new Svelte feature touching UI. Behaviour:
1. Read the target route/component.
2. List required shadcn-svelte components via the registry.
3. Install missing ones with `bunx shadcn-svelte@latest add`.
4. Plan composition (imports, layout, behaviour).
5. **Delegate the actual `.svelte` write to `svelte:svelte-file-editor`** with a precise brief — that agent runs `svelte-autofixer` + bestpractices loop.
6. Report files written + any unresolved autofixer findings.

## Hooks

- `SessionStart` — emits a reminder that this plugin's skills + agent should be used when the project has `components.json`, `svelte.config.{js,ts}`, or a `svelte` dep in `package.json`. Implemented at `hooks/scripts/session-start.sh`.

## Build / verify

There are no build steps for a Claude Code plugin — manifests + markdown only. Validation:

```bash
# After scaffolding, validate with the plugin-dev validator agent or:
/plugin validate            # if invoked in a host repo with the plugin enabled
```

In a consuming SvelteKit project:

```bash
bun install
bun run dev                 # SvelteKit dev server
bun run check               # svelte-check (TS)
bunx shadcn-svelte@latest add <component>
```

## Out of scope

- Generic Svelte 4 support. New code is Svelte 5 only.
- Non-Tailwind styling adapters.
- npm/yarn lockfiles.
