---
kind: package-summary
repo: ui
package_name: "@vortech/hosting"
package_path: packages/hosting
language: ts
manifest: package.json
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: experimental
---

# @vortech/hosting

## 1. Identidad

- **Nombre:** `@vortech/hosting`
- **Path:** `packages/hosting`
- **Manifest:** `packages/hosting/package.json`
- **Descripción en manifest:** no declarada
- **Lenguaje:** TypeScript

## 2. Propósito

### 2.1 Declarado

No hay descripción en `package.json`.

### 2.2 Inferido con Evidencia

Infraestructura de hosting/transporte para servicios Vortech. La carpeta `src/` expone:

- `http/` — transporte HTTP (`HttpTransport`, `HttpConfig`)
- `broker/` — broker standalone (`StandaloneBroker`, `StandaloneBrokerConfig`)
- `features/` — feature flags o configuración de capacidades
- `to-port/` — probable adaptador de ports/adapters pattern

## 3. Superficie pública

Exports (vía `packages/hosting/src/index.ts`):

| Símbolo | Descripción |
|---|---|
| `HttpTransport` | Clase/interfaz de transporte HTTP |
| `HttpConfig` | Configuración del transporte HTTP |
| `StandaloneBroker` | Broker standalone |
| `StandaloneBrokerConfig` | Configuración del broker |
| `createStandaloneBroker` | Factory function |

## 4. Dependencias

### 4.1 Internas

No determinado. Probable dependencia de `@vortech/core` o `@vortech/apis`.

### 4.2 Externas

No determinado sin instalación de deps.

## 5. Consumidores internos

No determinado. Probable uso por `packages/dev-server` y aplicaciones de demo.

## 6. Estructura interna

```
packages/hosting/
├── package.json
└── src/
    ├── broker/
    ├── features/
    ├── http/
    ├── index.ts
    └── to-port/
```

## 7. Estado

- **Madurez:** experimental
- **Justificación:** Surface pública reducida (solo HTTP transport y broker standalone). La carpeta `to-port/` sugiere refactoring en curso.
- **Build:** no ejecutado
- **Tests:** no detectados
- **Último cambio:** no determinado (requiere `git log`)

## 8. Dominios que toca

- Transporte HTTP
- Infraestructura de broker / mensajería
- Configuración de hosting

## 9. Observaciones

- `to-port/` es un nombre inusual; puede indicar código pendiente de mover o ports del patrón hexagonal.
- La presencia de `broker/` en hosting y también en `packages/dev-server/src/broker/` sugiere posible duplicación o herencia.

## 10. Hipótesis (?:)

- ?: `StandaloneBroker` puede ser una implementación in-process del broker usado en dev, sin dependencia de red.
- ?: `features/` podría ser configuración de capacidades del servidor (ej.: SSE, WebSocket).

## 11. Preguntas abiertas

- ¿`to-port/` es código de migración o es una abstracción de ports (hexagonal)?
- ¿`HttpTransport` implementa una interfaz compartida con otros transportes (WebSocket, etc.)?
- ¿Cuál es la relación entre `@vortech/hosting` y `packages/dev-server`?
