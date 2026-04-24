---
kind: domain-inventory
source_repo: vortech
source_commit: f55e8e0202c3ef2486d845bb87601c7366d76b90
repo: vortech
domain: layout
inventoried_at: 2026-04-24T20:00:00Z
inventoried_by: cursor-inventario-fase1
implementations_count: 4
languages_involved: [ts]
---

# Dominio — `layout`

## 1. Definición operativa
Sistema de layout estilo workbench, grillas, y componentes estructurales: `platform/layout`, `platform/v-layout`, apps Angular que componen vistas.

## 2. Implementaciones encontradas

| # | Package | Path | Lenguaje | Madurez | Rol |
|---|---------|------|----------|---------|-----|
| 1 | @vortech/layout | `platform/layout` | ts | beta | layout base |
| 2 | v-layout | `platform/v-layout` | ts | beta | extensión |
| 3 | v-sdk / demo | `platform/sdk`, `platform/sdk/demo` | ts / angular | beta | demostración |
| 4 | @vortech/v-ui (layout-related) | `platform/v-ui` | ts | beta | primitivas UI (árboles, etc.) |

## 3. Responsabilidades cubiertas

- **Contenedores, paneles, árbol** → rastreable en nombres de directivas/componentes bajo `platform/v-ui` y pruebas `platform/v-components`.

## 4. Contratos y tipos clave

- Ver `package.json` de cada paquete; superficie pública en `src/`.

## 5. Flujos observados

```
App Angular → @vortech/v-ui → v-layout / layout
```

## 6. Duplicaciones internas al repo
- `platform/layout` y `platform/v-layout` comparten responsabilidad nominal de “layout” — posible solapamiento.

## 7. Observaciones cross-language
- Ninguna.

## 8. Estado global del dominio en este repo
- **Completitud:** parcial.
- **Consistencia interna:** requiere mapa de dependencias reales.
- **Justificación:** múltiples paquetes con prefijo `v-` bajo `platform/`.

## 9. Sospechas para Fase 2
- Diferenciar claramente `layout` vs `v-layout` en contratos y README.
