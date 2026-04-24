# 30 — Atoms — análisis y refactor

> **Veredicto rápido.** El sistema de atoms está sano y completo. No requiere rediseño, sólo: (a) consolidar exports bajo un único barrel `@vortech/core/atoms`, (b) clarificar la frontera entre `atom`/`derived`/`emitter`/`watch` y (c) confirmar que el modelo coincide con la doctrina del cierre TS — `atom()`, `emitter()`, `derived()`, `watch()` como funciones reactivas, sin decoradores.

Referencias canónicas: `01-cierre-decisiones-ts.md §5`, `22-components.md`.

---

## 1. Inventario de subdominios

```
core/src/atoms/
├── atom/        — atom, linkedAtom, atomFamily, peek, transaction, isAtom, isWritableAtom
├── core/        — ReactiveNode, scheduler, dependency-tracker, glitch-free-scheduler,
│                  circular-detector, hooks, errors
├── derived/     — derived, asyncDerived, derivedWithFallback, lazyDerived, recompute,
│                  retryDerived, select, switchDerived, UNSET
├── devtools/    — instrumentación opt-in
├── emitter/     — emitter, asyncEmitter, bufferEmitter, debounceEmitter, throttleEmitter,
│                  pauseableEmitter, deferEmitter, relay, mergeEmitters, mapEmitter,
│                  filterEmitter, distinctEmitter, take/once/onceIf, withLatestFrom,
│                  zipEmitters, shareReplay, pipeEmitter, toObservable, fromObservable
├── event-handler/ — Event, EventContainer, ActionFunc, CancellationToken,
│                    CancellationTokenSource, Interceptor (capa imperativa de eventos)
├── operators/   — combine, debounced, throttled, periodic, previous, reduced,
│                  createWatchedAtom
├── owner/       — IAtomOwner, createOwner, withOwner (scoping de atoms)
├── tracker/     — granular-tracker, version-tracker
└── watch/       — watch, watchEffect, watchWithErrorBoundary, when, WhenTimeoutError,
                  destroyWatch, destroyAllWatches, getActiveWatchCount, activeWatches
```

### 1.1 Primitivas — qué hacen, en una frase

| Primitiva | Una frase |
|---|---|
| `atom(initial, opts?)` | Estado reactivo escribible (`get/set/update/asReadonly`) — núcleo del sistema. |
| `linkedAtom(...)` | Atom escribible derivado de otros atoms (ida y vuelta). |
| `atomFamily<K,V>(factory)` | Mapa caché de atoms parametrizados por clave. |
| `peek(atom)` | Lee sin trackear como dependencia. |
| `transaction(() => …)` | Agrupa múltiples sets en un solo flush coherente. |
| `derived(fn)` | Computación reactiva sólo lectura, recomputa cuando deps cambian. |
| `asyncDerived(fn)` | Versión async con `AsyncState<T>` (`loading/value/error`). |
| `lazyDerived` / `derivedWithFallback` / `retryDerived` / `switchDerived` / `select` / `recompute` | Variantes con políticas concretas. |
| `watch(fn)` / `watchEffect(fn)` | Side-effect que se reejecuta cuando deps cambian. |
| `when(predicate, opts?)` | Promesa que resuelve la primera vez que el predicado se cumple (con timeout). |
| `emitter<T>()` | Stream imperativo con `emit/asReadonly/dispose`, base de eventos. |
| `relay`, `bufferEmitter`, `debounceEmitter`, `throttleEmitter`, `pauseableEmitter`, `deferEmitter`, `asyncEmitter` | Operadores sobre emitters. |
| `mergeEmitters`, `mapEmitter`, `filterEmitter`, `distinctEmitter`, `take`, `onceIf`, `once`, `pipeEmitter`, `withLatestFrom`, `zipEmitters`, `shareReplay` | Combinadores. |
| `toObservable` / `fromObservable` | Puente con `rxjs`-style observables. |
| `Event` / `EventContainer` / `ActionFunc` / `Interceptor` | Capa imperativa de eventos con cancelación. |
| `CancellationToken` / `CancellationTokenSource` | Cancelación cooperativa, equivalente a `CancellationToken` de .NET. |
| `IAtomOwner` / `createOwner` / `withOwner` | Asocia atoms a un dueño con dispose en cascada. |

### 1.2 Núcleo `atoms/core/`

- `ReactiveNode` — nodo del grafo reactivo con `version`, deps, dependents.
- `scheduler` — flush en microtask, glitch-free.
- `glitch-free-scheduler` — ordena recomputaciones por topología.
- `dependency-tracker` — trackea reads dentro de un computation context.
- `circular-detector` — detecta ciclos de dependencia.

→ Diseño cercano a SolidJS / Angular signals (post zoneless). No requiere cambios.

---

## 2. Reglas invariantes (a documentar formalmente)

1. **Llamar a un atom como función `atom()`** dentro de `derived`/`watch` lo registra como dependencia.
2. **`peek()` no trackea.** Lectura de transición.
3. **No se llama `set` dentro de `derived`/`watch` síncronamente** — error en runtime (`assertWriteAllowed`).
4. **`transaction(() => …)` es la forma de hacer múltiples sets como un solo flush.**
5. **Todo `watch` retorna un `WatchRef` que debe disponerse** o estar bajo un `IAtomOwner`.
6. **`emitter` no es un atom.** No participa del grafo reactivo. Es para eventos puntuales.
7. **`event-handler/Event` es la API imperativa.** Internamente puede usar emitter; expone `add/remove/dispose`. Es el equivalente del `event` de C# / `IObservable` mínimo.

## 3. Frontera con `event/` (carpeta vieja)

`core/src/event/` contiene `cancellation/`, `emitter/`, `lifecycle/`. Es **anterior** a `atoms/event-handler/` y `atoms/emitter/`.

**Decisión.** Migrar consumidores de `core/src/event/*` a `core/src/atoms/event-handler/*` y `core/src/atoms/emitter/*`. Borrar `core/src/event/` cuando no queden referencias. Subpath `@vortech/core/event` queda como alias de `atoms/event-handler` durante un release de transición.

## 4. Frontera con `dom/atoms/`, `node/atoms/`, `serialization/atoms/`

Tres carpetas usan el namespace `atoms/` pero proveen helpers reactivos para sus respectivos dominios (DOM events como atoms, fs watchers como atoms, etc.). **No son confusión** — son extensiones de dominio. Se conservan tal cual.

Regla: cualquier subdominio puede tener un `atoms/` interno con utilidades reactivas específicas; el subdominio raíz `core/src/atoms/` es el único que define **primitivas reactivas**.

## 5. Modelo del cierre vs realidad actual

El cierre TS `01-cierre-decisiones-ts.md §5` exige:

```ts
class SkuListView {
  readonly skuId   = input<SkuId | null>(null);
  readonly select  = output<Sku>();
  private readonly inv = inject(IInventoryProvider);
}
```

Hoy el equivalente directo en `@vortech/core/atoms` es:

```ts
class SkuListView {
  readonly skuId   = atom<SkuId | null>(null);   // input  → atom escribible
  readonly select  = emitter<Sku>();             // output → emitter
  private readonly inv = inject(IInventoryProvider);
}
```

**Brecha.** Las funciones `input()` / `output()` que el cierre menciona **no existen todavía** en `@vortech/core`. Existen `atom()` y `emitter()`.

**Decisión.** Se introducen como **alias semánticos** en `@vortech/components` (no en core), porque su sentido depende del modelo de Component:

```ts
// @vortech/components/inputs.ts
export const input  = <T>(initial: T, opts?: InputOptions<T>): WritableAtom<T> => atom(initial, opts);
export const output = <T>(opts?: OutputOptions<T>): Emitter<T>               => emitter<T>();
```

Las primitivas duras (`atom`, `emitter`) viven en `@vortech/core/atoms`. Los alias con semántica de UI viven en `@vortech/components`. Esto preserva la separación: `@vortech/core` no sabe nada de "input"/"output" como conceptos visuales.

## 6. Correspondencia con `dotnet/`

Mapping de primitivas (no implementación cruzada — sólo equivalencia conceptual):

| TS (`@vortech/core/atoms`) | .NET (`Vortech.Core.Atoms`) | Notas |
|---|---|---|
| `atom<T>()` | `IAtom<T>` (read) + `IWritableAtom<T>` (write) | El equivalente directo de `atom` con `set/update/asReadonly`. |
| `derived(fn)` | `Derived(...)` / `Computed<T>(fn)` | Recomputación sobre cambios; nombre canónico .NET `Computed`. |
| `asyncDerived(fn)` | `AsyncComputed<T>(fn)` | Estado `AsyncState<T>` con `IsLoading/Value/Error`. |
| `emitter<T>()` | `IEmitter<T>` con `Emit`, `OnEmit`, `Dispose` | Stream imperativo. |
| `watch(fn)` | `Watch(fn) → IWatchRef` | Side effect reactivo con `Dispose`. |
| `when(pred, opts?)` | `When(pred, opts?) → ValueTask` | Equivalente a `TaskCompletionSource` con cancelación. |
| `transaction(() => …)` | `using var txn = Atom.Transaction()` | Patrón using/IDisposable en .NET. |
| `peek(atom)` | `Atom.Peek(a)` | Lectura sin tracking. |
| `IAtomOwner` / `createOwner` | `IAtomOwner` / `AtomOwner.Create()` | Dueños con dispose en cascada. |
| `CancellationToken(Source)` | `System.Threading.CancellationToken(Source)` | Reusar el de BCL en .NET. |
| `Event` / `EventContainer` | `Event` / `EventContainer` | Mismo patrón; en .NET puede coexistir con `event` keyword. |

**Regla de simetría.** Cualquier nueva primitiva que se añada a `core/atoms/` debe poder describirse con la misma firma conceptual en `dotnet/atoms/`. Si no se puede, no entra al core — vive en un dominio superior.

## 7. Acciones de Fase 1 sobre atoms

1. ✅ Auditar `core/src/atoms/index.ts` — ya es completo. Sólo verificar que cada export tenga su tipo asociado.
2. ⬜ Promover `atoms/` a subpath export oficial `@vortech/core/atoms` (ya parcialmente). Documentar en [`20-renombrado-y-exports.md`](20-renombrado-y-exports.md).
3. ⬜ Marcar `core/src/event/` como deprecated; abrir issue de migración.
4. ⬜ Añadir `core/src/atoms/README.md` con tabla 1.1 + reglas §2.
5. ⬜ Verificar que `devtools/` queda detrás de un flag `__DEV__` y se tree-shakea en producción (script `tree-shake` ya existe en `package.json`, ampliar).
6. ⬜ Confirmar que `circular-detector.ts` y `glitch-free-scheduler.ts` están bajo tests y documentar invariantes (notas en `core/propuestas/registry-atoms.md`).

## 8. Lo que NO se toca en Fase 1

- Implementación interna de `core/`, `scheduler`, `tracker`, `derived`. Son sólidas; cualquier optimización entra como ticket aparte.
- Operadores (`mapEmitter`, etc.) — completos.
- API de `atomFamily` — la usa LINQ y DI.

## 9. Riesgos

| Riesgo | Mitigación |
|---|---|
| Consumidores que dependen del barrel raíz `@vortech/core` para `atom` siguen funcionando | El barrel `public-api.ts` ya re-exporta `atoms`; mantenemos esto durante la transición. |
| `IAtomOwner` se usa en DI (`Injector.scope: IAtomOwner`) | Cualquier cambio en `IAtomOwner` rompe DI; congelado en Fase 1. |
| `event-handler` y `event/` viven en paralelo | Marcar `event/` como soft-deprecated; abrir issue antes de borrar. |
