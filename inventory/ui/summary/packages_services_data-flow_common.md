---
kind: package-summary
repo: ui
package_name: "@vortech/data-flow-common"
package_path: packages/services/data-flow/common
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
| name          | `@vortech/data-flow-common`                        |
| version       | 0.0.1                                              |
| directorio    | `packages/services/data-flow/common`               |
| type          | module (ESM) — no declarado explícitamente         |
| private       | no especificado                                    |
| entrypoint    | `dist/index.mjs`                                   |
| types         | `dist/index.d.mts`                                 |

> Ubicado bajo `packages/services/data-flow/` — es el paquete de tipos compartidos de un sistema de data flow más amplio (probablemente con múltiples sub-paquetes: executor, runner, etc.).

## 2. Propósito

### 2.1 Declarado

Sin campo `description` en `package.json`.

### 2.2 Inferido + Evidencia

Paquete de **tipos compartidos** para el sistema de data flow de Vortech. Define el contrato entre las distintas capas del sistema de automatización/orquestación de tareas:

- **Steps**: tipos para acciones atómicas en un flujo — navegación, clicks, input de texto, selección, scroll, espera, capturas (screenshot, response), extracción, aserciones, pausas humanas, condiciones.
- **Tasks / Workspace**: `DataFlowTask`, `DataFlowWorkspace`, `TaskDependency` — unidades de trabajo composables.
- **Results**: `TaskResult`, `FlowResult`, `StepResult`, `FlowSummary`, `CapturedResponse` — resultado de ejecución.
- **Capture**: `CaptureSession`, `CapturedInteraction`, `InteractionCaptureConfig` — captura de interacciones de usuario.
- **API / Protocol**: `WsClientMessage`, `WsServerMessage`, `ExecuteFlowRequest`, `ExecuteFlowResponse` — protocolo WebSocket para ejecución remota.
- **Logger**: `FlowLogger`, `LogLevel`, `ProgressEvent`.

Evidencia: `packages/services/data-flow/common/src/index.ts:1-60`.

Los tipos de steps (click, type, scroll, navigate) sugieren un motor de **automatización web** (similar a Playwright/Puppeteer) con captura de datos, aserciones y reanudación humana.

## 3. Superficie pública

Entry points (campo `exports`):

| Export | Archivo dist       |
|--------|--------------------|
| `.`    | `dist/index.mjs`   |

Tipos exportados (todos son `type`, sin valores en runtime):

| Módulo     | Tipos principales                                                                  |
|------------|------------------------------------------------------------------------------------|
| step.ts    | `StepAction`, `StepStatus`, `StepCondition`, `FailureStrategy`, `TaskStep`, `NavigateStep`, `ClickStep`, `TypeStep`, `SelectStep`, `ScrollStep`, `WaitStep`, `CaptureScreenshotStep`, `CaptureResponseStep`, `ExtractStep`, `AssertStep`, `ConditionalStep`, `HumanPauseStep`, `AnyStep` |
| task.ts    | `TaskDependency`, `DataFlowTask`, `DataFlowWorkspace`                            |
| result.ts  | `TaskStatus`, `FlowStatus`, `StepResult`, `StepError`, `TaskResult`, `FlowResult`, `FlowSummary`, `CapturedResponse` |
| capture.ts | `InteractionCaptureConfig`, `InteractionType`, `CapturedInteraction`, `CaptureSession`, `CaptureProgressData` |
| api.ts     | `ExecutionMode`, `LogLevel`, `FlowLogger`, `ProgressEvent`, `WsClientMessage`, `WsServerMessage`, `ExecuteFlowRequest`, `ExecuteFlowResponse` |

> **Solo tipos** — el paquete no exporta ningún valor en runtime. Es un paquete de contratos puro.

## 4. Dependencias

### 4.1 Internas

Ninguna.

### 4.2 Externas

Ninguna (solo devDependencies de tooling).

> Este es el único paquete del inventario completamente libre de dependencias — un paquete de tipos puro.

## 5. Consumidores internos

Por diseño, debe ser consumido por todos los paquetes del sistema data-flow:

- El ejecutor de flows (probablemente `packages/services/data-flow/executor/` o similar).
- El runner/orquestador.
- El cliente que envía `ExecuteFlowRequest` vía WebSocket.
- El servidor que procesa `WsClientMessage`.

No se detectaron referencias directas en `package.json` del workspace en la revisión estática.

## 6. Estructura interna

```
packages/services/data-flow/common/src/
├── api.ts       # Protocolo WebSocket + logger + execution mode
├── capture.ts   # Tipos de captura de interacciones
├── index.ts     # Barrel público (solo type re-exports)
├── result.ts    # Resultados de tasks y flows
├── step.ts      # 15+ tipos de steps atómicos
└── task.ts      # DataFlowTask, DataFlowWorkspace, TaskDependency
```

## 7. Estado

| Campo          | Valor                                                                               |
|----------------|-------------------------------------------------------------------------------------|
| Madurez        | experimental                                                                        |
| Justificación  | v0.0.1, sin descripción, sin tests, paquete de tipos sin implementación propia      |
| Build          | no ejecutado (inventario estático)                                                  |
| Tests          | No detectados (solo tipos, sin lógica testeable en este paquete)                   |
| Último cambio  | desconocido (no se accedió a git log)                                               |

## 8. Dominios que toca

- Automatización web (browser automation)
- Orquestación de tareas / pipelines
- Captura de interacciones de usuario
- Protocolo WebSocket para ejecución remota
- Testing / QA automatizado

## 9. Observaciones

- `HumanPauseStep` es inusual — implica que el sistema puede pausar un flujo automatizado y esperar intervención humana antes de continuar. Sugiere flujos híbridos human-in-the-loop.
- `ConditionalStep` indica lógica de branching en el flujo — los flows no son lineales.
- `WsClientMessage` / `WsServerMessage` — el protocolo es bidireccional, posiblemente para progress streaming y control remoto en tiempo real.
- La estructura del flujo (Workspace → Tasks → Steps) es jerárquica de 3 niveles.

## 10. Hipótesis

- El sistema de data flow es un motor de automatización de browser con capacidad de captura — similar a Playwright pero diseñado para pipeline de datos estructurados (no solo testing).
- `CaptureResponseStep` y `CapturedResponse` sugieren interceptación de peticiones HTTP durante la automatización.
- El protocolo WebSocket permite ejecutar flows remotamente (desde el servidor AI o desde la extensión VS Code).
- `ExecutionMode` probablemente incluye modos: `headless`, `headed`, `dry-run`.

## 11. Preguntas abiertas

1. ¿Existe un paquete `packages/services/data-flow/executor/` que implementa la ejecución de estos tipos?
2. ¿`HumanPauseStep` es para aprobación manual en pipelines de CI o para flujos de demostración/grabación?
3. ¿El protocolo WebSocket usa el socket.io de `@vortech/ai-server` o es un WS independiente?
4. ¿`DataFlowWorkspace` puede contener múltiples tasks con dependencias entre ellas (DAG)?
