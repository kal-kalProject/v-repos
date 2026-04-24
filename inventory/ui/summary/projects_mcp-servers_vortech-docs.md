---
kind: package-summary
repo: ui
package_name: "vortech-docs-mcp-server"
package_path: projects/mcp-servers/vortech-docs
language: ts
manifest: package.json
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: experimental
---

## 1. Identidad

- **Nombre publicado:** `vortech-docs-mcp-server`
- **Descripción declarada:** "MCP Server para documentación inteligente del proyecto Vortech"
- **Ruta en el repo:** `projects/mcp-servers/vortech-docs`
- **Manifiesto:** `package.json`
- **Lenguaje principal:** TypeScript

## 2. Propósito

Servidor MCP (Model Context Protocol) que expone la documentación del proyecto Vortech como recursos y herramientas consultables por agentes de IA. Permite que modelos de lenguaje accedan, busquen y comprendan la documentación interna de Vortech de forma estructurada y semánticamente rica.

## 3. Superficie pública

- Servidor MCP con herramientas de consulta de documentación.
- Recursos MCP que sirven páginas de documentación como contexto para LLMs.
- Posiblemente búsqueda semántica sobre la documentación del proyecto.

## 4. Dependencias

- MCP SDK para implementar el protocolo de herramientas/recursos.
- Documentación del proyecto Vortech (Markdown, archivos `.md`, posiblemente el inventario de `v-repos`).
- Posiblemente `@devtools/analyzer` para indexación del codebase.
- Posiblemente una base vectorial local (ChromaDB, similar) o búsqueda por texto plano.

## 5. Consumidores internos

- Agentes de IA configurados con este MCP server (Copilot, Claude Desktop, etc.).
- `projects/ui/ai-chat` — la app de chat IA que puede consultar la documentación Vortech via este server.
- Desarrolladores del equipo Vortech para asistencia con IA sobre la documentación interna.

## 6. Estructura interna

```
projects/mcp-servers/vortech-docs/
└── src/
    ├── index.ts
    └── (herramientas y recursos de documentación)
```

## 7. Estado

- **Madurez:** experimental
- El MCP de documentación inteligente es un uso avanzado del protocolo; en estado experimental coherente con la madurez del ecosistema MCP.

## 8. Dominios que toca

- **MCP / Model Context Protocol** — servidor de documentación para LLMs.
- **Documentación** — indexación y consulta de docs del proyecto.
- **IA / RAG** — posible Retrieval-Augmented Generation sobre la documentación Vortech.

## 9. Observaciones

- La descripción "documentación inteligente" sugiere capacidades más allá de simple serving de archivos: búsqueda, indexación, posiblemente embeddings.
- La coexistencia de `vortech-docs-mcp-server` con `packages/ai-assistant` (que también tiene capacidades de RAG) puede indicar solapamiento de responsabilidades o una arquitectura donde el MCP server delega en el ai-assistant.
- Es el complemento natural de `@vortech/mcp-common`: uno para utilidades/código, otro para documentación.

## 10. Hipótesis

- El server posiblemente indexa los archivos `.md` del repo `ui` y del workspace en general (incluyendo arquitectura, decisiones, guías).
- Puede usar el sistema de embeddings de `packages/ai-assistant` para búsqueda semántica si hay integración entre ambos.

## 11. Preguntas abiertas

1. ¿Qué fuentes de documentación indexa: solo el repo `ui` o también `v-repos` u otros repos?
2. ¿Usa búsqueda semántica (embeddings) o búsqueda por texto plano?
3. ¿Cómo se mantiene actualizado el índice de documentación cuando los archivos cambian?
4. ¿Hay solapamiento funcional con `packages/ai-assistant` y, si es así, cómo se coordinan?
