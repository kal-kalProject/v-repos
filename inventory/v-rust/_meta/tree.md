---
source_repo: v-rust
source_commit: dfb2bdc3ace105d04d66c6439bd2aa8818919629
kind: discovery-tree
repo: v-rust
scanned_at: 2026-04-24T16:15:00Z
agent_id: cursor-agent
root_path: e:/v-repos/repos/v-rust
---

# Árbol — `v-rust`

## Top-level

| Path | Tipo inferido | Lenguajes / rol |
|------|---------------|-----------------|
| `crates/` | workspace Cargo (miembros en `Cargo.toml` raíz) | Rust |
| `vortech/` | solución .NET embebida (`vortech/vortech.sln`) + árbol broker/sdk/data/wire/transport | C# |
| `vortech-dotnet/` | solución .NET (`Vortech.sln`) — common/core/data/LS/Templates/Analyzers | C# |
| `vortech-2026/` | variante .NET 2026 (common/sdk/data/wire) | C# |
| `v-gate-dotnet/` | `VGate.sln` | C# |
| `orquesta/` | `Orchestrator.sln` (host, protocol, agentes) | C# |
| `wire/` | CMake C (wire-common, tests C) | C |
| `ng-workspace/` | workspace Angular/TS | TypeScript, Angular |
| `editors/` | extensiones VS Code | TypeScript, Node |
| `contracts/` | generación (`ContractGen`) | C# |
| `examples/` | sin manifest único en raíz | (misc) |
| `mach4/`, `nada-que-ver/`, `orquesta/` (parcial) | carpetas de experimentos / nombres descriptivos | varios |
| `mach4/`, `nada-que-ver/` | sin manifest de paquete en subárbol | no clasificado |
| documentación raíz | `ARCHITECTURE.md`, `ARQUITECTURA-VORTECH.md`, `vortech_architectural_standards2026.md` | Markdown |

## Manifests detectados (raíz y workspaces)

- `Cargo.toml` — workspace virtual con `members = ["crates/*"]` y `exclude` para `v-ttm-framework` y `v-ttm-code-analysis`.
- `vortech/vortech.sln` — múltiples proyectos bajo `vortech/`.
- `vortech-dotnet/Vortech.sln` — núcleo .NET, Data, LSP, plantillas, analizadores.
- `vortech-2026/` — proyectos `*.csproj` sin un único .sln listado en el inventario (presencia vía búsqueda de proyectos).
- `v-gate-dotnet/VGate.sln` — VGate, VGate.Access.
- `orquesta/Orchestrator.sln` — protocolo, host, agente CNC.
- `wire/CMakeLists.txt` — `wire-common` estático y ejecutable de tests.
- `ng-workspace/package.json` — Angular 21.2.x, workspace privado.
- `editors/vscode-vortech/package.json` y `editors/vscode-ttm/package.json`.
- Cada `crates/<name>/Cargo.toml` (salvo `v-ttm-code-analysis` y `v-ttm-framework`, que usan `ttm.json` sin manifiesto Rust).

## Directorios excluibles del análisis de **código** (Fase 1)

- `target/`, `node_modules/`, `bin/`, `obj/`, `dist/`, `build/`, `.git/` — generados, ignorados, o no presentes en el clon; no inventariados como fuente.

## Notas

- `test.db*`: artefacto SQLite bajo la raíz del repo; no un paquete.
