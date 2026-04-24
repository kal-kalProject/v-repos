---
kind: package-summary
repo: ui
package_name: "ai-chat"
package_path: projects/ui/ai-chat
language: angular
manifest: angular.json
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: experimental
---

## 1. Identidad

- **Nombre publicado:** `ai-chat` (Angular project dentro de `angular.json`)
- **Ruta en el repo:** `projects/ui/ai-chat`
- **Manifiesto:** `angular.json`
- **Lenguaje principal:** Angular / TypeScript

## 2. Propósito

Aplicación Angular de chat con IA — interfaz de usuario para interactuar con modelos de lenguaje y documentos propios. Integra Monaco Editor (editor de código de VS Code) para permitir la edición y visualización de código dentro del contexto de la conversación con IA. Sirve en el puerto 4201.

## 3. Superficie pública

- No tiene API pública exportada; es una aplicación ejecutable.
- Interfaz de chat con streaming de respuestas.
- Monaco Editor embebido para código.
- Posiblemente integración con `packages/ai-assistant` (backend Python) o los MCP servers del workspace.

## 4. Dependencias

- Monaco Editor (`@monaco-editor/angular` o similar) — editor de código embebido.
- `@vortech-presets/vscode` — preset visual estilo VS Code, coherente con Monaco.
- La librería de componentes UI de Vortech.
- Angular 17+ (standalone).
- Posiblemente `@vortech/mcp-common` o los MCP servers para comunicación con IA.

## 5. Consumidores internos

- No es consumida por otros paquetes; es un artefacto de producto/herramienta.
- Usada internamente para asistencia de IA con el codebase de Vortech.

## 6. Estructura interna

```
projects/ui/ai-chat/
└── src/
    └── (componentes de chat, integración Monaco, llamadas a backend IA)
```

## 7. Estado

- **Madurez:** experimental
- Puerto: 4201.
- Dependiente del estado de los backends IA (MCP servers, `packages/ai-assistant`).

## 8. Dominios que toca

- **IA / Chat** — interfaz conversacional con modelos de lenguaje.
- **Editor de Código** — Monaco Editor para visualización/edición de código.
- **Developer Tools** — asistencia de IA para desarrollo.

## 9. Observaciones

- La combinación de Angular + Monaco + preset VS Code crea una experiencia coherente de "IDE en el browser".
- El puerto 4201 (4200+1) sugiere que puede convivir con otras instancias Angular simultáneamente.
- La integración con `packages/ai-assistant` (ChromaDB, búsqueda semántica local) es plausible dado el contexto.

## 10. Hipótesis

- La app probablemente se conecta a los MCP servers (`projects/mcp-servers/`) para obtener contexto del codebase Vortech y usar el paquete `ai-assistant` como backend de RAG.
- El preset `@vortech-presets/vscode` fue creado principalmente para esta app, dado que Monaco Editor sigue el mismo design system.

## 11. Preguntas abiertas

1. ¿Con qué modelo de IA se conecta (OpenAI, Anthropic, local/Ollama)?
2. ¿La integración con Monaco es solo para visualización o también permite ejecutar código?
3. ¿Cómo se comunica con el backend IA — REST, WebSocket, Server-Sent Events?
4. ¿Hay autenticación/autorización para el acceso al chat IA?
