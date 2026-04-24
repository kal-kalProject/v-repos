---
kind: package-summary
repo: ui
package_name: "ts-runtime"
package_path: rust-ts-runtime
language: rust
manifest: Cargo.toml
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: experimental
---

## 1. Identidad

- **Nombre publicado:** `ts-runtime` (binario Rust)
- **Descripción declarada:** "TypeScript Runtime powered by Rust + QuickJS — lightweight TypeScript execution engine with native I/O"
- **Ruta en el repo:** `rust-ts-runtime`
- **Manifiesto:** `Cargo.toml`
- **Lenguaje principal:** Rust

## 2. Propósito

Motor de ejecución de TypeScript ligero basado en Rust y QuickJS — un runtime alternativo que permite ejecutar TypeScript/JavaScript directamente desde Rust usando el motor QuickJS (a través del binding `rquickjs`). Provee I/O nativo (red, sistema de archivos) via Tokio para operaciones asíncronas. Es un prototipo de runtime de scripting embebido.

## 3. Superficie pública

- Binario: `ts-runtime` (definido en `Cargo.toml` como `[[bin]]`).
- `src/main.rs` — punto de entrada del binario.
- Interfaz de CLI para ejecutar archivos TypeScript/JavaScript.

## 4. Dependencias

- `rquickjs 0.4` — binding Rust para el motor QuickJS (intérprete JS/TS ligero en C).
- `tokio 1` — runtime asíncrono de Rust para I/O no bloqueante.
- `serde` + `serde_json` — serialización/deserialización de datos entre Rust y JS.
- `reqwest 0.11` — cliente HTTP para I/O de red desde scripts TS.

## 5. Consumidores internos

- No es consumida por otros paquetes del workspace directamente; es un binario standalone.
- Potencial consumidor: `crates/vc-language` si el compilador VCatalyst necesita un runtime de ejecución.
- Contexto de uso: ejecución de scripts TypeScript de automatización dentro del ecosistema Vortech.

## 6. Estructura interna

```
rust-ts-runtime/
├── Cargo.toml
└── src/
    └── main.rs    ← binario ts-runtime
```

## 7. Estado

- **Madurez:** experimental (prototipo de runtime)
- Implementación mínima con un solo fichero `src/main.rs`.
- QuickJS es un motor JS ligero pero no tiene soporte completo de TypeScript nativo — probablemente requiere transpilación previa o un subset limitado de TS.

## 8. Dominios que toca

- **Runtime de Scripts** — ejecución de TypeScript/JavaScript en Rust.
- **Rust / Systems Programming** — motor de scripting embebido en lenguaje de sistemas.
- **I/O Asíncrono** — red y archivos via Tokio desde scripts TS.

## 9. Observaciones

- QuickJS no soporta TypeScript nativament; `rquickjs` probablemente requiere que el TS sea transpilado a JS antes de ejecutarse, o usa un transpilador mínimo integrado.
- La combinación Rust + QuickJS + Tokio es similar al enfoque de Deno (Rust + V8 + Tokio), pero con QuickJS en lugar de V8 — mucho más ligero pero con menos compatibilidad.
- `reqwest` como dependencia sugiere que los scripts pueden hacer llamadas HTTP, lo que lo convierte en un runtime de automatización con capacidades de red.

## 10. Hipótesis

- El runtime puede estar diseñado para ejecutar scripts de configuración o automatización de Vortech (similar a lo que hace Deno con scripts de Deno Deploy).
- La elección de QuickJS (vs V8) prioriza el tamaño del binario y la velocidad de arranque sobre la compatibilidad completa con el ecosistema JS.

## 11. Preguntas abiertas

1. ¿El runtime transpila TypeScript a JS internamente o requiere que el usuario lo haga previamente?
2. ¿Hay compatibilidad con `import`/`export` ES modules o solo CommonJS?
3. ¿Cuál es el caso de uso concreto que motiva este runtime vs usar Bun, Deno o Node.js directamente?
4. ¿Existe relación con `crates/vc-language` o son proyectos independientes?
