---
source_repo: v-rust
source_commit: dfb2bdc3ace105d04d66c6439bd2aa8818919629
kind: status-report
repo: v-rust
area: repo
inventoried_at: 2026-04-24T16:30:00Z
inventoried_by: cursor-agent
---

# Estado — `repo` (v-rust, snapshot completo)

## Bugs

Ninguno detectado con evidencia de **fallo de ejecución** en Fase 1. Justificación: el inventario es estático; no se capturan errores de runtime, solo posibles problemas lógicos si se añadiera revisión de código en profundidad.

**Observación (no es bug comprobado):** hipótesis de divergencia entre `vortech/**` y `vortech-2026/**` requiere pruebas de integración, no hechas aquí.

## Duplicaciones internas

| # | Concepto | Ubicación A | Ubicación B | Diferencias |
|---|----------|-------------|-------------|-------------|
| 1 | Wire (C#) | `vortech/wire/common` | `vortech-2026/wire/common` | Misma nómina de ensamblado `vortech-wire-*` bajo distintas raíces. |
| 2 | Data / providers | `vortech/data/*` | `vortech-2026/data/*` y `vortech-dotnet/Data/*` | Múltiples familias de acceso a datos y esquemas. |
| 3 | Gate / acceso | `crates/v-gate*`, `crates/v-access` (Rust) | `v-gate-dotnet/src/VGate*` (C#) | Posible lógica de “gate / acceso” en dos lenguajes. |
| 4 | SDK / host | `vortech/sdk/*`, `vortech/host` | `vortech-2026/sdk/*` (y raíz 2026) | Paralelismo 2025 vs 2026. |

## Incompletitud

| # | Tipo | Ubicación | Descripción |
|---|------|----------|-------------|
| 1 | todo-estructural | `crates/v-ttm/src/types/inference.rs:285` | Comentario `// TODO: Check fields match` (validación de campos). |
| 2 | manifest faltante | `crates/v-ttm-code-analysis`, `crates/v-ttm-framework` | Solo `ttm.json` y `src/`; excluidos del workspace en `e:/v-repos/repos/v-rust/Cargo.toml:6-9` sin `Cargo.toml` de crate. |
| 3 | no_verificado | Varios | Dependencias y `ProjectReference` resueltos en restore/build, no en Fase 1. |

## Deuda

| # | Categoría | Ubicación | Observación |
|---|------------|-----------|-------------|
| 1 | archivo-monolítico | `crates/v-ttm/src/eval/tests.rs` (aprox. 9501 LOC) | Archivo de pruebas extremadamente grande; difícil de revisar y de mantener. Conteo: script estático, no CI. |
| 2 | archivo-monolítico | `mach4/sdk/lib/MachIPC.cs` (aprox. 6511 LOC) | Subárbol `mach4/` sin paquete principal inventariado; archivo gigante. |
| 3 | múltiples-eras | `vortech-2026/` frente a `vortech/` y `vortech-dotnet/` | Tres cuerpos de .NET/convención paralela incrementan carga mental y de unificación. |

## Tests

- **Rust:** aprox. **17** archivos con al menos un `#\[test\]`; conteo aproximado de atributos `#[test]`: **~1000+** (búsqueda en `.rs` del repo, sin ejecución). Método: recorrido con Python, no `cargo test`.
- **C#:** **6** proyectos con `Test` o `Tests` en el nombre de `.csproj` (bajo el árbol; ejemplos: `Vortech.Common.Tests`, `Vortech.LanguageServer.Tests`, `vortech-2026/tests/Vortech.Tests`, etc.; lista exacta vía búsqueda de archivos).
- **C (wire):** pruebas en ejecutable unificado bajo `wire/CMakeLists.txt:29-40` (ctest habilita `wire-tests`); no se ejecutó el binario.
- **Front-end (Angular):** al menos un `tsconfig.spec.json` bajo el árbol; no se cuentan tests Jasmine/Karma ejecutados.
- **Estado de ejecución:** no verificado (verde/rojo no aplica en Fase 1).

## Configuración / toolchain

- **Rust:** `rust-toolchain.toml` en la raíz del repo; align con convención del workspace. Sin `cargo build` en Fase 1.
- **.NET:** múltiples `.sln` independientes; posible dolor de alinear `TargetFramework` y propiedades. Sin `dotnet build` en Fase 1.
- **Node/Angular:** `ng-workspace` fija `packageManager` a `npm@10.8.2` en `ng-workspace/package.json:27`; `node_modules` no presente en clon (mitigación estándar v-repos).

## Resumen ejecutivo del área

Monorepo **multiplataforma** (Rust, C, C# .NET en varias generaciones, TypeScript) con ecosistemas TTM, wire, datos y tooling compartido. El principal riesgo de unificación es la **duplicación de subárboles** (`vortech` / `vortech-2026` / `vortech-dotnet`) y de conceptos (gate, data, LSP) entre lenguajes, sin trazabilidad de build en esta fase.

## Riesgos para la unificación

- Coexistencia de dos “líneas” de producto .NET bajo nombres casi idénticos.
- Tests Rust concentrados en pocos archivos monolíticos, costosos de dividir o priorizar.
- Extensión VS Code y Angular sin mapa estricto a backends en este entregable.
