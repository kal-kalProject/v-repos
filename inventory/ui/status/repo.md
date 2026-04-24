---
kind: status-report
repo: ui
area: repo
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
---

# Status Report — `ui` (repo completo)

## Bugs

| ID  | Severidad | Descripción                                                                 | Evidencia                                                     |
|-----|-----------|-----------------------------------------------------------------------------|---------------------------------------------------------------|
| B01 | baja      | Typo en directorio: `configurtions/` (falta la 'a')                        | `repos/ui/projects/devtools/src/configurtions/`               |
| B02 | baja      | Typo en directorio: `comunication/` (falta la primera 'm')                 | `repos/ui/packages/vortech/src/comunication/`                 |
| B03 | media     | Exports masivos comentados en index principal de @vortech/common             | `repos/ui/packages/common/src/index.ts` (>500 líneas comentadas según inspección) |
| B04 | media     | `rust-ts-runtime/target/` está presente en el repo (no gitignoreado)        | `repos/ui/rust-ts-runtime/target/`                            |
| B05 | baja      | `COPILOT_AGENT_HANDOFF.md`, `hola.md`, `hello.md` — archivos de agente sueltos en raíz | `repos/ui/COPILOT_AGENT_HANDOFF.md`, `repos/ui/hola.md`, `repos/ui/hello.md` |

## Duplicaciones internas

| ID  | Tipo              | Descripción                                                                          | Packages involucrados                                                           |
|-----|-------------------|--------------------------------------------------------------------------------------|---------------------------------------------------------------------------------|
| D01 | funcional         | Primitivos Atom duplicados: `ComputedAtom` (@common) y `CompositeAtom` (@core)       | `packages/common`, `packages/core`                                              |
| D02 | funcional         | Dos sistemas DI independientes: `injection/` en plataforma y en core                | `packages/platform/src/injection/`, `packages/core/src/injection/`             |
| D03 | funcional         | Triple compilador VTL en 3 lenguajes sin versión canónica designada                  | `packages/lang`, `crates/vc-language`, `packages/vc-language-py`               |
| D04 | funcional         | Dos extensiones VS Code con responsabilidades solapadas                               | `packages/vscode`, `ai/agent-extension`                                        |
| D05 | funcional         | Dos servidores AI/WebSocket: `@vortech/agent-server` y `packages/ai-server`          | `ai/agent-server`, `packages/ai-server`                                        |
| D06 | funcional         | RAG/chat en Python y en TypeScript (agent-memory + agent-indexer vs ai-assistant.py) | `packages/ai-assistant`, `ai/agent-memory`, `ai/agent-indexer`                 |
| D07 | utilidades        | Módulos `color` presentes en @vortech/common, @vortech/utils y @vortech/dom          | `packages/common/src/color/`, `packages/utils/src/color/`, `packages/dom/src/` |
| D08 | runtime           | Runtime "Platform" y "RuntimeManager" — dos gestores del runtime de la plataforma    | `packages/platform`, `packages/core`                                           |

## Incompletitud

| ID  | Tipo              | Descripción                                                                          | Evidencia                                                     |
|-----|-------------------|--------------------------------------------------------------------------------------|---------------------------------------------------------------|
| I01 | directorio ausente| `ng-workspace/` referenciado en `angular.json` pero no existe en el repo             | `repos/ui/angular.json` → `ng-workspace/projects/utils`, `ng-workspace/projects/data-flow-client` |
| I02 | package ausente   | `@vortech/color` referenciado en scripts de build root pero sin `package.json`       | `repos/ui/package.json` scripts → `@vortech/color`           |
| I03 | workspace incompleta | `pnpm-workspace.yaml` raíz declara solo `ai/*`; `packages/` y `projects/` no son workspace members formales | `repos/ui/pnpm-workspace.yaml`                     |
| I04 | package obsoleto  | `@vortech/common-old` — package explícitamente deprecated, sin eliminar              | `repos/ui/packages/common-old/package.json` → `name: "@vortech/common-old"` |
| I05 | documentación     | Múltiples `.md` de planificación de agente sueltos en raíz (RUST_INSTALL_*.md, VC_*.md, VTS_*.md) — no son parte del producto | `repos/ui/` raíz (>20 archivos .md no estructurados) |

## Deuda

| ID  | Área              | Descripción                                                                          | Evidencia                                                     |
|-----|-------------------|--------------------------------------------------------------------------------------|---------------------------------------------------------------|
| DT01| package           | `@vortech/common-old` — package deprecated sin eliminar                               | `repos/ui/packages/common-old/`                               |
| DT02| workspace config  | Inconsistencia entre `pnpm-workspace.yaml` (solo ai/*) y uso real de todos los packages | `repos/ui/pnpm-workspace.yaml` vs `repos/ui/package.json` |
| DT03| refactoring       | Exports masivos comentados en @vortech/common — migración incompleta                  | `repos/ui/packages/common/src/index.ts`                       |
| DT04| artifact en repo  | `rust-ts-runtime/target/` — directorio de build Rust commiteado                     | `repos/ui/rust-ts-runtime/target/`                            |
| DT05| arquitectura      | Separación @vortech/core vs @vortech/platform sin documentar su relación             | ambos tienen runtime/ + injection/ con solapamiento           |
| DT06| gramática VTL     | Tres parsers VTL en 3 lenguajes sin especificación formal de la gramática            | `packages/lang/`, `crates/vc-language/`, `packages/vc-language-py/` |

## Tests

| Package                  | Path                              | Framework    | Estado                    | Evidencia                                           |
|--------------------------|-----------------------------------|--------------|---------------------------|-----------------------------------------------------|
| `@vortech/common`        | `packages/common`                 | vitest       | configurado (no ejecutado)| `packages/common/vitest.config.ts` (inferido)       |
| `@vortech/utils`         | `packages/utils`                  | vitest       | configurado (no ejecutado)| `packages/utils/vitest.config.ts` (inferido)        |
| `@vortech/ai-server`     | `packages/ai-server`              | vitest       | configurado (no ejecutado)| `packages/ai-server/vitest.config.ts` (inferido)    |
| `vc-language-py`         | `packages/vc-language-py`         | pytest       | configurado (no ejecutado)| `packages/vc-language-py/tests/` + `requirements.txt: pytest` |
| `vc-language` (Rust)     | `crates/vc-language`              | cargo test   | no ejecutado              | `crates/vc-language/` (tests en módulos Rust, no verificado) |
| `@devtools/analyzer`     | `devtools/packages/analyzer`      | desconocido  | sin evidencia de tests    | `devtools/packages/analyzer/src/` sin tests/ visible |
| Angular apps/libs        | `projects/ui/`                    | karma/jasmine| configurados (no ejecutados)| `tsconfig.spec.json` por proyecto Angular         |

**Observación:** no se ejecutaron tests. Solo se verifica configuración por presencia de archivos estáticos. Conteo total de packages con tests: ~7. Packages sin evidencia de tests: ~64.

## Resumen ejecutivo

- **71 packages** en 11 dominios: ui-kit, theming, runtime, di, codegen, devtools, agents, transport, http-client, desktop.
- **Duplicaciones críticas:** triple compilador VTL (D03), doble DI (D02), doble runtime (D08).
- **Deuda alta:** workspace config inconsistente (DT02), @vortech/common-old sin eliminar (DT01), ng-workspace missing (I01).
- **Cobertura de tests baja:** ~10% de packages tienen tests configurados; ninguno verificado por ejecución.
- **Anomalías de artefacto:** `rust-ts-runtime/target/` en repo (B04), 20+ .md sueltos en raíz (B05).
- **Madurez general:** nada ha podido ser marcado `maduro` (build no verificable). Mejor madurez observada: `maduro-aparente` en `@vortech/ui` (estructura completa, 100+ secondary entry points).
