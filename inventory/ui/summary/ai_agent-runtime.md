---
kind: package-summary
repo: ui
package_name: "@vortech/agent-runtime"
package_path: ai/agent-runtime
language: ts
manifest: package.json
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: experimental
---

## 1. Identidad

- **Nombre de paquete:** `@vortech/agent-runtime`
- **Ruta:** `ai/agent-runtime/`
- **Manifest:** `ai/agent-runtime/package.json`
- **Tipo:** librería TypeScript

## 2. Propósito

Runtime del agente IA de Vortech. Implementa las políticas de ejecución (cuándo actuar de forma autónoma, cuándo pedir confirmación), gestiona la construcción y ensamblado de prompts para el modelo LLM, y aplica reglas de comportamiento del agente durante las distintas fases de ejecución.

## 3. Superficie pública

Exporta desde `src/index.ts`. Surface inferida de la estructura:

- **Policy:** implementación de `AgentExecutionPolicy` (definida en `@vortech/agent-protocol`) — lógica de decisión sobre autonomía
- **Prompt:** constructores y gestores de prompts — ensamblado de contexto, system prompt, historial
- **Rules:** reglas de comportamiento aplicadas durante la ejecución (e.g., restricciones de herramientas, límites de iteraciones)

## 4. Dependencias

- `@vortech/agent-protocol` — consume `AgentExecutionPolicy`, `AgentPolicyViolation`, `AgentRunPhase`, `PlanItem`
- `@vortech/agent-models` — solicita completions al modelo resuelto
- `@vortech/agent-tools` — invoca herramientas durante la ejecución
- `@vortech/agent-memory` — recupera contexto persistido para incluir en prompts

## 5. Consumidores internos

- `@vortech/agent-core` — delega la ejecución de pasos del agente al runtime

## 6. Estructura interna

```
ai/agent-runtime/
├── package.json
└── src/
    ├── policy/        # implementación de AgentExecutionPolicy
    ├── prompt/        # construcción y gestión de prompts
    ├── rules/         # reglas de comportamiento del agente
    └── index.ts       # barrel exports
```

## 7. Estado

Experimental. Tres subdirectorios de lógica sustancial, pero sin madurez declarada. Es probable que las políticas y reglas estén en activo desarrollo.

## 8. Dominios que toca

- Política de autonomía del agente IA
- Ingeniería de prompts (prompt engineering)
- Ciclo de razonamiento: planificación → ejecución → revisión
- Seguridad y límites de comportamiento del agente

## 9. Observaciones

- La separación entre `policy/` y `rules/` puede indicar que `policy` controla el flujo de alto nivel (autonomía vs. confirmación) mientras `rules` aplica restricciones granulares (e.g., "no borrar archivos fuera del workspace").
- `prompt/` como módulo separado sugiere que la ingeniería de prompts es una preocupación de primera clase, con posible soporte para plantillas o composición modular de system prompts.

## 10. Hipótesis

- `policy/` probablemente implementa la interfaz `AgentExecutionPolicy` como una máquina de estados que transiciona entre `AgentRunPhase` values.
- `rules/` podría incluir reglas expresadas como predicados evaluados antes de ejecutar cada herramienta.
- `prompt/` puede tener templates para diferentes tipos de tareas (coding, debugging, explanation).

## 11. Preguntas abiertas

- ¿El runtime soporta múltiples pasos de razonamiento (chain-of-thought, ReAct) o solo single-step?
- ¿Cómo se propagan las `AgentPolicyViolation` al usuario?
- ¿Las reglas son configurables por el usuario o están hardcoded?
- ¿Hay mecanismo de timeout o límite de tokens por run?
