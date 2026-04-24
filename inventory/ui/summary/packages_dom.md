---
kind: package-summary
repo: ui
package_name: "@vortech/dom"
package_path: packages/dom
language: ts
manifest: package.json
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: beta
---

# @vortech/dom

## 1. Identidad

- **Nombre:** `@vortech/dom`
- **Path:** `packages/dom`
- **Manifest:** `packages/dom/package.json`
- **Descripción en manifest:** no declarada
- **Lenguaje:** TypeScript

## 2. Propósito

### 2.1 Declarado

No hay descripción en `package.json`.

### 2.2 Inferido con Evidencia

Librería de utilidades DOM de uso general. La estructura de carpetas en `packages/dom/src/` cubre todas las áreas principales de manipulación del DOM en el navegador:

- `animation/` — fade, transiciones
- `attributes/` — lectura/escritura de atributos HTML
- `detection/` — detección de entorno (SSR, clickabilidad)
- `devices/` — detección de plataforma (Android, iOS, browser)
- `dimensions/` — ancho, alto, offsets
- `focus/` — gestión del foco
- `manipulation/` — inserción/remoción de nodos
- `positioning/` — posicionamiento de elementos
- `query/` — selectores y búsqueda en el árbol DOM
- `scroll/` — control del scroll
- `selection/` — selección de texto/rango
- `styles/` — manipulación de estilos inline y clases CSS
- `traversal/` — recorrido del árbol DOM
- `xml-dom/` — manipulación de XML

## 3. Superficie pública

Exports representativos (vía `packages/dom/src/index.ts`):

| Símbolo | Categoría |
|---|---|
| `fadeIn`, `fadeOut` | animation |
| `getAttribute` | attributes |
| `isClickable`, `isElement` | detection |
| `isSsr` | detection (SSR guard) |
| `getBrowser` | devices |
| `isAndroid`, `isIOS` | devices |
| `getHeight`, `getWidth`, `getOffset` | dimensions |
| `resolveUserAgent` | devices |
| (y otros exports por módulo) | — |

## 4. Dependencias

### 4.1 Internas

No determinado sin lectura completa del `package.json`.

### 4.2 Externas

No determinado sin instalación de deps.

## 5. Consumidores internos

No determinado. Dada la amplitud de la API, es probable que sea consumido por paquetes Angular (`packages/`) y demos (`demos/`).

## 6. Estructura interna

```
packages/dom/
├── package.json
└── src/
    ├── animation/
    ├── attributes/
    ├── detection/
    ├── devices/
    ├── dimensions/
    ├── focus/
    ├── index.ts
    ├── manipulation/
    ├── positioning/
    ├── query/
    ├── scroll/
    ├── selection/
    ├── styles/
    ├── traversal/
    └── xml-dom/
```

## 7. Estado

- **Madurez:** beta
- **Justificación:** API pública amplia y bien categorizada en 14 módulos temáticos. Sin tests detectados.
- **Build:** no ejecutado
- **Tests:** no detectados
- **Último cambio:** no determinado (requiere `git log`)

## 8. Dominios que toca

- Browser / DOM
- Detección de plataforma / SSR
- Animación CSS
- Accesibilidad (focus)

## 9. Observaciones

- El módulo `xml-dom/` sugiere soporte para entornos no-browser (Node.js XML parsing).
- `isSsr` indica soporte explícito de SSR (Angular Universal / SSR).

## 10. Hipótesis (?:)

- ?: Los módulos `focus/` y `selection/` podrían relacionarse con la integración con editores de texto o RTE dentro del ecosistema Vortech.
- ?: `xml-dom/` podría ser wrapper de `@xmldom/xmldom` u otra lib similar.

## 11. Preguntas abiertas

- ¿Existe un test suite separado o están los tests en `packages/dom/src/**/*.spec.ts`?
- ¿Cuál es la dependencia de peer con el DOM global (`lib.dom.d.ts`)?
- ¿`getBrowser` / `resolveUserAgent` usan `navigator.userAgent` directamente?
