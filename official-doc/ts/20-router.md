# Router en TypeScript / frontend

> **Rol.** En el frontend coexisten **dos routers conceptualmente distintos**. Uno es proyección del Router de plataforma (consultivo). El otro es el **Router del shell** — y su forma final está **abierta a debate**.
>
> **Espejo del backend (Router de plataforma):** [`../dotnet/20-router.md`](../dotnet/20-router.md).

---

## 1. Los dos routers

### 1.1 Router de plataforma (proyección consultiva) — cerrado

`IPlatformRouter` (proxy generado del `IRouter` C# del backend).

- **Solo informa** — no invoca.
- Útil para tooling: "qué Provider/Driver atendería esta operación bajo este Scope".
- Consumido por:
  - Devtools del shell.
  - Componentes que adaptan UI según Driver activo en backend.
  - Diagnóstico de operaciones.
- No tiene aspectos abiertos a discusión: replica el contrato del backend.

### 1.2 Router del shell — `IShellRouter` — **abierto**

Su forma específica es la decisión pendiente de este documento (§X).

Lo que sí está cerrado:

- **Es Provider local** del frontend, con Drivers intercambiables.
- **Drivers v1** confirmados: `HistoryRouteDriver` y `HashRouteDriver` (ambos en alcance v1, decisión E.3).
- **Vive en `@vortech/router`.**
- **Se sincroniza con `ScopeContext`** ([`19-scope.md §8`](19-scope.md)) cuando hace falta deep-link.

Lo que **no** está decidido — es lo que se discute en §X.

---

## 2. Forma cerrada del IShellRouter

Independiente de la decisión §X, este es el contrato base mínimo:

```ts
@Provider({ domain: 'shell.router' })
export interface IShellRouter {
  readonly current: Atom<RouteState>;
  navigate(target: RouteTarget, options?: NavigateOptions): Promise<void>;
  back(): Promise<void>;
  forward(): Promise<void>;
  canDeactivate: Atom<boolean>;
  // ...
}

export interface RouteState {
  readonly path: string;
  readonly params: ReadonlyMap<string, string>;
  readonly query: ReadonlyMap<string, string>;
  readonly hash: string | null;
  readonly view: ViewRef | null;
}
```

---

## 3. Drivers v1

### 3.1 `HistoryRouteDriver`

- Usa `History API` del navegador (`pushState`, `popstate`).
- Capabilities: `Caps.CleanUrls`, `Caps.RequiresServerRewrite`.
- Default cuando hay control sobre el server (rewrite a `index.html`).

### 3.2 `HashRouteDriver`

- Usa `location.hash`.
- Capabilities: `Caps.NoServerSetup`, `Caps.WorksOnFile`.
- Útil para deploys estáticos sin rewrite, file:// (Electron renderer en algunos modos).

### 3.3 (Mención) `MemoryRouteDriver`

- Sin URL real; estado en memoria.
- Útil para tests, embeds, vistas anidadas.
- v1: incluido como Driver de testing/embed, no como modo principal.

El usuario o el deploy elige Driver activo por configuración.

---

## X. Decisión abierta — modelo del IShellRouter

Esta sección **queda explícitamente abierta**. Antes de cerrarla hace falta producir propuestas formales y compararlas. Lo que sigue es el planteo del problema y las alternativas en juego, **no decisión**.

### X.1 Por qué no se decide aún

VSCode — referencia natural del shell — **no tiene router URL** estilo SPA. Tiene **comandos + active editor + active view**. Una "ruta" es más bien un comando ("abrir editor X con argumento Y") que se reproduce y deep-linkea.

Otras shells (Atom, Eclipse Theia) varían entre modelos. Adoptar Angular Router / TanStack Router de antemano contradiría el cierre §1; pero tampoco se ha demostrado que un router URL clásico sea correcto para una shell tipo IDE.

### X.2 Alternativas en consideración

#### Alternativa A — Router URL clásico

Modelo SPA tradicional. Cada vista tiene una ruta. Navegación = cambio de URL.

- **Pros:** familiar, deep-link natural, integra con browser back/forward, indexable.
- **Contras:** tensión con el modelo VSCode (donde el "estado" es comandos + editores abiertos, no URL); rigidez al modelar splits, paneles laterales, multi-editor.

#### Alternativa B — Modelo de comandos + active state (estilo VSCode)

No hay rutas. Hay **comandos** que producen efectos sobre el estado activo (qué editor está abierto, qué view en sidebar, qué panel visible). Deep-link se construye como **secuencia replay** de comandos.

- **Pros:** match natural con shell IDE; flexible para layouts complejos; integra con sistema de comandos del Workbench que ya existe.
- **Contras:** diseñar deep-link/serialización del estado es no trivial; back/forward del navegador necesita mapeo no obvio.

#### Alternativa C — Híbrido

Router URL para "vistas principales" (lo que un usuario casual deep-linkea: dashboard, item específico, settings). Comandos + active state para detalles internos del Workbench (qué panel está expandido, qué tab activa).

- **Pros:** lo mejor de ambos en sus dominios.
- **Contras:** dos modelos coexisten — más superficie de API, decisiones de "qué va dónde" en cada caso.

#### Alternativa D — Solo Scope-driven

El Scope activo **es** la ruta. El URL serializa el Scope. Cambiar Scope = navegar.

- **Pros:** un solo concepto rige todo; alineado con la primitiva canónica Scope; consistencia máxima.
- **Contras:** Scope puede no capturar todo lo que una "ruta SPA" expresa (qué tab UI, qué split, qué sub-panel); hay que ver cuánto del estado UI puro encaja en Scope.

### X.3 Qué se necesita antes de decidir

1. **Propuesta detallada de cada alternativa** (cómo modela views, splits, paneles, deep-link, back/forward, comandos).
2. **Comparación contra escenarios reales del shell**: abrir editor de SKU, abrir terminal, dividir editor en dos, instalar extension que aporta vista nueva, deep-linkear a "configuración → tema → personalizar".
3. **Comparación contra integración con `ScopeContext`** ([`19-scope.md`](19-scope.md)): ¿el router emite cambios de Scope, o el Scope emite cambios de router?
4. **Comparación contra el modelo de comandos** que ya existe en `@vortech/workbench`: ¿es uno u otro, o conviven?

### X.4 Cierre temporal

Hasta que §X se cierre con propuesta+comparación+decisión:

- El contrato base de §2 se considera estable.
- Los Drivers `HistoryRouteDriver` y `HashRouteDriver` se construyen porque son sustrato compartido por cualquier alternativa.
- **No se publica decisión** sobre el modelo (URL clásico / comandos / híbrido / scope-driven).
- Cualquier código que asuma uno de los modelos debe marcarse como provisional hasta el cierre.

---

## 4. Reglas invariantes (independientes de §X)

1. **Cero `window.location.href = ...`** suelto en componentes. Todo va por `IShellRouter`.
2. **Cero `react-router` / `vue-router` / `@angular/router`.** Implementación propia.
3. **Drivers intercambiables** sin tocar componentes.
4. **Sincronización con `ScopeContext`** declarativa, no manual.
5. **Back/forward respetan canDeactivate.**

---

## 5. Qué no es

- **No es el Router de plataforma.** Ese es §1.1 — proyección consultiva.
- **No es un store de URL state.** Es Provider con responsabilidad clara.
- **No es navegación nativa.** Aunque puede haber Driver para Electron/Tauri en el futuro, v1 son los dos web.

---

## 6. Inspiración (a leer al elaborar §X)

- **VSCode** — modelo de comandos + active state.
- **Angular Router / TanStack Router / vue-router** — modelos URL clásicos.
- **HashRouter / HistoryRouter** patrones — implementación de drivers.
- **Theia / Atom** — shells IDE alternativas.

Material para las propuestas; no para adopción.
