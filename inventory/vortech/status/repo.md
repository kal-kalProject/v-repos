---
kind: status-report
source_repo: vortech
source_commit: f55e8e0202c3ef2486d845bb87601c7366d76b90
repo: vortech
area: repo
inventoried_at: 2026-04-24T20:00:00Z
inventoried_by: cursor-inventario-fase1
---

# Estado — `vortech` (repo completo)

## Bugs

| # | Severidad | Ubicación | Descripción | Evidencia |
|---|------------|------------|-------------|-----------|
| 1 | bajo (upstream) | `sokectio/engine.io/lib/userver.ts:321` | Comentario `// FIXME: not implemented` en ruta de manejo de estado | texto en fuente bajo `repos/vortech/` |
| 2 | bajo (config) | `platform/v-ui/tsup.config.ts:12` | `dts: false` con nota de errores de tipos heredados de `v-layout` | comentario en `tsup.config.ts` (build de tipos desactivado) |

Ninguno detectado de tipo “pérdida de datos” o crash sin reproducir: inventario estático; severidades refieren deuda o límites conocidos con evidencia de línea.

## Duplicaciones internas

| # | Concepto | Ubicación A | Ubicación B | Nota |
|---|----------|-------------|-------------|------|
| 1 | Transporte evented / sockets | `sokectio/socket.io/`, `sokectio/engine.io/`, múltiples subpaquetes | `packages/sockets`, `packages/wire` | Tres “capas” de acceso a socket/engine.io; posible solapamiento de responsabilidad (observación, no conclusión de reemplazo). |
| 2 | Núcleo “core” (nombre) | `platform/core` (paquete TS) | `rust-workspace/core` (crate `v-core`) | Homonimia; riesgo de confusión en documentación. |

**Ninguno detectado** con evidencia de copia pégita línea a línea entre A y B en esta Fase 1; las filas anteriores documentan **sospechas estructurales** con anclas de path.

## Incompletitud

| # | Tipo | Ubicación | Descripción |
|---|------|------------|-------------|
| 1 | manifest ausente (Angular) | `packages/angular-demo/`, `packages/monkey/`, `system-agent/dashboard/`, `packages/v-studio/` | Proyectos listados en `angular.json:6-270` y existentes en disco sin `package.json` en la raíz de cada app (comparar con arbol: solo `tsconfig*`, `src/`, `public/` en `packages/angular-demo`). |
| 2 | TODO estructural | `sokectio/engine.io/lib/userver.ts:321` | Ruta con `not implemented` explícita (ver Bugs). |
| 3 | API de tipos desactivada | `platform/v-ui/tsup.config.ts:12` | Generación d.ts deshabilitada por errores de tipos heredados (comentario en manifest de build). |

**Imports internos rotos** no auditados globalmente: sin `tsc` ni análisis de módulos; Fase 2 con graph real.

## Deuda

| # | Categoría | Ubicación | Observación |
|---|-----------|------------|-------------|
| 1 | árbol vendor grande | `sokectio/**` (decenas de subpaquetes) | Mantiene un ecosistema completo tipo socket.io en el repo: coste de actualización. |
| 2 | documentación y propuestas dispersas | `platform/core/propuestas/**`, `.vortech/doc/**` | Gran volumen de `*.md` de diseño; riesgo de desalineación con código. |
| 3 | nombres de directorio | `sokectio/` | Ortografía no estándar; puede dificultar búsqueda y normas de `grep`. |

**Archivos con más de 500 LOC** — presentes bajo `platform/v-ui` y `platform/core` (p. ej. múltiples `*.ts` y tests extensos); conteo de líneas exacto omitido (no `wc` obligatorio Fase 1), pero la densidad de tests en `platform/core/tests` supera módulos típicos (evidencia: listado de archivos con prefijo `platform/core/tests/*` en el workspace).

## Tests

- **Archivos `*.test.ts` (aprox.):** más de 150 archivos bajo `repos/vortech` (búsqueda con patrón `**/*.test.ts`; dominio principal `platform/core/tests`, `platform/v-common`, `platform/v-components`, `packages/wire`, etc.; incluye árbol `sokectio` con tests de upstream).
- **Archivos `*.spec.ts` (aprox.):** múltiples bajo `platform/v-runtime`, `platform/v-ui`, `platform/v-api-factory`, y apps `packages/angular-demo`, `packages/v-studio` (p. ej. `packages/v-studio/src/app/app.spec.ts:1`, `packages/angular-demo/src/app/app.spec.ts:1`).
- **`*Tests.cs` / `*Tests.*` .NET:** no detectados vía búsqueda de patrón `*Tests.cs` en el snapshot (conteo 0 en grep orientativo).
- **`#[test]` (Rust):** 0 apariciones en búsqueda de patrones bajo `rust-workspace/*.rs` (conteo estático; no implica inexistencia de tests con otro estilo o en carpetas excluidas).
- **Estado de ejecución:** no verificado (Fase 1 no ejecuta test runners).


