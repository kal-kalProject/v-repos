---
kind: package-summary
repo: ui
package_name: "@vortech/ai-server"
package_path: packages/ai-server
language: ts
manifest: package.json
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: experimental
---

## 1. Identidad

| Campo         | Valor                                           |
|---------------|-------------------------------------------------|
| name          | `@vortech/ai-server`                            |
| version       | 0.0.1                                           |
| directorio    | `packages/ai-server`                            |
| type          | module (ESM)                                    |
| private       | no especificado                                 |
| entrypoint    | `dist/server.mjs` (servidor ejecutable)         |
| types         | no declarados en manifest                       |

> El `main` apunta a `dist/server.mjs` en lugar de `dist/index.mjs`, lo que indica que el paquete es un **servidor ejecutable**, no una librería pura — aunque también expone un barrel `src/index.ts` con módulos reutilizables.

## 2. Propósito

### 2.1 Declarado

> "Vortech AI Server — self-hosted LLM platform (vLLM + Ollama + Qdrant)"

### 2.2 Inferido + Evidencia

Servidor HTTP self-hosted que integra múltiples backends de IA:

- **LLM**: módulo para chat y embeddings compatibles con OpenAI (`LlmModule`, `OpenAiCompatBackend`, `MockLlmBackend`) — backends: vLLM, Ollama.
- **TTS**: síntesis de voz (`TtsModule`, `TtsService`).
- **RAG**: retrieval-augmented generation con Qdrant (`RagModule`, `RagService`).
- **Knowledge**: ingestión y consulta de documentos (`KnowledgeModule`, `KnowledgeService`, `chunkText`, `extractText`).
- **Gestures**: detección de gestos por broadcast (`createGestureProvider`).
- **Auth**: OAuth con Google (`GoogleOAuthService`, `createBearerAuthMiddleware`).
- **Wire**: setup de Express + socket.io, SSE para chat streaming.

Evidencia: `packages/ai-server/src/index.ts:1-35`.

## 3. Superficie pública

Entry points (campo `exports`): no declarados explícitamente (solo `main`).

Símbolos clave exportados desde `src/index.ts`:

| Módulo     | Símbolos principales                                                              |
|------------|-----------------------------------------------------------------------------------|
| LLM        | `LlmModule`, `LLM_CONFIG`, `LLM_BACKEND`, `LLM_SERVICE`, `LlmService`, `OpenAiCompatBackend`, `MockLlmBackend`, `createLlmProvider`, `chatSchema`, `embedSchema` |
| TTS        | `TtsModule`, `TTS_CONFIG`, `TTS_SERVICE`, `TtsService`, `MockTtsService`, `createTtsProvider` |
| RAG        | `RagModule`, `RAG_CONFIG`, `RAG_SERVICE`, `RagService`, `MockRagService`, `createRagProvider` |
| Gestures   | `createGestureProvider`, `GESTURE_BROADCAST_EVENT`                               |
| Knowledge  | `KnowledgeModule`, `KNOWLEDGE_CONFIG`, `KNOWLEDGE_SERVICE`, `KnowledgeService`, `chunkText`, `extractText` |
| Auth       | `AuthModule`, `GoogleOAuthService`, `MockGoogleOAuthService`, `createBearerAuthMiddleware` |
| Wire       | `createWireSetup`, `createLoggingMiddleware`, `createSseChatHandler`             |

Todos los módulos exponen también mocks (`MockLlmBackend`, `MockTtsService`, etc.), indicando diseño orientado a testabilidad.

## 4. Dependencias

### 4.1 Internas

Ninguna declarada en `dependencies`. El paquete es autónomo a nivel de runtime interno.

### 4.2 Externas

| Paquete      | Catálogo       | Propósito                        |
|--------------|----------------|----------------------------------|
| `express`    | catalog:common | HTTP server                      |
| `socket.io`  | catalog:realtime | WebSockets / SSE transport     |

> **Nota**: referencias de catálogo (`catalog:common`, `catalog:realtime`) — versiones exactas en `pnpm-workspace.yaml`.

## 5. Consumidores internos

No se detectaron dependencias directas desde otros paquetes del workspace hacia `@vortech/ai-server` en la revisión estática. El servidor está diseñado para ejecutarse como proceso independiente.

## 6. Estructura interna

```
packages/ai-server/src/
├── auth/         # OAuth Google, middleware Bearer
├── gestures/     # Detección y broadcast de gestos
├── index.ts      # Barrel con todos los módulos reutilizables
├── knowledge/    # Ingestión, chunking y consulta de documentos
├── llm/          # Chat, embeddings, backends (OpenAI-compat, vLLM, Ollama)
├── rag/          # Retrieval-augmented generation (Qdrant)
├── tts/          # Text-to-speech
└── wire/         # HTTP setup (Express + socket.io + SSE)
```

Scripts de desarrollo incluyen `test:oauth` (`tsx scripts/test-google-oauth.ts`) — integración OAuth manual.

## 7. Estado

| Campo          | Valor                                                                   |
|----------------|-------------------------------------------------------------------------|
| Madurez        | experimental                                                            |
| Justificación  | v0.0.1, sin exports declarados, integración con múltiples backends LLM en flux, script `test:oauth` sugiere desarrollo activo |
| Build          | no ejecutado (inventario estático)                                      |
| Tests          | `vitest` configurado (`test`, `test:watch`)                             |
| Último cambio  | desconocido (no se accedió a git log)                                   |

## 8. Dominios que toca

- Inteligencia artificial / LLM (vLLM, Ollama)
- RAG / Vector search (Qdrant)
- Text-to-speech
- Autenticación OAuth (Google)
- Infraestructura de servidor AI self-hosted

## 9. Observaciones

- El paquete combina un servidor ejecutable con módulos de librería — arquitectura dual que puede dificultar el tree-shaking si se usa como dependencia.
- `BUILD` requiere `NODE_OPTIONS=--max-old-space-size=4096`, indicando una base de código grande o compilación pesada.
- Expone mocks para todos los servicios — buena señal de diseño testable por inyección de dependencias.
- No tiene `exports` declarados en `package.json`, lo que limita el consumo como librería con resolución de subpaths.

## 10. Hipótesis

- Los módulos (`LlmModule`, `TtsModule`, etc.) probablemente usan el sistema DI de `@vortech/app` (`InjectorBuilder`), siguiendo el patrón de tokens de inyección (`LLM_CONFIG`, `LLM_BACKEND`, `LLM_SERVICE`).
- `createWireSetup` es el punto de entrada para componer el servidor completo con los backends seleccionados.

## 11. Preguntas abiertas

1. ¿`src/server.ts` (referenciado en `scripts.dev`) existe pero no fue encontrado — fue eliminado o renombrado?
2. ¿Qué backend LLM se usa por defecto en producción — vLLM o Ollama?
3. ¿La integración con Qdrant está en `rag/` o en `knowledge/`?
4. ¿El módulo `gestures/` está relacionado con algún hardware específico (cámara, sensor)?
