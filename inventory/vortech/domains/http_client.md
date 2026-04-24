---
kind: domain-inventory
source_repo: vortech
source_commit: f55e8e0202c3ef2486d845bb87601c7366d76b90
repo: vortech
domain: http_client
inventoried_at: 2026-04-24T20:00:00Z
inventoried_by: cursor-inventario-fase1
implementations_count: 1
languages_involved: [ts]
---

# Dominio — `http_client`

## 1. Definición operativa
Cliente HTTP de producto bajo `apis/http-client` (`@vortech/http-client`); vitest y tests en estructura estándar.

## 2. Implementaciones encontradas

| # | Package | Path | Lenguaje | Madurez | Rol |
|---|---------|------|----------|---------|-----|
| 1 | @vortech/http-client | `apis/http-client` | ts | maduro-aparente | api HTTP |

## 3. Responsabilidades cubiertas
- **Comunicación HTTP hacia servicios** — a enlazar con `packages/apis` y wire según usos reales (grep Fase 2).

## 4. Contratos y tipos clave
- `apis/http-client` — evidencia: `package.json` local y `apis/http-client/vitest.config.ts` (presente en búsqueda de archivos con nombre vitest)

## 5. Flujos observados
```
Feature → http-client → backend remoto
```

## 6. Duplicaciones internas al repo
- Puede superponerse con `packages/wire` (`fetch` tests en wire); no concluido.

## 7. Observaciones cross-language
- Ninguna.

## 8. Estado global del dominio en este repo
- **Completitud:** un solo paquete bajo `apis/`
- **Consistencia interna:** N/A (único módulo)

## 9. Sospechas para Fase 2
- Documentar qué backplane HTTP usa (fetch vs `express` de raíz) y política de auth.
