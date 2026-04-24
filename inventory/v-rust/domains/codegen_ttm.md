---
source_repo: v-rust
source_commit: dfb2bdc3ace105d04d66c6439bd2aa8818919629
kind: domain-inventory
repo: v-rust
domain: codegen_ttm
inventoried_at: 2026-04-24T16:20:00Z
inventoried_by: cursor-agent
implementations_count: 8
languages_involved: [rust, csharp]
---

# Dominio — `codegen_ttm`

## 1. Definición operativa
Ecosistema TTM: lexer/parser/eval, compilador, CLI, derive, Tree-sitter, y analizadores / generadores .NET bajo `vortech-dotnet/CodeAnalysis/`.

## 2. Implementaciones encontradas
| # | Package | Path | Lenguaje | Madurez | Rol |
|---|---------|------|----------|---------|-----|
| 1-6 | v-ttm, v-ttm-*, v-ttm-cli, treesitter, compiler, derive | `crates/v-ttm*`, excl. carpetas sin `Cargo.toml` | Rust | maduro-aparente | ver `summary/crates_v-ttm*.md` |
| 7-8 | Vortech.Analyzers, Vortech.Generators (+ tests) | `vortech-dotnet/CodeAnalysis/*` | C# | maduro-aparente | Roslyn-style tooling |

Carpetas `v-ttm-code-analysis` y `v-ttm-framework` con `ttm.json` (sin `Cargo.toml`) alinean con TTM sin ser crates.

## 3. Responsabilidades cubiertas
- **Front-end lenguaje** (lexer/parser/eval) en `v-ttm` y módulos asociados.
- **Herramienta CLI** `v-ttm-cli`, **LSP** en dominio `lsp.md`.
- **Código C#** analizador/generador para el ecosistema .NET (paralelo conceptual al compilador Rust).

## 4. Contratos y tipos clave
- Tests de evaluación masivos: `crates/v-ttm/src/eval/tests.rs` (archivo con gran número de pruebas unitarias, evidencia estructural en el árbol).

## 5. Flujos observados
```
Fuente TTM → parser Rust → eval/tests → (posible) codegen / analizador C# en paralelo
```

## 6. Duplicaciones internas al repo
- Lógica TTM en Rust frente a análisis/ingeniería de código en C#; duplicación de intención “compilar / analizar” en dos stacks.

## 7. Observaciones cross-language
- TTM es principalmente Rust; C# aporta analizadores — coordinación requerida para convenciones compartidas.

## 8. Estado global del dominio en este repo
- **Completitud:** avanzada en Rust (muchos tests, varios crates).
- **Consistencia interna:** riesgo de divergencia con analizadores C#.
- **Justificación:** múltiples `crates/v-ttm*` + `CodeAnalysis` en vortech-dotnet.

## 9. Sospechas para Fase 2
- `?:` Alinear atributos de generación (Rust derive) con generadores C# de `Vortech.Generators`.
