# Cierre de decisiones — TypeScript / frontend

> **Estado.** Normativo. Consolida y finaliza las decisiones sobre el lado TS de la plataforma, reemplazando cualquier versión intermedia que haya sugerido lo contrario.
>
> **Complementa a** [`00-responsabilidad-del-frontend.md`](00-responsabilidad-del-frontend.md): aquel describe el rol; éste fija las decisiones que materializan ese rol.

---

## 1. Regla madre

> **El código TS de la plataforma es 100% propio. Las únicas dependencias permitidas son TypeScript estándar y APIs nativas del runtime (DOM, Web APIs en browser; Node estándar cuando aplique). Cualquier otra librería queda fuera del núcleo.**

Igual que en .NET ([`../dotnet/01-cierre-decisiones-dotnet.md §1`](../dotnet/01-cierre-decisiones-dotnet.md)): decisión cerrada, no aspiración.

---

## 2. Qué es "propio" y qué es "nativo"

### 2.1 Permitido sin discusión

- **TypeScript estándar** y target de compilación moderno.
- **Web Platform APIs**: DOM, `fetch`, `WebSocket`, `BroadcastChannel`, `IndexedDB`, `Web Workers`, `Web Streams`, `Crypto Subtle`, `IntersectionObserver`, `ResizeObserver`, `Pointer Events`, `Custom Elements`/`Shadow DOM` cuando aplique.
- **Node APIs estándar** cuando el código corre en Node (build tools, SSR, drivers `platform-node`).
- **Toolchain del repo**: tsc, bundler oficial elegido (decisión operativa, fuera de este doc), test runner, linter, format. Estos son herramientas de build, no dependencias del runtime.

### 2.2 Propio

Todo lo demás se escribe en Vortech. Incluye:

- Sistema de atoms / signals / reactividad.
- Inyector DI tipado.
- Sistema de extensiones / slots.
- Framework de componentes (decoradores, parser de templates, scheduler, scoped styles).
- Shell tipo Workbench.
- Primitivas de layout (Sash, SplitView, GridView).
- Cliente Wire (codificación, correlación, retries, idempotencia).
- Provider proxies y Providers locales.
- Router del shell.
- Cargador de Extensions UI.
- Sistema de theming / tokens.

### 2.3 Excluido del núcleo

Quedan fuera, como dependencia del frontend de plataforma:

- **Frameworks de componentes externos**: Angular, React, Vue, Svelte, Solid, Lit, Preact.
- **Estado/efectos**: RxJS, MobX, Redux, Zustand, Recoil, XState (como dependencia; sus ideas pueden inspirar el código propio).
- **HTTP / RPC clients**: Axios, ky, trpc, gRPC-web, signalr-client, OpenAPI-generated clients.
- **CSS frameworks**: Tailwind como dependencia runtime, styled-components, emotion. (Tailwind como herramienta de tooling de desarrollador local es decisión operativa separada).
- **UI kits**: PrimeNG, Material, Ant, Chakra, Bootstrap.
- **Forms**: Formik, react-hook-form, AngularForms.
- **Routers**: react-router, vue-router, @angular/router.

La plataforma **no las referencia** desde el núcleo.

### 2.4 Caso especial — `@vortech/ui` (Angular fork PrimeNG)

`@vortech/ui` (en `repos/ui/projects/ui/ui/`) **queda archivado** como referencia visual / catálogo de comportamiento UX. Sus ~100 componentes son el **mapa de qué componentes hay que tener** en `@vortech/components`. No es dependencia, no es destino — es inspiración visual.

---

## 3. Naming canónico de packages

Todo paquete TS de la plataforma usa el scope **`@vortech/*`**. Sin excepción.

Renombrado canónico desde el estado actual:

| Estado actual | Canónico |
|---|---|
| `v-core` | `@vortech/core` |
| `v-common` | `@vortech/common` |
| `v-components` | `@vortech/components` |
| `v-layout` (port VSCode) | `@vortech/workbench` |
| `layout` (primitivas Sash/Split/Grid) | `@vortech/layout` |
| `theming` | `@vortech/theming` |
| `v-runtime` | `@vortech/runtime` |
| `sdk` | `@vortech/sdk` |
| `v-api-factory` | `@vortech/api-factory` |
| `v-ui` | (a revisar — posible refactor de `@vortech/workbench`) |
| `@vortech/ui` (Angular fork) | (queda archivado, ver §2.4) |
| `ui/packages/core` | reconvertir / fusionar con `@vortech/core` |
| `ui/packages/common` | reconvertir / fusionar con `@vortech/common` |
| `ui/packages/platform/platform-angular` | archivado (Angular fuera del núcleo) |
| `ui/packages/platform/platform-node` | reconvertir → `@vortech/runtime` o `@vortech/sdk-node` |
| (futuro Wire TS) | `@vortech/wire` |
| (futuro Router shell) | `@vortech/router` |
| (futuro extension loader cliente) | `@vortech/extensions-loader` |

La operación de renombrado es operativa (no se ejecuta desde este doc), pero el nombre destino queda fijado aquí.

---

## 4. Driver UI canónico

- **Driver UI canónico v1**: **`@vortech/components`**.
- `IViewFactory` (la interfaz que abstrae "render runtime") **queda definida** como punto de extensión defensivo, pero **no hay un segundo driver activo**. Lit, Solid u otros pueden integrarse en el futuro si justificación clara aparece — siguiendo la cláusula de reapertura §8.
- **Angular sale como driver UI.** Cualquier código existente que dependa de Angular se reclasifica como referencia visual o se archiva.

---

## 5. Modelo de componente — atoms sobre decoradores

Decisión clave que separa `@vortech/components` de Angular tradicional:

### 5.1 Decoradores **solo de clase**

Permitidos como decoradores:

- `@Component({ selector, template, styles, encapsulation, providers })`.
- `@Directive({ selector })`.
- `@Pipe({ name })`.
- `@Injectable({ providedIn })`.

Estos son **metadata estructural** — describen qué es la clase, no qué hacen sus campos.

### 5.2 Inputs / outputs / inject como **funciones reactivas**, no decoradores de campo

Inspirado en Angular zoneless / signals:

```ts
@Component({ selector: 'app-sku', template: html`...` })
class SkuView {
  // input(): atom de lectura, bindeado a atributo o property
  readonly skuId  = input<SkuId>();                       // requerido
  readonly compact = input<boolean>(false);                // con default
  readonly title  = input<string>().alias('label');        // con alias

  // output(): emitter
  readonly select = output<Sku>();

  // inject(): no es decorador, es función
  private readonly inv = inject(IInventoryProvider);
  private readonly nav = inject(INavigationProvider);

  // estado derivado: atom derivado
  readonly sku = derivedAsync(() => this.inv.getSku(this.skuId()));

  onClick() { this.select.emit(this.sku()); }
}
```

Reglas que esto fija:

1. **`@Input()` / `@Output()` / `@Inject()` como decoradores de campo NO existen** en `@vortech/components`. Se consideran legacy del modelo Angular pre-zoneless.
2. **`input<T>()` devuelve un atom de lectura** bindeado al atributo/property del DOM.
3. **`output<T>()` devuelve un emitter** que el padre escucha como evento.
4. **`inject<T>(token)`** es una función pura — no decorador, no parámetro de constructor — invocable solo en contexto de injection (constructor o factory).
5. **Templates 100% reactivos sobre atoms.** No hay change detection global, no hay zone, no hay digest cycle. Si un atom cambia, los nodos del template que lo leen se actualizan; nada más.
6. **Pipes son funciones puras** registradas con `@Pipe`, sin parser propio del lado expression.

### 5.3 Zoneless por diseño

- Sin Zone.js ni equivalentes.
- Sin `markForCheck` / `detectChanges` / `ChangeDetectionStrategy`.
- El scheduler de atoms (`GlitchFreeScheduler`) coordina rerenders por microtask coalesced.
- DX equivalente a SolidJS en el modelo, a Angular en la superficie de decoradores y templates.

---

## 6. Inspiración

Lo que la plataforma lee como código fuente para extraer ideas — sin adoptar como dependencia:

| Fuente | Qué se aprovecha |
|---|---|
| **Angular** (zoneless, signals, signal-input/output, inject function) | Modelo de decoradores de clase + funciones reactivas para inputs/outputs/inject. Sintaxis de control flow `@if`/`@for`/`@switch`. Convenciones de selector/template/styles. |
| **VSCode** (`vs/base`, `vs/workbench`) | Shell completo: Workbench, parts, sash/splitview/gridview, command palette, contributes pattern. Ya consumido vía port en `@vortech/workbench` y `@vortech/layout`. |
| **SolidJS** | Modelo de signals fine-grained, glitch-free scheduling, `createEffect`/`createMemo` semantics. |
| **Lit** | Templates tagged template literal, scoped styles vía Custom Elements. |
| **PrimeNG / Material** (vía `@vortech/ui` archivado) | Catálogo visual y UX de componentes a tener. |
| **MobX / Recoil / Jotai** | Modelos de atom, derivación, transacciones. |
| **trpc / OpenAPI clients** | Patrones de cliente tipado generado. |

Reglas del uso-como-inspiración: idénticas a las del lado .NET ([`../dotnet/01-cierre-decisiones-dotnet.md §3.3`](../dotnet/01-cierre-decisiones-dotnet.md)). No copiar literal; no adoptar modelo entero; respetar licencias; sin acoplamiento.

---

## 7. Por qué esta decisión

Resumen consolidado:

1. **Coherencia con el lado .NET.** Las primitivas Provider/Driver/Capability/Wire/Scope/Extension viven mejor sin frameworks UI con su propia opinión sobre cada una.
2. **Atoms ya están**, son producción-ready, y son superiores en granularidad a lo que ofrecen frameworks alternativos hoy.
3. **`@vortech/components` ya está construido** en serio (decoradores + parser + control flow + scoped styles + scheduler). Adoptar Angular era cargar dos universos.
4. **Estabilidad del sustrato.** Igual que .NET no quiere depender de la salud de N librerías; el frontend tampoco.
5. **Codegen y proyección de tipos.** Los proxies generados desde C# son tipos TS limpios. Inyectarlos en cualquier framework externo añade fricción; en código propio que ya conoce atoms y DI no la añade.
6. **Experimentado.** El ciclo TS-everything ya se probó parcialmente con duplicaciones (`ui/packages/core` vs `v-core`). La política propia evita el ciclo.

---

## 8. Cláusula de reapertura

Esta decisión se revisa solo si se cumplen **todas**:

1. Aparece un problema que código propio sobre Web Platform APIs no puede resolver en horizonte razonable.
2. Existe una librería externa que lo aporta sin acoplamiento al modelo Vortech ni al ecosistema entero del que depende.
3. La librería tiene licencia compatible y madurez verificable.

No se reabre por:

- "Es más rápido escribir UI con X".
- "X tiene más componentes hechos".
- "El equipo conoce mejor X".
- "X tiene más popularidad".

Si aparece el impulso, releer §7.

---

## 9. Decisiones acordadas explícitamente

Estas son las decisiones específicas confirmadas en el debate previo a este cierre, registradas para evitar ambigüedad:

| Tema | Decisión |
|---|---|
| Stack TS conservado | Atoms, DI, extensions de `@vortech/core`; `@vortech/components`; `@vortech/workbench`; `@vortech/layout`; `@vortech/theming` |
| Angular | Sale del núcleo. `@vortech/ui` (Angular fork PrimeNG) queda archivado como referencia visual. |
| Zoneless | Obligatorio. Sin Zone.js. |
| Decoradores | Solo de clase. `@Input`/`@Output`/`@Inject` de campo no existen — sustituidos por `input()`/`output()`/`inject()` reactivos. |
| Driver UI canónico v1 | `@vortech/components` (uno solo activo). `IViewFactory` queda como abstracción defensiva. |
| Wire frontend | Código propio. Drivers v1: **WebSocket, HTTP, in-process** — los tres en alcance v1. |
| Provider en frontend | Dos clases: remotos (proxies generados) + locales (Navigation, Theme, Layout, Router, Cache, Dialogs, Notifications). Mismo modelo Provider/Driver/Capability. |
| Router del shell | **Pendiente de propuesta y comparación** — ver [`20-router.md §X`](20-router.md). |
| Naming | Todo paquete `@vortech/*`. Tabla de renombrado en §3. |

---

## 10. Resumen operativo

- **Dependencias permitidas:** TypeScript + Web Platform APIs (+ Node estándar donde corra).
- **Código de plataforma:** propio.
- **Librerías maduras externas:** inspiración por lectura; sin adopción.
- **Decoradores:** solo de clase; resto vía funciones reactivas.
- **Driver UI canónico:** `@vortech/components`.
- **Naming:** `@vortech/*`.
- **Pendiente decisión:** modelo final de Router del shell.
