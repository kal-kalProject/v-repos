---
kind: package-summary
repo: ui
package_name: "@vortech/ui"
package_path: projects/ui/ui
language: angular
manifest: package.json
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: maduro-aparente
---

## 1. Identidad

- **Nombre de paquete:** `@vortech/ui`
- **Ruta:** `projects/ui/ui/`
- **Manifest:** `projects/ui/ui/package.json`
- **Tipo:** librería Angular (ng-packagr con secondary entry points)

## 2. Propósito

Librería de componentes UI Angular de Vortech. Proporciona más de 100 componentes Angular listos para producción, organizados como secondary entry points ng-packagr para permitir tree-shaking granular. Es la librería de componentes principal del monorepo y el artefacto Angular de mayor madurez del ecosistema `ui`.

## 3. Superficie pública

Componentes organizados como secondary entry points (importación independiente por componente). Catálogo inferido incluye:

- **Navegación:** accordion, tabs, breadcrumb, menu, navigation
- **Entrada de datos:** autocomplete, checkbox, datepicker, input, select, radio, slider, toggle, textarea
- **Visualización:** avatar, badge, card, carousel, chip, table, timeline, tag
- **Feedback:** dialog, tooltip, popover, toast/snackbar, progress, spinner
- **Layout:** divider, grid, spacer
- **Acción:** button, button-group, icon-button, split-button
- **Otros:** tree, virtual-scroll, drag-drop

Cada componente puede importarse como `@vortech/ui/button`, `@vortech/ui/dialog`, etc.

## 4. Dependencias

- `@vortech/ui-core` (workspace:*) — infraestructura base obligatoria
- `@vortech/chart` (workspace:*) — para componentes de visualización de datos
- Angular Core, Common, Forms, Animations (peer dependencies)
- Probable: `@vortech/theming` para tokens de diseño

## 5. Consumidores internos

- Aplicaciones demo en `demos/` del monorepo
- `@vortech/api` — puede hacer referencia a tipos de componentes
- Proyectos consumidores externos que importan la librería

## 6. Estructura interna

```
projects/ui/ui/
├── package.json            # declara secondary entry points
└── src/
    ├── accordion/
    ├── autocomplete/
    ├── avatar/
    ├── badge/
    ├── button/
    ├── card/
    ├── carousel/
    ├── checkbox/
    ├── dialog/
    ├── datepicker/
    ├── table/
    └── [100+ componentes más...]
```

## 7. Estado

Maduro-aparente. La cantidad de componentes (100+) implementados con secondary entry points ng-packagr indica un nivel de desarrollo avanzado y una API relativamente estable. La madurez real depende del estado de tests y coverage, no verificables en inventario estático.

## 8. Dominios que toca

- Componentes UI Angular de aplicación general
- Design system de Vortech
- Accesibilidad (ARIA, keyboard navigation) — esperado en librería de este tipo
- Tree-shaking y optimización de bundle (via secondary entry points)

## 9. Observaciones

- El uso de secondary entry points ng-packagr (`@vortech/ui/button` en lugar de `@vortech/ui`) es la arquitectura correcta para librerías de componentes de gran tamaño: permite que los bundlers eliminen componentes no usados.
- La dependencia de `@vortech/chart` (workspace:*) indica que algunos componentes de `@vortech/ui` incluyen visualizaciones de datos (e.g., un componente `<vt-chart>`).
- Al ser la librería Angular principal, `@vortech/ui` es el indicador más claro del estado de madurez del monorepo en su conjunto.

## 10. Hipótesis

- Cada directorio de componente tiene al menos: `*.component.ts`, `*.module.ts` (o standalone), `*.component.html`, `*.component.scss`, y un `public-api.ts`.
- Los componentes son probablemente Angular standalone (post Angular 14) dado el contexto temporal del proyecto.
- El datepicker y el autocomplete son los componentes más complejos y los más propensos a bugs/deuda técnica.

## 11. Preguntas abiertas

- ¿Los componentes son Angular Standalone o basados en NgModule?
- ¿Hay storybook u otro sistema de documentación interactiva de componentes?
- ¿Cuál es el estado de coverage de tests (unit + e2e)?
- ¿Los componentes implementan ARIA completo para accesibilidad?
- ¿Hay un changelog/versioning semántico para gestionar breaking changes de la API de componentes?
