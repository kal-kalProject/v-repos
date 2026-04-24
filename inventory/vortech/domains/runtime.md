---
kind: domain-inventory
source_repo: vortech
source_commit: f55e8e0202c3ef2486d845bb87601c7366d76b90
repo: vortech
domain: runtime
inventoried_at: 2026-04-24T20:00:00Z
inventoried_by: cursor-inventario-fase1
implementations_count: 5
languages_involved: [ts, rust]
---

# Dominio — `runtime`

## 1. Definición operativa
Capa de ejecución de la plataforma: señales/atoms, ciclo de vida de host, y bins nativos que arrancan procesos (Rust). Incluye paquetes nombrados `runtime` y `v-runtime`, además de núcleo en `platform/core`.

## 2. Implementaciones encontradas

| # | Package | Path | Lenguaje | Madurez | Rol |
|---|---------|------|----------|---------|-----|
| 1 | @vortech/runtime | `packages/runtime` | ts | beta | librería runtime TS |
| 2 | @vortech/browser / @vortech/node | `packages/runtime/browser`, `packages/runtime/node` | ts | beta | adaptadores |
| 3 | v-runtime | `platform/v-runtime` | ts | beta | runtime v2 y pruebas |
| 4 | v-core (rust) | `rust-workspace/core` | rust | beta | crate mínimo serde |
| 5 | v-alloy | `rust-workspace/alloy` | rust | beta | bin `vrust` |

## 3. Responsabilidades cubiertas

- **Señales / atoms** → `platform/core` (tests bajo `platform/core/tests/atoms/`)
- **API de runtime por entorno** → `platform/v-runtime`, `packages/runtime/*`
- **Proceso nativo / tray (Rust)** → `rust-workspace/alloy`, `rust-workspace/desktop`

## 4. Contratos y tipos clave

- Ver exports de `packages/runtime/package.json` y `platform/v-runtime/src` (no resueltos sin `node_modules`).

## 5. Flujos observados

```
App TS → @vortech/runtime → (peer) platform/core atoms → wire/sockets (otro dominio)
```

## 6. Duplicaciones internas al repo

- **Runtime TS vs crate `v-core` (Rust)**: nombres homónimos distintos (`v-core` TS en `platform/core` vs crate `v-core` en `rust-workspace/core`) — riesgo de confusión en documentación; no se concluye duplicación funcional sin Fase 2.

## 7. Observaciones cross-language

- Rust `v-alloy` / `v-desk` coexisten con hosting y plataforma TypeScript; contrato entre ambos no verificado estáticamente.

## 8. Estado global del dominio en este repo

- **Completitud:** parcial (múltiples capas en evolución).
- **Consistencia interna:** inconsistente en nombres (`v-core` duplicado semántico).
- **Justificación:** evidencia de tests masivos en `platform/core/tests` y `platform/v-runtime/tests`.

## 9. Sospechas para Fase 2

- `?:` Unificar nomenclatura `v-core` (TS) vs crate `v-core` (Rust) — evidencia: paths `platform/core` vs `rust-workspace/core/Cargo.toml:1`.
