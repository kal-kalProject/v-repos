---
kind: package-summary
repo: ui
package_name: "@vortech/agent-protocol"
package_path: ai/agent-protocol
language: ts
manifest: package.json
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: beta
---

## 1. Identidad

- **Nombre de paquete:** `@vortech/agent-protocol`
- **Ruta:** `ai/agent-protocol/`
- **Manifest:** `ai/agent-protocol/package.json`
- **Tipo:** librería TypeScript (tipos y contratos)

## 2. Propósito

Define los tipos y contratos del protocolo del agente IA de Vortech. Cubre mensajería entre componentes, gestión de sesiones, eventos del agente, política de ejecución y estructura de snapshots de estado. Es la fuente de verdad del contrato de comunicación entre todos los paquetes `agent-*`.

## 3. Superficie pública

Exporta desde `src/index.ts`:

**Enumeraciones / union types:**
- `AgentControlMode` — modos de control del agente (manual, automático, etc.)
- `AgentExecutionPolicy` — políticas de ejecución (e.g., ask-before-write, fully-autonomous)
- `AgentPolicyViolation` — tipos de violación de política detectados
- `AgentRunPhase` — fases del ciclo de ejecución (planning, executing, reviewing, etc.)
- `AgentRole` — rol del agente en la conversación (assistant, user, system)
- `AgentModelProvider` — providers LLM soportados

**Tipos de planificación:**
- `PlanItem` — ítem de un plan de acción del agente

**Eventos:**
- `ToolCallEvent` — evento de llamada a herramienta
- `ToolResultEvent` — evento de resultado de herramienta
- `AgentEvent` — unión discriminada de todos los eventos del agente

**Cambios de archivo:**
- `ProposedFileChange` — propuesta de modificación de archivo (diff estructurado)

**Snapshots:**
- `AgentRunSnapshot` — snapshot completo del estado de una ejecución del agente

Módulos fuente:
- `src/control.ts` — tipos de control y política
- `src/messenger.ts` — contratos de mensajería
- `src/protocol.ts` — definición del protocolo general
- `src/session.ts` — tipos de sesión
- `src/index.ts` — barrel de exports

## 4. Dependencias

- Sin dependencias de runtime propias del ecosistema `agent-*` (es la capa de tipos base).
- Posibles dependencias de utilidades de tipos (`@vortech/lang` o `@vortech/utils`).

## 5. Consumidores internos

- `@vortech/agent-core` — usa los contratos del protocolo para orquestar el agente
- `@vortech/agent-runtime` — implementa políticas definidas aquí
- `@vortech/agent-server` — serializa/deserializa los tipos del protocolo para WebSocket
- `@vortech/agent-gui` — consume eventos y snapshots para renderizar la UI
- `@vortech/agent-extension` — usa tipos de sesión y eventos para la extensión VS Code

## 6. Estructura interna

```
ai/agent-protocol/
├── package.json
└── src/
    ├── control.ts     # AgentControlMode, AgentExecutionPolicy, AgentPolicyViolation
    ├── messenger.ts   # contratos de mensajería
    ├── protocol.ts    # protocolo general
    ├── session.ts     # AgentRunPhase, AgentRunSnapshot, sesiones
    └── index.ts       # barrel exports
```

## 7. Estado

Beta. El mayor número de archivos fuente (5) y la riqueza de tipos exportados indica un contrato de protocolo bien definido y relativamente estable. Sin embargo, la ausencia de versión mayor indica que el API puede aún evolucionar.

## 8. Dominios que toca

- Protocolo de comunicación de agente IA
- Mensajería entre extensión IDE, servidor y GUI
- Gestión de sesiones y fases de ejecución
- Política de autonomía del agente

## 9. Observaciones

- La separación de `control.ts`, `messenger.ts`, `protocol.ts` y `session.ts` sugiere una arquitectura de protocolo bien pensada con responsabilidades claras por módulo.
- `ProposedFileChange` implica que el agente puede proponer diffs de archivos de forma estructurada, con posible aprobación del usuario.
- `AgentExecutionPolicy` con variantes como `ask-before-write` apunta a un diseño defensivo orientado a "human-in-the-loop".

## 10. Hipótesis

- `AgentRunSnapshot` probablemente se usa para serializar el estado del agente hacia la GUI y para persistencia en `@vortech/agent-memory`.
- El protocolo puede estar inspirado en el protocolo LSP (Language Server Protocol) o en el protocolo de agente de Anthropic.

## 11. Preguntas abiertas

- ¿El protocolo es compatible con el protocolo de agente de VS Code (`vscode.chat`) o es completamente propietario?
- ¿`AgentEvent` es una unión discriminada con campo `type`? ¿Qué variantes existen más allá de `ToolCallEvent` y `ToolResultEvent`?
- ¿`ProposedFileChange` incluye diff unificado o estructura propia?
