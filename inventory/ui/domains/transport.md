---
kind: domain-inventory
repo: ui
domain: transport
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
implementations_count: 4
languages_involved: [ts]
---

# Dominio — `transport`

## 1. Definición operativa
Capa de comunicación inter-proceso y cliente/servidor — HTTP transport, message broker, data flow, y almacenamiento reactivo. Abstrae la comunicación entre componentes de la plataforma Vortech.

## 2. Implementaciones encontradas

| # | Package                          | Path                                      | Lenguaje | Madurez      | Rol                                        |
|---|----------------------------------|-------------------------------------------|----------|--------------|--------------------------------------------|
| 1 | `@vortech/hosting`               | `packages/hosting`                        | ts       | beta         | HttpTransport, StandaloneBroker, MessageBus |
| 2 | `@vortech/data-flow-common`      | `packages/services/data-flow/common`      | ts       | experimental | Contratos de data flow — stream, pipeline  |
| 3 | `@vortech/storage`               | `packages/services/storage/core`          | ts       | experimental | Almacenamiento con provider pattern        |
| 4 | `@vortech/data`                  | `packages/data`                           | ts       | beta         | Acceso a datos — entities, queries, mappers |

## 3. Responsabilidades cubiertas

- **HTTP transport** → `@vortech/hosting/src/http-transport/`
- **Message broker** → `@vortech/hosting/src/standalone-broker/`
- **Message bus** → `@vortech/hosting/src/message-bus/`
- **Data flow contratos** → `@vortech/data-flow-common/src/`
- **Storage abstraction** → `@vortech/storage/src/` (providers: memory, local, remote)
- **Data entities** → `@vortech/data/src/entities/`
- **Queries y mappers** → `@vortech/data/src/`

## 4. Contratos y tipos clave
- `HttpTransport`, `TransportOptions` → `packages/hosting/src/http-transport/`
- `MessageBroker`, `BrokerMessage` → `packages/hosting/src/standalone-broker/`
- `DataFlowStream`, `DataFlowPipeline` → `packages/services/data-flow/common/src/`
- `StorageProvider`, `StorageEntry` → `packages/services/storage/core/src/`
- `Entity`, `Query`, `DataMapper` → `packages/data/src/`

## 5. Flujos observados
```
Platform
  → @vortech/hosting (HttpTransport — HTTP request/response)
  → @vortech/hosting (StandaloneBroker — pub/sub interno)
  → @vortech/data-flow-common (pipeline de datos reactivo)
  → @vortech/storage (persistencia con provider intercambiable)
  → @vortech/data (entidades de dominio — query/map)
```

## 6. Duplicaciones internas al repo
- `@vortech/hosting` MessageBus y `@vortech/data-flow-common` DataFlowStream pueden solaparse — ambos son sistemas de mensajería/stream.
- `@vortech/data` y `@vortech/drizzle-base-sqlite` — el primero es abstracto, el segundo es implementación SQLite — relación potencialmente bien definida (abstraction + implementation).

## 7. Observaciones cross-language
Solo TypeScript. No hay implementación de transport en Rust, C# o Python en este dominio.

## 8. Estado global del dominio en este repo
- **Completitud:** parcial — contratos presentes pero implementaciones concretas no verificables estáticamente
- **Consistencia interna:** aparentemente consistente
- **Justificación:** `packages/hosting/src/` tiene directorios http-transport, standalone-broker, message-bus — estructura clara. `packages/data/` tiene entidades, queries, mappers — arquitectura repository pattern.

## 9. Sospechas para Fase 2
- `?:` `@vortech/hosting` podría ser el bridge entre la plataforma Atom/DI y el mundo HTTP — candidato a mantener en v-mono como capa de infraestructura.
- `?:` `@vortech/data` podría ser la capa repository que usa `@vortech/drizzle-base-sqlite` como implementación de persistencia.
