---
kind: domain-inventory
repo: ui
domain: agents
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
implementations_count: 12
languages_involved: [ts]
---

# Dominio — `agents`

## 1. Definición operativa
Sistema de agentes de inteligencia artificial — protocolo, runtime, gestión de modelos, memoria, herramientas, servidores, y interfaces de usuario para agentes IA conversacionales y autónomos.

## 2. Implementaciones encontradas

| # | Package                    | Path                          | Lenguaje | Madurez      | Rol                                          |
|---|----------------------------|-------------------------------|----------|--------------|----------------------------------------------|
| 1 | `@vortech/ai`              | `ai/`                         | ts       | experimental | Root workspace AI — scripts, tipos compartidos |
| 2 | `@vortech/agent-core`      | `ai/agent-core`               | ts       | experimental | Primitivos base de agente — Agent, AgentContext |
| 3 | `@vortech/agent-protocol`  | `ai/agent-protocol`           | ts       | experimental | Protocolo de comunicación entre agentes      |
| 4 | `@vortech/agent-models`    | `ai/agent-models`             | ts       | experimental | Integración con modelos LLM (OpenAI, Ollama) |
| 5 | `@vortech/agent-runtime`   | `ai/agent-runtime`            | ts       | experimental | Runtime de ejecución de agentes              |
| 6 | `@vortech/agent-server`    | `ai/agent-server`             | ts       | experimental | Servidor de agentes — WebSocket, HTTP        |
| 7 | `@vortech/agent-service`   | `ai/agent-service`            | ts       | experimental | Capa de servicio — orquestación de agentes   |
| 8 | `@vortech/agent-tools`     | `ai/agent-tools`              | ts       | experimental | Tools ejecutables por agentes (function calling) |
| 9 | `@vortech/agent-memory`    | `ai/agent-memory`             | ts       | experimental | Gestión de memoria y contexto del agente     |
| 10| `@vortech/agent-indexer`   | `ai/agent-indexer`            | ts       | experimental | Indexación de conocimiento (RAG, embeddings) |
| 11| `@vortech/agent-gui`       | `ai/agent-gui`                | ts       | experimental | UI de agente (integración con Angular/DOM)   |
| 12| `@vortech/agent-extension` | `ai/agent-extension`          | ts       | experimental | Extension VS Code para agente Vortech        |

## 3. Responsabilidades cubiertas

- **Primitivos de agente** (Agent, AgentContext, AgentConfig) → `@vortech/agent-core`
- **Protocolo mensajes** → `@vortech/agent-protocol`
- **Integración LLM** (OpenAI API, Ollama, etc.) → `@vortech/agent-models`
- **Runtime de ejecución** → `@vortech/agent-runtime`
- **Servidor WebSocket/HTTP** → `@vortech/agent-server`
- **Orquestación** → `@vortech/agent-service`
- **Function calling / tools** → `@vortech/agent-tools`
- **Memoria contextual** → `@vortech/agent-memory`
- **Indexación RAG** → `@vortech/agent-indexer`
- **UI de chat** → `@vortech/agent-gui`
- **Extension VS Code** → `@vortech/agent-extension`

## 4. Contratos y tipos clave
- `Agent`, `AgentContext`, `AgentConfig` → `ai/agent-core/src/`
- `AgentMessage`, `MessageRole` → `ai/agent-protocol/src/`
- `ModelProvider`, `ModelOptions` → `ai/agent-models/src/`
- `AgentTool`, `ToolResult`, `ToolCall` → `ai/agent-tools/src/`
- `MemoryEntry`, `MemoryStore` → `ai/agent-memory/src/`
- `IndexDocument`, `EmbeddingProvider` → `ai/agent-indexer/src/`

## 5. Flujos observados
```
Usuario
  → @vortech/agent-gui o @vortech/agent-extension (VS Code)
  → @vortech/agent-service (orquestación)
  → @vortech/agent-runtime (ejecución)
    → @vortech/agent-models (LLM call)
    → @vortech/agent-tools (function calling)
    → @vortech/agent-memory (contexto)
    → @vortech/agent-indexer (RAG)
  → @vortech/agent-server (WebSocket — cliente remoto)
  → @vortech/agent-protocol (serialización)
```

## 6. Duplicaciones internas al repo
- `@vortech/agent-extension` y `vortech-vscode` (packages/vscode) — ambos son extensiones VS Code. Posible overlap de responsabilidades.
- `@vortech/agent-server` y `packages/ai-server` — ambos exponen HTTP/WebSocket para AI — posible duplicación.
- `packages/ai-assistant` (Python RAG) solapa funcionalidad con `@vortech/agent-indexer` y `@vortech/agent-memory`.

## 7. Observaciones cross-language
- La implementación principal es TypeScript (ai/ workspace).
- `packages/ai-assistant` (Python) es una implementación alternativa de RAG/chat con ChromaDB — independiente del sistema TS.

## 8. Estado global del dominio en este repo
- **Completitud:** completo en arquitectura — todos los componentes de un sistema agente están presentes (core, protocol, models, runtime, server, service, tools, memory, indexer, gui, extension)
- **Consistencia interna:** aparentemente consistente — workspace propio `ai/pnpm-workspace.yaml` con 12 packages bajo la misma convención
- **Justificación:** todos los packages bajo `ai/` declaran `source_type: clone` coherente. Workspace separado en `ai/pnpm-workspace.yaml` (`repos/ui/ai/pnpm-workspace.yaml`).

## 9. Sospechas para Fase 2
- `?:` El sistema de agentes podría ser el objetivo final de la plataforma Vortech — toda la infraestructura (runtime, DI, transport) sirve como base para este sistema — evidencia: workspace propio con 12 packages dedicados.
- `?:` `packages/ai-server` y `@vortech/agent-server` podrían ser el mismo sistema con nombres distintos — candidato a fusión.
