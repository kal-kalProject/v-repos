---
kind: package-summary
repo: ui
package_name: "vc-language"
package_path: crates/vc-language
language: rust
manifest: Cargo.toml
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: experimental
---

## 1. Identidad

- **Nombre publicado:** `vc-language` (crate Rust)
- **Descripción declarada:** "VCatalyst Language - Independent Compiler & LSP Server"
- **Ruta en el repo:** `crates/vc-language`
- **Manifiesto:** `Cargo.toml`
- **Lenguaje principal:** Rust

## 2. Propósito

Compilador independiente y servidor LSP (Language Server Protocol) para el lenguaje VCatalyst. Implementa el pipeline completo de un lenguaje de programación: parsing (con PEG grammar via `pest`), análisis semántico y servidor de lenguaje para IDEs. La implementación Rust es el objetivo de producción, contrastada con la implementación experimental Python (`packages/vc-language-py`).

## 3. Superficie pública

- Crate de librería con API pública del compilador VCatalyst.
- Servidor LSP (via `tower-lsp`) cuando se habilita el feature `lsp`.
- CLI (via `clap`) para compilación desde línea de comandos.
- Features:
  - `default = ["lsp"]` — LSP habilitado por defecto.
  - `lsp` — activa `tower-lsp` + `tokio` para el servidor de lenguaje.

## 4. Dependencias

- `pest 2.7` — parser PEG (Parsing Expression Grammar) para el lenguaje VCatalyst.
- `pest_derive` — macro de derivación para generar parsers desde gramáticas PEG.
- `serde` + `serde_json` — serialización para el protocolo LSP (mensajes JSON-RPC).
- `clap 4.4` — CLI para el compilador standalone.
- `tower-lsp` (opcional, feature `lsp`) — implementación del protocolo LSP.
- `tokio` (opcional, feature `lsp`) — runtime asíncrono para el servidor LSP.

## 5. Consumidores internos

- `rust-ts-runtime` — posible consumidor si el runtime necesita el compilador VCatalyst.
- Herramientas de IDE/editor que soporten LSP (VS Code, Neovim, etc.) — a través del servidor LSP.
- `packages/vc-language-py` — referencia conceptual (implementación alternativa en Python).

## 6. Estructura interna

```
crates/vc-language/
├── Cargo.toml
└── src/
    ├── (parser PEG del lenguaje VCatalyst)
    ├── (análisis semántico)
    ├── (servidor LSP, condicional al feature "lsp")
    └── (CLI entry point con clap)
```

## 7. Estado

- **Madurez:** experimental — **Phase 1: Parser Implementation** según README.
- El proyecto está en su fase más temprana: solo el parser está en implementación activa.
- El servidor LSP está estructurado pero probablemente con funcionalidades mínimas en Phase 1.

## 8. Dominios que toca

- **Compiladores / Lenguajes** — diseño e implementación de un lenguaje de programación.
- **LSP / Tooling IDE** — servidor de lenguaje para integración en editores.
- **Rust / Systems Programming** — implementación de alta performance del compilador.

## 9. Observaciones

- El uso de `pest` (PEG grammar) en lugar de LALR (yacc/bison) es una elección moderna y expresa la gramática de forma más legible.
- El feature `lsp` como default indica que la experiencia de desarrollo (IDE support) es tan prioritaria como el compilador en sí.
- La existencia de una implementación Python paralela (`vc-language-py`) sugiere que el lenguaje se desarrolla con prototipado rápido en Python primero, luego implementación de producción en Rust.
- VCatalyst Language parece ser un proyecto a largo plazo de crear un lenguaje propio para el ecosistema Vortech.

## 10. Hipótesis

- VCatalyst puede ser un lenguaje de dominio específico (DSL) para UI Vortech o un lenguaje de propósito general con características específicas de la plataforma.
- La motivación del propio lenguaje puede ser superar limitaciones de TypeScript en el contexto de Vortech (sistema de tipos más estricto, mejor performance de compilación, etc.).

## 11. Preguntas abiertas

1. ¿VCatalyst es un DSL para configurar UI/componentes o un lenguaje de propósito general?
2. ¿La gramática PEG está documentada fuera del código Rust?
3. ¿Cuándo se espera terminar Phase 1 (parser) y comenzar Phase 2 (semantic analysis)?
4. ¿El LSP de VS Code ya está configurado para usar este server en el repo `ui`?
