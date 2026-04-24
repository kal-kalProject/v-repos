---
source_repo: v-rust
source_commit: dfb2bdc3ace105d04d66c6439bd2aa8818919629
kind: domain-inventory
repo: v-rust
domain: rust_platform
inventoried_at: 2026-04-24T16:20:00Z
inventoried_by: cursor-agent
implementations_count: 6
languages_involved: [rust]
---

# Dominio — `rust_platform`

## 1. Definición operativa
Núcleo de runtime/servicio en Rust: `v-core`, `v-access`, `v-alloy`, `v-server` y el shell `vortech-desktop` (Tauri/escritorio — ver manifest del crate).

## 2. Implementaciones encontradas
| # | Package | Path | Lenguaje | Madurez | Rol |
|---|---------|------|----------|---------|-----|
| 1 | v-core | `crates/v-core` | Rust | maduro-aparente | núcleo lógica |
| 2 | v-server | `crates/v-server` | Rust | maduro-aparente | servicio (HTTP/axum, según workspace dependencies en `Cargo.toml` raíz) |
| 3 | vortech-desktop | `crates/vortech-desktop` | Rust | maduro-aparente | app de escritorio (inferido por nombre; confirmar Tauri/egui leyendo `Cargo.toml` en Fase 2) |
| 4+ | v-access, v-alloy, v-entity-derive, etc. | `crates/*` | Rust | maduro-aparente | apoyo (acceso, metal/alloy, derives) — ver `classification.md` |

## 3. Responsabilidades cubiertas
- **Núcleo** del stack Rust, **servicio de red** (`v-server` con `axum` en dependencias de workspace, `e:/v-repos/repos/v-rust/Cargo.toml:47-48`).

## 4. Contratos y tipos clave
- Dependencias de workspace compartidas en `e:/v-repos/repos/v-rust/Cargo.toml:18-52` (tokio, axum, serde, etc.).

## 5. Flujos observados
```
Binarios/servers Rust ↔ wire/gate/TTM LSP (otros dominios) según `Cargo.lock` (no leído en Fase 1)
```

## 6. Duplicaciones internas al repo
- Posible **solapación** con responsabilidades C# (broker, data) en otras capas; duplicación de producto, no de archivo.

## 7. Observaciones cross-language
- Rust ofrece piezas paralelas a .NET: evaluación de Fase 2 frente a `vortech-2026` y `vortech/`.

## 8. Estado global del dominio en este repo
- **Completitud:** múltiples crates activos; dos carpetas TTM sin `Cargo.toml` documentadas bajo `classification.md`.
- **Consistencia interna:** alineada con un único `Cargo.toml` de workspace a nivel raíz.
- **Justificación:** 15 miembros de workspace + 2 entradas `ttm.json` bajo `crates/`.

## 9. Sospechas para Fase 2
- `?:` Papel de `v-server` frente a `vortech-broker-host` (C#) en despliegues finales: elegir o integrar.
