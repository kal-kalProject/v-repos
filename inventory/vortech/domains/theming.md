---
kind: domain-inventory
source_repo: vortech
source_commit: f55e8e0202c3ef2486d845bb87601c7366d76b90
repo: vortech
domain: theming
inventoried_at: 2026-04-24T20:00:00Z
inventoried_by: cursor-inventario-fase1
implementations_count: 3
languages_involved: [ts]
---

# Dominio — `theming`

## 1. Definición operativa
Tokens, presets y utilidades de tema (incl. integración con Prime/Tailwind según manifiestos pnpm): `platform/theming`, `platform/v-theming`, dependencias de UI en catálogos pnpm.

## 2. Implementaciones encontradas

| # | Package | Path | Lenguaje | Madurez | Rol |
|---|---------|------|----------|---------|-----|
| 1 | @vortech/theming | `platform/theming` | ts | beta | theming producto |
| 2 | v-theming | `platform/v-theming` | ts | beta | extensión / vitest |
| 3 | @vortech/v-ui (color, estilos) | `platform/v-ui` | ts | beta | utilidades de color, estilos |

## 3. Responsabilidades cubiertas
- **Paleta / helpers** → `platform/v-theming/tests`, `platform/theming/tests/helpers-integration.test.ts:1`

## 4. Contratos y tipos clave
- Revisar exports en `package.json` de `platform/theming` y `platform/v-theming`.

## 5. Flujos observados
```
App / lib → @vortech/theming / v-theming → componentes
```

## 6. Duplicaciones internas al repo
- Nombres `theming` y `v-theming` sugieren capas paralelas; Fase 2 debe confirmar canonicidad.

## 7. Observaciones cross-language
- Ninguna.

## 8. Estado global del dominio en este repo
- **Completitud:** parcial; tests de integración presentes bajo `platform/theming/tests/`.
- **Consistencia interna:** homónimos `v-*` a revisar.

## 9. Sospechas para Fase 2
- Alinear API pública de `v-theming` y `@vortech/theming`.
