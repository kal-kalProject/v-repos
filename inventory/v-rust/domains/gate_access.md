---
source_repo: v-rust
source_commit: dfb2bdc3ace105d04d66c6439bd2aa8818919629
kind: domain-inventory
repo: v-rust
domain: gate_access
inventoried_at: 2026-04-24T16:20:00Z
inventoried_by: cursor-agent
implementations_count: 3
languages_involved: [rust, csharp]
---

# Dominio — `gate_access`

## 1. Definición operativa
Punto de control y acceso a datos: `v-gate` (Rust) con backend `v-gate-sqlite`, y en .NET el producto `VGate` bajo `v-gate-dotnet/src/`.

## 2. Implementaciones encontradas
| # | Package | Path | Lenguaje | Madurez | Rol |
|---|---------|------|----------|---------|-----|
| 1 | v-gate | `crates/v-gate` | Rust | maduro-aparente | manifiesto `crates/v-gate/Cargo.toml` |
| 2 | v-gate-sqlite | `crates/v-gate-sqlite` | Rust | maduro-aparente | `crates/v-gate-sqlite/Cargo.toml` |
| 3 | VGate / VGate.Access | `v-gate-dotnet/src/VGate`, `VGate.Access` | C# | maduro-aparente | `v-gate-dotnet` solución mínima de dos ensamblados |

## 3. Responsabilidades cubiertas
- **Cortafuegos o capa de policy** (nombre “gate” en Rust) y **API de acceso** en C# bajo nombres `VGate*`.

## 4. Contratos y tipos clave
- `v-gate` expone módulo `filter` (archivo `crates/v-gate/src/filter.rs:1` en el clon) — evidencia estructural de naming.

## 5. Flujos observados
```
Cliente o host → v-gate (policy) → proveedor (SQLite) en Rust; o consumo vía VGate (C#) — sin alinear en Fase 1.
```

## 6. Duplicaciones internas al repo
- Implementación de “gate” en **Rust** y en **.NET** con prefijo similar (`VGate`); posible duplicación de negocio.

## 7. Observaciones cross-language
- C# y Rust: dos entornos de despliegue; decisiones de unificación deben comparar requisitos de desempeño y despliegue.

## 8. Estado global del dominio en este repo
- **Completitud:** parcial (dos plataformas con naming convergente).
- **Consistencia interna:** desconocida sin lectura de contrato compartido.
- **Justificación:** coexistencia de `v-gate-dotnet` y `crates/v-gate*`.

## 9. Sospechas para Fase 2
- `?:` Especificar qué `VGate` (C#) reemplaza o complementa a `v-gate` (Rust).
