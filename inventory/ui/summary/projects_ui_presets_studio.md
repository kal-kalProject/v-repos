---
kind: package-summary
repo: ui
package_name: "@vortech-presets/studio"
package_path: projects/ui/presets/studio
language: ts
manifest: package.json
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: experimental
---

## 1. Identidad

- **Nombre publicado:** `@vortech-presets/studio`
- **Ruta en el repo:** `projects/ui/presets/studio`
- **Manifiesto:** `package.json`
- **Lenguaje principal:** TypeScript

## 2. Propósito

Preset de theming "Studio" para el sistema UI de Vortech. Define el design system propio de la aplicación Studio de Vortech — una herramienta de diseño/edición visual — con tokens específicos que reflejan su identidad de marca y necesidades de UX de herramienta creativa.

## 3. Superficie pública

- `index.ts` — punto de entrada del preset.
- Tokens de diseño específicos de la app Studio (paleta, tipografía, layout de paneles).
- Overrides de componentes adaptados a la UX de herramienta de diseño.

## 4. Dependencias

- Infraestructura de theming del workspace.
- Acoplado semánticamente a `projects/ui/studio` (la app que consume este preset).

## 5. Consumidores internos

- `projects/ui/studio` — app principal que usa este preset como identidad visual.
- `projects/ui/demo` — posiblemente como opción de tema en el showcasing.

## 6. Estructura interna

```
projects/ui/presets/studio/
├── package.json
└── src/
    ├── index.ts
    └── (tokens y overrides del design system Studio)
```

## 7. Estado

- **Madurez:** experimental
- Acoplado al desarrollo de la app `projects/ui/studio`; evoluciona con ella.
- No tiene sentido como preset genérico hasta que la app Studio madure.

## 8. Dominios que toca

- **UI / Theming** — tokens y estilos propios de Studio.
- **Design System** — identidad visual de la herramienta Studio.
- **Producto** — brand específico de aplicación Vortech.

## 9. Observaciones

- Es un preset de "product brand" a diferencia de Aura/Lara/Nora que son presets genéricos intercambiables.
- El preset y la app comparten el nombre "studio", lo que facilita su asociación pero también indica un acoplamiento fuerte.

## 10. Hipótesis

- Los tokens de Studio probablemente son más especializados que los de Aura/Lara/Nora, con variables para conceptos específicos de la herramienta (canvas, toolbar, paneles laterales).
- Podría evolucionar hacia un design token system propio con Figma tokens o equivalente.

## 11. Preguntas abiertas

1. ¿El preset Studio está pensado para ser reutilizado en otras apps o es exclusivo de `projects/ui/studio`?
2. ¿Existe un sistema de diseño en Figma o similar que sea la fuente de verdad de los tokens Studio?
3. ¿Cuándo se considera que este preset puede pasar a beta? ¿Está ligado al estado de la app Studio?
4. ¿El preset soporta modo oscuro o es solo un tema claro?
