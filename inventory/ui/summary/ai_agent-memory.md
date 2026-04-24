---
kind: package-summary
repo: ui
package_name: "@vortech/agent-memory"
package_path: ai/agent-memory
language: ts
manifest: package.json
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: experimental
---

## 1. Identidad

- **Nombre de paquete:** `@vortech/agent-memory`
- **Ruta:** `ai/agent-memory/`
- **Manifest:** `ai/agent-memory/package.json`
- **Tipo:** librería TypeScript

## 2. Propósito

Sistema de memoria del agente IA de Vortech. Proporciona persistencia y recuperación de contexto entre sesiones del agente: almacena fragmentos relevantes de conversaciones previas, resultados de herramientas, y datos de contexto del workspace para que el agente pueda recordar información más allá de la ventana de contexto del LLM.

## 3. Superficie pública

Exporta desde `src/index.ts`. Surface mínima observada (solo `index.ts` en `src/`):

- Probables exports: interfaz `MemoryStore`, funciones `remember()`, `recall()`, `forget()`
- Puede incluir tipos: `MemoryEntry`, `MemoryScope` (sesión vs. persistente vs. workspace)

## 4. Dependencias

- `@vortech/agent-protocol` — puede usar `AgentRunSnapshot` para persistir estado de sesión
- Probables: adaptadores de almacenamiento (filesystem, SQLite, vector DB)

## 5. Consumidores internos

- `@vortech/agent-runtime` — recupera contexto relevante para incluir en prompts
- `@vortech/agent-core` — persiste snapshots de sesión al finalizar una ejecución
- `@vortech/agent-indexer` — puede compartir datos de documentos indexados con la memoria

## 6. Estructura interna

```
ai/agent-memory/
├── package.json
└── src/
    └── index.ts       # barrel exports (surface mínima)
```

## 7. Estado

Experimental. Surface mínima (solo `src/index.ts`). Puede ser un stub inicial o una capa de abstracción muy delgada sobre almacenamiento externo. Paquete en etapa muy temprana.

## 8. Dominios que toca

- Persistencia de contexto de agente IA
- Recuperación de información (RAG básico)
- Gestión de memoria a largo plazo vs. corto plazo del agente

## 9. Observaciones

- La surface mínima (un solo archivo) contrasta con el potencial de complejidad del dominio de memoria de agentes. Puede indicar que es un wrapper simple alrededor de `@vortech/agent-indexer` o de almacenamiento en disco.
- En sistemas de agentes modernos, la memoria suele involucrar búsqueda vectorial para recuperación semántica; no es posible confirmar si esto está implementado con la información disponible.

## 10. Hipótesis

- `index.ts` puede re-exportar una implementación concreta de memoria en filesystem (JSON o SQLite) como la implementación por defecto.
- El sistema de memoria puede estar diseñado para ser reemplazable (pattern de interfaz + implementación), con `index.ts` exportando la interfaz y una implementación por defecto.
- La integración con `@vortech/agent-indexer` sugiere que los documentos indexados pueden ser recuperados como contexto de memoria.

## 11. Preguntas abiertas

- ¿La implementación actual usa almacenamiento en filesystem, SQLite, o llamadas a un servicio externo?
- ¿Hay soporte para búsqueda semántica (embeddings + vector similarity)?
- ¿Qué granularidad tiene la memoria: fragmentos, sesiones completas, o archivos?
- ¿La memoria es volátil (in-memory) o persistente entre reinicios de VS Code?
