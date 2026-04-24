# 20 — Renombrado y exports `@vortech/*`

> **Decisión global.** Todo package canónico usa scope `@vortech/`. Los nombres antiguos `v-common`, `v-core`, `v-components`, `v-runtime`, `v-layout` quedan deprecados. Esto es la corrección explícita del usuario sobre `01-cierre-decisiones-ts.md §packages`.

---

## 1. Tabla de renombrado

| Antes | Después | Estado en Fase 1 |
|---|---|---|
| `v-common` | `@vortech/common` | **Cambia en Fase 1** |
| `v-core` | `@vortech/core` | **Cambia en Fase 1** |
| `v-components` (PrimeNG fork) | `@vortech/ui` (archivado) | Referencia visual, no canónico |
| `@vortech/components` (Driver UI canónico) | `@vortech/components` | Existe a partir de Fase 2 |
| `v-layout` (port VSCode shell) | `@vortech/workbench` | Fase 2 |
| `layout` (Sash/SplitView/GridView) | `@vortech/layout` | Fase 2 |
| `theming` | `@vortech/theming` | Fase 2 |
| `v-runtime` (Driver runtime) | `@vortech/runtime` | Fase 2 |
| nuevo | `@vortech/wire` | Fase 2 |

## 2. Subpath exports de `@vortech/common`

`v-common` hoy declara 8 subpaths, pero el barrel raíz solo expone `Regex` y `Middleware` como namespaces. Se rectifica:

```jsonc
// @vortech/common/package.json#exports
{
  ".":            "./dist/index.js",
  "./char-codes": "./dist/char-codes/index.js",
  "./collections":"./dist/collections/index.js",
  "./data":       "./dist/data/index.js",
  "./expressions":"./dist/expressions/index.js",
  "./helpers":    "./dist/helpers/index.js",
  "./middleware": "./dist/middleware/index.js",
  "./regex":      "./dist/regex/index.js",
  "./trees":      "./dist/trees/index.js"
}
```

Y el barrel raíz:

```ts
// @vortech/common/src/index.ts
export * as CharCodes   from './char-codes';
export * as Collections from './collections';
export * as Data        from './data';
export * as Expressions from './expressions';
export * as Helpers     from './helpers';
export * as Middleware  from './middleware';
export * as Regex       from './regex';
export * as Trees       from './trees';

// types convenientes a top-level (no symbols)
export type { HierarchyAccessor } from './trees';
export type { Pipeline }          from './middleware';
```

**Regla.** Subdominios se importan por subpath: `import { … } from '@vortech/common/trees'`. El barrel raíz sólo da namespaces y tipos convenientes — nunca implementaciones.

## 3. Subpath exports de `@vortech/core`

```jsonc
// @vortech/core/package.json#exports
{
  ".":              "./dist/index.js",
  "./atoms":        "./dist/atoms/index.js",
  "./builders":     "./dist/builders/index.js",
  "./common":       "./dist/common/index.js",
  "./di":           "./dist/di/index.js",
  "./dom":          "./dist/dom/index.js",
  "./extensions":   "./dist/extensions/index.js",
  "./event":        "./dist/event/index.js",
  "./globals":      "./dist/globals/index.js",
  "./history":      "./dist/history/index.js",
  "./linq":         "./dist/linq/index.js",
  "./main":         "./dist/main/index.js",
  "./meta":         "./dist/meta/index.js",
  "./node":         "./dist/node/index.js",
  "./platform":     "./dist/platform/index.js",
  "./route":        "./dist/route/index.js",
  "./scope":        "./dist/scope/index.js",
  "./serialization":"./dist/serialization/index.js",
  "./tools":        "./dist/tools/index.js",
  "./tree":         "./dist/tree/index.js"
}
```

Cambios respecto a hoy:

| Cambio | Antes | Después |
|---|---|---|
| Subpath `./scope` | inexistente | barrel real (carpeta antes era `context-handler/`) |
| Subpath `./route` | inexistente | nuevo, hermano de `scope` |
| Subpath `./platform` | inexistente | renombre de `./runtime` (para no chocar con package `@vortech/runtime`) |
| Subpath `./main` | inexistente | nuevo, expone `@App`, `bootstrap`, `AppRef` |
| Subpath `./meta` | sólo en barrel | promovido a subpath; `metadata/` se absorbe |
| `./api` | existía como carpeta | absorbida por `./tools` o `./common` (a decidir en refactor) |
| `./scope` viejo (clase) | en `core/src/scope/` | **eliminado** |
| `./context-handler` | subpath actual | **renombrado a `./scope`** |

## 4. Renombre del package raíz: pasos mecánicos

1. `package.json#name`: `v-common` → `@vortech/common`, `v-core` → `@vortech/core`.
2. `package.json#dependencies`: en core, `"v-common": "workspace:*"` → `"@vortech/common": "workspace:*"`.
3. Buscar imports `from 'v-common'` y `from 'v-common/...'` en core/ → reemplazo masivo a `@vortech/common[/...]`.
4. Buscar imports `from 'v-core'`, `from '@vortech/core/...'` (algunos archivos ya usan el nuevo, otros usan rutas relativas largas) → consolidar a subpath imports.
5. Actualizar `tsconfig.json#paths` de cada workspace que use el alias.
6. Actualizar `tsup.config.ts` para emitir cada subdominio como entry.
7. `pnpm-workspace.yaml` ya soporta scoped packages — sin cambios.

## 5. Convención de globals `v<Capitalized>`

Hoy hay tipos globales en uso sin import explícito:

| Global | Usado en | Significado |
|---|---|---|
| `vToken<T>` | `injection-token.ts`, `inject-decorator.ts`, decorators | Token de DI (símbolo o clase) |
| `vScope<P, T>` | `context-handler/`, `scope-handle.ts` | Identidad de un scope (path tipado + nodo opcional) |
| `vMeta<P>` | `di/main.ts`, `meta/` | Llave tipada de metadato |
| `vSelector` | `scope/types.ts` | Selector de scope (heredado, en revisión) |

**Decisión.** Mantener la convención. Declarar todos en `@vortech/core/globals.d.ts` (o equivalente que el resto del workspace pueda referenciar vía `tsconfig#types`). Cualquier nueva primitiva pública del core que merezca alias global sigue el patrón:

```ts
declare global {
  type vRoute<P extends string = string, T = unknown> = …;
}
```

**Regla.** No se introduce un global nuevo sin entrada correspondiente en este §5.

## 6. Migración de imports en consumidores

Lista de buscar/reemplazar para repos consumidores (a documentar en su propia migración, no aquí):

```
v-core             →  @vortech/core
v-core/atoms       →  @vortech/core/atoms
v-core/di          →  @vortech/core/di
v-core/scope       →  @vortech/core/scope          (era 'context-handler')
v-core/runtime     →  @vortech/core/platform        (renombre semántico)
v-core/extensions  →  @vortech/core/extensions
v-common           →  @vortech/common
v-common/regex     →  @vortech/common/regex
v-common/middleware→ @vortech/common/middleware
…
```

## 7. Validación de exports

Cada PR de refactor debe pasar:

```bash
pnpm --filter @vortech/common build && pnpm --filter @vortech/common dlx publint
pnpm --filter @vortech/core   build && pnpm --filter @vortech/core   dlx publint
pnpm --filter @vortech/core   dlx @arethetypeswrong/cli --pack .
```

`publint` valida que cada `exports` tenga `types`/`import`/`default` consistentes. `attw` valida que TypeScript resuelva tipos correctamente para ESM.
