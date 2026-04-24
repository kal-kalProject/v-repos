---
kind: tree
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
---

# Árbol de `repos/ui` — mapa inicial

## 1. Directorios top-level

| Directorio         | Tipo inferido          | Notas                                               |
|--------------------|------------------------|-----------------------------------------------------|
| `ai/`              | sub-workspace pnpm     | workspace propio (`ai/pnpm-workspace.yaml`): `.` + `agent-*` |
| `bun/`             | demo                   | demo con runtime Bun                                |
| `crates/`          | Rust crates            | `vc-language` (compilador VCatalyst + LSP)          |
| `demos/`           | demos/apps             | data-tree, node-app, sqlite, tauri                  |
| `devtools/`        | tooling                | `devtools/packages/analyzer`                        |
| `dotnet/`          | C# — loose files       | scripting-demo.csproj, CsvReader.csproj, src/ sin manifest |
| `packages/`        | paquetes TS/JS         | 24+ packages con `package.json`; también subdirs sin manifest |
| `projects/`        | Angular workspace      | libs Angular + apps Angular + MCP servers + devtools|
| `rust-ts-runtime/` | Rust crate             | `ts-runtime`: runtime JS basado en rquickjs         |
| `scripts/`         | scripts shell/mjs      | scripts de build y utilidades                       |

## 2. Manifests raíz detectados

| Manifest                  | Tipo              | Descripción                                         |
|---------------------------|-------------------|-----------------------------------------------------|
| `package.json`            | workspace root    | `vortech-workspace`, pnpm 10.17.0                   |
| `pnpm-workspace.yaml`     | pnpm workspace    | declara SOLO `ai/*`; packages/ no incluidos como miembros |
| `angular.json`            | Angular CLI       | 10 proyectos: 5 apps + 5 libs (ver §3)              |
| `ai/pnpm-workspace.yaml`  | pnpm sub-workspace| declara `.` + `agent-*`                             |
| `rust-ts-runtime/Cargo.toml` | Rust crate     | `ts-runtime` (bin)                                  |
| `crates/vc-language/Cargo.toml` | Rust crate  | `vc-language` (bin + lib, LSP opcional)             |
| `demos/tauri-demo/Cargo.toml`   | Rust crate  | `v-desk` (app Tauri 2)                              |
| `dotnet/scripting-demo/ScriptingDemo.csproj` | .NET | scripting demo con Roslyn  |
| `dotnet/Vortech.Utils.CsvReader/Vortech.Utils.CsvReader.csproj` | .NET | utilidad CSV |

## 3. Proyectos Angular (angular.json)

### Aplicaciones (projectType: application)
| ID Angular         | Root                        | Manifest propio |
|--------------------|-----------------------------|-----------------|
| `ai-chat`          | `projects/ui/ai-chat`       | no              |
| `demo`             | `projects/ui/demo`          | no              |
| `cnc-monkey`       | `projects/ui/cnc-monkey`    | no              |
| `studio`           | `projects/ui/studio`        | no              |
| `angular-demo`     | `projects/ui/angular-app`   | no              |

### Librerías (projectType: library)
| ID Angular         | Root                        | Package name              |
|--------------------|-----------------------------|---------------------------|
| `core`             | `projects/ui/core`          | `@vortech/ui-core`        |
| `ui`               | `projects/ui/ui`            | `@vortech/ui`             |
| `editor`           | `projects/ui/editor`        | `editor`                  |
| `utils`            | `ng-workspace/projects/utils`    | **path no existe** (incompletitud) |
| `data-flow-client` | `ng-workspace/projects/data-flow-client` | **path no existe** (incompletitud) |

## 4. Expansión del workspace pnpm (`ai/pnpm-workspace.yaml`)

| Package                  | Path                        | Nombre npm              |
|--------------------------|-----------------------------|-------------------------|
| workspace root           | `ai/`                       | (root)                  |
| `agent-core`             | `ai/agent-core/`            | `@vortech/agent-core`   |
| `agent-extension`        | `ai/agent-extension/`       | `@vortech/agent-extension` |
| `agent-gui`              | `ai/agent-gui/`             | `@vortech/agent-gui`    |
| `agent-indexer`          | `ai/agent-indexer/`         | `@vortech/agent-indexer` |
| `agent-memory`           | `ai/agent-memory/`          | `@vortech/agent-memory` |
| `agent-models`           | `ai/agent-models/`          | `@vortech/agent-models` |
| `agent-protocol`         | `ai/agent-protocol/`        | `@vortech/agent-protocol` |
| `agent-runtime`          | `ai/agent-runtime/`         | `@vortech/agent-runtime` |
| `agent-server`           | `ai/agent-server/`          | `@vortech/agent-server` |
| `agent-service`          | `ai/agent-service/`         | `@vortech/agent-service` |
| `agent-tools`            | `ai/agent-tools/`           | `@vortech/agent-tools`  |

## 5. Packages TS/JS en `packages/` (con `package.json`)

Nota: El `pnpm-workspace.yaml` raíz solo declara `ai/*`. Los packages de `packages/` no son miembros formales del workspace pnpm raíz — sus scripts en `package.json` raíz usan `--filter` que requeriría membresía. Esto es inconsistencia detectada.

| Path                               | Nombre npm                    |
|------------------------------------|-------------------------------|
| `packages/common`                  | `@vortech/common`             |
| `packages/core`                    | `@vortech/core`               |
| `packages/data`                    | `@vortech/data`               |
| `packages/dev-server`              | `@vortech/dev-server`         |
| `packages/dom`                     | `@vortech/dom`                |
| `packages/hosting`                 | `@vortech/hosting`            |
| `packages/lang`                    | `@vortech/lang`               |
| `packages/language-server`         | `@vortech/language-server`    |
| `packages/lang-vscode`             | `vtl-vscode`                  |
| `packages/llama-client`            | `llama-client`                |
| `packages/platform`                | `@vortech/platform`           |
| `packages/proxmox-client`          | `proxmox-client`              |
| `packages/sdk`                     | `@vortech/sdk`                |
| `packages/sii-dte-signer`          | `@vortech/security`           |
| `packages/utils`                   | `@vortech/utils`              |
| `packages/vortech`                 | `@vortech/app`                |
| `packages/vscode`                  | `vortech-vscode`              |
| `packages/apis`                    | `@vortech/apis`               |
| `packages/ai-server`               | `@vortech/ai-server`          |
| `packages/drizzle-base-sqlite`     | `@vortech/drizzle-base-sqlite`|
| `packages/server-side/file-system` | `@vortech/file-system`        |
| `packages/public/rx`               | `@vortech/rx`                 |
| `packages/services/data-flow/common` | `@vortech/data-flow-common` |
| `packages/services/storage/core`   | `@vortech/storage`            |

## 6. Packages en `projects/`

| Path                                  | Nombre npm                  | Tipo         |
|---------------------------------------|-----------------------------|--------------|
| `projects/devtools`                   | `@vortech/devtools`         | TS lib       |
| `projects/mcp-servers/vortech-common` | `@vortech/mcp-common`       | TS lib (MCP) |
| `projects/mcp-servers/vortech-docs`   | `vortech-docs-mcp-server`   | TS app (MCP) |
| `projects/shared/chart`               | `@vortech/chart`            | TS lib       |
| `projects/ui/api`                     | `@vortech/api`              | Angular lib  |
| `projects/ui/common`                  | `@vortech/common-old`       | Angular lib  |
| `projects/ui/core`                    | `@vortech/ui-core`          | Angular lib  |
| `projects/ui/editor`                  | `editor`                    | Angular lib  |
| `projects/ui/theming`                 | `@vortech/theming`          | TS lib       |
| `projects/ui/tailwindcss-plugin`      | `@vortech/tailwind`         | TS lib       |
| `projects/ui/ui`                      | `@vortech/ui`               | Angular lib (70+ componentes) |
| `projects/ui/presets/aura`            | `@vortech-presets/aura`     | TS lib       |
| `projects/ui/presets/lara`            | `@vortech-presets/lara`     | TS lib       |
| `projects/ui/presets/nora`            | `@vortech-presets/nora`     | TS lib       |
| `projects/ui/presets/material`        | `@vortech-presets/material` | TS lib       |
| `projects/ui/presets/vscode`          | `@vortech-presets/vscode`   | TS lib       |
| `projects/ui/presets/studio`          | `@vortech-presets/studio`   | TS lib       |
| `projects/ui/presets/cnc-monkey`      | `@vortech-presets/cnc-monkey` | TS lib     |

## 7. Devtools

| Path                          | Nombre npm            | Tipo       |
|-------------------------------|-----------------------|------------|
| `devtools/packages/analyzer`  | `@devtools/analyzer`  | TS lib     |

## 8. Demos y ejemplos

| Path                         | Nombre npm                  | Tipo              |
|------------------------------|-----------------------------|-------------------|
| `demos/data-tree-demo`       | `@vortech-demos/data-tree`  | TS app            |
| `demos/node-app`             | `@vortech-demos/node-app`   | TS app            |
| `demos/sqlite-demo`          | `@vortech-demos/sqlite-demo`| TS app            |
| `demos/tauri-demo`           | `v-desk` (Rust crate)       | Rust/Tauri desktop|
| `bun/demo`                   | `demo`                      | TS (Bun runtime)  |

## 9. Directorios sin manifest formal (documentados por completitud)

| Path                       | Lenguaje   | Estado                                 |
|----------------------------|------------|----------------------------------------|
| `packages/ai-assistant/`   | Python     | `requirements.txt`, sin `pyproject.toml` |
| `packages/vc-language-py/` | Python     | `requirements.txt`, sin `pyproject.toml` |
| `packages/server-side/`    | —          | directorio padre; solo contiene `file-system/` |
| `packages/services/`       | —          | directorio padre; contiene `data-flow/` y `storage/` |
| `packages/public/`         | —          | directorio padre; contiene `rx/`       |
| `packages/devtools/`       | —          | directorio vacío o alias               |
| `dotnet/src/`              | C#         | archivos C# sueltos (Messaging), sin `.csproj` |
| `dotnet/Messaging/`        | C#         | archivos C# sueltos, sin `.csproj`     |
| `rust-ts-runtime/target/`  | —          | artefactos de build Rust (ignorados)   |

## 10. Notas estructurales

1. **Workspace inconsistente:** `pnpm-workspace.yaml` solo declara `ai/*`, pero el `package.json` raíz filtra packages de `packages/` (p.ej. `@vortech/common`). Si los packages de `packages/` no son miembros del workspace, los scripts `--filter` fallarían.
2. **ng-workspace ausente:** `angular.json` referencia `ng-workspace/projects/utils` y `ng-workspace/projects/data-flow-client`, pero ese directorio no existe en el repo.
3. **`@vortech/color` referenciado pero no encontrado:** El script `color:build` en `package.json` raíz llama a `@vortech/color`, pero no se encuentra ningún directorio con ese package.
4. **`dotnet/src/`:** Contiene archivos de serialización de mensajes sin `.csproj`; probablemente código a integrar en algún proyecto.
5. **`rust-ts-runtime/target/`:** Artefacto de build Rust presente en el repo (debería estar en `.gitignore`).
