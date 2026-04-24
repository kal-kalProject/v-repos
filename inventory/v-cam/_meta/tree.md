---
source_repo: v-cam
source_commit: b220eefe852d7b3dc0db141aed3f46126c486db0
---

# Árbol de directorios — v-cam

Estructura top-level y manifests detectados para `v-cam`.

## 1. Estructura raíz
- `AGENTS.md` — Meta-información para agentes.
- `cnc-studio/` — **Workspace Entry** (Angular App).
- `repos.json` — Definición de recursos (si existiera, no detectado en root).
- `v-cam-ng/` — **Workspace Entry** (Angular/Industrial UI).
- `v-cam-ts/` — **Workspace Group** (Core logic & Viewer).
  - `common/` — Estructuras IR y tipos base.
  - `core/` — Lógica de procesamiento.
  - `viewer/` — Componente de visualización (BabylonJS).
- `v-converters/` — **Workspace Group** (Multi-language IR & Converters).
  - `ir/` — Implementaciones de IR en Rust, C#, Python, TS.
  - `parsers/` — Parsers (DXF).
- `vgen.agent.md` — Definición de agente especializado.

## 2. Manifests detectados

| Path | Tipo |
|------|------|
| `pnpm-workspace.yaml` | pnpm workspace root |
| `cnc-studio/package.json` | npm package (Angular) |
| `cnc-studio/angular.json` | Angular manifest |
| `v-cam-ng/package.json` | npm package (Angular) |
| `v-cam-ng/angular.json` | Angular manifest |
| `v-cam-ts/common/package.json` | npm package |
| `v-cam-ts/core/package.json` | npm package |
| `v-cam-ts/viewer/package.json` | npm package |
| `v-cam-ts/viewer-demo/package.json` | npm package |
| `v-converters/Cargo.toml` | Cargo workspace root |
| `v-converters/ir/rust/cam-ir-rust/Cargo.toml` | Cargo package |
| `v-converters/ir/conformance-runner/Cargo.toml` | Cargo package (binary) |
| `v-converters/ir/dotnet/Cam.Ir/Cam.Ir.csproj` | .NET project |
| `v-converters/ir/python/cam-ir-python/pyproject.toml` | Python package (hatchling) |
| `v-converters/ir/typescript/cam-ir-ts/package.json` | npm package |
| `v-converters/parsers/parser-dxf/pyproject.toml` | Python package (cli) |
