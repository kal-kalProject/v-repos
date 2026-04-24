---
titulo: "Propuesta — UI Shell al estilo VSCode sobre atoms + DI propios"
tipo: analisis-preview
alcance: multi-repo
source_repos:
  - vortech
  - ui
fecha: 2025-11-06
supersede: ninguno
complementa:
  - inventory/_analysis-preview/PLATAFORMA-VISION-GLOBAL.v2.md
  - inventory/_analysis-preview/FINDINGS-TS-PLATFORM.md
estado: draft
---

# Propuesta — UI Shell al estilo VSCode consumiendo atoms + DI propios

> **Objetivo del autor (verbatim)**: *"quiero componentes al estilo angular, con su theming, typings de instance y bindings, pero construyendo sobre mis atoms y DI; y que encima de todo viva un layout tipo VSCode con sistema de extensions que contribuyan a secciones del shell"*.
>
> Esta propuesta traza **caminos** (no decisiones) partiendo del código real inventariado en [FINDINGS-TS-PLATFORM.md](FINDINGS-TS-PLATFORM.md) y alineado con las primitivas del [v2 §1](PLATAFORMA-VISION-GLOBAL.v2.md).

---

## 0. Principios de diseño (no negociables)

1. **Reusar lo ya construido** — `v-components`, `v-core/extensions`, `v-layout` tienen meses de trabajo. No reescribir desde cero.
2. **Un solo sistema de extensions** — el slot tipado de `core/extensions` gana. Las registries de Workbench se **adaptan**, no compiten.
3. **Dos drivers UI coexisten** — el shell expone una API de contribución **driver-agnóstica**; `v-components` y Angular (`@vortech/ui`) cada uno sabe cómo renderizar. Respuesta a §6 X6.
4. **Los atoms son el canal reactivo único** — tanto `v-components` como Angular signals consumen atoms. No hay dos sistemas reactivos en la misma app.
5. **Layout primitives aisladas** — `@vortech/layout` (Sash/SplitView/GridView) se consumen tal cual por cualquier stack UI.
6. **Theming como tokens, no como componentes** — `theming/` produce tokens CSS/JS consumibles por ambos drivers.
7. **DX "atributos Vortech"** — decoradores + v-gen + LSP que engaña al compiler (alineación con [v2 §9](PLATAFORMA-VISION-GLOBAL.v2.md)).

---

## 1. Arquitectura propuesta — 5 anillos

```
┌─────────────────────────────────────────────────────────────────────┐
│  A5 · VERTICALES (ai-assistant, cnc-monkey, devtools, editor, …)    │
│          ↑ instalan Extensions en el Shell; usan Components         │
├─────────────────────────────────────────────────────────────────────┤
│  A4 · SHELL VSCode-like (Workbench + 7 Parts + contributes)         │
│         basado en v-layout, refactor para consumir A3               │
├─────────────────────────────────────────────────────────────────────┤
│  A3 · EXTENSION MODEL (slots tipados + contribution points)         │
│         fuente: v-core/extensions                                   │
├─────────────────────────────────────────────────────────────────────┤
│  A2 · COMPONENT DRIVERS  (ambos intercambiables por provider)       │
│   ┌────────────────────────┬──────────────────────────────┐         │
│   │ Driver "v-components"  │ Driver "Angular/@vortech/ui" │         │
│   │ (Angular-like custom)  │ (PrimeNG fork)               │         │
│   └────────────────────────┴──────────────────────────────┘         │
├─────────────────────────────────────────────────────────────────────┤
│  A1 · NÚCLEO   atoms + DI + scope + meta + layout primitives        │
│         fuente: v-core + @vortech/layout + theming (tokens)         │
└─────────────────────────────────────────────────────────────────────┘
```

**Mapa de packages → anillos**:
- **A1**: `v-core`, `@vortech/layout`, `theming`, (quizás) `v-common`.
- **A2**: `v-components` (driver 1), `@vortech/ui` + `ui/packages/platform/platform-angular` (driver 2).
- **A3**: `v-core/extensions` (universal — no hay "driver" aquí).
- **A4**: `v-layout` refactorizado para exponer slots sobre `v-core/extensions`.
- **A5**: `ui/packages/*` (cnc-monkey, ai-*, devtools, editor, studio, vscode, etc.).

---

## 2. Camino 1 — Unificación del modelo de extensions (prioridad máxima)

### Problema (de FINDINGS §2.6 / §3 D6)
`v-layout/src/workbench/workbench.ts` usa `IWorkbenchRegistries` — maps mutables tipados — mientras `v-core/extensions` ofrece `defineExtension<TDesc, TApi>` con slots tipados por Symbol, deps, dispose reverso, eventos observables. **Los dos sistemas no hablan entre sí**.

### Propuesta

Cada registry actual del workbench (`activityBar, sidebar, editor, panel, statusBar, commands, menu, breadcrumb, notifications, auxiliaryBar`) se redefine como **slot tipado** + **contribution point**:

```ts
// A3 — paquete shared (nuevo o en v-layout/contributes/)
import { defineExtension } from '@vortech/core/extensions';

export interface WorkbenchCaps extends HostCapabilities {
    host: Workbench;
    events: WorkbenchEvents;
    hooks: WorkbenchHooks;
}

// Slots de contribución (uno por área del shell)
export const ACTIVITY_BAR_CONTRIB  = defineExtension<WorkbenchCaps, ActivityBarApi>('activitybar');
export const SIDEBAR_VIEW_CONTRIB  = defineExtension<WorkbenchCaps, SidebarViewApi>('sidebar.view');
export const STATUS_BAR_ITEM_CONTRIB = defineExtension<WorkbenchCaps, StatusBarItemApi>('statusbar.item');
export const COMMAND_CONTRIB       = defineExtension<WorkbenchCaps, CommandApi>('command');
export const EDITOR_TAB_CONTRIB    = defineExtension<WorkbenchCaps, EditorTabApi>('editor.tab');
export const PANEL_TAB_CONTRIB     = defineExtension<WorkbenchCaps, PanelTabApi>('panel.tab');
export const MENU_CONTRIB          = defineExtension<WorkbenchCaps, MenuApi>('menu');
export const NOTIFICATION_CONTRIB  = defineExtension<WorkbenchCaps, NotificationApi>('notification');
```

El Workbench existente **sigue exponiendo sus registries internas**, pero ahora hay una **capa de adaptación**:

```ts
// Adaptadores — escriben en las registries actuales del Workbench
// pero la superficie pública es la del sistema Extensions.
const createActivityBarContrib = ACTIVITY_BAR_CONTRIB.create((cfg: ActivityBarItemConfig) => ({
    install(ctx) {
        const handle = ctx.host.registries.activityBar.register(cfg);
        ctx.subs.add(() => handle.dispose());
        return { id: cfg.id, setBadge: handle.setBadge };
    },
    dispose() { /* no-op — ya hay subs.add */ },
}));
```

### Beneficios
- `v-layout` queda **sin cambios invasivos** en el core.
- Una extensión de producto (p.ej. `ai-assistant`) instala su lado UI así:
  ```ts
  extensions.use(createActivityBarContrib({ id: 'ai', icon: 'sparkle', label: 'AI Assistant' }));
  extensions.use(createSidebarViewContrib({ id: 'ai.chat', viewFactory: () => new ChatView() }));
  extensions.use(createCommandContrib({ id: 'ai.toggle', handler: () => ... }));
  ```
- Dispose reverso gratis del manager → al desinstalar se limpian todas las aportaciones de golpe.
- Typings completos gracias al Symbol + generics del slot.

### Decisión pendiente
- ¿Los adaptadores viven en `v-layout/contributes/`, o en un package nuevo (`@vortech/shell-contributes`)? Recomiendo `v-layout/contributes/` para no añadir packages.

---

## 3. Camino 2 — API de componentes driver-agnóstica (responde §6 X6)

### Problema
Dos stacks de componentes UI existen hoy y no son compatibles:
- **Stack α** — `v-components` con `@Component`/`@Input` + `html\`\`` tagged templates + atoms.
- **Stack β** — `@vortech/ui` + Angular (signals de Angular).

Las verticales de `ui/packages/` consumen Stack β (Angular). El autor quiere "estilo Angular" — que ya tiene en ambos.

### Propuesta — contrato de contribución visual

El Shell (A4) **no sabe qué stack renderiza una view**. El contrato es:

```ts
// A3 — en la misma capa de slots
export interface IViewRenderer {
    mount(container: HTMLElement, ctx: ViewMountContext): IDisposable;
}

export interface IViewFactory {
    readonly stack: 'v-components' | 'angular' | string;
    create(): IViewRenderer;
}
```

Cada driver trae un adaptador:

```ts
// A2 — driver v-components (reside en v-components)
export function fromComponent(clazz: ComponentClass): IViewFactory {
    return {
        stack: 'v-components',
        create: () => ({
            mount(container, ctx) {
                const injector = ctx.parentInjector.createChild({ providers: [...] });
                const instance = injector.resolve(clazz);
                const renderer = componentRegistry.build(instance);
                renderer.attach(container);
                return { dispose: () => renderer.detach() };
            },
        }),
    };
}

// A2 — driver angular (reside en ui/packages/platform/platform-angular)
export function fromNgComponent(clazz: Type<any>, inputs?: Record<string, unknown>): IViewFactory {
    return {
        stack: 'angular',
        create: () => ({
            mount(container, ctx) {
                const appRef = createApplication({ providers: [bridgeAtomsToNgSignals()] });
                const ref = createComponent(clazz, { hostElement: container, environmentInjector: appRef.injector });
                Object.assign(ref.instance, inputs);
                ref.changeDetectorRef.detectChanges();
                return { dispose: () => ref.destroy() };
            },
        }),
    };
}
```

El bridge **atoms → Angular signals** es la clave. Como `atom()` es callable y emite, se puede implementar con `toSignal()` wrapper:

```ts
export function atomToSignal<T>(a: Atom<T>): Signal<T> {
    const s = signal(a());  // snapshot inicial
    watch(() => s.set(a())); // subscripción con dispose owned
    return s;
}
```

### Implicación para X6 (v2 §6)
- **X6 no se decide "uno u otro"** — se decide **"cuál driver es default"**. Recomendación: **Angular driver default hoy** (tiene 100 componentes maduros); **v-components como driver premium** (cuando llegue la DX de atributos Vortech con LSP).
- Las verticales pueden elegir stack sin afectar el Shell.

---

## 4. Camino 3 — Theming compartido por ambos drivers

### Propuesta
`theming/` produce:
1. **Token JSON/TS** — consumible desde código TS.
2. **Variables CSS** — consumible desde cualquier componente (`v-components` con scoped styles ya las respeta; Angular con `:host` también).
3. **Preset por driver** — `theming/presets/v-components/` + `theming/presets/angular/` que exportan helpers específicos si necesitan adaptación (p.ej. Angular Material theming API vs `@vortech/ui` Tailwind plugin).

El Shell (`v-layout`) consume **solo** variables CSS — nunca componentes de un driver específico.

### Consistencia visual
- Ambos drivers deben honrar los mismos tokens (`--v-color-primary, --v-space-*, --v-radius-*`, `--v-font-*`).
- Tests visuales de contratos: un snapshot de token-per-component asegura paridad.

---

## 5. Camino 4 — El papel de `layout/` vs `v-layout/` vs `v-ui/`

Tres packages con nombres cercanos. Propuesta:

| Package | Rol propuesto | Estado |
|---|---|---|
| `@vortech/layout` (`platform/layout/`) | **Primitivas layout** — Sash, SplitView, GridView, Disposable, Event. Cero deps de shell. Reutilizable por cualquiera. | Consolidar como público |
| `@vortech/v-layout` (`platform/v-layout/`) | **Shell IDE completo** — Workbench + 7 parts + contributes. Depende de `@vortech/layout` (internalmente ya tiene su copia; refactor pendiente). | Mantener; refactorizar para: (a) depender de `@vortech/layout`; (b) exponer contributes sobre `v-core/extensions`. |
| `@vortech/v-ui` (`platform/v-ui/`) | **Hipótesis** — subset refactor de v-layout (solo `browser/` + `common/` sin workbench). Podría ser la "base DOM" reutilizable. | Investigar: ¿deprecar, fusionar con layout, o mantener como base-layer más delgado? |

**Acción inmediata propuesta**: añadir `_analysis-preview/TRIAGE-layout-packages.md` con lectura de `v-ui/src/public-api.ts` + `v-layout/src/index.ts` + comparativa. Es necesario antes de decidir.

---

## 6. Camino 5 — DX estilo "atributos Vortech" (alineado con v2 §9)

El sueño del autor: *"decoradores para todo, v-gen hace el resto, LSP engaña al compiler"*.

### Hoy (real, funciona)
```ts
@Component({ selector: 'ai-chat', styles: '...', providers: [ChatService] })
class ChatComponent {
    @Input() projectId!: Atom<string>;
    @Input({ transform: Number }) maxTokens = atom(2048);

    private chat = inject(ChatService);
    private messages = derived(() => this.chat.messagesFor(this.projectId()));

    template = () => html`
        <div class="chat">
            @for (m of this.messages(); track m.id) {
                <v-message .data=${m} />
            }
        </div>
    `;
}
```

Ya es posible con `v-components` + `v-core/atoms` + `v-core/di`.

### Meta (con v-gen universal + LSP)
```ts
@Extension({
    slot: 'activitybar',
    id: 'ai-assistant',
    icon: 'sparkle',
    label: 'AI Assistant',
    command: 'ai.toggle',
    // v-gen genera: Wire contract, C# Provider, registry boilerplate
})
@Contributes({
    sidebar: { view: AIChatView },
    statusbar: { item: AIStatusItem },
    commands: [ 'ai.toggle', 'ai.regenerate' ],
})
class AIAssistantExtension {
    install(ctx: ExtensionContext<WorkbenchCaps>) {
        // lógica real, no boilerplate
    }
}
```

El LSP (para TS+C#+Rust, alineado con v2 §6 X7/X4) ve los decoradores y presenta **tipos completos** antes de que `v-gen` corra. `v-gen` corre en CI y emite: slots registrados, contracts Wire, stubs backend.

### Qué hacer ya
- Escribir los decoradores `@Extension` / `@Contributes` **sobre** `v-core/extensions` en un package nuevo `@vortech/shell-decorators` (o dentro de `v-layout/contributes/`).
- `v-gen` integrado puede venir **después**: los decoradores funcionan puros ahora con `Extensions.use(...)` interno.

---

## 7. Camino 6 — Consolidación de duplicaciones (consecuencia de FINDINGS §3)

Propuesta de deprecación por rondas:

### Ronda 1 (sin fricción)
- `ui/packages/core` → re-export desde `@vortech/core` + stubs de compat. Mover `communication/` + `pipeline/` a **packages nuevos** (`@vortech/wire`, `@vortech/host-pipeline`) — no se pierden, se aclaran.
- `ui/packages/common` → re-export desde `v-common` + extras propios (`coercion/`, `guards/`, `validation/`) se quedan en un sub-package propio (`@vortech/common-ui`) por ser UI-específicos.

### Ronda 2 (requiere X1 resuelta)
- Si `vortech/platform` gana: `ui/packages/platform` se fusiona. Su `platform-angular/` + `platform-node/` son gold — pasan a ser `@vortech/platform-driver-angular` + `@vortech/platform-driver-node`.
- Si `ui` gana: `vortech/platform` se archiva como "research" (se conserva read-only).

### Ronda 3 (opcional)
- Un único `core` + `common` + `layout` + `v-layout` + `v-components` + `theming` + `drivers/*` estable.

---

## 8. Propuesta de roadmap incremental (4 hitos)

> **Orden propuesto**, no plazos.

### Hito H1 — **Adapter de contributes sobre Extensions**
- Refactor `v-layout/contributes/` para que `createTreeView`, etc., internamente usen `defineExtension` + `Extensions.use`.
- Workbench expone un manager `Extensions<WorkbenchCaps>` en lugar de (o **además de**) registries. Retrocompat mantenida.
- Resultado: **una sola manera de contribuir al shell**, tipada, con dispose automático.

### Hito H2 — **IViewFactory driver-agnóstico**
- `@vortech/shell-contracts` (nuevo, pequeño) define `IViewFactory`, `IViewRenderer`, `ViewMountContext`.
- Dos implementaciones: `fromComponent()` en `v-components`, `fromNgComponent()` en `platform-angular`.
- Las sidebars/panels del Workbench aceptan `IViewFactory` en lugar de mount-DOM imperativo.

### Hito H3 — **Theming tokens compartidos**
- `theming/` expone tokens CSS como variables globales.
- Ambos drivers honran esas variables.
- Un preset PrimeNG adaptado para Angular + un preset para `v-components`.

### Hito H4 — **Decoradores `@Extension` / `@Contributes`**
- Sugar sobre `defineExtension` + `Extensions.use`.
- Sin v-gen primero. Con v-gen (hito lateral) después, genera Wire + C# stub.

---

## 9. Lo que esta propuesta NO decide

Decisiones que siguen abiertas y que esta propuesta **no resuelve** — son del autor:

- **X1** (v-mono): vortech/platform como canónico **o** roles complementarios (framework research + integrador). Esta propuesta sugiere "complementarios" (ver FINDINGS §6).
- **X4** (TTM destino): intocado — es rama aparte.
- **X5** (wire + socketio): intocado — pertenece a lado backend/Wire.
- **X7** (v-gen Rust vs C#): intocado — esta propuesta asume que los decoradores TS funcionan independientemente del generador.

---

## 10. Próximos pasos sugeridos

1. **Leer [QUESTIONS-TS-SHELL.md](QUESTIONS-TS-SHELL.md)** y responder las 5 preguntas bloqueantes (§7 de FINDINGS).
2. Validar/ajustar los 5 principios §0.
3. Decidir si se arranca por H1 (Adapter) o H2 (Driver) — H1 tiene menor blast radius.
4. Programar el triage `v-ui` vs `v-layout` (§5).
5. Aparcar hasta tener H1+H2 estables antes de tocar deprecaciones (§7).
