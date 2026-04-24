---
kind: package-summary
repo: ui
package_name: "@vortech/common"
package_path: packages/common
language: ts
manifest: package.json
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: beta
---

# @vortech/common

## 1. Identidad
- **Nombre:** `@vortech/common`
- **Path:** `packages/common`
- **Lenguaje:** TypeScript
- **Versión declarada:** 0.0.1
- **Publicado:** no (privado por convención workspace)

## 2. Propósito

### 2.1 Declarado
Sin descripción en `package.json`.

### 2.2 Inferido
Librería de utilidades transversales de bajo nivel: coerción de tipos, manejo de colores, convertidores, guards, generación y manejo de claves (GUID, UUID, BSON, SQL, auto-increment), tipos comunes, utilidades de validación y acceso a valores. Es la base utilitaria del ecosistema Vortech.

**Evidencia:**
- `packages/common/src/index.ts:1-80` — exporta módulos: `coercion`, `color`, `converters`, `guards`, `keys`, `platform`, `types`, `utils`, `validation`, `value`, y sistema reactivo (Atom).
- `packages/common/src/apis/vortech/keys/` — sistema de claves: `createKey`, `defineKey`, `createSqlKeyProvider`, `createBsonIdProvider`, `createGuidValueProvider`.

## 3. Superficie pública
- `tryGetString`, `tryGetNumber`, `tryGetBoolean`, `tryGetBigInt`, `tryGetSymbol` — coerción con resultado tipado
- `ColorUtils`, `createColor`, `Color`, `RGBA` — utilitaria de color
- `BidirectionalConverter`, `createValueMap`, `createStructuralCast` — sistema de conversión
- `ThrowIfNull`, `Guards`, `toError` — guards y errores
- `createKey`, `defineKey` — sistema de claves tipadas
- `atom`, `derived`, `watch`, `createScope` — sistema reactivo (exportado parcialmente vía comentarios — muchas exportaciones comentadas en `index.ts:14-80`)

## 4. Dependencias

### 4.1 Internas al repo
Ninguna declarada.

### 4.2 Externas
- `typescript` (devDep) — compilación
- `tsup` (devDep) — bundler
- `vitest` (devDep) — tests

## 5. Consumidores internos
- `packages/platform` — importa `@vortech/common/globals` (`platform/src/index.ts:1`)
- `packages/core` — posiblemente consume types de common (verificar por grep)
- Múltiples packages del workspace importan de `@vortech/common`

## 6. Estructura interna
```
src/
├── apis/       ← APIs públicas (keys, etc.)
├── coercion/   ← coerción de tipos
├── color/      ← utilidades de color
├── converters/ ← sistema de convertidores
├── guards/     ← guards y assertions
├── key/        ← lógica de claves
├── platform/   ← detección de plataforma
├── types/      ← tipos base
├── utils/      ← utilidades generales
├── validation/ ← validación
├── value/      ← acceso a valores
└── index.ts    ← barrel export principal
```

## 7. Estado
- **Madurez:** beta
- **Justificación:** Muchas exportaciones comentadas en `index.ts` (atom, builder, etc.), sugiere refactoring en curso. Tiene test runner (vitest) pero no hay archivos de test visibles en exploración estática.
- **Build:** no ejecutado
- **Tests:** 0 archivos `*.test.*` detectados en exploración
- **Último cambio relevante observado:** desconocido

## 8. Dominios que toca
- `domain/runtime` — sistema Atom/reactivo (parcialmente exportado)
- `domain/ui-kit` — utilitarias de color
- `domain/codegen` — sistema de claves

## 9. Observaciones
Muchas exportaciones del módulo `atom` y el `builder-toolkit` están comentadas, lo que sugiere una refactorización hacia `@vortech/platform` para el sistema reactivo.

## 10. Hipótesis
- `?:` El sistema Atom se está migrando de `@vortech/common` a `@vortech/platform` — evidencia: `packages/common/src/index.ts` (comentarios masivos en exports de atom).

## 11. Preguntas abiertas
- ¿El export `./globals` es un polyfill de globals? No confirmado sin inspección del archivo.
