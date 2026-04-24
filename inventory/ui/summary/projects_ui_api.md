---
kind: package-summary
repo: ui
package_name: "@vortech/api"
package_path: projects/ui/api
language: angular
manifest: package.json
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: beta
---

## 1. Identidad

- **Nombre de paquete:** `@vortech/api`
- **Ruta:** `projects/ui/api/`
- **Manifest:** `projects/ui/api/package.json`
- **Tipo:** librería Angular/TypeScript

## 2. Propósito

API de componentes Angular de Vortech. Define las abstracciones de alto nivel para describir, identificar y configurar componentes UI: definiciones declarativas de componentes, sistema de identidad, árbol de nodos de componentes, variantes y tipos. Proporciona la capa de metadatos sobre la que otros sistemas (temas, documentación, tooling) pueden introspeccionar los componentes de `@vortech/ui`.

## 3. Superficie pública

Exports inferidos de los directorios `src/`:

- **`component-instance.ts`** — tipo que representa una instancia activa de un componente Vortech
- **`components/`** — definiciones de componentes: metadatos, configuración, slots
- **`core/`** — tipos y utilidades centrales de la API
- **`definitions/`** — definiciones declarativas de los componentes (nombre, descripción, inputs, outputs, variantes)
- **`identity/`** — sistema de identidad: IDs únicos, nombres canónicos de componentes
- **`index.ts`** — barrel exports
- **`node/`** — árbol de nodos de componentes: composición jerárquica
- **`types/`** — tipos compartidos de la API
- **`variants/`** — sistema de variantes de componentes (e.g., `size: 'sm' | 'md' | 'lg'`, `color: 'primary' | 'danger'`)

## 4. Dependencias

- `@vortech/ui-core` — usa contratos base y tipos de componentes
- Probable: `@vortech/ui` para referenciar los componentes concretos cuya API describe

## 5. Consumidores internos

- `@vortech/theming` — puede usar definiciones de `@vortech/api` para generar tokens por componente
- Posibles herramientas de documentación o generación de código dentro del monorepo
- Demos y playgrounds que necesiten introspectar los componentes disponibles

## 6. Estructura interna

```
projects/ui/api/
├── package.json
└── src/
    ├── component-instance.ts    # instancia activa de componente
    ├── components/              # definiciones de componentes
    ├── core/                    # tipos y utilidades centrales
    ├── definitions/             # definiciones declarativas
    ├── identity/                # sistema de identidad (IDs, nombres)
    ├── node/                    # árbol de nodos de componentes
    ├── types/                   # tipos compartidos
    ├── variants/                # sistema de variantes
    └── index.ts                 # barrel exports
```

## 7. Estado

Beta. La cantidad de módulos bien diferenciados (`identity/`, `definitions/`, `variants/`, `node/`) indica un diseño maduro de la API de introspección de componentes. Es una capa de metadatos, no de implementación, lo que la hace más estable que los componentes concretos.

## 8. Dominios que toca

- Metadatos de componentes Angular
- Sistema de identidad de componentes
- Introspección de componentes (para tooling, documentación)
- Composición jerárquica de componentes (árbol de nodos)
- Sistema de variantes y configuración de componentes

## 9. Observaciones

- El concepto de "node tree" de componentes sugiere que `@vortech/api` puede ser la base de un designer visual o un sistema de configuración declarativa de UIs.
- `identity/` con IDs únicos puede soportar sistemas de tracking de componentes en producción o en herramientas de análisis.
- La existencia de `variants/` como módulo separado indica que el sistema de variantes es una abstracción de primera clase, no solo un conjunto de CSS classes.

## 10. Hipótesis

- `definitions/` puede usar decoradores o funciones de registro similares a Angular's `@Component` pero para metadatos de negocio (nombre público, descripción, categoría).
- `node/` puede representar la composición de componentes como un árbol, similar al concepto de Virtual DOM pero para la arquitectura de componentes Vortech.
- `@vortech/api` podría ser la base de un design system token: cada componente con su variante y estado tiene tokens de diseño asociados definidos aquí.

## 11. Preguntas abiertas

- ¿`@vortech/api` es consumida principalmente por tooling interno o por aplicaciones finales?
- ¿`node/` permite construir UIs dinámicas a partir de una descripción JSON (low-code)?
- ¿Hay integración con Storybook u otra herramienta de documentación de componentes?
- ¿`identity/` genera IDs estables entre versiones o son generados en runtime?
