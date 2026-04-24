---
kind: package-summary
repo: ui
package_name: "@vortech-presets/material"
package_path: projects/ui/presets/material
language: ts
manifest: package.json
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: beta
---

## 1. Identidad

- **Nombre publicado:** `@vortech-presets/material`
- **Ruta en el repo:** `projects/ui/presets/material`
- **Manifiesto:** `package.json`
- **Lenguaje principal:** TypeScript

## 2. Propósito

Preset de theming "Material Design" para el sistema UI de Vortech. Implementa el vocabulario de tokens de Material Design (MD3 / Material You) mapeados al sistema de theming de Vortech, permitiendo que los componentes adopten la estética de Google Material.

## 3. Superficie pública

- `index.ts` — punto de entrada del preset.
- Tokens Material Design mapeados al sistema de Vortech (colores de rol, tipografía MD, elevación).
- Overrides de componentes con estética Material (ripple, estados hover/focus MD).

## 4. Dependencias

- Infraestructura de theming del workspace.
- No requiere `@angular/material` como dependencia directa; los tokens se replican en el sistema propio de Vortech.

## 5. Consumidores internos

- `projects/ui/demo` — app de demostración para mostrar el aspecto Material de los componentes Vortech.
- Proyectos que necesiten coherencia visual con ecosistemas que ya usan Material Design.

## 6. Estructura interna

```
projects/ui/presets/material/
├── package.json
└── src/
    ├── index.ts
    └── (tokens MD y overrides de componentes)
```

## 7. Estado

- **Madurez:** beta
- Comparte el nivel de madurez con Aura, Lara y Nora; es el único preset beta con una especificación externa de referencia (Material Design Spec).

## 8. Dominios que toca

- **UI / Theming** — tokens Material Design y estilos de componentes.
- **Design System** — implementación del estándar de diseño de Google.
- **Interoperabilidad** — compatibilidad visual con otras apps Material en el ecosistema cliente.

## 9. Observaciones

- La presencia de un preset Material en estado beta (no experimental) indica que es un caso de uso validado para clientes de Vortech.
- Mantener la paridad con las especificaciones de Material Design (que evoluciona) puede suponer carga de mantenimiento adicional.

## 10. Hipótesis

- El preset probablemente implementa MD3 (Material You) en lugar de MD2, dado el contexto temporal (2024–2026).
- Los tokens de color de rol MD3 (`primary`, `on-primary`, `surface`, etc.) se mapean a las variables CSS del sistema Vortech.

## 11. Preguntas abiertas

1. ¿Se implementa MD2 o MD3 (Material You)? ¿Hay soporte para dynamic color?
2. ¿Los componentes de Vortech tienen estados de interacción MD (ripple, state layers) o sólo aplican tokens de color?
3. ¿Se valida la conformidad con la Material Design Spec oficial en algún proceso?
4. ¿Existe conflicto de nombres con `@angular/material` en el workspace?
