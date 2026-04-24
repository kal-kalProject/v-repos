# 10 — Mapa actual de los dos packages

Inventario literal de qué hay hoy en `repos/vortech/platform/v-common/src/` y `repos/vortech/platform/core/src/`. Sin valoración — la valoración va en los docs 30+. Aquí sólo se constata la topología.

---

## 1. `v-common/`

`package.json` declara 8 subpath exports:

```
.            collections   data        expressions
trees        regex         middleware  char-codes
```

Pero `src/index.ts` realmente sólo exporta como namespaces:

```ts
export * as Regex from './regex';
export * as Middleware from './middleware';
```

El resto (`collections`, `trees`, `data`, `expressions`) está comentado y solo se llega vía subpath imports `v-common/collections`, `v-common/trees`, etc. — no por barrel raíz.

### 1.1 Carpetas

| Carpeta | Contenido (archivos clave) |
|---|---|
| `char-codes/` | `ascii.ts`, `cjk-punctuation.ts`, `combining-mark.ts`, `fullwidth.ts`, `greek-diacritic.ts`, `modifier-letter.ts`, `separator.ts`, `special.ts` |
| `collections/` | `comparison/`, `iterables/`, `sorting/`, `filter-by-fields.ts`, `reorder-array.ts`, `types.ts` |
| `data/` | `resolution/`, `transformation/` |
| `expressions/` | `compile.ts`, `expr.ts`, `query-node.ts`, `query-plan.ts`, `visitor.ts`, `helpers.ts` |
| `helpers/` | `guards.ts` |
| `middleware/` | `pipeline.ts`, `types.ts` |
| `regex/` | `builder/`, `compile.ts`, `escape.ts`, `exec.ts`, `handler/`, `helpers/`, `internals/`, `match-all.ts`, `match.ts`, `replace.ts`, `safety/`, `types.ts`, `README.md` |
| `trees/` | `extraction/`, `hierarchy/`, `traversal/`, `filter-tree.ts` |

### 1.2 Dependencias

- Cero dependencias runtime declaradas en `package.json`.
- Sólo dev: `tsup`, `vitest`, `typescript`, `cross-env`, `@types/node`.

### 1.3 Observaciones de hechos

- No depende de nada interno (es la base).
- `helpers/guards.ts` es un único archivo huérfano de su carpeta.
- `data/` tiene sólo dos subcarpetas, sin barrel raíz visible al lado.

---

## 2. `core/` (`v-core`)

`package.json` declara sólo 3 subpath exports (`.`, `./event`, `./tools`), pero `src/public-api.ts` exporta los 25 dominios:

```ts
export * from './globals';
export * from './atoms';
export * from './common';
export * from './dom';
export * from './node';
export * from './serialization';
export * from './builders';
export * from './history';
export * from './tools';
export * from './collections';
export * from './tree';
export * from './linq';
export * from './tree/walk';
export * from './context-handler';
export * from './di';
export * from './meta';
```

Hay un mismatch claro entre `package.json#exports` y `public-api.ts` que se corrige en [`20-renombrado-y-exports.md`](20-renombrado-y-exports.md).

### 2.1 Carpetas top-level

| Carpeta | Identidad |
|---|---|
| `api/` | Helpers de API (sin inspeccionar profundo en este pase) |
| `application/` | `application-startup.ts`, `bootstrap.ts` — usa `scope/scope-tree.ts` viejo |
| `atoms/` | atom, derived, emitter, watch, owner, operators, tracker, event-handler, devtools, core (reactivo) |
| `builders/` | Decorator builders + helpers |
| `collections/` | (porting de v-common collections o capa propia) |
| `common/` | atoms/, index.ts — agrupador histórico |
| `context-handler/` | **scope tree nuevo** (createScopeTree, ScopeHandle, vScope) |
| `di/` | binding/, decorators/, di-context/, errors/, families/, hooks/, injectable/, injector/, lifecycle/, module/, di-root.ts, di-context.ts, create-di-context.ts, bootstrap.ts, main.ts, injection-context.ts, injection-token.ts |
| `dom/` | atoms/ — utilidades reactivas DOM |
| `event/` | cancellation/, emitter/, lifecycle/ — capa antigua de event/cancellation |
| `extensions/` | extensions.ts, slot.ts, hooks/, types.ts |
| `globals/` | path, uri, platform, nls, process, marshalling-ids — port VSCode |
| `history/` | history-tracker, rx-history, validation, history-extension |
| `linq/` | query, rx-query, operators |
| `meta/` | createMetadataStore, ClassEntry, MemberEntry |
| `metadata/` | metadata-adapter, ns, inheritance, registry, use-metadata-registry |
| `node/` | helpers/ — utilidades Node |
| `runtime/` | apis/, browser/, edge/, mobile/, native/, defaults.ts, detect.ts, model.ts, error/ |
| `scope/` | **scope tree viejo** (`ScopeTree<TNode>` clase) — coexiste con context-handler/ |
| `serialization/` | atoms/ |
| `tools/` | action/, color/, glob/, misc/, selector/, types/, validation/, virtual/ |
| `tree/` | rx-tree, tree, walk/, key-config, storage |

### 2.2 Dependencias

- `dependencies`: `v-common: workspace:*` solamente.
- `devDependencies`: `tsup`, `vitest`, `madge`, `dependency-cruiser`, `fast-glob`, `@types/node`, `cross-env`, `@hpcc-js/wasm-graphviz`.

### 2.3 Imports cruzados (muestreo)

| Fichero | Importa de |
|---|---|
| `di/injector/injector.ts:73` | `@vortech/core/context-handler` |
| `di/main.ts:18` | `@vortech/core/context-handler` |
| `application/application-startup.ts:3` | `../scope/scope-tree` (¡versión vieja!) |
| `scope/scope-tree.ts:19` | `v-common/trees` (HierarchyAccessor) |
| `di/injector/injector.ts:1` | `@vortech/core/atoms`, `@vortech/core/linq`, `@vortech/core/common` |
| `extensions/extensions.ts:23` | `@vortech/core/atoms` |
| `di/injectable/injectable-decorator.ts:3` | `@vortech/core/builders` |
| `di/injectable/injectable-decorator.ts:6` | `../di-root` |

→ La doble Scope no es teórica: hay imports vivos a la versión vieja **y** a la nueva en distintos archivos.

### 2.4 Carpetas con `propuestas/`

| Ruta | # archivos |
|---|---|
| `core/propuestas/` | ~40 (refactors históricos en discusión) |
| `core/src/scope/propuestas/` | 6 |
| `core/src/context-handler/propuestas/` | 3 |
| `v-common/propuestas/` | 1 (`regex-engine-pro.md`) |
| `core/src/di/.doc/` | varios (no inspeccionados) |

→ Indica trabajo de diseño activo no consolidado. Estos no son docs canónicos, son apuntes. La canonicidad pasa a `official-doc/ts/`.

### 2.5 Archivos huérfanos / sospechosos

- `core/src/di/di-context.ts`, `create-di-context.ts`, `di-context-options.ts` — mencionados en `di/index.ts` con líneas comentadas (`// export { type DiContext } from './di-context';`). Pendientes de borrado o reactivación.
- `core/src/di/decorators/` (varios `*-decorator-builder.ts`) — sólo `decorators/index.ts` los reexporta; barrel raíz `di/index.ts` los marca `@v-ignore`.
- `core/src/di/families/` — `bootstrap-host.ts`, `http/` también `@v-ignore`d en barrel.
- `core/src/event/` vs `core/src/atoms/event-handler/` — dos lugares para "event handling"; el segundo es el moderno y vivo.
- `core/src/scope/` vs `core/src/context-handler/` — duplicación ya señalada.
- `core/src/meta/` vs `core/src/metadata/` — ya señalada.
- `core/src/common/atoms/` vs `core/src/atoms/` — `common/atoms/` parece ser un re-export o helper sobre `atoms/`. Requiere lectura puntual al ejecutar refactor.

---

## 3. Comprobación rápida

| Pregunta | Respuesta |
|---|---|
| ¿Hay package que pueda romper si renombramos? | Sólo `core` depende de `v-common` (workspace). Cualquier consumidor externo está fuera de Fase 1. |
| ¿Hay export externo `v-core` distinto de `public-api.ts`? | `package.json#main` apunta a `./dist/index.js` que tsup produce desde `public-api.ts` (revisar `tsup.config.ts`). |
| ¿Hay tests acoplados a la estructura de carpetas? | Sí, en `core/tests/` y `v-common/tests/`. Renombre obliga a recorrer paths de tests. |
| ¿Hay `index.ts` en cada subdominio? | Mayormente sí. Faltan algunos (helpers en v-common). Se exige uno por dominio en el refactor. |

Continúa en [`20-renombrado-y-exports.md`](20-renombrado-y-exports.md).
