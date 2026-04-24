---
kind: package-summary
repo: ui
package_name: "@vortech/mcp-common"
package_path: projects/mcp-servers/vortech-common
language: ts
manifest: package.json
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: experimental
---

## 1. Identidad

- **Nombre publicado:** `@vortech/mcp-common`
- **Descripción declarada:** "MCP Server para @vortech/common - Asistente de utilidades"
- **Ruta en el repo:** `projects/mcp-servers/vortech-common`
- **Manifiesto:** `package.json`
- **Lenguaje principal:** TypeScript

## 2. Propósito

Servidor MCP (Model Context Protocol) que expone como herramientas las utilidades del paquete `@vortech/common` a agentes y LLMs. Actúa como asistente de utilidades — permite que modelos de lenguaje consulten y utilicen las funcionalidades del paquete común de Vortech mediante el protocolo MCP.

## 3. Superficie pública

- `index.ts` — punto de entrada del servidor MCP (inicio del servidor).
- `tools/` — definición de las herramientas MCP expuestas al cliente (LLM/agente).
- `data/` — datos estáticos o recursos que el servidor sirve como contexto.

## 4. Dependencias

- MCP SDK (`@modelcontextprotocol/sdk` o equivalente) para implementar el protocolo.
- `@vortech/common` o el paquete de utilidades correspondiente del workspace.
- Node.js runtime (stdio o HTTP transport según configuración).

## 5. Consumidores internos

- Agentes de IA (GitHub Copilot, Claude, etc.) configurados para usar este MCP server.
- `projects/devtools` (`@vortech/devtools`) — puede referenciar la configuración de este server.
- `projects/ui/ai-chat` — la app de chat puede consumir este server para obtener contexto de utilidades Vortech.

## 6. Estructura interna

```
projects/mcp-servers/vortech-common/
├── package.json
└── src/
    ├── index.ts
    ├── tools/
    └── data/
```

## 7. Estado

- **Madurez:** experimental
- Los MCP servers son tecnología relativamente nueva (protocolo MCP, 2024); el estado experimental es coherente.
- Requiere configuración en el cliente MCP (VS Code, Claude Desktop, etc.) para ser activado.

## 8. Dominios que toca

- **MCP / Model Context Protocol** — protocolo de herramientas para LLMs.
- **IA / Developer Tools** — asistencia de IA con utilidades Vortech.
- **Integración** — puente entre el código Vortech y los agentes de IA.

## 9. Observaciones

- El directorio `data/` dentro del server sugiere que sirve datos precomputados (documentación, ejemplos, índices) además de herramientas ejecutables.
- La existencia de dos MCP servers distintos (`vortech-common` y `vortech-docs`) indica una separación de responsabilidades: utilidades vs documentación.

## 10. Hipótesis

- `tools/` contiene las definiciones de herramientas MCP (nombre, descripción, schema de parámetros, función de ejecución).
- `data/` puede contener documentación de API serializada, ejemplos de uso o índices de búsqueda.
- El server probablemente corre sobre stdio transport para integración directa con clientes MCP de desktop.

## 11. Preguntas abiertas

1. ¿Qué herramientas específicas expone el server (list tools output)?
2. ¿El transport es stdio o HTTP/SSE?
3. ¿Cómo se mantiene sincronizado el server con los cambios en `@vortech/common`?
4. ¿Está configurado en el `.vscode/settings.json` del workspace para auto-activarse?
