---
kind: package-summary
repo: ui
package_name: "@vortech/chart"
package_path: projects/shared/chart
language: ts
manifest: package.json
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: beta
---

## 1. Identidad

- **Nombre de paquete:** `@vortech/chart`
- **Ruta:** `projects/shared/chart/`
- **Manifest:** `projects/shared/chart/package.json`
- **Tipo:** librería TypeScript (framework-agnostic, shared)

## 2. Propósito

Librería de gráficos de Vortech. Implementa una arquitectura de visualización de datos con controllers (tipos de gráfico), scales (ejes), elements (primitivas visuales), plugins (extensiones), y una plataforma de rendering. Diseñada para ser usada por `@vortech/ui` como backend de gráficos en componentes Angular, pero su arquitectura framework-agnostic la hace potencialmente reutilizable en otros contextos.

## 3. Superficie pública

Exports desde `src/index.ts`. Surface inferida de la estructura de directorios:

- **`controllers/`** — tipos de gráfico: line, bar, pie, scatter, etc. (cada controller maneja un tipo)
- **`core/`** — motor central del gráfico: ciclo de vida, rendering loop, canvas management
- **`elements/`** — primitivas visuales: punto, línea, arco, barra (base del rendering)
- **`helpers/`** — utilidades: formateo de números/fechas, cálculos matemáticos para gráficos
- **`platform/`** — abstracción de la plataforma de rendering (canvas, SVG, o virtual)
- **`plugins/`** — sistema de plugins: tooltips, leyenda, zoom, anotaciones
- **`scales/`** — ejes y escalas: lineal, logarítmica, temporal, categórica
- **`types/`** — tipos TypeScript del sistema de gráficos

## 4. Dependencias

- Sin dependencias Angular (librería shared/agnostic)
- Probable: `chart.js` como base o implementación propia inspirada en Chart.js
- Posible: `@vortech/theming` para aplicar tokens de color del design system a los gráficos

## 5. Consumidores internos

- `@vortech/ui` (workspace:*) — declara `@vortech/chart` como dependencia directa para componentes de visualización (e.g., `<vt-chart>`, `<vt-line-chart>`)

## 6. Estructura interna

```
projects/shared/chart/
├── package.json
└── src/
    ├── controllers/    # tipos de gráfico (line, bar, pie, scatter...)
    ├── core/           # motor central y ciclo de vida
    ├── elements/       # primitivas visuales (point, line, arc, bar)
    ├── helpers/        # utilidades matemáticas y de formateo
    ├── platform/       # abstracción de rendering (canvas/SVG)
    ├── plugins/        # plugins (tooltip, legend, zoom, annotations)
    ├── scales/         # ejes y escalas (linear, log, time, category)
    ├── types/          # tipos TypeScript
    └── index.ts        # barrel exports
```

## 7. Estado

Beta. La estructura completa (8 módulos bien diferenciados) con separación entre core, elements, scales y plugins indica un sistema de gráficos de arquitectura sólida. Está en uso por `@vortech/ui`, lo que implica integración real y cierto nivel de madurez operativa.

## 8. Dominios que toca

- Visualización de datos (charts/graphs)
- Rendering 2D (Canvas o SVG)
- Matemáticas de escalas y proyecciones de datos
- Sistema de plugins extensible para gráficos

## 9. Observaciones

- La arquitectura (controllers + elements + scales + plugins) es idéntica a la de Chart.js, lo que sugiere fuerte inspiración o wrapping de Chart.js con adaptaciones.
- Estar en `projects/shared/` en lugar de `projects/ui/` indica que está diseñado para ser reutilizable más allá de la librería UI Angular.
- La dependencia directa desde `@vortech/ui/package.json` (workspace:*) confirma que es una dependencia de producción real, no solo un peer.

## 10. Hipótesis

- `@vortech/chart` puede ser un fork o wrapper fuertemente customizado de Chart.js, con tipos TypeScript mejorados y integración con el sistema de theming de Vortech.
- `platform/` puede incluir una implementación para Angular (usando `ElementRef<HTMLCanvasElement>`) y potencialmente una para testing headless.
- `plugins/` probablemente incluye al menos: tooltip, leyenda, datalabels, y posiblemente zoom/pan.

## 11. Preguntas abiertas

- ¿`@vortech/chart` depende de `chart.js` como peer dependency o es una implementación completamente propia?
- ¿Hay soporte para SSR (Server-Side Rendering) o solo rendering en browser?
- ¿Los gráficos son accesibles (ARIA para screen readers)?
- ¿`@vortech/theming` está integrado para que los colores de los gráficos sigan el tema actual?
- ¿Hay soporte para animaciones de entrada y transiciones de datos?
