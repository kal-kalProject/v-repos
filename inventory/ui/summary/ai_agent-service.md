---
kind: package-summary
repo: ui
package_name: "@vortech/agent-service"
package_path: ai/agent-service
language: ts
manifest: package.json
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: experimental
---

## 1. Identidad

- **Nombre de paquete:** `@vortech/agent-service`
- **Ruta:** `ai/agent-service/`
- **Manifest:** `ai/agent-service/package.json`
- **Tipo:** librería TypeScript

## 2. Propósito

Capa de servicio del agente IA de Vortech. Gestiona el estado observable del agente y proporciona un store reactivo que puede ser consumido tanto por la GUI como por la extensión VS Code. Actúa como la capa de estado compartido entre los diferentes consumidores del agente.

## 3. Superficie pública

Exporta desde `src/index.ts`. Surface inferida:

- **`store/`** — store de estado del agente (observable/reactivo): estado actual de la sesión, historial de eventos, configuración activa
- Potenciales exports: funciones de acción para modificar el store, selectores de estado, tipos de estado

## 4. Dependencias

- `@vortech/agent-protocol` — tipos de sesión, eventos y snapshots usados en el store
- Probable: librería de estado reactivo (signals, observables RxJS, Zustand, o similar)

## 5. Consumidores internos

- `@vortech/agent-gui` — consume el store para renderizar el estado del agente en la UI
- `@vortech/agent-extension` — usa el store para sincronizar el estado del agente con la extensión VS Code
- `@vortech/agent-core` — puede actualizar el store durante la ejecución del agente

## 6. Estructura interna

```
ai/agent-service/
├── package.json
└── src/
    ├── store/         # store reactivo del estado del agente
    └── index.ts       # barrel exports
```

## 7. Estado

Experimental. Surface mínima (1 directorio + index.ts). Puede estar en etapa temprana o ser intencionalmente delgado como capa de adaptación.

## 8. Dominios que toca

- Gestión de estado del agente IA
- Reactividad / observabilidad del estado
- Sincronización de estado entre GUI e IDE

## 9. Observaciones

- La existencia de una capa de servicio dedicada (en lugar de que cada consumidor gestione su propio estado) sugiere intención de mantener una única fuente de verdad del estado del agente.
- La separación entre `agent-service` (estado) y `agent-core` (lógica) sigue el patrón de separación de concerns clásico en sistemas de agentes.

## 10. Hipótesis

- `store/` probablemente usa signals (si el stack es Angular/Preact) o un store como Zustand/Jotai (si es React puro) para reactividad.
- El store puede serializar su estado para persistencia en `@vortech/agent-memory` o para restaurar sesiones interrumpidas.
- Podría exportar un hook `useAgentStore()` (React) o una función `injectAgentStore()` (Angular) según el contexto de consumo.

## 11. Preguntas abiertas

- ¿Qué librería de estado se usa en `store/` (signals, RxJS, Zustand, Redux, otra)?
- ¿El store es compartido entre procesos (extensión VS Code ↔ servidor WebSocket ↔ GUI) o cada proceso tiene su propia instancia?
- ¿Hay mecanismo de persistencia del store entre sesiones?
