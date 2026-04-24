---
source_repo: v-gen
source_type: clone
source_commit: b7bfd02cc94b7417068e5fd3465225a41b466575
path: editors/vscode
name: vgen-vscode
type: package TS/JS
language: TypeScript (VS Code Extension)
---

# Summary - vgen-vscode

## Propósito
Extensión oficial de VS Code para el ecosistema vGen. Proporciona resaltado de sintaxis, IntelliSense (vía LSP), vista previa en vivo (live preview), diagnósticos y comandos para renderizar plantillas `.v-gen` y crear componentes C# asociados.

## Clasificación de Madurez
`maduro-aparente`
- **Justificación:** Estructura de extensión VS Code completa y moderna (LSP, Telemetry, TreeViews, Walkthroughs). Versión `0.1.3` en `package.json`. Integración con `vGen.LanguageServer`. Actividad reciente.

## Observaciones de Código
- **Arquitectura:** Basada en componentes desacoplados (`lsp/`, `preview/`, `treeview/`, `telemetry/`).
- **LSP:** Delegación masiva de la inteligencia de lenguaje al servidor `vGen.LanguageServer` (C#).
- **Herramientas:** Usa `esbuild` para el bundle y `mocha` para tests.
- **Incompletitud:** No se detectaron `TODO` por grep.

## Uso y Dependencias
- **Consumidores:** Desarrolladores que usan el motor vGen.
- **Dependencias clave:** `vscode-languageclient`, `@vscode/extension-telemetry`.

## Tests
- **Presencia:** Sí.
- **Conteo:** Directorio `test/` presente en la raíz de la extensión.
- **Estado verificado:** No ejecutados.
