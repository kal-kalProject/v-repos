# 00 — Resumen ejecutivo

> **Tres frases.** `@vortech/common` queda como caja de utilidades puras casi sin tocar — sólo renombre y limpieza de exports. `@vortech/core` tiene **dos puntos de tensión reales**: la duplicación `scope/` ↔ `context-handler/` y la doble vía de DI (decoradores con `getDiRoot()` por un lado, `inject()` + `runInInjectionContext()` por otro). El refactor de Fase 1 colapsa esas dos tensiones, introduce `@vortech/core/route` como hermano de `scope`, y cierra los exports.

---

## 1. Qué se conserva tal cual

| Área | Por qué |
|---|---|
| `atoms/` (atom, derived, emitter, watch, owner, operators, tracker, event-handler) | Contrato sólido y completo. Es la base reactiva de toda la plataforma. Sólo afinar exports. Ver [`30-atoms.md`](30-atoms.md). |
| `linq/` (Query, RxQuery) | Independiente, autocontenido, ya consumido por DI. Ver [`71-utils-vcore.md §LINQ`](71-utils-vcore.md). |
| `tree/` (RxTree, walk) | Lo usa scope, history, hierarchy. No requiere cambios estructurales. |
| `history/` | Stable. |
| `runtime/` (model, detect, defaults, browser/node/edge/mobile/native) | Plano. Pasa a llamarse `@vortech/core/platform` para no chocar con `@vortech/runtime` (Driver runtime). Ver [`20-renombrado-y-exports.md`](20-renombrado-y-exports.md). |
| `globals/` (path, uri, platform, nls, process) | Port de VSCode globals. Mantener. |
| `regex/`, `collections/`, `trees/`, `data/`, `expressions/`, `middleware/`, `char-codes/` en `v-common` | Utilidades puras sin acoplamiento a plataforma. Solo renombre. |

## 2. Qué se mueve / colapsa

| Origen actual | Destino | Razón |
|---|---|---|
| `core/src/scope/` (clase `ScopeTree<TNode>`) | **Eliminado** | Versión vieja, simple. Reemplazada por la de `context-handler/`. Ver [`50-scope-y-route.md §3`](50-scope-y-route.md). |
| `core/src/context-handler/` | `@vortech/core/scope` | El nombre real de lo que hay ahí. `context-handler` es nombre histórico confuso. |
| `core/src/extensions/` | `@vortech/core/extensions` | Sin cambios estructurales, sólo barrel y re-export. |
| `core/src/common/` (atoms helpers, slots) | Distribuido en `atoms/` y `extensions/` según corresponda | Es un agrupador histórico sin identidad propia. |
| `core/src/metadata/` y `core/src/meta/` | Unificados en `@vortech/core/meta` | Hoy son dos APIs distintas para el mismo concepto. Ver [`71-utils-vcore.md §meta`](71-utils-vcore.md). |
| `core/src/application/` (uso de `scope/scope-tree.ts` viejo) | Reescritura mínima sobre `@vortech/core/scope` nuevo | application-startup.ts está acoplado al ScopeTree viejo. |

## 3. Qué se introduce

| Nuevo | Ubicación | Función |
|---|---|---|
| **`@vortech/core/route`** | `core/src/route/` | Primitiva hermana de `scope/`. Topología de **rutas** (URL/segmentos/params), separada de `scope/` (topología de **identidad jerárquica**). Simétrica con `dotnet/scope` ↔ `dotnet/route`. Ver [`50-scope-y-route.md`](50-scope-y-route.md). |
| **`@vortech/core/main`** | `core/src/main/` (port de `di/main.ts`) | `@App`, `bootstrap()`, `AppRef`. Sustituye `getDiRoot()` y `di-root.ts`. Mismo patrón que `dotnet/Bootstrap`. |
| **Subpath exports `@vortech/core/*`** | `package.json#exports` | Cada subdominio expone su barrel limpio: `atoms`, `di`, `scope`, `route`, `extensions`, `linq`, `tree`, `history`, `runtime`, `meta`, `builders`, `event`, `globals`, `dom`, `node`, `serialization`, `tools`, `common`, `main`. |

## 4. Qué se borra

| Origen | Razón |
|---|---|
| `core/src/scope/scope-tree.ts` y `core/src/scope/types.ts` (versión vieja) | Reemplazados por `context-handler/`. |
| `core/src/scope/propuestas/` | Notas históricas. Referenciar desde `analysis/` y archivar. |
| `core/src/di/decorators/` (parcialmente) y `core/src/di/di-root.ts` | El barrel de `di/index.ts` ya las marca `@v-ignore — pending new architecture (main() bootstrap)`. Ver [`40-di.md §6`](40-di.md). |
| `core/src/di/.doc/` | Notas internas de implementación, mover a `analysis/` o archivar. |
| `core/src/di/di-context*.ts` legacy | Reemplazado por `injection-context.ts`. |
| Múltiples `propuestas/` | Archivar fuera del package; no son código. |

## 5. Tensiones principales (resueltas en este análisis)

### T1 — Doble Scope
- `scope/` (`ScopeTree<TNode>` clase, simple) y `context-handler/` (`createScopeTree()`, `ScopeHandle`, `vScope`, walk-up/down, eventos por nodo y por árbol) coexisten.
- `Injector` (`di/injector/injector.ts:73`) ya importa de `@vortech/core/context-handler`. `application/application-startup.ts:3` aún importa de `scope/scope-tree`.
- **Decisión.** El bueno es `context-handler/`. Renombrar a `scope/`, eliminar el viejo. Ver [`50-scope-y-route.md`](50-scope-y-route.md).

### T2 — Doble vía de DI
- Vía clásica con decoradores: `@Injectable`, `@Inject` (campo), `getDiRoot()`, `injectableStore`, `metadata-store`. Todavía referenciada por `bootstrap.ts`.
- Vía moderna sin decoradores ricos: `Injector`, `inject()`, `runInInjectionContext()`, `BindingRegistry`, `Binding`. Es la que el `01-cierre-decisiones-ts.md` consagra.
- El barrel `di/index.ts` ya tiene comentado `@v-ignore — pending new architecture (main() bootstrap)`.
- **Decisión.** La moderna gana. Decoradores de clase quedan limitados a marcadores (`@Injectable`, `@App`, `@Module`) que sólo registran metadatos; toda inyección de campos pasa a `inject()` reactivo. Ver [`40-di.md`](40-di.md).

### T3 — `meta/` vs `metadata/`
- Dos sistemas: `meta/` (createMetadataStore, ClassEntry/MemberEntry) y `metadata/` (registry, adapter, ns, inheritance).
- Builders consumen `meta/`; algunos sitios todavía consumen `metadata/`.
- **Decisión.** Unificar bajo `meta/`; `metadata/` se absorbe.

### T4 — Naming `vToken` / `vScope` / `vMeta` globales
- Se usan como tipos globales (`vToken`, `vScope`, `vMeta`) sin import explícito en `injection-token.ts`, `inject-decorator.ts`, etc.
- **Decisión.** Mantener convención (alias globales declarados en `globals.d.ts`) pero documentarla en [`20-renombrado-y-exports.md §convención global`](20-renombrado-y-exports.md). Cualquier nueva primitiva sigue el patrón `v<Capitalized>`.

## 6. Ámbito intacto (no se discute en Fase 1)

- Cualquier package que dependa de `@vortech/core` (componentes, workbench, runtime de Driver) — las decisiones aquí son ascendentes y se propagan en su propia fase.
- El sistema de Wire (transports WS/HTTP/in-process) — vive en `@vortech/wire`, no en core.
- El ShellRouter — explícitamente diferido en `01-cierre-decisiones-ts.md`. La introducción de `@vortech/core/route` **no** decide ShellRouter; sólo da la primitiva genérica de árbol de rutas.

## 7. Métrica de cierre de Fase 1

Se considera Fase 1 cerrada cuando:

1. `pnpm --filter @vortech/common build` y `pnpm --filter @vortech/core build` pasan limpios.
2. Los subpath exports declarados en `package.json#exports` resuelven sin warnings con `attw` y `publint`.
3. `madge --circular` sobre `@vortech/core` da cero ciclos.
4. No queda código en `core/src/` que importe de `core/src/scope/scope-tree` ni de `core/src/di/di-root`.
5. Cada doc 30/40/50/60/70/71 tiene su PR correspondiente cerrada.

Detalles operativos en [`90-plan-refactor-fase-1.md`](90-plan-refactor-fase-1.md).
