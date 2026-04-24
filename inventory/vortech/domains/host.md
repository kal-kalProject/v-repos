---
kind: domain-inventory
source_repo: vortech
source_commit: f55e8e0202c3ef2486d845bb87601c7366d76b90
repo: vortech
domain: host
inventoried_at: 2026-04-24T20:00:00Z
inventoried_by: cursor-inventario-fase1
implementations_count: 3
languages_involved: [ts]
---

# Dominio — `host`

## 1. Definición operativa
Alojamiento de extensiones, procesos y aplicaciones: `host/application-host`, `host/host`, `packages/hosting` (dominio relacionado de servidor).

## 2. Implementaciones encontradas

| # | Package | Path | Lenguaje | Madurez | Rol |
|---|---------|------|----------|---------|-----|
| 1 | @vortech/application-host | `host/application-host` | ts | beta | application host |
| 2 | @vortech/extensions-host | `host/host` | ts | beta | ext host |
| 3 | @vortech/hosting | `packages/hosting` | ts | beta | hosting utilidades |

## 3. Responsabilidades cubiertas
- **Orquestar plugins / extensiones** (inferido de nombres; confirmar con lectura de `src/` en Fase 2).

## 4. Contratos y tipos clave
- Exports en `package.json` bajo `host/`.

## 5. Flujos observados
```
Extensión / plugin → extensions-host / application-host → runtime (dominio `runtime`)
```

## 6. Duplicaciones internas al repo
- `host` vs `packages/hosting` — posible traslape semántico “hosting”

## 7. Observaciones cross-language
- Ninguna.

## 8. Estado global del dominio en este repo
- **Completitud:** parcial
- **Consistencia interna:** requiere glosario (host vs hosting)

## 9. Sospechas para Fase 2
- Unificar términos: “application-host” vs “hosting”.
