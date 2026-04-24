---
kind: domain-inventory
repo: ui
domain: devtools
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
implementations_count: 5
languages_involved: [ts]
---

# Dominio — `devtools`

## 1. Definición operativa
Herramientas de desarrollo para el ecosistema Vortech — extensión VS Code, análisis de workspace, integración con MCP, y analizador de código. Agrupa toda la capa tooling del desarrollador.

## 2. Implementaciones encontradas

| # | Package                        | Path                                    | Lenguaje | Madurez      | Rol                                         |
|---|--------------------------------|-----------------------------------------|----------|--------------|---------------------------------------------|
| 1 | `vortech-vscode`               | `packages/vscode`                       | ts       | experimental | Extension VS Code — comandos, TreeView, acciones |
| 2 | `@vortech/devtools`            | `projects/devtools`                     | ts       | experimental | Devtools internos — workspace config, MCP, análisis |
| 3 | `@devtools/analyzer`           | `devtools/packages/analyzer`            | ts       | experimental | Analizador de código — types, análisis estático |
| 4 | `@vortech/mcp-common`          | `projects/mcp-servers/vortech-common`   | ts       | experimental | MCP Server para @vortech/common (asistente utils) |
| 5 | `vortech-docs-mcp-server`      | `projects/mcp-servers/vortech-docs`     | ts       | experimental | MCP Server para documentación Vortech |

## 3. Responsabilidades cubiertas

- **Extension VS Code** (comandos, TreeView, StatusBar) → `vortech-vscode`
- **LSP client VTL** (integrado en vortech-vscode) → `packages/vscode/src/` + `packages/lang-vscode/src/`
- **Configuración de workspace Vortech** → `@vortech/devtools/src/workspace/`
- **Integración MCP** → `@vortech/devtools/src/mcp-servers/`
- **Análisis estático de código** → `@devtools/analyzer/src/`
- **MCP tools para @vortech/common** (utilidades, colores, types) → `@vortech/mcp-common`
- **MCP tools para documentación** → `vortech-docs-mcp-server`

## 4. Contratos y tipos clave
- `ExtensionContext`, `commands.registerCommand` → `packages/vscode/src/extension.ts`
- Typo `configurtions/` (sic) → `projects/devtools/src/configurtions/` (directorio con typo)
- MCP tool types → `projects/mcp-servers/*/src/tools/`
- `AnalyzerResult`, `AnalysisOptions` → `devtools/packages/analyzer/src/types.d.ts`

## 5. Flujos observados
```
VS Code
  → activa vortech-vscode (ExtensionContext.activate())
  → registra comandos Vortech + TreeView + LanguageClient (VTL LSP)
  → @vortech/devtools configura workspace (MCP servers, analysis)
  → MCP servers exponen tools al AI (common utils, docs)
  → @devtools/analyzer analiza código Vortech
```

## 6. Duplicaciones internas al repo
- `vortech-vscode` y `vtl-vscode` (`packages/lang-vscode`) ambos son extensiones VS Code — posible overlap o integración esperada. `vtl-vscode` se centra en LSP VTL; `vortech-vscode` en la plataforma general.
- `@vortech/devtools/src/mcp-servers/` podría duplicar la configuración de `projects/mcp-servers/`.

## 7. Observaciones cross-language
Solo TypeScript. La extensión VS Code y los MCP servers son todos TypeScript/Node.js.

## 8. Estado global del dominio en este repo
- **Completitud:** parcial — MCP servers creados pero sin evidencia de pruebas de integración; typo en directorio devtools sugiere trabajo en progreso.
- **Consistencia interna:** inconsistente — dos extensiones VS Code con alcances solapados.
- **Justificación:** `projects/devtools/src/configurtions/` tiene un typo que indica code en progreso (`repos/ui/projects/devtools/src/configurtions/`).

## 9. Sospechas para Fase 2
- `?:` `vortech-vscode` y `vtl-vscode` podrían fusionarse en una sola extensión VS Code — la separación actual no tiene beneficio claro.
- `?:` Los dos MCP servers podrían consolidarse en un server multi-tool.
