---
kind: package-summary
repo: ui
package_name: "@vortech/agent-core"
package_path: ai/agent-core
language: ts
manifest: package.json
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: experimental
---

## 1. Identidad

- **Nombre de paquete:** `@vortech/agent-core`
- **Ruta:** `ai/agent-core/`
- **Manifest:** `ai/agent-core/package.json`
- **Tipo:** librería TypeScript

## 2. Propósito

Núcleo del agente IA de Vortech. Orquesta el ciclo de vida completo del agente: inicialización, ejecución de pasos, coordinación entre runtime, modelos, herramientas y memoria. Es la capa de integración central que conecta todos los demás sub-paquetes `agent-*`.

## 3. Superficie pública

Exporta desde `src/index.ts`:

- `AgentCore` — clase principal; punto de entrada para instanciar y controlar el agente
- `AgentCoreOptions` — tipo de configuración del agente (providers, runtime, políticas)
- `CoreLogger` — interfaz/utilidad de logging interna del core

Módulos fuente:
- `src/core.ts` — implementación de `AgentCore`
- `src/index.ts` — barrel de exports públicos

## 4. Dependencias

- `@vortech/agent-protocol` — tipos y contratos del protocolo
- `@vortech/agent-models` — registro y resolución de modelos LLM
- `@vortech/agent-runtime` — políticas y runtime de ejecución
- `@vortech/agent-tools` — herramientas invocables por el agente
- `@vortech/agent-memory` — persistencia de contexto
- Probables: `@vortech/agent-service`, `@vortech/agent-server` (para comunicación externa)

## 5. Consumidores internos

- `@vortech/agent-extension` — la extensión VS Code instancia `AgentCore` como orquestador principal
- Potencialmente `@vortech/agent-server` si expone el core vía WebSocket

## 6. Estructura interna

```
ai/agent-core/
├── package.json
└── src/
    ├── core.ts       # implementación AgentCore
    └── index.ts      # exports públicos
```

## 7. Estado

Experimental. Surface mínima (2 archivos src). No hay evidencia de tests unitarios ni documentación interna extensa. API sujeta a cambios.

## 8. Dominios que toca

- Ciclo de vida de agente IA
- Orquestación de sub-sistemas (modelos, runtime, tools, memoria)
- Integración con IDE (vía extensión VS Code)

## 9. Observaciones

- La reducida superficie (2 archivos) puede indicar que `core.ts` actúa como thin orchestrator, delegando toda la lógica pesada a los paquetes especializados.
- El nombre `AgentCore` sigue el patrón de nomenclatura consistente con el resto del sub-sistema AI.

## 10. Hipótesis

- `AgentCore` probablemente implementa un patrón de mediator o façade sobre el resto de paquetes `agent-*`.
- `CoreLogger` puede ser un wrapper sobre una utilidad de logging compartida (e.g., `@vortech/lang` o `@vortech/utils`).

## 11. Preguntas abiertas

- ¿`AgentCore` es un singleton o puede instanciarse múltiples veces en paralelo?
- ¿Cómo gestiona errores de modelo (fallback a otro provider)?
- ¿Hay un mecanismo de cancelación/abort del ciclo de vida del agente?
