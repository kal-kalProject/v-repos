---
titulo: "Hallazgos TS — Plataforma (core, v-common, v-components, v-layout, layout, @vortech/ui)"
tipo: analisis-preview
alcance: multi-repo
source_repos:
  - vortech
  - ui
fecha: 2025-11-06
supersede: ninguno
complementa:
  - inventory/_analysis-preview/PLATAFORMA-VISION-GLOBAL.v2.md
  - inventory/_analysis-preview/mis-anotciones.md
estado: draft
---

# Hallazgos — Lado TypeScript de la plataforma

> Preview antes de Fase 2 formal. Lectura directa de código real, no de `summary/`/`domains/`.
> **Reglas**: separo **hecho** (cita file:line), **observación** (agregación), **valoración** (juicio cualitativo), **hipótesis** (a validar).
> Todo cita rutas dentro de `repos/vortech/platform/` o `repos/ui/`.

---

## 0. Alcance y método

- **Propósito**: inventariar **qué está realmente construido** en el lado TS, para alimentar la decisión §6 X1 (`vortech/platform` vs `ui` como canónico) y §6 X6 (UIProvider drivers) del [v2](PLATAFORMA-VISION-GLOBAL.v2.md).
- **Método**: lectura de `public-api.ts`, `index.ts`, y archivos clave de cada package. No se leyó cada `.ts`; los juicios de "madurez" son sobre superficie pública + archivos núcleo.
- **Fuera de alcance**: `ui/packages/ai-*`, `cnc-monkey`, `sii-dte-signer`, `llama-client`, `proxmox-client`, `vscode`, etc. — son **verticales/productos** y merecen su propio análisis dedicado (ver §8).

---

## 1. Mapa de packages TS relevantes

### Línea A — `vortech/platform/` (framework research)

| Package | Nombre npm | Rol aparente | Madurez |
|---|---|---|---|
| `core` | `v-core` / `@vortech/core` | Atoms (signals) + DI + extensions + event + collections + linq + tree + scope + meta + runtime-detect | **Alta** |
| `v-common` | `v-common` | Utilidades transversales (collections, trees, regex, expressions, middleware) | Media |
| `v-components` | (no leído) | **Framework Angular-like custom**: `@Component`, `@Input`, `@Output`, `html`\`\`, control flow `@if/@for/@switch`, scoped styles, registry | **Alta** |
| `v-layout` | `@vortech/v-layout` (no leído) | **Port directo del shell VSCode**: Workbench + 7 Parts (title/activity/side/aux/panel/editor/status) + SplitView + command palette + notifications + tree-view contribute | **Alta** |
| `layout` | `@vortech/layout` | Layout primitives extraídas limpiamente (Sash, SplitView, GridView). Subconjunto "sano" de v-layout | Media-alta |
| `v-ui` | (no leído) | Entry equivalente a v-layout pero reducido (`browser/`, `common/`, `public-api.ts`, sin `workbench/contributes`) | **Hipótesis**: versión refactor-candidate |
| `v-components` (theming dentro) | — | Ver también package `theming/` hermano |
| `theming` | (no leído) | Sistema de theming con tokens + presets + core | Media (tiene typedoc) |
| `v-runtime` | (no leído) | Detección runtime (browser/node/mobile/edge) + runtimes específicos | Baja-media |
| `sdk` | (no leído) | SDK con demo/ — **hipótesis**: superficie de consumo externa | No determinado |
| `v-api-factory` | (no leído) | Factoría tipo `ejemplo-storage-api.md` sugiere decorator-driven API | No determinado |

### Línea B — `ui/packages/` (integrador + verticales)

| Package | Rol aparente | Relación con Línea A | Madurez |
|---|---|---|---|
| `core` | `action/ adapter/ api/ atom/ builder/ communication/ injection/ metadata/ pipeline/ runtime/ serialization/ template/ translation/ tree-node/` | **Duplica v-core** con adiciones propias (`communication/` = Wire; `pipeline/` = Host pipeline; `translation/` = i18n) | Media (no leído) |
| `common` | `apis/ coercion/ color/ converters/ guards/ key/ platform/ types/ utils/ validation/ value/` | **Duplica v-common** con enfoque UI-util (coerciones, color, validation) | Media |
| `platform` | `platform-angular/ platform-node/ feature/ reactive/ scope/ app/ builder-toolkit/ context/ injection/ shared-service.ts` | **El verdadero UIProvider multi-driver** (Angular + Node bajo una abstracción común). No existe equivalente en Línea A | Media-alta (clave para X6) |

### Línea C — `ui/projects/ui/ui/` (Angular component library)

- **`@vortech/ui`** — ~100 componentes (button, accordion, datepicker, table, tree, editor, terminal…) con `ng-package.json`. **Es un fork rebranded de PrimeNG** (lista idéntica incluso a componentes raros como `organizationchart`, `speeddial`, `metergroup`).
- Peer deps Angular. Deps internas `@vortech/ui-core` + `@vortech/chart` (workspace:*).
- **Valoración**: es la capa de consumo "realista hoy" — lo que Angular apps usan. No sigue el modelo de decoradores de `v-components`.

---

## 2. Hallazgos por subsistema

### 2.1 Atoms (signals)  — `core/src/atoms/`

**Hechos**:
- `atom()` es callable (lee) + `.set()` (escribe) ([core/src/atoms/atom/atom.ts:30](../../repos/vortech/platform/core/src/atoms/atom/atom.ts)).
- API completa exportada desde `ui/packages/common/src/index.ts:28-55`: `atom, derived, derivedWithFallback, watch, watchWithErrorBoundary, batch, flushSync, GlitchFreeScheduler, untracked, asyncDerived, AtomScope, createScope, withScope`, + devtools (`enableDevTools`), + errores tipados (`AtomError, CircularDependencyError, DerivedEvaluationError, WatchExecutionError`).
- Operadores emitter (20+): `async-emitter, buffer, concat, debounce, defer, flat-map, merged, pauseable, relay, scan, skip, throttle, delivery-queue, observable-bridge` (`core/src/atoms/emitter/`).
- Extensiones del modelo: `atom-family`, `linked-atom`, `transaction`, `peek`.
- `AtomScope` + `createScope` + `withScope` permiten aislar grafos reactivos — se alinea con la primitiva **Scope** del [v2 §1.9](PLATAFORMA-VISION-GLOBAL.v2.md).

**Observación**: el modelo reactivo **no es Angular signals** ni Preact signals; es una implementación completa propia con glitch-free scheduler y error boundaries tipados. La API de `batch()` + `untracked()` + `isInReactiveContext()` es más rica que Angular.

**Valoración**: **producción-ready en apariencia**. Amplitud comparable a SolidJS signals + primitivas extra (family, linked, transaction).

**Duplicación crítica**: `ui/packages/core/src/atom/` existe también — probablemente generación anterior o hermano. **Hay que consolidar en uno**.

### 2.2 DI  — `core/src/di/`

**Hechos**:
- Injector completo: `injector.ts` tiene 50+ líneas solo de imports ([core/src/di/injector/injector.ts:1-80](../../repos/vortech/platform/core/src/di/injector/injector.ts)).
- Tokens tipados (`ClassToken`, `InjectionToken`), lifecycle hooks (`InjectorHooks`), bindings (`ClassBinding`, `BindToSyntax`, `BindingRegistry`), errores ricos (`TokenNotFoundError, CircularDependencyError, FrozenInjectorError, InjectorDisposedError, ShadowConflictError, ResolutionCancelledError`), resolution-pipeline (`checkCache, applyActivation, injectFields, applyLifecycle, applyDeactivation, wrapResolutionError`), resolución async con cancelación, integración con `ScopeTree` (context-handler).
- Builders de decoradores: `ClassDecoratorBuilder`, `FieldDecoratorBuilder`, `InjectableDecoratorBuilder`, `InjectorDecoratorBuilder`, `DiMethodBuilder` (`core/src/di/decorators/`).
- Integración linq: el Injector usa `Query, RxQuery` de `@vortech/core/linq` para introspección.

**Valoración**: DI de **gama profesional** (Inversify/tsyringe-class). El pipeline con cancelación + integración Scope es atípicamente ambicioso para un DI TS.

### 2.3 Extensions (slots)  — `core/src/extensions/`

**Hechos**:
- API mínima: `defineExtension<TDesc, TApi>(name)` → `ExtensionSlot` con `id: Symbol` + `create(factory)` para definir factories parametrizadas ([core/src/extensions/slot.ts:1-50](../../repos/vortech/platform/core/src/extensions/slot.ts)).
- `Extensions<TDesc extends HostCapabilities>` manager: `.use(def)` con check de deps, `.query(slot)`, `changes` emitter, `_version` atom, `dispose` reverso, iterable ([core/src/extensions/extensions.ts:1-100](../../repos/vortech/platform/core/src/extensions/extensions.ts)).
- Decisión de diseño: NO implementa `Queryable` para romper acoplo circular con linq/.

**Valoración**: implementación **elegante y desacoplada**. Responde exactamente a la primitiva **Extension** del [v2 §1.12](PLATAFORMA-VISION-GLOBAL.v2.md) en su cara TS.

**Gap**: `v-layout` (§2.6) **no la usa** — usa sus propias "registries" internas en la Workbench. Ver §3.

### 2.4 Componentes (framework Angular-like)  — `v-components/src/`

**Hechos**:
- `@Component({ selector, styles, encapsulation, template, providers })` ([v-components/src/decorators/component.ts:41-53](../../repos/vortech/platform/v-components/src/decorators/component.ts)) — API **casi idéntica a Angular**.
- `@Input()` con `alias?: string`, `transform?: (v) => any`, `required?: boolean` ([v-components/src/decorators/input.ts:19-32](../../repos/vortech/platform/v-components/src/decorators/input.ts)).
- `@Output()`, `@Directive()` declarados (`src/decorators/output.ts`, `directive.ts`).
- Templates: tagged template literal propia `html\`<div class=${cls}>${v}</div>\`` ([v-components/src/template/html.ts:21-24](../../repos/vortech/platform/v-components/src/template/html.ts)) — **NO es lit-html**, es parser propio.
- Parser con **control flow Angular-17-style**: `@if`, `@for`, `@switch` → `parseTemplate()` detecta y produce `PreparedTemplate` con `markers`, `controlFlows`, HTML procesado ([v-components/src/template/parse-template.ts:1-80](../../repos/vortech/platform/v-components/src/template/parse-template.ts)).
- Markers tipados: `ControlFlowNode`, `ControlFlowBranch`, `TemplateContext`, `TemplateSlot`.
- Scoped styles reales: `apply-scope`, `generate-scope-id`, `inject-component-styles`, `scope-styles` ([v-components/src/styling/](../../repos/vortech/platform/v-components/src/styling/)).
- Scheduler propio con `schedule-frame` + `disposable-group` (`v-components/src/scheduler/`).
- ComponentRegistry central (`v-components/src/renderer/component-registry.ts`).

**Valoración**: **framework Angular-like real y coherente**. DX objetivo claramente alineado con *"componentes Angular, con su theming, typings de instance y bindings"*. No es un experimento — es trabajo de meses.

**Hipótesis (a validar)**: motor reactivo detrás = atoms de `v-core` → actualización fina, sin Zone, sin VDOM, similar a SolidJS pero con ergonomía Angular.

### 2.5 Theming  — `theming/src/`

**Hechos**: `components/`, `components-style-tokens.ts`, `core/`, `default-preset/`, `index.ts`. Tiene `.doc/` y `typedoc.json`. Estructura reconocible estilo PrimeNG Tailwind preset.

**Hipótesis**: sistema de tokens reutilizable por **ambos** stacks (v-components custom + Angular @vortech/ui). Clave para la propuesta §2.5.

### 2.6 Shell VSCode  — `v-layout/src/`

**Hechos**:
- Puerto **directo** de `vs/base` + `vs/workbench/browser/parts`. Nombres de archivos idénticos a fuentes VSCode: `browser/dnd.ts`, `browser/dompurify/`, `browser/event.ts`, `browser/fastDomNode.ts`, `browser/formattedTextRenderer.ts`, `browser/iframe.ts`, `browser/indexedDB.ts`, `browser/keyboardEvent.ts`, `browser/markdownRenderer.ts`, `browser/trustedTypes.ts`, `browser/ui/` (splitview, tree, list, etc.).
- `common/` con `codicons, ternarySearchTree, observableInternal, marked, fuzzyScorer, glob, jsonFormatter, jsonSchema, keyCodes, keybindings, map, prefixTree, resourceTree, sseParser, uri, uriIpc, uriTransformer` — básicamente **`vs/base/common` completo**.
- `Workbench extends Disposable` con 7 parts: `TitleBarPart, ActivityBarPart, SidebarPart, EditorPart, PanelPart, AuxiliaryBarPart, StatusBarPart` + `EditorPanelArea` (editor+panel vertical split) ([v-layout/src/workbench/workbench.ts:30-100](../../repos/vortech/platform/v-layout/src/workbench/workbench.ts)).
- `IWorkbenchRegistries` (no DI!) mantiene estado de: `IActivityBarItem, IEditorTab, IPanelTab, IStatusBarItem, IMenuItem, IAuxiliaryBarView, IBreadcrumbItem, ICommand, INotification`.
- Contribute pattern: `createTreeView(options: ITreeViewOptions)` devuelve `ISidebarView` ([v-layout/src/contributes/tree-view.ts:1-80](../../repos/vortech/platform/v-layout/src/contributes/tree-view.ts)).
- Clase base `WorkbenchPart extends Disposable` con `id, element, create()` ([v-layout/src/workbench/parts/workbench-part.ts:1-24](../../repos/vortech/platform/v-layout/src/workbench/parts/workbench-part.ts)).

**Valoración**: es **el shell VSCode real** — no un mock. Aporta el 80% del trabajo "tipo IDE" listo.

**Gap crítico**: el shell usa sus propias **registries mutables** en lugar de `v-core/extensions`. Son dos sistemas de plugin compitiendo:
1. `v-core/extensions`: slots tipados, dispose reverso, DI-friendly.
2. `v-layout/workbench/registries`: mapas/listas internas, API imperativa tipo VSCode (`registries.commands.register(...)`).

**No están integrados.** Es la brecha más importante para la propuesta (§3 de [PROPUESTA-UI-SHELL.md](PROPUESTA-UI-SHELL.md)).

### 2.7 Layout primitives (limpio)  — `layout/src/`

**Hechos**: `public-api.ts` exporta **solo** `Sash, SplitView, GridView, Disposable, Event, Emitter, Relay` + tipos de layout ([layout/src/public-api.ts:1-40](../../repos/vortech/platform/layout/src/public-api.ts)). Es **el núcleo layout VSCode limpiamente separado**.

**Observación**: existe *en paralelo* a `v-layout/src/browser/ui/splitview/` que tiene lo mismo. **Duplicación consciente**: `layout/` es la **cara pública estable**; `v-layout/` lo re-empaqueta internamente como port monolítico.

**Propuesta implícita**: quedarse con `layout/` como primitiva pública y hacer que `v-layout/` dependa de él (o replace su copia interna).

### 2.8 UIProvider multi-driver  — `ui/packages/platform/src/`

**Hechos**:
- `platform-angular/` + `platform-node/` como sub-módulos ([ui/packages/platform/src/](../../repos/ui/packages/platform/src/)).
- Carpetas nucleares: `action/ api/ app/ builder-toolkit/ common/ context/ feature/ injection/ metadata/ reactive/ scope/ shared-service.ts`.

**Observación**: es **la materialización más clara del concepto UIProvider/UIDriver** de [v2 §1.1-1.2](PLATAFORMA-VISION-GLOBAL.v2.md). Existe en Línea B (`ui/`), no en Línea A.

**Valoración**: es el puente natural entre `@vortech/ui` (Angular) y un hipotético driver `v-components` — si se adopta, responde §6 X6 (drivers UI) antes que X1 (canónico).

---

## 3. Duplicaciones y conflictos detectados

| # | Concepto | Ubicación A | Ubicación B | Gravedad |
|---|---|---|---|---|
| D1 | Atoms/signals | `vortech/platform/core/src/atoms/` | `ui/packages/core/src/atom/` | **Alta** — dos implementaciones |
| D2 | Core utilities | `vortech/platform/v-common/src/` | `ui/packages/common/src/` | Alta — focos distintos pero solapamiento |
| D3 | DI / injection | `vortech/platform/core/src/di/` | `ui/packages/core/src/injection/` + `ui/packages/platform/src/injection/` | **Crítica** — triplicado |
| D4 | Layout engine | `vortech/platform/layout/src/` | `vortech/platform/v-layout/src/browser/ui/splitview/` | Consciente (layout es el extract público) |
| D5 | Workbench / Shell | `vortech/platform/v-layout/src/workbench/` | No hay competidor TS | N/A |
| D6 | Plugin/extension system | `vortech/platform/core/src/extensions/` (slots) | `vortech/platform/v-layout/src/workbench/registries/` (mutable maps) | **Alta** — brecha de integración |
| D7 | UI components | `vortech/platform/v-components/` (custom) | `ui/projects/ui/ui/` (Angular PrimeNG fork) | **Crítica** — dos stacks incompatibles; X6 |
| D8 | Theming / styles | `vortech/platform/theming/` + `v-components/styling/` | `ui/projects/ui/ui/` (estilos PrimeNG) | Media |
| D9 | Template engine | `v-components/src/template/` (html tag + parser propio) | Angular templates (via Angular compiler) | Inherente a D7 |
| D10 | Runtime detection | `vortech/platform/core/src/runtime/` + `vortech/platform/v-runtime/` | — | Baja — probable v-runtime sucesor |
| D11 | v-layout vs v-ui | `vortech/platform/v-layout/src/` | `vortech/platform/v-ui/src/` | **Hipótesis**: v-ui es refactor-candidate de v-layout — requiere investigación |

---

## 4. Qué NO está construido (vs visión v2)

| Primitiva v2 | Estado TS | Nota |
|---|---|---|
| Provider | **Implícito** | No hay tipo `Provider<T>` canónico. Los "providers" del DI (`providers: any[]` en `@Component`) son providers de DI, no los Provider de la visión. |
| Driver | **Implícito** | Solo `platform-angular/` / `platform-node/` insinúan el patrón. No hay `Driver<TProvider>` genérico. |
| Agent | **No** | Nada TS reconocible como Agent polyglot executor. |
| Wire | **Parcial** | `ui/packages/core/src/communication/` podría serlo — no leído. |
| Bridge (cross-lang) | **No** | `vortech/platform/v-runtime/src/__runtimes/` es hint, no implementación. |
| Host | **No** (en TS) | Es concepto de ASP.NET; el equivalente TS sería `Workbench`. |
| Identity | **No** | Conceptualmente un Host autónomo. |
| Data (Provider+Driver+Bridge) | **No** | Hay `sii-dte-signer`, `storage`, `drizzle-base-sqlite` — verticales, no el patrón Data como demo. |
| Scope | **Construido** | `AtomScope` + `ScopeTree` (core/context-handler) + `scope/` (platform) |
| Router | **No** | Ni en platform ni en ui/packages hay Router canónico identificado. |
| Capability | **Implícito** | `HostCapabilities` genérico en `core/extensions/types.ts` — base para formalizarlo. |
| Extension | **Construido** | `defineExtension` + `Extensions` manager (§2.3). |

**Conclusión**: las primitivas *reactivas/infraestructurales* están avanzadas (Atoms, DI, Scope, Extension); las primitivas *distribuidas/polyglot* (Provider/Driver/Wire/Bridge/Agent/Host) son C#-first o aún no-TS.

---

## 5. Valoración global de madurez

| Package | Madurez | Evidencia | Riesgo al apostar |
|---|---|---|---|
| `core` (atoms+DI+extensions) | **Alta** | API amplia, errores tipados, builders, scheduler, scopes | **Bajo** |
| `v-components` | **Alta** | Decoradores + parser + control flow + scoped styles + scheduler | Medio (reescribir si se migra a Angular canónico) |
| `v-layout` | **Alta** | Shell completo + Workbench real + 7 parts + contributes | Medio (depende de integración con Extensions §D6) |
| `layout` | **Alta** | Primitivas extraídas limpiamente con public-api | Bajo |
| `v-common` | Media | No leído en profundidad | Bajo |
| `theming` | Media | Estructura clara, typedoc configurado | Bajo |
| `@vortech/ui` | Alta | ~100 componentes | Alta dependencia de Angular |
| `ui/packages/platform` | Media-alta (hipótesis) | Existe `platform-angular` + `platform-node` | Medio — clave X6 |
| `ui/packages/core` | Media | Duplica Línea A con extras (communication, pipeline) | **Alto** — duplicación |
| `v-ui`, `v-runtime`, `sdk`, `v-api-factory` | No determinado | Solo estructura vista | Medio — requiere lectura dedicada |

---

## 6. Verticales integradoras — lo que aparece en `ui/packages/`

Observación clave no documentada antes:

`ui/packages/` **ya contiene verticales alineadas con los 7 casos de uso del v2 §8**:

| Vertical v2 | Package(s) en `ui/packages/` |
|---|---|
| IA (agentes, chat) | `ai-assistant/`, `ai-server/`, `llama-client/`, `composer/`, `ai-chat/` (en `ui/projects/ui/`) |
| CNC | `cnc-monkey/` |
| Tributario CL | `sii-dte-signer/` |
| Infra/virtualización | `proxmox-client/`, `hosting/`, `server-side/` |
| Dev tools / IDE | `devtools/`, `dev-server/`, `editor/`, `studio/`, `vscode/`, `language-server/`, `lang/`, `lang-vscode/`, `vc-language-py/` |
| Datos | `drizzle-base-sqlite/`, `storage/`, `data/` (en `ui/projects/ui/`) |
| UI / app | `angular-app/`, `demo/`, `presets/`, `tailwindcss-plugin/`, `theming/` |

**Implicación**: `ui` **no es sólo "la Angular lib"** — es **el monorepo integrador donde ya viven las verticales reales**. Re-evalúa X1: probablemente la respuesta no es "vortech canónico vs ui canónico" sino **roles complementarios** (vortech = framework research; ui = integración de producto).

---

## 7. Preguntas inmediatas al autor (a resolver en QUESTIONS-TS-SHELL.md)

Las 5 más urgentes — el detalle completo en [QUESTIONS-TS-SHELL.md](QUESTIONS-TS-SHELL.md).

1. ¿`v-components` (Angular-like custom) es la **apuesta futura** o un experimento mantenido?
2. ¿`v-layout` es el **shell canónico** de todas las apps, o solo de las "tipo IDE" (devtools, studio, editor)?
3. ¿Las registries internas de Workbench deben **migrarse** a `v-core/extensions`, o coexisten por diseño?
4. ¿`ui/packages/platform/platform-angular` + `platform-node` son la base para X6 (UIDriver)?
5. ¿`ui/packages/core` y `ui/packages/common` se **deprecan** o se **fusionan** con `v-core` + `v-common`?

---

## 8. Qué sigue

- Leer [PROPUESTA-UI-SHELL.md](PROPUESTA-UI-SHELL.md) — camino arquitectónico para el shell + sistema de extensions consumiendo atoms/DI, con API de componentes estilo Angular.
- Leer [QUESTIONS-TS-SHELL.md](QUESTIONS-TS-SHELL.md) — preguntas que bloquean decisiones.
- Pendiente en una pasada dedicada: `v-api-factory/`, `sdk/`, `v-ui/`, `ui/packages/core/communication/`, `ui/packages/core/pipeline/`, y las verticales (§6).
