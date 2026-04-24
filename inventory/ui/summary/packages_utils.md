---
kind: package-summary
repo: ui
package_name: "@vortech/utils"
package_path: packages/utils
language: ts
manifest: package.json
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: beta
---

# @vortech/utils

## 1. Identidad

- **Nombre:** `@vortech/utils`
- **Path:** `packages/utils`
- **Manifest:** `packages/utils/package.json`
- **Descripción en manifest:** no declarada
- **Lenguaje:** TypeScript

## 2. Propósito

### 2.1 Declarado

No hay descripción en `package.json`.

### 2.2 Inferido con Evidencia

Colección de utilidades de propósito general para el ecosistema Vortech. El `index.ts` re-exporta los siguientes módulos:

- `version` — información de versión
- `naming` — conversiones de nombres (camelCase, kebab-case, etc.)
- `type-check` — guardas de tipo en runtime
- `color` — utilidades de color
- `collection` — operaciones sobre colecciones (arrays, maps, sets)
- `tempo` — utilidades de tiempo/fecha
- `misc` — utilidades misceláneas
- `coercion` — coerción de tipos
- `string` — manipulación de strings
- `guards` — guardas adicionales
- `regex` — utilidades de expresiones regulares

## 3. Superficie pública

Exports (vía `packages/utils/src/index.ts`): re-exports de todos los módulos listados arriba. La superficie pública incluye helpers de tipo genérico usados transversalmente.

## 4. Dependencias

### 4.1 Internas

No determinado. Por su naturaleza de utilidades base, probable que no dependa de otros paquetes internos.

### 4.2 Externas

No determinado sin instalación de deps. Posible uso de `date-fns` u otra lib de fechas para `tempo/`.

## 5. Consumidores internos

No determinado. Por su naturaleza de utilidades base, probable que sea consumido por la mayoría de paquetes del workspace.

## 6. Estructura interna

```
packages/utils/
├── package.json
└── src/
    ├── index.ts       (re-exports de todos los módulos)
    ├── version.*
    ├── naming.*
    ├── type-check.*
    ├── color.*
    ├── collection.*
    ├── tempo.*
    ├── misc.*
    ├── coercion.*
    ├── string.*
    ├── guards.*
    └── regex.*
```

## 7. Estado

- **Madurez:** beta
- **Justificación:** Cobertura amplia de utilidades (11 módulos). Sin tests detectados. Posible duplicación de funcionalidad con `@vortech/common` (si existe).
- **Build:** no ejecutado
- **Tests:** no detectados
- **Último cambio:** no determinado (requiere `git log`)

## 8. Dominios que toca

- Utilidades transversales (cross-cutting)
- Manipulación de strings y colecciones
- Guardas de tipo
- Fechas y tiempo

## 9. Observaciones

- La coexistencia de módulos `guards` y `type-check` sugiere posible solapamiento; pueden ser dos capas distintas (guardas de tipo TS vs. chequeos en runtime).
- `color` en un paquete de utils genérico es inusual; puede relacionarse con theming o logging con color.
- Posible duplicación con `@vortech/common` si ese paquete existe en el workspace.

## 10. Hipótesis (?:)

- ?: `tempo` puede ser un wrapper de `date-fns` o `luxon` adaptado a los primitivos de `@vortech/lang` (`DateOnly`, `TimeOnly`).
- ?: `naming` puede usarse en `@vortech/sdk` para generación de nombres de símbolos.

## 11. Preguntas abiertas

- ¿Existe `@vortech/common` como paquete separado? ¿Cuál es la diferencia con `@vortech/utils`?
- ¿`color` expone utilidades para CSS-in-JS, para logging, o para ambos?
- ¿`guards` y `type-check` tienen responsabilidades diferentes?
