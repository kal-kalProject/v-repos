---
kind: domain-inventory
source_repo: vortech
source_commit: f55e8e0202c3ef2486d845bb87601c7366d76b90
repo: vortech
domain: rust_core
inventoried_at: 2026-04-24T20:00:00Z
inventoried_by: cursor-inventario-fase1
implementations_count: 3
languages_involved: [rust]
---

# Dominio — `rust_core`

## 1. Definición operativa
Crates Rust bajo `rust-workspace/`: `v-alloy` (bin), `v-core` (lib mínima), `v-desk` (Tauri v2 y plugins).

## 2. Implementaciones encontradas

| # | Package | Path | Lenguaje | Madurez | Rol |
|---|---------|------|----------|---------|-----|
| 1 | v-alloy | `rust-workspace/alloy` | rust | maduro-aparente | `vrust` binary |
| 2 | v-core | `rust-workspace/core` | rust | maduro-aparente | primitivas |
| 3 | v-desk | `rust-workspace/desktop` | rust | maduro-aparente | Tauri + tray (deps en `Cargo.toml:9-18`) |

## 3. Responsabilidades cubiertas
- **Desktop / tray, proceso a largo plazo (Alloy)**, **shell UI (Tauri)**.

## 4. Contratos y tipos clave
- `v-desk` → `tauri` y plugins en `rust-workspace/desktop/Cargo.toml:9-18`
- `v-alloy` → dependencias de red/tokio en `rust-workspace/alloy/Cargo.toml:12-22`

## 5. Flujos observados
```
v-alloy (vrust) / v-desk (Tauri) → OS / red (fuera de alcance de verificación de build)
```

## 6. Duplicaciones internas al repo
- **Nombre `v-core` (Rust) vs** paquetes TS con vocación de “core” (ver `domains/runtime.md`).

## 7. Observaciones cross-language
- Integración con monorepo TS no visible sin build.

## 8. Estado global del dominio en este repo
- **Completitud:** básica (3 crates, sin `#[test]` detectado vía búsqueda estática)
- **Consistencia interna:** edición 2024 en manifests

## 9. Sospechas para Fase 2
- `Cargo.lock` ignorado (`.gitignore:172`) — versiones congeladas no en repo; Fase 2 deberá documentar implicación para reproducibilidad.
