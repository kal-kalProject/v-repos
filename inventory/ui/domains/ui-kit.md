---
kind: domain-inventory
repo: ui
domain: ui-kit
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
implementations_count: 4
languages_involved: [angular, ts]
---

# Dominio — `ui-kit`

## 1. Definición operativa
Componentes UI reutilizables para aplicaciones Angular y TypeScript de la plataforma Vortech. Abarca la librería de componentes Angular principal, el core compartido de directivas/overlays, la capa de DOM utilities, y el sistema de gráficos.

## 2. Implementaciones encontradas

| # | Package                | Path                    | Lenguaje | Madurez          | Rol                                      |
|---|------------------------|-------------------------|----------|------------------|------------------------------------------|
| 1 | `@vortech/ui`          | `projects/ui/ui`        | angular  | maduro-aparente  | Librería principal — 100+ componentes Angular |
| 2 | `@vortech/ui-core`     | `projects/ui/core`      | angular  | beta             | Core: contratos, directivas, overlay, messaging, motion |
| 3 | `@vortech/dom`         | `packages/dom`          | ts       | beta             | Utilidades DOM puras (sin framework) |
| 4 | `@vortech/chart`       | `projects/shared/chart` | ts       | beta             | Gráficos — Chart.js-based con controllers, scales, plugins |

## 3. Responsabilidades cubiertas

- **Componentes interactivos** (accordion, autocomplete, button, select, table, dialog, toast, etc.) → `@vortech/ui`
- **Contratos de componente** (types, variants, identity, node API) → `@vortech/ui-core` + `@vortech/api`
- **Overlays** (dropdown, dialog, tooltip) → `@vortech/ui-core/overlay/`
- **Animaciones/Motion** → `@vortech/ui-core/motion/`
- **DOM utilities** (dimensiones, scroll, focus, manipulación, detección UA) → `@vortech/dom`
- **Gráficos** (line, bar, pie, plugins, scales) → `@vortech/chart`
- **Iconos** → `@vortech/ui-core/icon/`

## 4. Contratos y tipos clave
- `@vortech/ui-core/contracts/` — interfaces principales de componente
- `@vortech/ui-core/hosts/` — host element patterns
- `@vortech/ui/*/ng-package.json` — secondary entry points por componente (100+)
- `@vortech/api` (projects/ui/api) — `ComponentInstance`, `ComponentDefinition`, tipos de variantes

## 5. Flujos observados
```
App Angular
  → importa @vortech/ui (secondary entry point, ej: @vortech/ui/button)
  → componente Button depends on @vortech/ui-core (overlay, directives)
  → @vortech/ui-core depends on @vortech/dom (dimensiones, scroll)
  → @vortech/ui depends on @vortech/chart (para chart component integrado)
```

## 6. Duplicaciones internas al repo
- `projects/ui/api` y `projects/ui/core` ambos modelan conceptos de componente — possible overlap entre `@vortech/api/definitions/` y `@vortech/ui-core/contracts/`.
- `@vortech/dom` y `@vortech/utils` tienen módulos `color` — posible duplicación con `@vortech/common/color`.

## 7. Observaciones cross-language
- El dominio es 100% Angular/TypeScript. No hay implementación de componentes en Rust, C# o Python.
- `@vortech/dom` es framework-agnostic (TypeScript puro), usable sin Angular.

## 8. Estado global del dominio en este repo
- **Completitud:** completo (100+ componentes, core, DOM utils, gráficos)
- **Consistencia interna:** consistente (misma versión Angular 21.x, misma convención ng-packagr)
- **Justificación:** `projects/ui/ui/` tiene secondary entry points para cada componente indicando madurez del patrón. La dependencia de `@vortech/ui` sobre `@vortech/ui-core` está declarada en `package.json`.

## 9. Sospechas para Fase 2
- `?:` `@vortech/ui` es un fork/derivado de PrimeNG — la estructura de secondary entry points (accordion, autocomplete, etc.) coincide exactamente con la arquitectura de PrimeNG — evidencia: nombres de componentes en `projects/ui/ui/`.
- `?:` `@vortech/api` podría ser la capa de abstracción sobre PrimeNG — evidencia: `projects/ui/api/src/components/`, `projects/ui/api/src/identity/`.
