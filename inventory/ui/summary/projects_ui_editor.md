---
kind: package-summary
repo: ui
package_name: "editor"
package_path: projects/ui/editor
language: angular
manifest: package.json
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: experimental
---

## 1. Identidad

- **Nombre de paquete:** `editor` (nombre npm no confirmado; probable `@vortech/editor`)
- **Ruta:** `projects/ui/editor/`
- **Manifest:** `projects/ui/editor/package.json`
- **Tipo:** librería Angular

## 2. Propósito

Componente de editor de texto rico para Angular. Implementa un editor tipo Quill/ProseMirror con soporte para formato enriquecido mediante un modelo de delta (operaciones de inserción, borrado, formato), un sistema de parchment (abstracción del DOM del editor), toolbar configurable y un servicio de editor para integración programática.

## 3. Superficie pública

Exports inferidos de los archivos fuente:

- **`editor.ts`** — lógica central del editor (modelo de documento, operaciones)
- **`editor.html`** — template Angular del editor
- **`editor-component.ts`** — componente Angular que envuelve el editor
- **`editor-service.ts`** — servicio Angular para control programático del editor (get/set content, focus, commands)
- **`editor-toolbar.ts`** — componente de toolbar configurable (bold, italic, link, lista, etc.)
- **`delta/`** — implementación del modelo de delta (operaciones de transformación)
- **`parchment/`** — abstracción del DOM del editor (blots, formatos, embeds)
- **`public-api.ts`** — barrel de exports públicos
- **`index.ts`** — re-export principal

## 4. Dependencias

- `@vortech/ui-core` — probable para overlay (dropdowns de toolbar, tooltips) y contratos base
- Posible: `quill` como dependencia subyacente o implementación propia inspirada en Quill
- Angular Core, Forms (para integración con `ControlValueAccessor`)

## 5. Consumidores internos

- Probable consumidor: algún formulario de aplicación dentro del monorepo que requiera entrada de texto rico
- `@vortech/ui` — puede re-exportar el editor como componente adicional

## 6. Estructura interna

```
projects/ui/editor/
├── package.json
└── src/
    ├── delta/               # modelo de operaciones de transformación (OT)
    ├── editor/              # lógica central del editor
    ├── parchment/           # abstracción del DOM del editor
    ├── editor.html          # template Angular
    ├── editor.ts            # clase/módulo principal del editor
    ├── editor-component.ts  # componente Angular
    ├── editor-service.ts    # servicio Angular
    ├── editor-toolbar.ts    # toolbar configurable
    ├── index.ts             # barrel
    └── public-api.ts        # API pública
```

## 7. Estado

Experimental. La presencia de `delta/` y `parchment/` indica que no es un simple wrapper sobre una librería de terceros sino una implementación sustancial propia o fuertemente customizada. Sin embargo, los editores de texto rico son componentes de alta complejidad y propensión a bugs, justificando la clasificación experimental.

## 8. Dominios que toca

- Editor de texto rico (Rich Text Editor)
- Modelo de documento basado en delta (transformaciones operacionales)
- Abstracción del DOM del editor (parchment/blots)
- Integración con formularios Angular (ControlValueAccessor)

## 9. Observaciones

- Los términos "delta" y "parchment" son los nombres exactos del modelo de datos y la capa de abstracción DOM de la librería Quill. Esto sugiere que el editor está basado en o fuertemente inspirado por Quill.
- Un editor de texto rico propio en un monorepo UI es una decisión arquitectónica significativa: implica asumir el mantenimiento de un componente de alta complejidad.
- `editor-service.ts` permite uso programático del editor desde componentes padres, siguiendo el patrón Angular de servicios de componente.

## 10. Hipótesis

- El componente implementa `ControlValueAccessor` para integrarse con Angular Reactive Forms y Template-driven Forms.
- `delta/` puede implementar la especificación de Delta de Quill para representar y transformar documentos de texto rico de forma inmutable.
- `parchment/` puede incluir blots personalizados (e.g., mention, code-block, image) más allá de los formatos básicos.

## 11. Preguntas abiertas

- ¿El editor depende de `quill` como peer dependency o es una implementación completamente propia?
- ¿Hay soporte para colaboración en tiempo real (CRDT/OT)?
- ¿El editor soporta accesibilidad (ARIA: `contenteditable` con roles apropiados)?
- ¿Cuál es el nombre npm real del paquete (es `@vortech/editor` o simplemente `editor`)?
