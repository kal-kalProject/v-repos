---
kind: package-summary
repo: ui
package_name: "@vortech-presets/cnc-monkey"
package_path: projects/ui/presets/cnc-monkey
language: ts
manifest: package.json
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: experimental
---

## 1. Identidad

- **Nombre publicado:** `@vortech-presets/cnc-monkey`
- **Ruta en el repo:** `projects/ui/presets/cnc-monkey`
- **Manifiesto:** `package.json`
- **Lenguaje principal:** TypeScript

## 2. Propósito

Preset de theming "CNC Monkey" para el sistema UI de Vortech. Define el design system oscuro especializado para la aplicación CNC Studio de mecanizado — con una estética industrial y de alto contraste adecuada para entornos de taller y control de máquinas CNC.

## 3. Superficie pública

- `index.ts` — punto de entrada del preset.
- Tokens de diseño de estética oscura industrial (paleta de alto contraste, tipografía legible en condiciones difíciles).
- Overrides de componentes adaptados a la UX de software de control CNC.

## 4. Dependencias

- Infraestructura de theming del workspace.
- Acoplado semánticamente a `projects/ui/cnc-monkey` (la app SSR que consume este preset).

## 5. Consumidores internos

- `projects/ui/cnc-monkey` — app Angular SSR principal que usa este preset como identidad visual.
- `projects/ui/demo` — posiblemente disponible como opción de tema para demostración.

## 6. Estructura interna

```
projects/ui/presets/cnc-monkey/
├── package.json
└── src/
    ├── index.ts
    └── (tokens oscuros industriales y overrides CNC)
```

## 7. Estado

- **Madurez:** experimental
- Acoplado fuertemente al desarrollo de la app `projects/ui/cnc-monkey`; evoluciona junto a ella.
- La naturaleza SSR de la app puede plantear retos adicionales para la aplicación del tema.

## 8. Dominios que toca

- **UI / Theming** — tokens oscuros e industriales para app CNC.
- **Design System** — identidad visual de producto CNC Monkey.
- **Manufactura / CNC** — UX adaptada a contexto de taller de mecanizado.

## 9. Observaciones

- Es el único preset del conjunto explícitamente diseñado para un contexto físico/industrial (taller CNC).
- El tema oscuro podría ser obligatorio por consideraciones de ergonomía en entornos de taller (pantallas en ambientes con luz variable).
- El nombre "Monkey" es un indicador de que la herramienta puede tener un tono playful a pesar del contexto industrial.

## 10. Hipótesis

- Los tokens de color probablemente priorizan legibilidad sobre estética (alto contraste, colores de acento vibrantes para alertas de estado de máquina).
- Puede incluir tokens específicos de dominio CNC: estados de ejecución, alarmas, posición de ejes.

## 11. Preguntas abiertas

1. ¿El preset soporta modo claro o es exclusivamente oscuro por diseño?
2. ¿Existen tokens para estados específicos de CNC (running, alarm, idle, homing)?
3. ¿El preset se ha validado en hardware de display industrial (bajas resoluciones, pantallas táctiles)?
4. ¿El SSR de la app afecta al mecanismo de aplicación del preset en el primer render?
