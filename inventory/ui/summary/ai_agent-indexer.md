---
kind: package-summary
repo: ui
package_name: "@vortech/agent-indexer"
package_path: ai/agent-indexer
language: ts
manifest: package.json
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: experimental
---

## 1. Identidad

- **Nombre de paquete:** `@vortech/agent-indexer`
- **Ruta:** `ai/agent-indexer/`
- **Manifest:** `ai/agent-indexer/package.json`
- **Tipo:** librería TypeScript

## 2. Propósito

Indexador de código para el agente IA de Vortech. Construye packs de contexto estructurados que contienen documentos y símbolos indexados del workspace, permitiendo al agente acceder a información relevante del código fuente más allá de lo que cabe en la ventana de contexto del LLM. Es la capa de comprensión estática del código del sistema de agente.

## 3. Superficie pública

Exporta desde `src/index.ts`:

- **`build-context-pack.ts`** — función(es) para construir un `ContextPack` a partir del workspace
- **`context-pack.ts`** — tipo `ContextPack`: colección de documentos e información indexada para pasar al agente
- **`indexed-document.ts`** — tipo `IndexedDocument`: representación de un archivo con su contenido y metadatos
- **`indexed-symbol.ts`** — tipo `IndexedSymbol`: representación de un símbolo de código (función, clase, variable) con su ubicación y firma

## 4. Dependencias

- Probable: parser de TypeScript/AST (`ts-morph`, TypeScript compiler API, o `tree-sitter`) para extraer símbolos
- `@vortech/agent-protocol` — puede usar tipos de snapshot o contexto del protocolo
- Posible integración con el LSP o las APIs de VS Code para acceso a información de símbolos

## 5. Consumidores internos

- `@vortech/agent-runtime` — usa context packs para construir prompts enriquecidos con contexto de código
- `@vortech/agent-memory` — puede almacenar context packs indexados para recuperación posterior
- `@vortech/agent-core` — inicia el indexado al arrancar el agente o al detectar cambios en el workspace

## 6. Estructura interna

```
ai/agent-indexer/
├── package.json
└── src/
    ├── build-context-pack.ts    # construcción de context packs
    ├── context-pack.ts          # tipo ContextPack
    ├── indexed-document.ts      # tipo IndexedDocument
    ├── indexed-symbol.ts        # tipo IndexedSymbol
    └── index.ts                 # barrel exports
```

## 7. Estado

Experimental. Cinco archivos con responsabilidades bien definidas. La distinción entre `IndexedDocument` e `IndexedSymbol` indica un modelo de indexado de dos niveles (documento completo + símbolos extraídos).

## 8. Dominios que toca

- Análisis estático de código
- Indexado de workspace para contexto de LLM
- Extracción de símbolos y estructura de código
- Compresión de contexto (context window management)

## 9. Observaciones

- La existencia de `IndexedSymbol` sugiere que el indexador va más allá de incluir archivos completos: extrae estructura (funciones, clases, tipos) para optimizar el uso de la ventana de contexto del modelo.
- `build-context-pack.ts` como archivo separado de `context-pack.ts` (tipo) es coherente con la separación de builder vs. tipo de datos.
- Este paquete es clave para el rendimiento del agente: un indexador eficiente puede marcar la diferencia entre un agente que comprende el codebase y uno que trabaja "a ciegas".

## 10. Hipótesis

- `IndexedSymbol` puede incluir: nombre, tipo (function/class/variable/interface), firma, docstring, ruta del archivo, rango de líneas.
- `build-context-pack()` puede tener estrategias de selección (relevancia por query, por archivo activo, por grafo de dependencias).
- Puede haber integración con el TypeScript Language Server para obtener tipos resueltos y referencias entre símbolos.

## 11. Preguntas abiertas

- ¿El indexado es incremental (solo cambios) o full-scan en cada ejecución?
- ¿Qué parser/AST se usa para extraer `IndexedSymbol`?
- ¿Hay soporte para lenguajes distintos de TypeScript?
- ¿Cómo se decide qué documentos/símbolos incluir en un context pack dado una query del agente?
