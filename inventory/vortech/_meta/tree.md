---
kind: discovery-tree
source_repo: vortech
source_commit: f55e8e0202c3ef2486d845bb87601c7366d76b90
inventoried_at: 2026-04-24T20:00:00Z
inventoried_by: cursor-inventario-fase1
repo: vortech
scanned_at: 2026-04-24T20:00:00Z
agent_id: cursor-inventario-fase1
root_path: repos/vortech
---

# Árbol — `vortech`

## Top-level

| Path | Tipo | Lenguajes / rol |
|------|------|-----------------|
| `ai/` | docs / experimentos | (sin `package.json` en el snapshot) |
| `apis/` | paquetes TS | `apis/http-client` |
| `connections/` | integraciones (calendar, email, google, shared) | TypeScript |
| `devtools/` | CLI, LSP, MCP, dev-server, VS Code ext, ts-server, devtools, SDK | TypeScript |
| `host/` | host de extensión / application host | TypeScript |
| `metaquest/` | Quest app (npm) + PC agent ( .NET) | TS + C# |
| `packages/` | núcleo plataforma (core, common, wire, hosting, …) y apps Angular | TS / Angular |
| `platform/` | layout, theming, v-ui, v-lsp, v-runtime, v-components, `core/`, `sdk/` | TypeScript / Angular |
| `refactoring/` | documentación de refactor | md |
| `rust-workspace/` | crates `v-alloy`, `v-core`, `v-desk` | Rust |
| `scripts/` | utilidades de repo | varios |
| `sokectio/` | árbol socket.io / engine.io (fork o vendor) | TypeScript / JS |
| `system-agent/` | contrato TS, fleet-manager, agents .NET, dashboard Angular, install | TS + C# + Angular |
| `v-mono/` | documentación `v-mono` embebida | md |
| `.vortech/` | documentación interna de producto | md |
| `.github/` | workflows / agentes | yaml / md |
| `pnpm-workspace.yaml` | raíz de workspaces pnpm (globs) | monorepo |
| `Vortech.sln` | solución .NET (system-agent, inspiración, xml-crypto) | C# |
| `angular.json` | apps Angular: `angular-demo`, `monkey`, `fleet-dashboard`, `v-studio` | Angular |

## Manifests detectados (raíz)

- `package.json` — workspace `vortech-workspace` (pnpm), scripts agregan apps Angular
- `pnpm-workspace.yaml` — listado: `platform/*`, `system-agent/*`, `packages/*`, `packages/runtime/*`, `host/*`, `connections/*`, `devtools/*`, `apis/*`, `platform/sdk/demo`
- `angular.json` — proyectos `angular-demo`, `monkey`, `fleet-dashboard`, `v-studio`
- `Vortech.sln` — proyectos .NET bajo `system-agent` y referencias a `.source-insiration/*`
- `tsconfig.json` — configuración base TypeScript

## Directorios excluidos del análisis (por convención)

- `node_modules/`, `dist/`, `build/`, `target/`, `bin/`, `obj/`, `.angular/`, `coverage/`, `TestResults/`, `publish/` (coincidente con `.gitignore` del repo)

## Estructura inesperada u observables

- Carpeta de nombre `sokectio/` (p. ej. typo de “socket”); contiene cientos de archivos al estilo `socket.io` (evidencia: árbol bajo `repos/vortech/sokectio/`).
- Varios **proyectos Angular** en `angular.json` **no tienen `package.json`** en su carpeta (`packages/angular-demo`, `packages/monkey`, `system-agent/dashboard`, `packages/v-studio`) — solo `tsconfig*`, `src/`, `public/`: se clasifican por `angular.json` (evidencia: ausencia de `package.json` al listar `repos/vortech/packages/angular-demo/`).
- `Vortech.sln` referencia rutas bajo `.source-insiration/*` (subárbol de inspiración / terceros); no todos los paths entraron en el conteo de packages TypeScript.
- `package.json` en la **raíz** (`.`) define el workspace; no se duplica una fila de clasificación con path con `/` para la raíz: el conteo de packages operativos son los subdirectorios (evidencia: `repos/vortech/package.json:1`).
