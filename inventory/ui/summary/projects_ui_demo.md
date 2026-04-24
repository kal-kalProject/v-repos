---
kind: package-summary
repo: ui
package_name: "demo"
package_path: projects/ui/demo
language: angular
manifest: angular.json
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: beta
---

## 1. Identidad

- **Nombre publicado:** `demo` (Angular project dentro de `angular.json`)
- **Ruta en el repo:** `projects/ui/demo`
- **Manifiesto:** `angular.json` (sin `package.json` propio; configurado como proyecto del workspace Angular)
- **Lenguaje principal:** Angular / TypeScript

## 2. Propósito

Aplicación Angular de demostración del sistema UI Vortech. Es la app principal de showcasing de componentes — sirve como catálogo visual interactivo donde se puede explorar y validar el comportamiento de los componentes bajo los distintos presets de theming disponibles. Sirve en el puerto 5500.

## 3. Superficie pública

- No tiene API pública exportada; es una aplicación ejecutable, no una librería.
- Punto de entrada: `src/main.ts` (o equivalente Angular 17+ standalone).
- Rutas de la app que exponen secciones de componentes (presumiblemente).
- Assets estáticos en `public/`.

## 4. Dependencias

- `@vortech-presets/aura`, `@vortech-presets/lara`, `@vortech-presets/nora`, `@vortech-presets/material` — presets beta disponibles en el selector de tema.
- `@vortech-presets/vscode`, `@vortech-presets/studio`, `@vortech-presets/cnc-monkey` — presets experimentales.
- La librería de componentes UI de Vortech (`@vortech/ui` o equivalente del workspace).
- Angular CLI / Angular 17+ (standalone components).

## 5. Consumidores internos

- No es consumida por otros paquetes; es un artefacto de deploy/demo.
- Usada por el equipo de desarrollo para validación visual de los componentes y presets.

## 6. Estructura interna

```
projects/ui/demo/
├── src/
│   ├── main.ts (o app.component.ts standalone)
│   └── (páginas y componentes de demostración)
├── public/
│   └── (assets estáticos)
├── tsconfig.app.json
└── tsconfig.spec.json
```

## 7. Estado

- **Madurez:** beta
- Es la app de demostración más madura del conjunto; sirve como referencia principal del sistema UI.
- Puerto: 5500 (configurado en `angular.json`).
- Puede tener suite de tests (dado que tiene `tsconfig.spec.json`).

## 8. Dominios que toca

- **UI / Componentes** — showcasing de la librería de componentes.
- **Theming** — demostración de todos los presets disponibles.
- **QA visual** — validación de apariencia de componentes.

## 9. Observaciones

- La existencia de `tsconfig.spec.json` sugiere que hay tests de componente (Karma/Jest).
- La carpeta `public/` indica el uso del nuevo sistema de assets de Angular 17+.
- El puerto 5500 (en lugar del 4200 por defecto) indica configuración explícita para coexistir con otras apps del workspace.

## 10. Hipótesis

- La app probablemente tiene una ruta por componente (e.g., `/button`, `/input`, `/table`) para facilitar la revisión individual.
- Puede incluir un selector de preset en la barra de navegación que reconfigura el tema en tiempo real.

## 11. Preguntas abiertas

1. ¿La app demo tiene tests de regresión visual (snapshot tests)?
2. ¿El selector de tema actúa en tiempo real (sin recarga) o requiere reinicio del servidor?
3. ¿Existe un proceso de deploy de la app demo como sitio estático (GitHub Pages, etc.)?
4. ¿El `public/` contiene assets de la app demo o assets compartidos con otras apps?
