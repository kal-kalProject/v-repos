---
kind: package-summary
repo: ui
package_name: "@vortech/tailwind"
package_path: projects/ui/tailwindcss-plugin
language: ts
manifest: package.json
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: experimental
---

## 1. Identidad

- **Nombre de paquete:** `@vortech/tailwind`
- **Ruta:** `projects/ui/tailwindcss-plugin/`
- **Manifest:** `projects/ui/tailwindcss-plugin/package.json`
- **Tipo:** plugin Tailwind CSS (TypeScript)

## 2. Propósito

Plugin Tailwind CSS para integrar el sistema de theming de Vortech en proyectos que usan Tailwind. Toma los design tokens definidos en `@vortech/theming` y los expone como utilidades, colores y variables CSS de Tailwind, permitiendo que el tema Vortech sea consumido en contextos que no usen los componentes Angular de `@vortech/ui`.

## 3. Superficie pública

Un plugin Tailwind CSS se registra como función en `tailwind.config.js`. Exports esperados:

- **Plugin principal:** función `plugin()` compatible con la API de Tailwind CSS
- Posibles exports auxiliares: configuración de tema (`theme` extension), `preset` de Tailwind para uso como `presets: [vortechPreset]`
- Posiblemente re-exporta tokens de `@vortech/theming` para uso programático

## 4. Dependencias

- `@vortech/theming` — consume `DesignTokens`, `ColorScale`, `default-preset/` para generar las utilidades CSS
- `tailwindcss` (peer dependency) — API de plugin de Tailwind

## 5. Consumidores internos

- Proyectos del monorepo que usen Tailwind CSS (e.g., demos, documentación, proyectos no-Angular)
- `@vortech/agent-gui` (React) — probablemente usa Tailwind para estilo, con este plugin para coherencia con el design system

## 6. Estructura interna

```
projects/ui/tailwindcss-plugin/
├── package.json
└── src/
    └── [implementación del plugin]
```

(Estructura interna no detallada; directorio raíz inferido del path.)

## 7. Estado

Experimental. El plugin es probablemente una capa delgada de adaptación entre `@vortech/theming` y la API de Tailwind. La madurez experimental puede reflejar que la integración está en prueba de concepto o que el API del plugin aún no es estable.

## 8. Dominios que toca

- Integración de design system con Tailwind CSS
- Generación de utilidades CSS custom
- Interoperabilidad Angular (`@vortech/ui`) + Tailwind (proyectos no-Angular)

## 9. Observaciones

- La existencia de un plugin Tailwind junto a una librería Angular de componentes sugiere una estrategia dual: componentes completos (Angular) + utilidades (Tailwind) para proyectos mixtos o no-Angular.
- La separación del plugin en un paquete dedicado (`tailwindcss-plugin/`) en lugar de exportarlo desde `@vortech/theming` directamente indica que la dependencia de `tailwindcss` no debe contaminar el bundle de la librería de theming puro.
- `@vortech/agent-gui` (React) es el caso de uso interno más probable para este plugin.

## 10. Hipótesis

- El plugin expone los `ColorScale` de `@vortech/theming` como colores de Tailwind (e.g., `text-vortech-primary-500`).
- Puede generar variables CSS custom en el `:root` con los tokens de `default-preset/` para asegurar coherencia entre componentes Angular y elementos estilados con Tailwind.
- Puede exportar un `preset` completo de Tailwind para simplificar la configuración: `presets: [require('@vortech/tailwind')]`.

## 11. Preguntas abiertas

- ¿El plugin extiende el tema de Tailwind (`theme.extend`) o lo reemplaza completamente?
- ¿Hay soporte para dark mode de Tailwind integrado con `ColorModes` de `@vortech/theming`?
- ¿El plugin genera clases utilitarias custom más allá de los colores (e.g., spacing, typography)?
- ¿Hay documentación o tests del plugin funcionando con Tailwind v3 y v4?
