---
kind: domain-inventory
repo: ui
domain: http-client
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
implementations_count: 3
languages_involved: [ts]
---

# Dominio — `http-client`

## 1. Definición operativa
Clientes HTTP especializados para servicios externos y APIs de terceros — LLMs (Ollama/llama.cpp), infraestructura Proxmox, y servidor AI interno Vortech.

## 2. Implementaciones encontradas

| # | Package                 | Path                    | Lenguaje | Madurez      | Rol                                          |
|---|-------------------------|-------------------------|----------|--------------|----------------------------------------------|
| 1 | `@vortech/llama-client` | `packages/llama-client` | ts       | experimental | Cliente HTTP para Ollama / llama.cpp API     |
| 2 | `@vortech/proxmox`      | `packages/proxmox-client`| ts      | experimental | Cliente HTTP para API Proxmox VE             |
| 3 | `@vortech/ai-server`    | `packages/ai-server`    | ts       | experimental | Servidor/cliente AI — OpenAI proxy + streaming |

## 3. Responsabilidades cubiertas

- **LLM inference** (Ollama completions, embeddings) → `@vortech/llama-client`
- **Infraestructura Proxmox** (VMs, LXC, nodes, storage) → `@vortech/proxmox`
- **AI proxy server** (OpenAI-compatible API, SSE streaming) → `@vortech/ai-server`

## 4. Contratos y tipos clave
- `LlamaClient`, `LlamaCompletionOptions`, `EmbeddingResult` → `packages/llama-client/src/`
- `ProxmoxClient`, `ProxmoxNode`, `ProxmoxVM` → `packages/proxmox-client/src/`
- `AiServer`, `ChatCompletionOptions`, `StreamResponse` → `packages/ai-server/src/`

## 5. Flujos observados
```
@vortech/agent-models
  → @vortech/llama-client (llamada a modelo local Ollama)
  → @vortech/ai-server (proxy hacia OpenAI o modelo local)

@vortech/devtools / infra tools
  → @vortech/proxmox (gestión de VMs Proxmox)
```

## 6. Duplicaciones internas al repo
- `@vortech/llama-client` y `@vortech/ai-server` pueden solaparse — ambos son clientes/proxies hacia LLMs. `ai-server` puede actuar como capa de abstracción sobre `llama-client`.

## 7. Observaciones cross-language
Solo TypeScript — todos los clientes HTTP son Node.js/TypeScript.

## 8. Estado global del dominio en este repo
- **Completitud:** parcial — 3 clientes HTTP para servicios específicos, sin cliente HTTP genérico visible
- **Consistencia interna:** consistente en patrón (packages separados por servicio)

## 9. Sospechas para Fase 2
- `?:` `@vortech/llama-client` y `@vortech/ai-server` podrían fusionarse — duplican responsabilidades de comunicación con LLMs.
- `?:` `@vortech/proxmox` sugiere que Vortech gestiona infraestructura de servidores con Proxmox — interesante para entender el contexto de despliegue.
