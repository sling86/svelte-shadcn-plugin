#!/usr/bin/env bash
# Detect Svelte project + emit reminder for Claude.
# Looks for components.json, svelte.config.js, or package.json with svelte dep.

set -euo pipefail

cwd="${CLAUDE_PROJECT_DIR:-$PWD}"

is_svelte=0
has_shadcn=0

if [[ -f "$cwd/svelte.config.js" || -f "$cwd/svelte.config.ts" ]]; then
  is_svelte=1
fi

if [[ -f "$cwd/components.json" ]]; then
  has_shadcn=1
  is_svelte=1
fi

if [[ -f "$cwd/package.json" ]] && grep -q '"svelte"' "$cwd/package.json" 2>/dev/null; then
  is_svelte=1
fi

if [[ $is_svelte -eq 0 ]]; then
  exit 0
fi

cat <<'EOF'
SessionStart:svelte-shadcn hook — Svelte project detected.

Rules for this session:
- UI primitives → shadcn-svelte (bunx shadcn-svelte@latest add <name>). Do not hand-roll.
- Svelte 5 runes only ($state/$derived/$effect/$props/$bindable). No export let, no $:.
- Bun (bun install, bun run dev, bunx). Never npm/yarn/pnpm.
- Tailwind v4 with CSS variables. No tailwind.config.js unless legacy.
- British English in copy/comments.

Agent routing:
- UI work → svelte-shadcn-builder agent (plans + installs primitives).
- Actual .svelte / .svelte.ts / .svelte.js writes → svelte:svelte-file-editor agent
  (loads svelte-core-bestpractices, runs svelte-autofixer). svelte-shadcn-builder delegates to it.
- Svelte syntax/best-practice lookup → svelte:svelte-core-bestpractices skill or
  mcp__plugin_svelte_svelte__{list-sections,get-documentation}.

Available commands:
  /svelte-shadcn:init        — initialise shadcn-svelte in current project
  /svelte-shadcn:add         — install primitive(s)
  /svelte-shadcn:block       — install a composed block (dashboard-01, sidebar-07, …)
  /svelte-shadcn:remove      — remove a primitive (with usage check)
  /svelte-shadcn:update      — re-install with --overwrite (upstream sync)
  /svelte-shadcn:theme       — apply preset palette or custom theme vars
  /svelte-shadcn:page        — scaffold SvelteKit route
  /svelte-shadcn:form        — scaffold Formsnap + superforms + Zod form
  /svelte-shadcn:data-table  — scaffold TanStack data-table for a model
  /svelte-shadcn:audit       — scan for stack-rule violations
EOF

if [[ $has_shadcn -eq 0 ]]; then
  echo "components.json not found — run /svelte-shadcn:init before adding primitives."
fi
