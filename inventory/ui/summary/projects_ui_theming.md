---
kind: package-summary
repo: ui
package_name: "@vortech/theming"
package_path: projects/ui/theming
language: ts
manifest: package.json
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: beta
---

## 1. Identidad

- **Nombre de paquete:** `@vortech/theming`
- **Ruta:** `projects/ui/theming/`
- **Manifest:** `projects/ui/theming/package.json`
- **Tipo:** librería TypeScript (agnóstica de framework)

## 2. Propósito

Sistema de theming de Vortech. Define y gestiona design tokens, variables CSS, modos de color (claro/oscuro/sistema), escalas de color y presets de tema por defecto. Es la fuente de verdad del sistema de diseño visual de Vortech y la base sobre la que `@vortech/ui` y `@vortech/tailwind` construyen sus estilos.

## 3. Superficie pública

Exports desde `src/index.ts`:

**Tipos de tokens y configuración:**
- `ThemeOptions` — opciones de configuración de un tema completo
- `StyleOptions` — opciones de estilo (propiedades CSS mapeadas)
- `DesignTokens` — colección completa de tokens de diseño del sistema
- `ColorScale` — escala de color (50–950, similar a Tailwind)
- `ColorModes` — modos de color soportados (`light`, `dark`, `system`)
- `TokenValue` — tipo base para valores de tokens (string, number, CSS value)

**Módulos fuente:**
- **`components/`** — tokens específicos por componente (button tokens, input tokens, etc.)
- **`components-style-tokens.ts`** — mapeo de tokens a propiedades CSS por componente
- **`core/`** — tokens base del sistema (spacing, typography, border-radius, shadows)
- **`default-preset/`** — tema por defecto de Vortech (implementación concreta de `ThemeOptions`)
- **`index.ts`** — barrel exports

## 4. Dependencias

- Sin dependencias de Angular (librería framework-agnostic)
- Posible integración con `@vortech/tailwind` (que la consume para generar utilidades CSS)

## 5. Consumidores internos

- `@vortech/ui` — aplica tokens de `@vortech/theming` para estilar sus componentes Angular
- `@vortech/ui-core` — puede usar tokens para sistema de motion, overlay, etc.
- `@vortech/tailwind` — usa tokens de `@vortech/theming` para generar el plugin Tailwind
- `@vortech/api` — posiblemente referencia tokens por variante de componente

## 6. Estructura interna

```
projects/ui/theming/
├── package.json
└── src/
    ├── components/               # tokens por componente
    ├── components-style-tokens.ts  # mapeo tokens → CSS properties
    ├── core/                     # tokens base (spacing, typography, colors)
    ├── default-preset/           # preset de tema por defecto de Vortech
    └── index.ts                  # barrel exports
```

## 7. Estado

Beta. La estructura bien organizada (core vs. components, preset separado) y el conjunto rico de tipos exportados (`ThemeOptions`, `DesignTokens`, `ColorScale`, `ColorModes`) indica un sistema de theming maduro conceptualmente. La madurez beta refleja que el API de tokens puede aún evolucionar.

## 8. Dominios que toca

- Design system y design tokens
- CSS custom properties / variables CSS
- Modos de color (light/dark mode)
- Escalas de color y tipografía
- Theming de componentes (tokens por componente)

## 9. Observaciones

- Ser framework-agnostic (TypeScript puro, no Angular) es una decisión estratégica: permite que `@vortech/theming` sea consumida por el plugin Tailwind, por herramientas de documentación, o por futuros frameworks sin acoplarse a Angular.
- La existencia de `components/` con tokens por componente (en lugar de solo tokens globales) indica un sistema de design tokens de dos niveles: global tokens → component tokens, siguiendo las mejores prácticas actuales (Theo, Style Dictionary).
- `default-preset/` como directorio separado facilita que consumidores puedan crear presets personalizados sin modificar los defaults.

## 10. Hipótesis

- `DesignTokens` es el objeto que mapea token names a valores CSS (e.g., `{ 'color-primary-500': '#6366f1' }`).
- `components-style-tokens.ts` puede generar las variables CSS (`--vt-button-background: var(--vt-color-primary-500)`) para cada componente.
- `ColorScale` puede ser generada programáticamente a partir de un color base usando algoritmos de escala perceptual.
- El sistema puede integrarse con herramientas como Style Dictionary o Theo para exportar tokens en múltiples formatos.

## 11. Preguntas abiertas

- ¿Los tokens se distribuyen como CSS custom properties, como variables JS, o como ambos?
- ¿Hay soporte para temas personalizados por usuario (multi-tenancy)?
- ¿`ColorModes` tiene integración automática con `prefers-color-scheme` o requiere configuración manual?
- ¿Los component tokens siguen alguna especificación estándar (W3C Design Tokens, Theo)?
