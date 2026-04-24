---
source_repo: v-rust
source_commit: dfb2bdc3ace105d04d66c6439bd2aa8818919629
kind: domain-inventory
repo: v-rust
domain: lsp
inventoried_at: 2026-04-24T16:20:00Z
inventoried_by: cursor-agent
implementations_count: 2
languages_involved: [rust, csharp]
---

# Dominio — `lsp`

## 1. Definición operativa
Servidores y clientes de lenguaje: `v-ttm-lsp` (Rust) y el stack `Vortech.LanguageServer*` bajo .NET (host, pruebas).

## 2. Implementaciones encontradas
| # | Package | Path | Lenguaje | Madurez | Rol |
|---|---------|------|----------|---------|-----|
| 1 | v-ttm-lsp | `crates/v-ttm-lsp` | Rust | maduro-aparente | LSP TTM en Rust, tests en `crates/v-ttm-lsp/src/tests.rs:1` |
| 2 | Vortech.LanguageServer (+ Host + Tests) | `vortech-dotnet/LanguageServer/*` | C# | maduro-aparente | tres proyectos bajo el mismo subárbol (`classification.md` los lista) |

## 3. Responsabilidades cubiertas
- **LSP para lenguaje TTM** (Rust) y **Language Server** .NET (producto de documentación/IDE, según nombres de proyecto).
- **Host** y **tests** .NET bajo el mismo namespace de carpetas.

## 4. Contratos y tipos clave
- Archivos bajo `vortech-dotnet/LanguageServer/Vortech.LanguageServer/` y el crate `v-ttm-lsp` (ver `lib.rs` en el path).

## 5. Flujos observados
```
Editor/IDE → proceso LSP (Rust o .NET) → análisis semántico / indexación
```

## 6. Duplicaciones internas al repo
- Dos plataformas de LSP (Rust vs C#) pueden solapar responsabilidad si TTM y “Vortech” comparten requisitos de edición. Sin merge en Fase 1.

## 7. Observaciones cross-language
- Misma capacidad (language server) en dos stacks; riesgo de doble coste de mantenimiento.

## 8. Estado global del dominio en este repo
- **Completitud:** parcial (dos enfoques).
- **Consistencia interna:** contradicción potencial de protocolo o de conjunto de capacidades.
- **Justificación:** `crates/v-ttm-lsp` y `vortech-dotnet/LanguageServer` coexisten.

## 9. Sospechas para Fase 2
- `?:` Unificar o documentar claramente el rol de cada LSP (TTM frente a lenguaje Vortech genérico).
