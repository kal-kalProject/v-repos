---
kind: package-summary
repo: ui
package_name: "studio"
package_path: projects/ui/studio
language: angular
manifest: angular.json
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: experimental
---

## 1. Identidad

- **Nombre publicado:** `studio` (Angular project dentro de `angular.json`)
- **Ruta en el repo:** `projects/ui/studio`
- **Manifiesto:** `angular.json`
- **Lenguaje principal:** Angular / TypeScript

## 2. Propósito

Aplicación Angular "Studio" — herramienta de diseño y edición visual de Vortech. Es una aplicación de creación/edición con interfaz tipo canvas o editor visual, probablemente orientada a diseñadores o desarrolladores que trabajan con el sistema UI Vortech. Sirve en el puerto 4500.

## 3. Superficie pública

- No tiene API pública exportada; es una aplicación ejecutable.
- Interfaz de usuario de edición visual (canvas, paneles, herramientas).
- Posiblemente exporta artefactos de diseño (tokens, componentes configurados).

## 4. Dependencias

- `@vortech-presets/studio` — preset que define la identidad visual de esta app.
- La librería de componentes UI de Vortech.
- Angular 17+ (standalone components presumiblemente).
- Posiblemente librerías de drag-and-drop o canvas rendering.

## 5. Consumidores internos

- No es consumida por otros paquetes; es un artefacto de producto.
- Usada por el equipo Vortech para diseño y configuración visual del sistema.

## 6. Estructura interna

```
projects/ui/studio/
└── src/
    └── (componentes, páginas y lógica de la herramienta de diseño)
```

## 7. Estado

- **Madurez:** experimental
- Puerto: 4500 (configurado en `angular.json`).
- En desarrollo activo; la madurez experimental indica que la interfaz y funcionalidades están en definición.

## 8. Dominios que toca

- **Herramienta de Diseño** — editor visual para el sistema UI.
- **Design System** — configuración y preview de tokens y componentes.
- **Producto Vortech** — aplicación interna de la plataforma.

## 9. Observaciones

- El puerto 4500 (distinto de 4200, 4300, 4201) confirma que todas las apps del workspace tienen puertos únicos para poder ejecutarse concurrentemente.
- La existencia de una app "Studio" junto a un preset "studio" indica una correspondencia directa entre producto y theming.

## 10. Hipótesis

- Studio puede ser una herramienta para generar o editar los propios tokens de los presets — un meta-editor del design system.
- Alternativamente, puede ser un editor WYSIWYG para construir layouts o páginas usando los componentes Vortech.

## 11. Preguntas abiertas

1. ¿Studio es una herramienta interna de desarrollo o un producto de cara al usuario final?
2. ¿Permite exportar configuraciones o diseños a otros formatos (JSON tokens, código Angular)?
3. ¿Qué característica distingue Studio de la app demo? ¿La interactividad de edición?
4. ¿Hay integración con el sistema MCP servers del workspace?
