---
kind: package-summary
repo: ui
package_name: "llama-client"
package_path: packages/llama-client
language: ts
manifest: package.json
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: experimental
---

## 1. Identidad

| Campo         | Valor                                              |
|---------------|----------------------------------------------------|
| name          | `llama-client`                                     |
| version       | 0.0.1                                              |
| directorio    | `packages/llama-client`                            |
| type          | module (ESM)                                       |
| private       | no especificado                                    |
| entrypoint    | `dist/index.js`                                    |
| types         | `dist/index.d.ts`                                  |

> **Nota**: nombre sin scope (`llama-client`, no `@vortech/llama-client`), lo que sugiere que podría haberse concebido como paquete independiente o fue creado antes de adoptar el scope `@vortech`.

## 2. Propósito

### 2.1 Declarado

> "Typed TypeScript client and request/response models for llama.cpp HTTP APIs."

### 2.2 Inferido + Evidencia

El paquete provee:

- **Cliente HTTP** tipado para la API REST de `llama.cpp` (`LlamaClient`).
- **Gestor de procesos** (`LlamaManager`): lanza, monitorea y enruta instancias de `llama.cpp` — soporta modos `single`, `cluster` y `router`.
- **Modelos OpenAI-compat**: re-exporta tipos de `apis/openai` para compatibilidad con la API OpenAI que expone llama.cpp.
- **SSE streaming**: `LlamaSseMessage` para respuestas en streaming.
- **Servidor Fastify** (`src/main/`): expone la API con documentación Swagger automática.

Evidencia: `packages/llama-client/src/index.ts:1-24`.

La presencia de `fastify` como dependencia de runtime indica que el paquete no es solo un cliente — también es capaz de levantar un servidor proxy/gateway para llama.cpp.

## 3. Superficie pública

Entry points (campo `exports`):

| Export    | Archivo dist         |
|-----------|----------------------|
| `.`       | `dist/index.js`      |
| `./main`  | `dist/main.js`       |

Símbolos clave:

| Clase/Función    | Propósito                                           |
|------------------|-----------------------------------------------------|
| `LlamaClient`    | Cliente HTTP para llama.cpp (`client/`)             |
| `LlamaManager`   | Gestor de procesos llama.cpp (single/cluster/router)|
| `LlamaApiError`  | Error tipado de la API                              |
| `LlamaSseMessage`| Mensaje SSE de streaming                           |
| Tipos `Llama*`   | Opciones GPU, flash attention, split mode, etc.     |
| Tipos OpenAI     | `export type * from './apis/openai'`                |
| Tipos llama      | `export type * from './apis/llama'`                 |

## 4. Dependencias

### 4.1 Internas

Ninguna.

### 4.2 Externas

| Paquete              | Versión    | Propósito                                      |
|----------------------|------------|------------------------------------------------|
| `fastify`            | ^5.7.4     | HTTP server para el gateway/proxy              |
| `@fastify/swagger`   | ^9.5.1     | Generación de spec OpenAPI                    |
| `@fastify/swagger-ui`| ^5.2.3     | UI Swagger                                     |

> **Paradoja arquitectónica**: el paquete se describe como "cliente" pero incluye `fastify` (framework de servidor) como dependencia de runtime. El directorio `src/main/` y el export `./main` son el servidor proxy.

## 5. Consumidores internos

No se detectaron dependencias directas hacia `llama-client` en los `package.json` del workspace. Probable consumo desde `@vortech/ai-server` (que integra múltiples backends LLM) a nivel de proceso, no de importación.

## 6. Estructura interna

```
packages/llama-client/src/
├── apis/
│   ├── openai/     # Tipos de la API OpenAI-compat
│   └── llama/      # Tipos nativos de llama.cpp API
├── client/         # LlamaClient — HTTP requests
├── errors.ts       # LlamaApiError
├── index.ts        # Barrel público
├── main/           # Servidor Fastify (gateway/proxy)
├── manager/        # LlamaManager — gestión de procesos
└── sse.ts          # LlamaSseMessage — streaming SSE
```

## 7. Estado

| Campo          | Valor                                                                   |
|----------------|-------------------------------------------------------------------------|
| Madurez        | experimental                                                            |
| Justificación  | v0.0.1 sin scope, doble rol cliente+servidor, sin tests configurados    |
| Build          | no ejecutado (inventario estático)                                      |
| Tests          | No detectados (`scripts` no incluye `test`)                            |
| Último cambio  | desconocido (no se accedió a git log)                                   |

## 8. Dominios que toca

- Inferencia local (llama.cpp)
- Compatibilidad OpenAI API
- Gestión de procesos de IA (single/cluster/router)
- Servidor HTTP / gateway de LLM

## 9. Observaciones

- El BUILD requiere `NODE_OPTIONS=--max-old-space-size=4096`.
- `DEFAULT_LLAMA_DIR`, `DEFAULT_POLL_INTERVAL_MS`, `DEFAULT_STARTUP_TIMEOUT_MS` exportados desde `manager/` — el manager gestiona el ciclo de vida del proceso binario de llama.cpp.
- El modo `cluster` sugiere balanceo de carga entre múltiples instancias de llama.cpp.
- No tiene scope `@vortech` — puede ser un paquete copiado/adaptado de una fuente externa o de uso más genérico.

## 10. Hipótesis

- `LlamaManager` probablemente usa `child_process` o similar para lanzar el binario de llama.cpp y mantiene un poll sobre su estado.
- El servidor en `src/main/` actúa como proxy: traduce llamadas OpenAI-compat hacia la API nativa de llama.cpp.
- Podría ser el backend que usa `@vortech/ai-server` cuando el proveedor LLM configurado es llama.cpp local.

## 11. Preguntas abiertas

1. ¿`LlamaManager` usa `child_process.spawn` o algún binding nativo?
2. ¿El modo `router` implementa load balancing o fallback entre instancias?
3. ¿Por qué `fastify` y no `express` (que usa `@vortech/ai-server`)? ¿Son paquetes independientes que coexisten?
4. ¿El paquete se planea publicar con scope `@vortech` en el futuro?
