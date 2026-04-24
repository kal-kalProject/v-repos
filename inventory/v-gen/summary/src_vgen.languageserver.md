---
source_repo: v-gen
source_type: clone
source_commit: b7bfd02cc94b7417068e5fd3465225a41b466575
path: src/vGen.LanguageServer
name: vGen.LanguageServer
type: proyecto .NET
language: C# (net10.0)
---

# Summary - vGen.LanguageServer

## Propósito
Implementación del protocolo LSP (Language Server Protocol) para plantillas vGen. Proporciona servicios de lenguaje (IntelliSense, diagnósticos, navegación) tanto a la extensión de VS Code como a otros editores compatibles.

## Clasificación de Madurez
`maduro-aparente`
- **Justificación:** Base de código organizada por funcionalidades (`Features/`, `Handlers/`), uso de librerías estándar de la industria (`StreamJsonRpc`), integración profunda con `vGen.Engine` y `vGen.Compiler`, y suite de tests dedicada.

## Observaciones de Código
- **Arquitectura:** Ejecutable (`OutputType: Exe`) que se comunica vía streams JSON-RPC.
- **Protocolo:** Implementa handlers LSP estándar (Completion, Hover, Diagnostics).
- **Incompletitud:** No se detectaron `TODO` críticos.

## Uso y Dependencias
- **Consumidores:** `vgen-vscode`, `vGen.Cli` (vía comando `lsp`).
- **Dependencias internas:** `vGen.Engine`, `vGen.Compiler`.
- **Dependencias externas:** `Microsoft.VisualStudio.LanguageServer.Protocol`.

## Tests
- **Presencia:** Sí.
- **Conteo:** 1 suite de tests detectada en `test/vGen.LanguageServer.Tests`.
- **Estado verificado:** No ejecutados.
