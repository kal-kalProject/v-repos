# official-doc/ts/analysis/

Análisis dirigido de los dos primeros packages que entran al alineamiento con la plataforma:

- `repos/vortech/platform/v-common/` → futuro `@vortech/common`
- `repos/vortech/platform/core/` → futuro `@vortech/core`

El propósito de esta carpeta es **producir el plano de cambios** (no la implementación) que deja la base TypeScript alineada con:

1. La doctrina canónica de `official-doc/ts/01-cierre-decisiones-ts.md`.
2. La simetría con `official-doc/dotnet/` — primitivas con contrato equivalente en ambos lados.
3. Las decisiones recientes del chat: solo decoradores de clase, atoms sobre `@Input/@Output/@Inject`, zoneless, Wire WS+HTTP+in-process, **Scope y Route como hermanos**.

## Cómo leer

| # | Documento | Qué contesta |
|---|---|---|
| 00 | [Resumen ejecutivo](00-resumen-ejecutivo.md) | Qué se conserva, qué se mueve, qué se borra, qué se introduce |
| 10 | [Mapa actual de los dos packages](10-mapa-actual.md) | Inventario de carpetas y exports tal como están hoy |
| 20 | [Renombrado y exports `@vortech/*`](20-renombrado-y-exports.md) | Tabla `v-*` → `@vortech/*` y reorganización de subpath exports |
| 30 | [Atoms — análisis y refactor](30-atoms.md) | atom / derived / emitter / watch / owner / operators / tracker; correspondencia .NET |
| 40 | [DI — análisis y refactor](40-di.md) | injector / bindings / decoradores / `inject()` / lifecycles; doble vía actual; correspondencia .NET |
| 50 | [Scope y Route como hermanos](50-scope-y-route.md) | **Pieza clave.** Colapsar `scope/` + `context-handler/` y crear `route/` simétrico, en TS y .NET |
| 60 | [Extensions](60-extensions.md) | Manager + slots + `defineExtension`; reglas de uso desde Workbench |
| 70 | [Utilidades de v-common](70-utils-vcommon.md) | collections / trees / regex / expressions / middleware / data / char-codes |
| 71 | [Utilidades de v-core](71-utils-vcore.md) | runtime / meta / metadata / builders / linq / tree / history / globals / dom / node / serialization / event / application |
| 80 | [Tensiones y decisiones abiertas](80-tensiones-y-decisiones-abiertas.md) | Lo que aún está sin resolver y bloquea código nuevo |
| 90 | [Plan de refactor — Fase 1](90-plan-refactor-fase-1.md) | Pasos ordenados para llegar a `@vortech/common@1.0.0-rc1` y `@vortech/core@1.0.0-rc1` |

## Reglas de este análisis

1. **No se modifica código** en `repos/vortech/`. Sólo se documenta.
2. **Toda afirmación cita** `repos/vortech/platform/<pkg>/src/...:line` cuando aplica.
3. **Decisiones nuevas** quedan marcadas `Decisión: …`; **propuestas no cerradas** quedan marcadas `Propuesta: …`.
4. **Equivalencia .NET** se da explícita por primitiva; si no existe homólogo se dice.
5. La Fase 1 es **TypeScript exclusivamente**. Las decisiones cruzadas (Scope, Route, Atoms cross-runtime) que afecten .NET se anotan pero su implementación entra en una fase posterior.

## Ámbito explícito de Fase 1

Sólo entran al refactor inicial:

- `@vortech/common` — utilidades puras.
- `@vortech/core` — atoms, DI, scope, route, extensions, runtime detection, builders, meta, linq, tree, history, globals.

**No entran** en Fase 1 (tienen su propia fase): `@vortech/components`, `@vortech/layout`, `@vortech/theming`, `@vortech/workbench`, `@vortech/wire`, `@vortech/runtime` (Driver runtime), aplicación viva.
