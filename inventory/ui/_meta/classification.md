---
kind: classification
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
total_entries: 71
---

# Clasificación por lenguaje — `repos/ui`

## A. Aplicaciones Angular (sin package.json propio; definidas en `angular.json`)

| # | Path                        | Lenguaje | Tipo                | Package name (angular.json) |
|---|-----------------------------|----------|---------------------|-----------------------------|
| 1 | `projects/ui/ai-chat`       | angular  | app                 | `ai-chat`                   |
| 2 | `projects/ui/demo`          | angular  | app                 | `demo`                      |
| 3 | `projects/ui/cnc-monkey`    | angular  | app (SSR)           | `cnc-monkey`                |
| 4 | `projects/ui/studio`        | angular  | app                 | `studio`                    |
| 5 | `projects/ui/angular-app`   | angular  | app                 | `angular-demo`              |

## B. Librerías Angular (ng-packagr)

| # | Path                            | Lenguaje | Tipo    | Package name              | Manifest              |
|---|---------------------------------|----------|---------|---------------------------|-----------------------|
| 6 | `projects/ui/core`              | angular  | lib     | `@vortech/ui-core`        | `package.json`        |
| 7 | `projects/ui/ui`                | angular  | lib     | `@vortech/ui`             | `package.json`        |
| 8 | `projects/ui/editor`            | angular  | lib     | `editor`                  | `package.json`        |
| 9 | `projects/ui/api`               | angular  | lib     | `@vortech/api`            | `package.json`        |
| 10| `projects/ui/common`            | angular  | lib     | `@vortech/common-old`     | `package.json`        |

## C. Librerías TypeScript (theming / presets)

| # | Path                               | Lenguaje | Tipo | Package name                  | Manifest       |
|---|------------------------------------|----------|------|-------------------------------|----------------|
| 11| `projects/ui/theming`              | ts       | lib  | `@vortech/theming`            | `package.json` |
| 12| `projects/ui/tailwindcss-plugin`   | ts       | lib  | `@vortech/tailwind`           | `package.json` |
| 13| `projects/ui/presets/aura`         | ts       | lib  | `@vortech-presets/aura`       | `package.json` |
| 14| `projects/ui/presets/lara`         | ts       | lib  | `@vortech-presets/lara`       | `package.json` |
| 15| `projects/ui/presets/nora`         | ts       | lib  | `@vortech-presets/nora`       | `package.json` |
| 16| `projects/ui/presets/material`     | ts       | lib  | `@vortech-presets/material`   | `package.json` |
| 17| `projects/ui/presets/vscode`       | ts       | lib  | `@vortech-presets/vscode`     | `package.json` |
| 18| `projects/ui/presets/studio`       | ts       | lib  | `@vortech-presets/studio`     | `package.json` |
| 19| `projects/ui/presets/cnc-monkey`   | ts       | lib  | `@vortech-presets/cnc-monkey` | `package.json` |

## D. Librerías TypeScript — plataforma Vortech (`packages/`)

| # | Path                                    | Lenguaje | Tipo | Package name                   | Manifest       |
|---|-----------------------------------------|----------|------|--------------------------------|----------------|
| 20| `packages/common`                       | ts       | lib  | `@vortech/common`              | `package.json` |
| 21| `packages/core`                         | ts       | lib  | `@vortech/core`                | `package.json` |
| 22| `packages/data`                         | ts       | lib  | `@vortech/data`                | `package.json` |
| 23| `packages/dev-server`                   | ts       | lib  | `@vortech/dev-server`          | `package.json` |
| 24| `packages/dom`                          | ts       | lib  | `@vortech/dom`                 | `package.json` |
| 25| `packages/hosting`                      | ts       | lib  | `@vortech/hosting`             | `package.json` |
| 26| `packages/lang`                         | ts       | lib  | `@vortech/lang`                | `package.json` |
| 27| `packages/language-server`              | ts       | lib  | `@vortech/language-server`     | `package.json` |
| 28| `packages/lang-vscode`                  | ts       | ext  | `vtl-vscode`                   | `package.json` |
| 29| `packages/llama-client`                 | ts       | lib  | `llama-client`                 | `package.json` |
| 30| `packages/platform`                     | ts       | lib  | `@vortech/platform`            | `package.json` |
| 31| `packages/proxmox-client`               | ts       | lib  | `proxmox-client`               | `package.json` |
| 32| `packages/sdk`                          | ts       | lib  | `@vortech/sdk`                 | `package.json` |
| 33| `packages/sii-dte-signer`               | ts       | lib  | `@vortech/security`            | `package.json` |
| 34| `packages/utils`                        | ts       | lib  | `@vortech/utils`               | `package.json` |
| 35| `packages/vortech`                      | ts       | lib  | `@vortech/app`                 | `package.json` |
| 36| `packages/vscode`                       | ts       | ext  | `vortech-vscode`               | `package.json` |
| 37| `packages/apis`                         | ts       | lib  | `@vortech/apis`                | `package.json` |
| 38| `packages/ai-server`                    | ts       | app  | `@vortech/ai-server`           | `package.json` |
| 39| `packages/drizzle-base-sqlite`          | ts       | lib  | `@vortech/drizzle-base-sqlite` | `package.json` |
| 40| `packages/server-side/file-system`      | ts       | lib  | `@vortech/file-system`         | `package.json` |
| 41| `packages/public/rx`                    | ts       | lib  | `@vortech/rx`                  | `package.json` |
| 42| `packages/services/data-flow/common`    | ts       | lib  | `@vortech/data-flow-common`    | `package.json` |
| 43| `packages/services/storage/core`        | ts       | lib  | `@vortech/storage`             | `package.json` |

## E. Workspace AI (`ai/`)

| # | Path                  | Lenguaje | Tipo | Package name                 | Manifest       |
|---|-----------------------|----------|------|------------------------------|----------------|
| 44| `ai`                  | ts       | workspace-root | (raíz sub-workspace) | `package.json` |
| 45| `ai/agent-core`       | ts       | lib  | `@vortech/agent-core`        | `package.json` |
| 46| `ai/agent-extension`  | ts       | lib  | `@vortech/agent-extension`   | `package.json` |
| 47| `ai/agent-gui`        | ts       | app  | `@vortech/agent-gui`         | `package.json` |
| 48| `ai/agent-indexer`    | ts       | lib  | `@vortech/agent-indexer`     | `package.json` |
| 49| `ai/agent-memory`     | ts       | lib  | `@vortech/agent-memory`      | `package.json` |
| 50| `ai/agent-models`     | ts       | lib  | `@vortech/agent-models`      | `package.json` |
| 51| `ai/agent-protocol`   | ts       | lib  | `@vortech/agent-protocol`    | `package.json` |
| 52| `ai/agent-runtime`    | ts       | lib  | `@vortech/agent-runtime`     | `package.json` |
| 53| `ai/agent-server`     | ts       | app  | `@vortech/agent-server`      | `package.json` |
| 54| `ai/agent-service`    | ts       | lib  | `@vortech/agent-service`     | `package.json` |
| 55| `ai/agent-tools`      | ts       | lib  | `@vortech/agent-tools`       | `package.json` |

## F. DevTools

| # | Path                         | Lenguaje | Tipo | Package name           | Manifest       |
|---|------------------------------|----------|------|------------------------|----------------|
| 56| `projects/devtools`          | ts       | lib  | `@vortech/devtools`    | `package.json` |
| 57| `devtools/packages/analyzer` | ts       | lib  | `@devtools/analyzer`   | `package.json` |

## G. MCP Servers

| # | Path                                  | Lenguaje | Tipo | Package name                | Manifest       |
|---|---------------------------------------|----------|------|-----------------------------|----------------|
| 58| `projects/mcp-servers/vortech-common` | ts       | lib  | `@vortech/mcp-common`       | `package.json` |
| 59| `projects/mcp-servers/vortech-docs`   | ts       | app  | `vortech-docs-mcp-server`   | `package.json` |

## H. Shared / Chart

| # | Path                    | Lenguaje | Tipo | Package name       | Manifest       |
|---|-------------------------|----------|------|--------------------|----------------|
| 60| `projects/shared/chart` | ts       | lib  | `@vortech/chart`   | `package.json` |

## I. Demos y ejemplos TS

| # | Path                   | Lenguaje | Tipo | Package name                 | Manifest       |
|---|------------------------|----------|------|------------------------------|----------------|
| 61| `demos/data-tree-demo` | ts       | app  | `@vortech-demos/data-tree`   | `package.json` |
| 62| `demos/node-app`       | ts       | app  | `@vortech-demos/node-app`    | `package.json` |
| 63| `demos/sqlite-demo`    | ts       | app  | `@vortech-demos/sqlite-demo` | `package.json` |
| 64| `bun/demo`             | ts       | app  | `demo` (Bun)                 | `package.json` |

## J. Rust

| # | Path                    | Lenguaje | Tipo    | Package name  | Manifest       |
|---|-------------------------|----------|---------|---------------|----------------|
| 65| `rust-ts-runtime`       | rust     | bin     | `ts-runtime`  | `Cargo.toml`   |
| 66| `crates/vc-language`    | rust     | bin+lib | `vc-language` | `Cargo.toml`   |
| 67| `demos/tauri-demo`      | rust     | bin     | `v-desk`      | `Cargo.toml`   |

## K. C# / .NET

| # | Path                                    | Lenguaje | Tipo    | Package name                 | Manifest   |
|---|-----------------------------------------|----------|---------|------------------------------|------------|
| 68| `dotnet/scripting-demo`                 | csharp   | app     | `ScriptingDemo`              | `.csproj`  |
| 69| `dotnet/Vortech.Utils.CsvReader`        | csharp   | lib     | `Vortech.Utils.CsvReader`    | `.csproj`  |

## L. Python

| # | Path                       | Lenguaje | Tipo    | Package name   | Manifest            |
|---|----------------------------|----------|---------|----------------|---------------------|
| 70| `packages/ai-assistant`    | python   | app     | (sin nombre)   | `requirements.txt`  |
| 71| `packages/vc-language-py`  | python   | lib     | (sin nombre)   | `requirements.txt`  |

## Notas

- `projects/ui/ui` (`@vortech/ui`) tiene 70+ subdirectorios con `ng-package.json` individuales (secondary entry points por componente). Se trata como **un solo package** en la clasificación.
- `ng-workspace/projects/utils` y `ng-workspace/projects/data-flow-client` referenciados en `angular.json` no existen en el filesystem → incompletitud.
- `@vortech/color` referenciado en scripts raíz pero no encontrado → incompletitud.
- `dotnet/src/` y `dotnet/Messaging/` contienen archivos C# sueltos sin `.csproj` → no se clasifican como proyectos.
