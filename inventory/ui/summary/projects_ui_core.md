---
kind: package-summary
repo: ui
package_name: "@vortech/ui-core"
package_path: projects/ui/core
language: angular
manifest: package.json
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: beta
---

## 1. Identidad

- **Nombre de paquete:** `@vortech/ui-core`
- **Ruta:** `projects/ui/core/`
- **Manifest:** `projects/ui/core/package.json`
- **Tipo:** librería Angular (ng-packagr)

## 2. Propósito

Core de la librería UI Angular de Vortech. Define los contratos base, directivas fundamentales, sistema de overlay, mensajería interna, sistema de motion/animación, iconos, logging y otros pilares transversales sobre los que se construye `@vortech/ui`. No contiene componentes visuales concretos; es la infraestructura compartida por todos los componentes de la librería.

## 3. Superficie pública

Exports inferidos de los directorios `src/`:

- **`app/`** — utilidades de nivel aplicación (inicialización, providers)
- **`bindings/`** — contratos de binding entre componentes y host (inputs/outputs base)
- **`build-constants.ts`** — constantes inyectadas en build time
- **`builders/`** — factories/builders de configuración de componentes
- **`collections/`** — utilidades para colecciones de componentes (selección, navegación)
- **`config/`** — sistema de configuración global de la librería
- **`contracts/`** — interfaces y tipos base: `Focusable`, `Disableable`, `Sizeable`, etc.
- **`directives/`** — directivas base reutilizables (host binding helpers, lifecycle utilities)
- **`filter-match-mode/`** — modos de filtrado para colecciones (contains, startsWith, equals, etc.)
- **`hosts/`** — directivas host para integración con el DOM (overlay host, portal host)
- **`icon/`** — sistema de iconos: registro, tokens, rendering
- **`logging/`** — sistema de logging interno de la librería
- **`messaging/`** — bus de eventos interno entre componentes Angular
- **`motion/`** — sistema de animación/motion (transiciones, keyframes)
- **`overlay/`** — infraestructura de overlay (posicionamiento, estrategias de conectividad con el DOM)

## 4. Dependencias

- Angular Core, CDK (probable `@angular/cdk` para overlay y portal)
- Posible: `@vortech/theming` para tokens de diseño

## 5. Consumidores internos

- `@vortech/ui` — consume prácticamente toda la superficie de `@vortech/ui-core` para construir sus componentes
- `@vortech/api` — usa contratos y tipos base
- `@vortech/editor` — usa el sistema de overlay y contratos base

## 6. Estructura interna

```
projects/ui/core/
├── package.json
└── src/
    ├── app/
    ├── bindings/
    ├── build-constants.ts
    ├── builders/
    ├── collections/
    ├── config/
    ├── contracts/
    ├── directives/
    ├── filter-match-mode/
    ├── hosts/
    ├── icon/
    ├── logging/
    ├── messaging/
    ├── motion/
    └── overlay/
```

## 7. Estado

Beta. La amplitud de responsabilidades (15+ módulos) y el uso directo por `@vortech/ui` (librería madura) indica estabilidad relativa. Sin embargo, al ser capa base de toda la UI, los cambios breaking son de alto impacto.

## 8. Dominios que toca

- Infraestructura de componentes Angular
- Sistema de overlay y posicionamiento
- Animaciones y motion
- Mensajería interna de componentes
- Sistema de iconos
- Contratos base de accesibilidad (Focusable, Disableable)

## 9. Observaciones

- La separación estricta entre `@vortech/ui-core` (infraestructura) y `@vortech/ui` (componentes) es un patrón arquitectónico similar al de Angular CDK vs. Angular Material.
- El módulo `messaging/` como bus de eventos interno evita el acoplamiento directo entre componentes, facilitando composición.
- `overlay/` es uno de los módulos más complejos en librerías UI: gestión de z-index, posicionamiento dinámico, detección de desbordamiento de viewport.

## 10. Hipótesis

- `contracts/` probablemente define interfaces con decoradores Angular (`@HostBinding`, `@Input`) que los componentes concretos de `@vortech/ui` implementan.
- `messaging/` puede basarse en RxJS `Subject` o en signals de Angular para la comunicación inter-componentes.
- `motion/` puede ser una abstracción sobre Angular Animations API o sobre CSS custom properties para animaciones declarativas.

## 11. Preguntas abiertas

- ¿`overlay/` usa `@angular/cdk/overlay` como base o es una implementación propia?
- ¿`messaging/` usa RxJS o signals de Angular?
- ¿`icon/` soporta iconos SVG, icon fonts, o ambos?
- ¿Hay un sistema de theming integrado en `@vortech/ui-core` o se delega completamente a `@vortech/theming`?
