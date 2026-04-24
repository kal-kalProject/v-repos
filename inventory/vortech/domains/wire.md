---
kind: domain-inventory
source_repo: vortech
source_commit: f55e8e0202c3ef2486d845bb87601c7366d76b90
repo: vortech
domain: wire
inventoried_at: 2026-04-24T20:00:00Z
inventoried_by: cursor-inventario-fase1
implementations_count: 1
languages_involved: [ts]
---

# Dominio — `wire`

## 1. Definición operativa
Capa de mensajería y contratos de transporte a nivel de aplicación Vortech: paquete `@vortech/wire` con suite de pruebas `packages/wire/tests/`.

## 2. Implementaciones encontradas

| # | Package | Path | Lenguaje | Madurez | Rol |
|---|---------|------|----------|---------|-----|
| 1 | @vortech/wire | `packages/wire` | ts | maduro-aparente | broker, client, transport |

## 3. Responsabilidades cubiertas
- **Broker, middleware, socket.io** — evidencia: `packages/wire/tests/socketio.test.ts:1` y múltiples `*.test.ts` en el mismo directorio.

## 4. Contratos y tipos clave
- Ver `packages/wire/src` y pruebas para superficie pública.

## 5. Flujos observados
```
App → wire broker → (transport: socket / fetch) → servidor
```

## 6. Duplicaciones internas al repo
- `wire` y el árbol `sokectio/` + `packages/sockets` tocan canales similares; riesgo de superposición conceptual (no concluida).

## 7. Observaciones cross-language
- Ninguna.

## 8. Estado global del dominio en este repo
- **Completitud:** buena señal de pruebas unitarias
- **Consistencia interna:** a contrastar con `sokectio/`

## 9. Sospechas para Fase 2
- Definir frontera entre `@vortech/wire` y el fork `sokectio/*`.
