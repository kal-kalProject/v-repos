# Responsabilidad del frontend en la plataforma Vortech

> **Alcance.** Describe el rol oficial del lado TypeScript / frontend dentro de la plataforma. No es guía de implementación, no es comparativa de frameworks. Es la declaración del papel que juega el ecosistema TS en el todo.

---

## 1. En una línea

> **El frontend de Vortech es el cliente oficial del Host .NET. No es un stack paralelo: es la cara visible de las primitivas, materializada en TypeScript sobre estándares web.**

No es "una UI hecha con un framework". Es la materialización de las 12 primitivas de la plataforma — las que tienen sentido en el cliente — usando un sustrato TS propio.

---

## 2. Por qué TypeScript, no .NET

Decisión cerrada en [`../dotnet/00-responsabilidad-de-dotnet.md §4`](../dotnet/00-responsabilidad-de-dotnet.md). Las razones que justifican el rol TS para la UI:

1. **El navegador es la plataforma de despliegue real.** Cualquier shell de aplicación moderna se renderiza desde HTML/CSS/JS, sea web nativo, Electron, Tauri o equivalente. TypeScript es el lenguaje del navegador con tipos.
2. **Reactividad fina.** Los modelos atómicos de signals/atoms en TS hoy superan en granularidad a las propuestas equivalentes en otros stacks. La UI moderna pide rerender por celda, no por componente.
3. **Ecosistema visual maduro.** CSS, animaciones, tooling de DX (HMR, devtools, source maps) viven nativos en el ecosistema web.
4. **Shell tipo VSCode existe en TS.** El port `v-layout` ya cubre el 80% de un IDE-shell. Reescribirlo en otro stack es trabajo sin retorno.
5. **Frontera de despliegue limpia.** El backend .NET expone Wire; el frontend TS lo consume. No hay confusión de qué corre dónde.

Ninguna de estas razones descalifica .NET como UI técnicamente posible (Blazor existe). Justifican que **el rol canónico de frontend en Vortech sea TS**.

---

## 3. Qué vive en TypeScript

Las siguientes capas tienen su implementación **canónica** en TS:

### 3.1 Atoms / reactividad fina

`@vortech/core/atoms` — sistema completo de signals: `atom`, `derived`, `derivedAsync`, `watch`, `batch`, `transaction`, `atomFamily`, `linkedAtom`, `AtomScope`, glitch-free scheduler, error boundaries tipados.

### 3.2 DI tipado

`@vortech/core/di` — Injector con tokens tipados, lifecycle, builders de decoradores, resolución async cancelable, integración con `ScopeTree`.

### 3.3 Sistema de extensiones (slots)

`@vortech/core/extensions` — `defineExtension<TDesc, TApi>(name)`, `Extensions<TDesc>` manager, `.use(def)` con check de deps, dispose reverso. Es el sistema de contribución único del frontend.

### 3.4 Render runtime

`@vortech/components` — framework de componentes propio: `@Component`/`@Directive` decoradores de clase, primitivas `input()`/`output()`/`inject()` basadas en atoms, `html\`\`` con parser propio, control flow `@if`/`@for`/`@switch`, scoped styles, `ComponentRegistry`. Inspirado en Angular zoneless.

### 3.5 Shell (Workbench)

`@vortech/workbench` — shell tipo VSCode: Workbench + 7 parts (TitleBar, ActivityBar, Sidebar, Editor, Panel, AuxiliaryBar, StatusBar) + tree-view, command palette, notifications. Conectado al sistema de extensiones de §3.3.

### 3.6 Primitivas de layout

`@vortech/layout` — `Sash`, `SplitView`, `GridView`, `Disposable`, `Event`, `Emitter`. La cara pública estable de las primitivas de splitting que el Workbench usa internamente.

### 3.7 Theming

`@vortech/theming` — tokens CSS, presets, sistema de variables consumido por todos los componentes.

### 3.8 Wire (cliente)

`@vortech/wire` — runtime cliente de Wire en TS: codificación de sobres, correlación, retries, idempotencia, scope embebido. Drivers de transporte: WebSocket, HTTP, in-process.

### 3.9 Provider proxies + Providers locales

Generados (proxies de Providers backend) o escritos a mano (Providers locales del frontend: navegación, theme, layout, preferences, cache, dialogs, notifications). Mismo modelo Provider/Driver/Capability.

### 3.10 ScopeContext

`@vortech/core/scope-context` — `Atom<Scope>` activo del shell. Cada llamada Wire lo lee y lo embebe; cada vista derivada se reactiva a sus cambios.

---

## 4. Qué **no** es responsabilidad del frontend

- **Host.** No existe Host TS. El Host es .NET ([`../dotnet/16-host.md`](../dotnet/16-host.md)).
- **Identity (implementación).** Se consume; no se implementa.
- **Data (lógica de dominio).** Se consume vía Provider proxies.
- **Bridges hacia runtimes ajenos.** Viven en .NET o como Agent. Excepción discutida en [`15-bridge.md`](15-bridge.md) para Electron/Tauri.
- **Agents.** Se invocan; no se alojan.
- **Codegen y LSP.** Son herramientas .NET ([`../dotnet/00-responsabilidad-de-dotnet.md §3.9–3.10`](../dotnet/00-responsabilidad-de-dotnet.md)).

La regla: **el frontend consume las primitivas distribuidas; implementa las primitivas de UI/cliente.**

---

## 5. Cómo se relaciona con el resto

```
                    ┌────────────────────────────────────┐
                    │  @vortech/workbench (shell)        │
                    │   ActivityBar / Sidebar / Editor / │
                    │   Panel / Status — slots           │
                    └────────────────────────────────────┘
                                  ▲
                                  │  contribuciones
                    ┌────────────────────────────────────┐
                    │  @vortech/components (render)      │
                    │  @Component decorators · atoms     │
                    │  html`` · @if @for @switch         │
                    └────────────────────────────────────┘
                                  ▲
              ┌───────────────────┼─────────────────────┐
              │                   │                     │
   Providers locales       Provider proxies     Extensions UI
   (Nav, Theme, Layout,    (IInventoryProvider,  (slots de v-core)
   Cache, Dialogs)          IAuthProvider, …)
              │                   │                     │
              ▼                   ▼                     │
        @vortech/core (atoms · DI · extensions · scope) ┘
                                  │
                                  ▼
                          @vortech/wire (cliente)
                                  │
                       WS · HTTP · in-process
                                  │
                                  ▼
                         Host .NET (Wire server)
```

---

## 6. Qué significa para quien construye

- **Crear una vista** → componente en `@vortech/components`, registrado por slot de `@vortech/core/extensions`, montado en una part del Workbench.
- **Hablar con un dominio remoto** → inyectar el Provider proxy generado y llamar sus operaciones; nunca tocar `fetch` ni `WebSocket` directos.
- **Estado local de UI** → atom o Provider local con su Driver de almacenamiento.
- **Navegación** → `@vortech/router` (Provider local del shell).
- **Distribuir una feature** → Extension end-to-end (backend .NET + frontend TS) versionada como unidad.

---

## 7. Cláusula de estabilidad

El rol del frontend TS como cliente oficial — y su sustrato (atoms, DI, extensiones, componentes propios, shell tipo VSCode) — es estable por diseño. No se revisa por aparición de un framework nuevo. Solo se revisa bajo condiciones objetivas equivalentes a las de la cláusula del lado .NET ([`01-cierre-decisiones-ts.md §8`](01-cierre-decisiones-ts.md)).

---

> **Qué no contiene este documento.** No fija versiones, no decide entre alternativas dentro del ecosistema TS (qué bundler, qué test runner, qué CSS-in-JS), no fija topología de despliegue. Esas son decisiones operativas que viven en otros documentos.
