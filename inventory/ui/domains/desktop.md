---
kind: domain-inventory
repo: ui
domain: desktop
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
implementations_count: 1
languages_involved: [rust]
---

# Dominio — `desktop`

## 1. Definición operativa
Aplicación de escritorio multiplataforma basada en Tauri 2 — frontend posiblemente Angular o web, backend Rust. Prototipo de aplicación nativa con system tray.

## 2. Implementaciones encontradas

| # | Package      | Path              | Lenguaje | Madurez      | Rol                                          |
|---|--------------|-------------------|----------|--------------|----------------------------------------------|
| 1 | `v-desk`     | `demos/tauri-demo`| rust     | experimental | App desktop Tauri 2 — system tray, menú contextual, greet command |

## 3. Responsabilidades cubiertas

- **App desktop** (Tauri 2) → `demos/tauri-demo/src/`
- **System tray** (tray-icon, menú contextual) → `demos/tauri-demo/src/lib.rs`
- **Comando greet** (IPC Tauri) → `demos/tauri-demo/src/lib.rs`
- **Build Windows** (winresource) → `demos/tauri-demo/build.rs`

## 4. Contratos y tipos clave
- `greet(name: String) -> String` → `demos/tauri-demo/src/lib.rs`
- `tray: TrayIconBuilder` → Tauri 2 tray-icon feature
- `tauri::Builder::default()` → Tauri 2 builder
- Dependencias: `tauri 2`, `serde`, `serde_json`, `tauri-build`, `winresource` (build)

## 5. Flujos observados
```
Tauri app boot
  → src-tauri/src/lib.rs: app builder (tauri::Builder)
  → registra command: greet
  → configura TrayIcon con menú contextual
  → frontend (probablemente web/Angular) llama invoke("greet", { name })
  → respuesta en español: "Hola, {name}! Has sido saludado desde Rust"
```
Evidencia del saludo en español: `demos/tauri-demo/src/lib.rs` (comando greet).

## 6. Duplicaciones internas al repo
- No hay otras implementaciones de aplicación desktop en el repo. El dominio es único.

## 7. Observaciones cross-language
- Backend: Rust (Tauri 2). Frontend: no determinado (directorio `demos/tauri-demo/` puede tener subdirectorio web).
- El saludo en español indica adaptación cultural local.

## 8. Estado global del dominio en este repo
- **Completitud:** mínima — solo prototipo de demo con un comando y system tray
- **Consistencia interna:** consistente (único package, sin conflictos)
- **Justificación:** clasificado como demo en la estructura del repo (`demos/tauri-demo/`).

## 9. Sospechas para Fase 2
- `?:` La app desktop podría ser la UI de CNC Studio — evidencia: nombre `v-desk` y presencia de `cnc-monkey` app en Angular con diseño dark. Correlacionar con `v-cam-ts/v-cam-ng` en el repo `v-cam`.
- `?:` Tauri + Angular podría ser la arquitectura target para todas las apps desktop — evidencia: solo un prototipo aquí pero con infraestructura completa (tray, comandos IPC).
