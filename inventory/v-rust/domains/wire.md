---
source_repo: v-rust
source_commit: dfb2bdc3ace105d04d66c6439bd2aa8818919629
kind: domain-inventory
repo: v-rust
domain: wire
inventoried_at: 2026-04-24T16:20:00Z
inventoried_by: cursor-agent
implementations_count: 5
languages_involved: [c, csharp, rust]
---

# Dominio — `wire`

## 1. Definición operativa
Protocolo de enmarcado, codecs y puentes entre procesos (named pipe / streams) compartido entre C, C# (vortech / vortech-2026) y crates Rust (`v-wire`).

## 2. Implementaciones encontradas

| # | Package | Path | Lenguaje | Madurez | Rol |
|---|---------|------|----------|---------|-----|
| 1 | wire (CMake) | `wire` | C | maduro-aparente | `wire-common` + tests C: `wire/CMakeLists.txt:10` |
| 2 | vortech-wire-common | `vortech/wire/common` | C# | maduro-aparente | `vortech/wire/common/vortech-wire-common.csproj` |
| 3 | vortech-wire-bridge | `vortech/wire/bridge` | C# | maduro-aparente | `vortech/wire/bridge/vortech-wire-bridge.csproj` |
| 4 | (equivalentes 2026) | `vortech-2026/wire/*` | C# | maduro-aparente | common/bridge/platform bajo vortech-2026 |
| 5 | v-wire (crate) | `crates/v-wire` | Rust | maduro-aparente | manifiesto en `crates/v-wire/Cargo.toml` |

## 3. Responsabilidades cubiertas
- **Codec y frames** en C (`wire/CMakeLists.txt:10-14` — fuentes bajo `wire/common/src`).
- **Envelope JSON y canales** en C# bajo `vortech/wire/`.
- **Crate complementario** en Rust: `summary/crates_v-wire.md`.

## 4. Contratos y tipos clave
- `IEnvelopeCodec` en `vortech/wire/common/src/JsonEnvelopeCodec.cs` (evidencia de naming en el árbol; sin lectura de cuerpo en Fase 1).
- Headers C: `wire/common/include/vortech/wire/codec.h` (ruta bajo `repos/v-rust`).

## 5. Flujos observados
```
Host .NET o proceso Rust ↔ bridge/wire layer ↔ C wire-common o transporte (named pipe, etc., según proyecto).
```

## 6. Duplicaciones internas al repo
- **Variante `vortech/**` y `vortech-2026/**` para wire**: dos árboles con `vortech-wire-*` bajo nombres similares; riesgo de divergencia. Evidencia: `vortech-2026/wire/common` y `vortech/wire/common` coexisten (paths bajo el mismo repo).

## 7. Observaciones cross-language
- Tres lenguajes (C, C#, Rust) tocan enmarcado: unificación exigirá alinear contrato binario/JSON. Sin verificación de build en Fase 1.

## 8. Estado global del dominio en este repo
- **Completitud:** parcial (superficies paralelas, posible herencia 2025 vs 2026).
- **Consistencia interna:** hipótesis: divergente entre subárboles; citar estructura duplicada en §6.
- **Justificación:** presencia múltiple de carpetas `wire` en soluciones distintas.

## 9. Sospechas para Fase 2
- `?:` Elegir un árbol canónico (`vortech` vs `vortech-2026`) o fusionar. Evidencia: `vortech-2026/wire/common` y `vortech/wire/common`.
