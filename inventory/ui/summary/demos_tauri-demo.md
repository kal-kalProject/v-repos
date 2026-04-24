---
kind: package-summary
repo: ui
package_name: "v-desk"
package_path: demos/tauri-demo
language: rust
manifest: Cargo.toml
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: experimental
---

## 1. Identidad

- **Nombre publicado:** `v-desk` (aplicación Tauri 2)
- **Ruta en el repo:** `demos/tauri-demo`
- **Manifiesto:** `Cargo.toml`
- **Lenguaje principal:** Rust (backend Tauri) + TypeScript/Angular (frontend)

## 2. Propósito

Aplicación de escritorio Tauri 2 — prototipo de app nativa para Windows usando Tauri como wrapper. Implementa funcionalidades de escritorio: system tray (icono en la bandeja del sistema), menú contextual y un comando `greet` en español. Sirve como prueba de concepto de una aplicación desktop Vortech basada en web tech con backend Rust.

## 3. Superficie pública

- Aplicación ejecutable de escritorio (`.exe` en Windows).
- System tray con icono y menú contextual.
- Comando Tauri `greet` expuesto al frontend (en español).
- Ventana de aplicación que carga el frontend web (probablemente el frontend Angular del workspace).

## 4. Dependencias

**Rust (runtime):**
- `tauri 2` — framework de app desktop con features `tray-icon` e `image-png`.
- `serde` + `serde_json` — serialización para comandos Tauri (IPC frontend-backend).

**Rust (build):**
- `tauri-build` — herramientas de compilación de Tauri.
- `winresource` (solo Windows) — para incrustar recursos de Windows (icono, metadata).

**Frontend (presumiblemente):**
- Una de las apps Angular del workspace como frontend de la ventana Tauri.

## 5. Consumidores internos

- No es consumida por otros paquetes; es una aplicación de escritorio standalone.
- El frontend Tauri puede ser `projects/ui/demo` o una app Angular específica.

## 6. Estructura interna

```
demos/tauri-demo/
├── Cargo.toml
└── src/
    └── main.rs (o lib.rs con la lógica Tauri: tray, menú, comandos)
```

## 7. Estado

- **Madurez:** experimental (prototipo de app desktop)
- Tauri 2 es relativamente reciente; el prototipo puede no estar completamente actualizado con todas sus APIs.
- Funcionalidades básicas implementadas (tray, menú, greet); funcionalidades de producción pendientes.

## 8. Dominios que toca

- **Desktop / Nativo** — aplicación de escritorio Windows.
- **Tauri / Rust** — framework de apps desktop web-based con backend Rust.
- **System Integration** — bandeja del sistema, menú contextual Windows.

## 9. Observaciones

- El comando `greet` en español (vs el clásico "Hello World" en inglés de los ejemplos Tauri) indica que es un proyecto Vortech genuino, no un template genérico.
- `winresource` como dependencia exclusiva de Windows indica que el target principal es Windows, coherente con el uso de CNC y herramientas de taller en entornos Windows.
- Tauri 2 usa WebKit en macOS/Linux y WebView2 en Windows — el comportamiento visual puede diferir entre plataformas.
- La feature `tray-icon` de Tauri 2 permite minimizar a bandeja, patrón común en apps de monitoreo continuo (como CNC).

## 10. Hipótesis

- `v-desk` puede ser el precursor de una aplicación desktop para el uso de CNC Monkey o Studio fuera del browser.
- El sistema tray sugiere que la app está diseñada para correr en segundo plano (monitoreo de máquina CNC, alertas, etc.).

## 11. Preguntas abiertas

1. ¿Qué app Angular usa como frontend dentro de la ventana Tauri?
2. ¿Hay plan de convertir CNC Monkey o Studio en una app Tauri de producción?
3. ¿El comando `greet` en español es un placeholder o tiene semántica real en la app?
4. ¿La app compila para macOS/Linux además de Windows?
