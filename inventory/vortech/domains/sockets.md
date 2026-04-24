---
kind: domain-inventory
source_repo: vortech
source_commit: f55e8e0202c3ef2486d845bb87601c7366d76b90
repo: vortech
domain: sockets
inventoried_at: 2026-04-24T20:00:00Z
inventoried_by: cursor-inventario-fase1
implementations_count: 18
languages_involved: [ts, js]
---

# Dominio — `sockets`

## 1. Definición operativa
WebSockets, engine.io, socket.io: implementación embebida bajo `sokectio/` (árbol al estilo upstream) y fachada de producto en `packages/sockets` + referencias en `packages/wire`.

## 2. Implementaciones encontradas (resumen)

| # | Package | Path | Lenguaje | Madurez | Rol |
|---|---------|------|----------|---------|-----|
| 1..n | múltiples | `sokectio/*` (engine.io, socket.io, …) | ts | maduro-aparente | implementación de referencia / vendor |
| n+1 | @vortech/sockets | `packages/sockets` | ts | maduro-aparente | integración Vortech |

## 3. Responsabilidades cubiertas
- **Transporte evented** — p.ej. comentarios `TODO` en `sokectio/engine.io/lib/userver.ts:321` (evidencia de código activo y deuda en upstream).

## 4. Contratos y tipos clave
- Superficies amplias bajo `sokectio/socket.io/lib/*.ts` (código forkeado de ecosistema socket.io).

## 5. Flujos observados
```
Cliente ↔ engine.io / socket.io ↔ wire / hosting
```

## 6. Duplicaciones internas al repo
- Duplicación funcional posible: `sokectio` + `node_modules` ausente aún, `@vortech/sockets` y `@vortech/wire` — documentar intención de Fase 2.

## 7. Observaciones cross-language
- Ninguna.

## 8. Estado global del dominio en este repo
- **Completitud:** rica bajo `sokectio/`, riesgo de peso y mantenimiento
- **Consistencia interna:** nombre de carpeta `sokectio` no alineado con términos de negocio

## 9. Sospechas para Fase 2
- Decidir si `sokectio` se mantiene como submódulo/vendor con política de actualización explícita.
