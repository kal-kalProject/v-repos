---
kind: package-summary
repo: ui
package_name: "@vortech/agent-tools"
package_path: ai/agent-tools
language: ts
manifest: package.json
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: experimental
---

## 1. Identidad

- **Nombre de paquete:** `@vortech/agent-tools`
- **Ruta:** `ai/agent-tools/`
- **Manifest:** `ai/agent-tools/package.json`
- **Tipo:** librería TypeScript

## 2. Propósito

Proporciona el catálogo de herramientas (tools) disponibles para el agente IA de Vortech. Implementa herramientas concretas de workspace (operaciones sobre archivos, búsqueda, etc.), un builder para definir nuevas herramientas con tipado fuerte, y la integración con el workspace del IDE.

## 3. Superficie pública

Exporta desde `src/index.ts`. Surface inferida:

- **`builder/`** — API para definir herramientas: tipado de parámetros, descripción, handler; similar al patrón de function calling de OpenAI
- **`tools/`** — implementaciones concretas de herramientas: read_file, write_file, search, run_command, etc.
- **`workspace/`** — abstracción del workspace del IDE: resolución de rutas, acceso al sistema de archivos del proyecto
- Tipos: `ToolDefinition`, `ToolHandler`, `ToolCall`, `ToolResult`

## 4. Dependencias

- `@vortech/agent-protocol` — usa `ToolCallEvent`, `ToolResultEvent`, `ProposedFileChange`
- `@vortech/agent-runtime` — el runtime invoca las herramientas registradas
- Probables dependencias de Node.js (`fs`, `path`, `child_process` para ejecución de comandos)

## 5. Consumidores internos

- `@vortech/agent-runtime` — invoca herramientas durante la fase de ejecución del agente
- `@vortech/agent-core` — registra el catálogo de herramientas al inicializar el agente
- `@vortech/agent-extension` — puede registrar herramientas adicionales específicas de VS Code

## 6. Estructura interna

```
ai/agent-tools/
├── package.json
└── src/
    ├── builder/       # API para definir herramientas con tipado
    ├── tools/         # implementaciones concretas de herramientas
    ├── workspace/     # abstracción del workspace del IDE
    └── index.ts       # barrel exports
```

## 7. Estado

Experimental. Tres subdirectorios con responsabilidades distintas. Las herramientas concretas en `tools/` son las más propensas a cambios frecuentes a medida que el agente adquiere nuevas capacidades.

## 8. Dominios que toca

- Integración con el sistema de archivos del workspace
- Operaciones de escritura/lectura de código (potencialmente destructivas)
- Definición de herramientas para function calling LLM
- Ejecución de comandos en el entorno del IDE

## 9. Observaciones

- El módulo `workspace/` es clave para la seguridad: debe garantizar que las herramientas solo operen dentro del workspace autorizado y no puedan escapar a rutas arbitrarias del sistema.
- El patrón `builder/` sugiere un DSL fluido para definir herramientas, similar a `zod` para validación de schemas de herramientas.
- `ProposedFileChange` del protocolo indica que las modificaciones de archivos se proponen antes de aplicarse, soportando el flujo "human-in-the-loop".

## 10. Hipótesis

- `builder/` puede generar automáticamente el JSON Schema de parámetros requerido por la API de function calling de OpenAI/Anthropic.
- `workspace/` probablemente incluye sandboxing de rutas (path traversal prevention) para que las herramientas no puedan acceder fuera del directorio del proyecto.
- Puede haber herramientas de búsqueda semántica que se integren con `@vortech/agent-indexer`.

## 11. Preguntas abiertas

- ¿Qué herramientas concretas están implementadas en `tools/`?
- ¿Las herramientas de escritura de archivos pasan siempre por `ProposedFileChange` (con aprobación del usuario) o pueden aplicarse directamente?
- ¿Hay sandboxing de sistema de archivos para prevenir path traversal?
- ¿Se pueden registrar herramientas externas (plugins de terceros)?
