# svelte-shadcn

Claude Code plugin that biases Svelte / SvelteKit development toward [shadcn-svelte](https://www.shadcn-svelte.com), Svelte 5 runes, Bun, Tailwind v4, and TypeScript strict.

## What it does

- **Skill** — teaches Claude when and how to install shadcn-svelte primitives instead of hand-rolling UI.
- **Agent** — `svelte-shadcn-builder` (sonnet) — invoked automatically for Svelte UI work.
- **Commands** — slash commands wrap the `shadcn-svelte` CLI:
  - `/svelte-shadcn:init` — `shadcn-svelte init` with sensible defaults.
  - `/svelte-shadcn:add <component>...` — install primitives + autofix.
  - `/svelte-shadcn:page <route> [primitives...]` — scaffold a SvelteKit route.
  - `/svelte-shadcn:form <route> <schema>` — Formsnap + superforms + Zod scaffold.
- **Hook** — `SessionStart` detects Svelte projects and reminds Claude of the stack rules.

## Install

```
/plugin install svelte-shadcn          # from a marketplace, once published
```

Or local:

```
/plugin                                # add this folder as a local plugin
/reload-plugins
```

## Conventions enforced

| Rule | Why |
|------|-----|
| shadcn-svelte first | Battle-tested accessibility, theming, registry updates. |
| Svelte 5 runes only | Project standard; legacy reactivity diverges from runtime semantics. |
| Bun only | Lockfile parity, faster installs. |
| Tailwind v4 | CSS-first config, theme tokens via variables. |
| TypeScript strict | `.svelte.ts` for runed modules outside components. |
| British English | House style. |

## Stack baseline

- Svelte 5 + SvelteKit 2
- Bun ≥ 1.1
- Tailwind v4
- Bits UI (via shadcn-svelte wrappers)
- Formsnap + sveltekit-superforms + Zod (forms)
- TanStack Table (via shadcn-svelte `data-table`)

## Companion plugin

Enable the **`svelte`** plugin alongside this one. This plugin delegates every `.svelte` / `.svelte.ts` write to the `svelte:svelte-file-editor` agent, which:

- Loads `svelte-core-bestpractices` (runes, snippets, keyed each, styling).
- Runs `svelte-autofixer` (catches Svelte 4 syntax, missing `$derived`, missing keys, etc.).
- Retries until clean.

Without the `svelte` plugin enabled, the agent falls back to the `svelte-code-writer` skill or `npx @sveltejs/mcp@latest`. Strongly recommended to install both.

## Structure

```
.claude-plugin/plugin.json
agents/svelte-shadcn-builder.md
commands/{init,add,page,form}.md
hooks/hooks.json
hooks/scripts/session-start.sh
skills/shadcn-svelte-usage/SKILL.md
```

## Development

This plugin is markdown + JSON only — no build step. Validate after edits:

```
/plugin                                # plugin-dev validator
```

Or run the `plugin-validator` agent from the `plugin-dev` plugin.

## Source of truth

shadcn-svelte registry index: <https://www.shadcn-svelte.com/llms.txt>
