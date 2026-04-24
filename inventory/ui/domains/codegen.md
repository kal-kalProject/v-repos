---
kind: domain-inventory
repo: ui
domain: codegen
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
implementations_count: 6
languages_involved: [ts, rust, python]
---

# Dominio — `codegen`

## 1. Definición operativa
Compilador e instrumentos de generación de código para el lenguaje VTL (VCatalyst Template Language / Vortech Template Language). Incluye parser, AST, generador de código, y bindings desde múltiples lenguajes.

## 2. Implementaciones encontradas

| # | Package                | Path                         | Lenguaje | Madurez      | Rol                                          |
|---|------------------------|------------------------------|----------|--------------|----------------------------------------------|
| 1 | `@vortech/lang`        | `packages/lang`              | ts       | experimental | Compilador VTL en TypeScript — parser, AST, codegen |
| 2 | `@vortech/sdk`         | `packages/sdk`               | ts       | experimental | SDK AST / ts-morph — manipulación de TypeScript AST |
| 3 | `vc-language`          | `crates/vc-language`         | rust     | experimental | Compilador VTL en Rust (pest grammar) — Phase 1 Parser |
| 4 | `vc-language-py`       | `packages/vc-language-py`    | python   | experimental | Compilador VTL en Python (Lark grammar)      |
| 5 | `@vortech/language-server` | `packages/language-server` | ts      | experimental | Language Server Protocol sobre el compilador VTL |
| 6 | `vtl-vscode`           | `packages/lang-vscode`       | ts       | experimental | Extension VS Code — cliente LSP VTL          |

## 3. Responsabilidades cubiertas

- **Parser VTL (TS)** → `@vortech/lang/src/parser/`
- **AST VTL** → `@vortech/lang/src/ast/`
- **Code generator** → `@vortech/lang/src/codegen/`
- **TypeScript AST manipulation** → `@vortech/sdk` (ts-morph based)
- **Parser VTL (Rust)** → `vc-language/src/parser/` (pest PEG grammar)
- **Parser VTL (Python)** → `vc-language-py/src/` (Lark grammar)
- **LSP server** → `@vortech/language-server` (TextDocumentSyncKind, completions, diagnostics)
- **LSP client (VS Code)** → `vtl-vscode` (ExtensionContext, LanguageClient)

## 4. Contratos y tipos clave
- `VTLParser`, `VTLAst`, `VTLCodegen` → `packages/lang/src/`
- `AstNode`, `AstWalker` → `packages/sdk/src/`
- `pest` grammar files → `crates/vc-language/src/grammar/`
- `lark` grammar → `packages/vc-language-py/`
- `TextDocumentSyncKind`, LSP types → `packages/language-server/`

## 5. Flujos observados
```
Editor
  → vtl-vscode (ExtensionContext) → registra LanguageClient
  → LanguageClient → conecta a @vortech/language-server (LSP)
  → language-server → llama a @vortech/lang (parser, AST, diagnostics)

CLI/build
  → vc-language (Rust binary) → parsea .vtl → genera output (TS)
  → alternativa: vc-language-py → parsea .vtl → Python/TS output

App Vortech
  → @vortech/sdk → manipula TS AST con ts-morph
```

## 6. Duplicaciones internas al repo
- **3 implementaciones del mismo compilador VTL**: TypeScript (`@vortech/lang`), Rust (`vc-language`), Python (`vc-language-py`) — duplicación cross-language intencional para evaluación de trade-offs (según README de vc-language-py).
- `@vortech/lang` y `@vortech/sdk` pueden solaparse en la capa de manipulación de AST TypeScript.

## 7. Observaciones cross-language
- El compilador VTL tiene 3 implementaciones independientes en 3 lenguajes distintos.
- La implementación Rust usa PEG grammar con `pest`. La Python usa Lark. La TS es original.
- Solo la implementación TS está integrada al ecosistema LSP; Rust y Python son standalone.
- La existencia de 3 parsers sugiere que la gramática VTL puede no estar estabilizada.

## 8. Estado global del dominio en este repo
- **Completitud:** parcial — pipeline completo solo en TS (lang → language-server → vtl-vscode). Rust y Python son parsers aislados sin LSP.
- **Consistencia interna:** inconsistente — triple implementación sin una versión canónica designada.
- **Justificación:** `vc-language` README indica "Phase 1 - Parser Implementation" (`crates/vc-language/README.md`). `vc-language-py` README indica "experimental Python implementation for comparison" (`packages/vc-language-py/README.md`).

## 9. Sospechas para Fase 2
- `?:` El compilador TS (`@vortech/lang`) es la versión activa, Rust y Python son prototipos de reescritura — evidencia: único pipeline LSP completo en TS.
- `?:` La migración definitiva podría ser a Rust (por performance) — evidencia: `vc-language` tiene feature LSP opcional con tower-lsp, indicando intención de reemplazar el servidor TS.
