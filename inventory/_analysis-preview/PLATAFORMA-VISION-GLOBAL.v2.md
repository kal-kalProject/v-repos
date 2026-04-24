---
kind: vision-consolidada
scope: cross-repo
status: draft-v2-discussion
supersedes: PLATAFORMA-VISION-GLOBAL.md (v0)
generated_at: 2026-04-24T00:00:00Z
sources:
  - repo: vortech
    inventory: inventory/vortech/
    commit_ref: _meta/source.md
  - repo: v-rust
    inventory: inventory/v-rust/
    commit_ref: _meta/source.md
  - repo: ui
    inventory: inventory/ui/
    commit_ref: _meta/source.md
  - repo: v-gen
    inventory: inventory/v-gen/
    commit_ref: _meta/source.md
  - repo: v-cam
    inventory: inventory/v-cam/
    commit_ref: _meta/source.md
  - repo: kalProject.MsAccess
    inventory: inventory/kalProject.MsAccess/
    commit_ref: _meta/source.md
input_docs:
  - inventory/_analysis-preview/mis-anotciones.md    # conceptos verbatim del autor
  - inventory/_analysis-preview/inferencia.md         # ronda 1 de inferencia
  - inventory/_analysis-preview/inferencia-02.md      # ronda 2 de inferencia
user_decisions_captured:
  codegen_scope: v-gen motor universal (C# + TS + Rust + SQL + JSON/XML schemas + cualquier texto)
  ui_wire: UI habla Wire directo (WS/TCP), contrato compartido con C#
  ui_canonical: indeciso — ambos candidatos documentados (vortech/platform y repo ui)
  lsp_scope: un LSP para atributos Vortech + plantillas v-gen; con truco "engañar al compiler"
  router: pattern + service agnóstico (no es Provider)
  action_table: eliminado — Scope asume su función
  capability: contrato Provider↔Driver (no "acción disponible")
  agent_vs_driver: ortogonales — Driver exclusivo de Provider; Agent es ejecución autónoma cualquier lenguaje
  extension_vs_driver: Extension = par UI+backend contributable; Driver = impl de Provider
  ui_provider_driver: UI encaja como Provider/Driver (Angular/Vanilla/Blazor = drivers)
  common_duplication: hay duplicación real entre @vortech/common, @vortech/core, platform/v-common
  identity: Host autónomo y replicable (master/slave), proceso propio siempre
pending_decisions:
  - X1 vortech/platform vs ui canónico (UI shell base)
  - X2 vortech-2026 destino (abandonar / nuevo main / experimental)
  - X3 orden de targets v-gen (TS antes que Rust antes que SQL?)
  - X4 TTM (v-ttm) — ¿lenguaje de usuario, motor interno del tooling, o ambos?
  - X5 @vortech/wire + sokectio fusión (ya / después)
  - X6 UIProvider drivers — ¿Angular-only v1, o multi-driver desde inicio?
  - X7 v-gen portado a Rust (unificar con LSP) o queda en C# (invocado externamente)
---

# Plataforma Vortech — Visión consolidada (draft v2)

> **Estado:** borrador discutible. No sustituye artefactos formales de Fase 2.
> **Diferencia con v0:** esta versión integra los conceptos verbatim del autor (`mis-anotciones.md`), las dos rondas de inferencia, y corrige errores de v0 (Identity como Provider, Scope retirado, Agent como tabla, Bridge ausente, UI como stack único).
> **Aún NO incluye:** decisión sobre TTM (X4) ni su impacto en la arquitectura del LSP y v-gen. Eso se resuelve aparte.
>
> **Convención:** `[H]` hecho citable, `[O]` observación agregada, `[V]` valoración, `[?]` pregunta abierta, `[A]` afirmación verbatim del autor.

---

## 0. Alcance y no-alcance

### Alcance
- Definir **el producto Vortech** como un todo, no como colección de repos.
- Consolidar el **vocabulario de primitivas** (Provider, Driver, Agent, Bridge, Wire, Host, Identity, Data, Scope, Router, Capability, Extension).
- Declarar la **arquitectura objetivo** en 4 capas.
- Enumerar los **casos de uso objetivo** (portfolio vertical) que guían las decisiones.
- Catalogar **duplicaciones y decisiones pendientes** sin resolverlas prematuramente.

### No-alcance
- No es plan de migración (→ `v-mono/analysis/migration-plan/`).
- No decide aún TTM (X4) ni la fusión v-gen↔Rust (X7).
- No elige entre `vortech/platform` y `ui` (X1). Ambos viven en el doc.
- No lista archivos a borrar. Eso sale de `comparisons/` + `criterios-unificacion`.

---

## 1. Primitivas de la plataforma (definiciones verbatim del autor)

Estas son **citas literales** de `mis-anotciones.md`, con comentarios mínimos de interpretación. Son la **fuente de verdad léxica** del proyecto. Cualquier otro doc (VISION-v3, vision-y-problema, VC_*) se subordina a este glosario.

### 1.1 Provider — fachada de dominio
> *"Api public con logica de negocio completa y agnostica, no conoce el driver"* `[A]`

- Es **la única superficie pública** de un dominio. El consumidor nunca ve otra cosa.
- Contiene lógica de negocio **completa** (no es interfaz vacía).
- Es agnóstico del driver: funciona incluso sin driver cargado, si el dominio lo permite.

### 1.2 Driver — implementación oculta
> *"implementa a un Provider y cumple con su api, nunca se accede al driver, solo a través del provider"* `[A]`

- Existe **solo** para implementar un Provider. Sin Provider, no hay Driver.
- Es **invisible por diseño**: no se invoca, no se inyecta, no se expone.
- Puede declarar **capabilities** que cumple o no cumple (ver §1.11).

### 1.3 Agent — ejecución autónoma polyglot
> *"micro task/service que ejecuta acciones especificas (similar a tool de un MCP, pero en cualquier contexto), puede ser invocado por Providers/drivers/hosts"* `[A]`
> *"Agent (cualquier lenguaje) es ejecucion especifica, lo utilizan host, providers, drivers, bridges. ej: cuando tu lanzas un script python para que haga algo, tambien puede ser un watchdog, etc."* `[A]`

- **Axis ortogonal** a Provider/Driver: no implementa Providers, **ejecuta tareas**.
- **Cualquier lenguaje, cualquier anfitrión.** Es la escotilla polyglot de la plataforma.
- Ejemplos: script Python on-demand, watchdog, tarea programada, tool expuesto a un MCP server.
- **Observación** `[V]`: Agent es la unidad natural para interop con el ecosistema de IA (MCP tools, RAG workers, voice pipelines).

### 1.4 Wire — API de comunicación
> *"api completa de comunicacion de la plataforma, opera con transports usando TransportProvider/TransportDriver"* `[A]`

- Wire **no** es un transporte: es una **API** sobre transportes.
- Los transportes se modelan con **la misma primitiva Provider/Driver** aplicada a sí misma. `[V: recursividad elegante]`
- Principal: .NET server. Clients en múltiples lenguajes son caso normal. Hosts en otros lenguajes son caso especial acotado. `[A]`

### 1.5 Bridge — traducción cross-lenguaje/plataforma
> *"similar a TransportDriver pero especifico, permite a un lenguaje o platafroma traducir a Wire"* `[A]`

- **TransportDriver especializado**: no transporta en abstracto, **traduce** a Wire desde un runtime ajeno.
- Habilita los casos reales de la plataforma (Mach4 C++, MSAccess COM 32-bit, SII Chile XML firmado, scraping bancario, firmware IoT). `[V]`
- **Bridge es probablemente la ventaja competitiva real** frente a frameworks genéricos (Spring, Nest, .NET vanilla): ningún otro tiene "adaptador a runtime ajeno" como primitiva de primera clase. `[V]`

### 1.6 Host — API de plataforma + pipeline
> *"Api de la plataforma, contiene la logica del pipeline, es wrapper de asp.net, puede ser master y/o slave"* `[A]`

- **Literalmente un ASP.NET Host extendido.** Decisión de stack cerrada.
- Contiene el pipeline (equivalente a middleware ASP.NET = Interceptors en términos VISION-v3).
- Soporta topología master/slave **nativa** desde el diseño.
- Inferencia `[V]`: DI de ASP.NET = container de toda la plataforma server-side. Otras proyecciones (TS en `platform/core/di`) son espejos cliente del mismo contrato.

### 1.7 Identity — Host autónomo replicable
> *"es un host construido con los elementos de la plataforma y es responzable del manejo de account/credentials, authentica, autoriza y mantiene session"* `[A]`
> *"es un host completo y autonomo, con la funcionalidad de host (master/slave) puede tener replicas para redundancia"* `[A]`

- **No es Provider.** Es Host completo. (Corrige v0.)
- Dogfooding: Identity se construye **con** las primitivas de Vortech.
- **Siempre proceso separado.** Soporta replicación master/slave para HA.
- Comparable conceptualmente a Keycloak/Dex/Ory pero construido nativamente. `[V]`

### 1.8 Data — Provider+Driver+Bridge para bases de datos
> *"es un Provider/Driver/Bridge especializado en databases, es logica completa de negocio database, drivers pueden ser tipo sql/no-sql, server/serverless, permite bridge por ejemplo para msaccess netframework com interop"* `[A]`

- **Plantilla ejemplar** del modelo universal: un dominio expresado como Provider (lógica), Drivers (SQL Server, PostgreSQL, MongoDB, …), Bridges (MSAccess COM, SQLite embebido, …).
- Los demás dominios verticales (CncProvider, SiiProvider, ScrapingProvider, ModelProvider IA, IoTProvider) replican este patrón. `[V]`

### 1.9 Scope — árbol de namespaces con contexto
> *"es arbol de namespace, basado en nodos, nodos pueden ser solo namespace o con un context, el context no es responzabilidad del scope, pero si es referencia al context y permite resolver, funciona en conjunto con Router para resolucion typo query"* `[A]`

- Árbol jerárquico: cada nodo es **namespace puro** o **namespace con contexto**.
- El contexto **no vive en Scope**, pero Scope lo **referencia**.
- Trabaja con **Router** para resoluciones tipo query sobre el grafo.
- Inferencia `[V]`: habilita direcciones estilo `identity.accounts.byEmail("x").sessions.active` — sistema de direccionamiento universal sobre el grafo de Providers.
- **v0 se equivocaba:** NO está retirado. La "tabla de acciones" de VISION-v3 queda eliminada; Scope cumple ese rol.

### 1.10 Router — pattern + service agnóstico
> *"es un pattern + service para resolver (agnostico)"* `[A]`

- **No es Provider.** Servicio transversal al Host.
- Resuelve rutas sobre Scope. Análogo conceptual: `IEndpointRouter` de ASP.NET pero sobre el grafo de Providers, no sobre HTTP.

### 1.11 Capability — contrato Driver↔Provider
> *"capability es lo que el provider espera que el driver implemente o declare sin capacidad"* `[A]`

- **NO es "acción disponible"** (eso era "tabla de acciones", eliminado).
- Es **contrato**: el Provider enumera capabilities requeridas/opcionales; el Driver declara cuáles cumple y cuáles no.
- Habilita **degradación graceful** y **matrices de compatibilidad** generables automáticamente (vía v-gen + LSP). `[V]`

### 1.12 Extension — par UI+backend contributable
> *"sistema de plugins, pueden ser dentro del bundle o en caliente"* `[A]`
> *"Extension es el conjunto ui/backend en secciones contributables"* `[A]`

- **NO es Driver con hot-reload.** Semántica distinta: Extension es **unidad dual** (frontend + backend) que contribuye a secciones del layout/shell.
- Modelo **VSCode literal**: `contributes.views`, `contributes.commands`, pero con backend adosado.
- Habilita **shipping feature-by-feature** de cada vertical. `[V]`
- Cold (bundle) + Hot (caliente) = dos ciclos de vida soportados.

---

## 2. Glosario canónico (resolviendo homónimos)

| Término | Significado canónico (§1) | Conflictos/homónimos actuales | Acción |
|---------|---------------------------|------------------------------|--------|
| **Provider** | §1.1 | — | ✅ único |
| **Driver** | §1.2 | — | ✅ único |
| **Agent** | §1.3 | (confusión posible con "Agent" VISION-v3 = "actor delegado humano/máquina") | **Renombrar en VISION-v3**: actor delegado = **"Principal"** o **"Identity subject"**, no Agent. |
| **Wire** | §1.4 | 6 implementaciones fragmentadas | ver §3.4 |
| **Bridge** | §1.5 | **nuevo primitivo** — no aparece en VISION-v3 | Actualizar VISION-v3 → v3.1 con Bridge. |
| **Host** | §1.6 | `@vortech/host` TS es proyección cliente, OK | Mantener doble uso documentado. |
| **Identity** | §1.7 | — | ✅ corregido (v0 lo ponía como Provider). |
| **Data** | §1.8 | — | ✅ patrón de referencia para otros dominios. |
| **Scope** | §1.9 | v0 lo retiraba (error) | Reintegrar. Eliminar "tabla de acciones" de VISION-v3. |
| **Router** | §1.10 | no inventariado en repos con ese nombre | crear service explícito. |
| **Capability** | §1.11 | uso vago en código actual | Formalizar. |
| **Extension** | §1.12 | confusión con Driver (v0 las mezclaba) | Separar semánticas. |
| **Feature** | — | `vortech/.vortech/doc/feature/*` | **Retirado**. Se reemplaza por composición Provider+SDK+Driver+Extension. |
| **Core** (kernel TS UI) | núcleo de `vortech/platform/core` / `ui/...` (DI+atoms, Node/Browser) | `v-rust/crates/v-core` es otra cosa | Renombrar crate Rust → `v-kernel` o similar. |
| **SDK** | Fachada pública **por rol** (Provider SDK, Driver SDK, Client SDK, UI SDK, Agent SDK) | 3 lugares con "SDK" distintos | Taxonomía única por rol. |
| **Plugin** | Sinónimo laxo; usar Driver o Extension según caso | — | Preferir términos exactos. |

---

## 3. Mapa de reconciliación

### 3.1 "Feature" → Provider + Driver + Extension
`vortech/.vortech/doc/feature/vision-y-problema.md` describe "Feature" como 3 responsabilidades (lógica / contrato SDK / implementación plugin). En vocabulario v2:
- Lógica = **Provider**.
- Contrato SDK = **Provider SDK** (generado por v-gen desde atributos).
- Implementación plugin = **Driver** (backend) + **Extension** (si contribuye a UI).
- **Acción:** retirar "Feature" del vocabulario oficial. Retagear docs.

### 3.2 DI de `platform/core` (TS) vs DI de ASP.NET (server)
Hoy `platform/core/di/injector/injector.ts` (~1057 LOC `[H]`) reimplementa container propio. .NET usa MS.DI.
- **Propuesta:** ambos son **proyecciones del mismo contrato de DI**. v-gen genera los registros desde atributos → fuente única.
- Homólogos de VSCode/Electron: DI del renderer ≠ DI del main, pero mismo contrato.

### 3.3 Múltiples LSPs → estrategia pendiente (depende de X4)
| Implementación | Stack | Propósito real | Estado |
|---------------|-------|----------------|--------|
| `Vortech.LanguageServer` (C#) | .NET | Atributos Vortech | candidato |
| `@vortech/lsp`, `vortech-language-server` (TS) | Node | Tooling dev TS | absorber en plugin VSCode |
| `v-ttm-lsp` (Rust, tower-lsp) | Rust | LSP de TTM — **pero ya tiene tree-sitter + AST + symbols** | **depende de X4** |
| `vortech/devtools/vscode` | TS | Plugin VSCode experimental | merge con plugin canónico |

- **Decisión X4 aún abierta:** si TTM/v-ttm se reposiciona como motor del LSP universal, el canónico pasa a ser Rust, no C#. Si TTM queda como lenguaje aparte, el canónico sigue siendo C#.

### 3.4 Múltiples Wires → uno con proyecciones generadas
| Implementación | Stack | Rol propuesto |
|---------------|-------|---------------|
| `vortech-wire` (C#) | .NET | **contrato canónico** server-side |
| `vortech-wire-2026` (C#) | .NET | evaluar (X2) |
| `v-wire` (Rust) | Rust | proyección + FFI |
| `@vortech/wire` (TS) | TS | proyección cliente UI |
| `sokectio/` (TS) | TS | transporte WS — fusionar con `@vortech/wire` (X5) |
| `vortech-wire` (C) | C | interop embebidos — mantener aparte |

**Invariante:** todos hablan el mismo protocolo. Las proyecciones TS/Rust/C las **genera v-gen** desde el contrato C#.

### 3.5 `v-core` Rust vs `core` TS
Kernels distintos de capas distintas. **Renombrar el Rust** para liberar el nombre.

### 3.6 `vortech` vs `vortech-2026` (X2)
Decisión binaria pendiente. Sin resolver queda deuda de navegación permanente.

### 3.7 `vortech/platform` vs `ui` como UI shell (X1)
- `vortech/platform/` — 15 subpaquetes TS, alto detalle en tests, core con DI propia+atoms Node/Browser.
- `ui/` — monorepo integrador con `devtools/`, `dotnet/`, `crates/`, `rust-ts-runtime/`.
- Hipótesis de trabajo: híbrido. Fase 2 decide.

### 3.8 `common` TS triplicado
`@vortech/common` + `@vortech/core` + `platform/v-common` — duplicación explícita reconocida por el autor. Fase 2 consolida.

### 3.9 `UIProvider` con drivers
El autor confirma que UI encaja en Provider/Driver. Drivers posibles: Angular, Vanilla, Blazor. **Recomendación de producto** `[V]`: un driver canónico v1 (Angular, dado el estado actual del código) para no diluir esfuerzo. Drivers adicionales cuando haya tracción (X6).

---

## 4. Arquitectura objetivo (4 capas)

```
┌──────────────────────────────────────────────────────────────┐
│  CAPA 1 — DEVELOPER EXPERIENCE                               │
│                                                              │
│  Autor escribe:                                              │
│    Atributos C# / Decoradores TS / (¿TTM?)                   │
│         │                                                    │
│         ▼                                                    │
│    v-gen  ────────▶  código real multi-target                │
│    (universal)        C#, TS, Rust, SQL, JSON Schema,        │
│                       XML, manifests, docs                   │
│                                                              │
│    LSP + plugin VSCode                                       │
│    "engaña al compiler" con símbolos proyectados             │
│    desde atributos, hasta que v-gen emite real               │
└──────────────────────────────────────────────────────────────┘
                             │ (código generado)
                             ▼
┌──────────────────────────────────────────────────────────────┐
│  CAPA 2 — PRIMITIVAS CONCEPTUALES                            │
│                                                              │
│  Provider ─── Driver          (par contractual)              │
│     │           │                                            │
│     │           └──▶ declara Capabilities                    │
│     │                                                        │
│     ├─── Agent       (ejecución autónoma polyglot)           │
│     │                                                        │
│     └─── Extension   (UI+backend contributable)              │
│                                                              │
│  Scope ─── Router  (direccionamiento tipo query)             │
└──────────────────────────────────────────────────────────────┘
                             │
                             ▼
┌──────────────────────────────────────────────────────────────┐
│  CAPA 3 — RUNTIME DISTRIBUIDO                                │
│                                                              │
│  ┌────────────────────────────────────────────────┐          │
│  │  Host  (wrapper ASP.NET, master/slave)         │          │
│  │                                                │          │
│  │  ┌──────────────────────────────────────────┐  │          │
│  │  │ Identity Host (autónomo, replicable)     │  │          │
│  │  └──────────────────────────────────────────┘  │          │
│  │                                                │          │
│  │  ┌──────────────────────────────────────────┐  │          │
│  │  │ Host de producto                         │  │          │
│  │  │   DataProvider + drivers + bridges       │  │          │
│  │  │   CncProvider + Mach4 bridge             │  │          │
│  │  │   SiiProvider + driver                   │  │          │
│  │  │   ModelProvider (IA) + drivers           │  │          │
│  │  │   Extensions (UI+BE por feature)         │  │          │
│  │  │   Agents (tareas, watchdogs, scripts)    │  │          │
│  │  └──────────────────────────────────────────┘  │          │
│  └────────────────────────────────────────────────┘          │
│                         ▲                                    │
│                         │ Wire                               │
│                         │ (TransportProvider + Driver)       │
│                         │ (Bridge para cross-lang/platform)  │
│                         ▼                                    │
│  Clients: C#, TS, Rust, C++, Python, …                       │
└──────────────────────────────────────────────────────────────┘
                             │
                             ▼
┌──────────────────────────────────────────────────────────────┐
│  CAPA 4 — UI SHELL                                           │
│                                                              │
│  UIProvider                                                  │
│   └── UIDriver Angular  (canónico v1)                        │
│   └── UIDriver Vanilla  (futuro)                             │
│   └── UIDriver Blazor   (futuro)                             │
│                                                              │
│  Layout VSCode-like  (NO depende de Angular)                 │
│  Theming              (tokens, NO depende de Angular)        │
│  Core/Common          (DI + atoms, Node/Browser)             │
│  Extensions           (VSCode-like: UI+backend)              │
└──────────────────────────────────────────────────────────────┘
```

---

## 5. Principios no-negociables

1. **Provider/Driver es universal.** Todo nodo de dominio se modela así. Incluye Wire (TransportProvider/Driver), Data, UI, Identity-internos.
2. **El Driver es invisible.** Nunca se expone, nunca se inyecta directamente. Solo el Provider es superficie pública.
3. **Atributos son el DSL.** Configuración y contratos se expresan con atributos/decoradores, no XML ad-hoc. v-gen los compila.
4. **Un solo Wire.** N lenguajes, un único protocolo. Las proyecciones se generan, no se escriben a mano.
5. **Identity es Host propio.** Siempre separado, siempre replicable.
6. **Host = ASP.NET.** No hay abstracción alternativa. ASP.NET es implementación de referencia, no "un backend posible".
7. **Self-hosted es requisito de producto.** Los 7 casos de uso lo exigen (ver §9).
8. **Bridge es primitivo de primera clase.** No es "capa anticorrupción". Se inventaría, versiona, versiona, despliega.
9. **Dogfooding.** Identity, UI, LSP y plugin VSCode son todos Hosts/Clients/Extensions de la plataforma que construyen.
10. **Agent es polyglot legítimo.** No hay que forzar todo a .NET: Agents Python, Node, shell, son ciudadanos de primera.

---

## 6. Decisiones pendientes

Unificadas entre `DECISIONES-PENDIENTES.md` (v-rust) y las nuevas emergentes.

| # | Tema | Estado |
|---|------|--------|
| 1 | Topología Provider in-proc vs out-of-proc | recomendada C (default A) — VISION-v3 |
| 2 | Scheduler simple vs avanzado | abierto |
| 3 | Capability: estricto vs laxo | Favor estricto dado §1.11 |
| 4 | (ex "nombre tabla de acciones") | **eliminado** — Scope cumple esa función |
| X1 | `vortech/platform` vs `ui` canónico | **abierto** — ambos documentados |
| X2 | `vortech-2026` destino | **abierto** — decisión binaria requerida |
| X3 | Orden de targets v-gen (TS / Rust / SQL / Schema) | abierto |
| **X4** | **TTM (`v-ttm`): lenguaje de usuario, motor del LSP, o ambos** | **CRÍTICO** — domina estrategia LSP y v-gen. Ver doc aparte. |
| X5 | `@vortech/wire` + `sokectio` fusión | abierto |
| X6 | UIProvider drivers — Angular-only v1 o multi-driver | recomendado Angular-only v1 |
| X7 | v-gen: portar a Rust o permanecer C# | abierto — acoplado a X4 |

---

## 7. Matriz legado → destino

| Repo / Área | Rol objetivo | Acción sugerida |
|-------------|-------------|-----------------|
| `v-rust/vortech-dotnet/Wire,Host,SDK,LanguageServer` | Canónico Capa 3 (server) + candidato Capa 1 (LSP) | Preservar; alinear namespaces; decidir LSP canónico en X4 |
| `v-rust/vortech-dotnet/docs/v-platform/VISION-v3.md` | Doc base — requiere update | Emitir **VISION-v3.1**: retirar "tabla de acciones", introducir Bridge, renombrar "Agent" VISION-v3 → "Principal", reintegrar Scope+Router |
| `v-rust/crates/v-wire` | Proyección Wire Rust | Preservar (generado por v-gen idealmente) |
| `v-rust/crates/v-core`, `v-alloy` | Kernel Rust | **Renombrar** para liberar `core` — p.ej. `v-kernel` |
| `v-rust/crates/v-ttm*` (7 crates) | **Decisión X4** | 3 escenarios: (a) lenguaje aparte, (b) motor LSP universal, (c) ambos |
| `vortech/platform/core, v-common, v-components, layout, theming, v-ui, v-runtime` | Base Capa 4 candidata (X1) | Preservar; resolver X1 |
| `vortech/packages/@vortech/wire,core,host,sdk,lsp` | Proyecciones TS Capa 3-4 | **Regenerar con v-gen** desde contratos C# |
| `vortech/sokectio/` | Transporte WS | Fusionar con `@vortech/wire` (X5) |
| `vortech/vortech-2026/` | Tentativa paralela | **Decisión X2** |
| `vortech/devtools/vscode` | Plugin VSCode | Fusionar con plugin del LSP canónico (depende de X4) |
| `ui/` (monorepo completo) | Base Capa 4 candidata (X1) / integrador | Preservar; resolver X1 |
| `ui/devtools/` (analyzer babel+ts-morph) | Tooling dev TS | Integrar al LSP unificado como worker auxiliar |
| `ui/crates/, rust-ts-runtime/, dotnet/` | Interop experimental | Evaluar duplicidad con `v-rust/crates/` |
| `v-gen/` | Canónico Capa 1 (codegen) | Preservar; ampliar targets (X3); decisión portar (X7) |
| `v-cam/` | Producto accesorio | Candidato a **primer vertical dogfood** (CAD/CAM/CNC) — ver §9 |
| `kalProject.MsAccess/` | Legacy fuera de la plataforma | Fuera de alcance; posible insumo para Data bridge MSAccess |

---

## 8. Verticales objetivo (portfolio)

Los 7 casos de uso de `mis-anotciones.md` no son ejemplos: **definen el producto**.

| Vertical | Composición estimada | Bridge crítico |
|----------|---------------------|----------------|
| **CAD/CAM/CNC** (Mach4) | Host + Identity + Data + CncProvider + Extensions UI (editor, simulador) | **Mach4 C++ bridge** |
| **CNC-Control** (real-time) | Host + CncProvider + Agents (watchdog safety) | bridge firmware / GRBL |
| **SII Chile tributario** | Host + Identity + Data + SiiProvider (firma XML + DTE) + Extensions UI | bridge webservices SII (SOAP + cert) |
| **Scraping bancario** | Host + Identity (vault credenciales) + ScrapingProvider + Agents (navegador headless) | bridge Playwright/navegador real |
| **ERP PyMEs** | Host + Identity + Data + SiiProvider + InventarioProvider + ContabilidadProvider + Extensions | — |
| **IA self-hosted** (MCP, RAG, chat, voz) | Host + Identity + Data + ModelProvider (OpenAI/Local) + VectorProvider + Agents (tools MCP) | bridge MCP externo |
| **IoT** | Host + Identity + Data + DeviceProvider + Agents (event loop) | bridges Modbus/MQTT/serial |

**Inferencia transversal** `[V]`: el **valor** de Vortech está en la **reutilización horizontal** — Data+Identity+UI se comparten entre verticales. Cada vertical es "casi gratis" una vez que el tronco existe. Esto posiciona el producto como **Retool/Odoo/Mendix técnica** para empresa mediana/industrial/regulada, no consumer cloud.

---

## 9. Developer Experience (capa 1 detallada)

Esta capa es **parte del producto**, no tooling auxiliar. Tres piezas que trabajan juntas:

### 9.1 Atributos / Decoradores
- **C# atributos** y **TS decoradores** son la superficie del DSL.
- Simplifican al developer: en vez de implementar 200 LOC de boilerplate (registro DI, manifest, contrato Wire, proyección cliente), escribe `[Provider("cnc")]` o `@Provider("cnc")`.
- Los atributos son **input de v-gen**.

### 9.2 v-gen — compilador del DSL
- **Motor universal de texto** `[A]`: C#, TS, Rust, SQL, JSON, XML, JSON Schema, manifests, docs.
- Angular-like: template no sabe de dónde viene el dato, componente no sabe cómo se renderiza.
- Genera desde atributos: registros DI, proyecciones Wire por lenguaje, manifiestos de Extension, schemas, docs.
- Autodescripción: la plataforma genera sus propios manifiestos y schemas.

### 9.3 LSP + plugin VSCode — el truco central
> *"engañar al compiler y vscode para que el usuario escriba codigo que no compilaria, con el proposito de ahorrar escritura de codigo que luego se generaría correctamente para pasar la compilacion y sea integrado a la plataforma"* `[A]`

- Flujo: developer escribe código incompleto → LSP inyecta símbolos proyectados (como si v-gen ya hubiera generado) → autocomplete, hover, goto-def funcionan → al guardar/compilar, v-gen emite real → Roslyn/ts-server lo ven real y compila.
- Técnicamente: **meta-LSP** que proxea a Roslyn/ts-server con síntesis de símbolos desde atributos.
- **Es la pieza más original del diseño** `[V]`. Sin ella, atributos+v-gen son "otro Source Generator más". Con ella, es una nueva experiencia de desarrollo.
- **Crítico**: el valor competitivo depende materialmente de que esto funcione bien.
- **Riesgo**: desincronización entre stubs y código real ("funciona en mi IDE, falla al compilar"). Exige telemetría interna + tests E2E del plugin.

---

## 10. Riesgos transversales

| # | Riesgo | Mitigación propuesta |
|---|--------|----------------------|
| R1 | LSP-que-miente desincronizado | Tests E2E, telemetría de "symbols ficticios vs generados", debounce inteligente |
| R2 | v-gen multi-target — cada target es mini-producto | Priorizar targets (X3): crítico = contrato Wire TS + manifiestos Extension |
| R3 | Extension hot-reload + Identity replicado + Host master/slave = mucha complejidad v1 | Congelar hot-reload y master/slave como v1.x, no v1.0 |
| R4 | UIProvider con N drivers diluye esfuerzo | Angular-only v1 (X6); drivers adicionales cuando haya casos |
| R5 | Bridge exige SDK per-lenguaje-host (C++, Python, COM, MCP…) | Cada Bridge es mini-producto; priorizar los de verticales activos |
| R6 | Duplicación existente (2026 vs 2025, LSPs, Wires, common) bloquea progreso | Fase 2 debe resolver X1/X2/X4/X5 antes de nuevo código |
| R7 | "Feature" vs "Provider/Driver" en docs → confusión histórica | Purga de término "Feature" + redirección de docs |

---

## 11. Qué sigue

1. **Autor revisa §6 y marca preferencias** sobre X1–X7.
2. **X4 (TTM) se trata en doc aparte** — su resolución cambia §3.3 y §3.4 parcialmente.
3. Una vez cerradas las X, cada sección alimenta artefactos Fase 2:
   - §1+§2 → `v-mono/analysis/glossary.md` (fuente única)
   - §3 → `v-mono/analysis/comparisons/`
   - §4+§5 → `v-mono/analysis/canonical-proposals/`
   - §6+§7 → `v-mono/analysis/migration-plan/`
   - §8 → `v-mono/analysis/verticals/` (portfolio orientador)
   - §9 → `v-mono/analysis/canonical-proposals/developer-experience.md`
4. Emitir **VISION-v3.1** en `v-rust/vortech-dotnet/docs/v-platform/` con las correcciones detectadas (Bridge primitivo, Scope+Router vivo, "Agent" VISION-v3 → "Principal", "tabla de acciones" retirada).

---

## 12. Apéndice — Texto verbatim del autor

Conservado para evitar reinterpretación. Fuente: `inventory/_analysis-preview/mis-anotciones.md`.

### Primitivas
- **Provider**: *Api public con logica de negocio completa y agnostica, no conoce el driver*
- **Driver**: *implementa a un Provider y cumple con su api, nunca se accede al driver, solo a través del provider*
- **Agent**: *micro task/service que ejecuta acciones especificas (similar a tool de un MCP, pero en cualquier contexto), puede ser invocado por Providers/drivers/hosts* — *Agent (cualquier lenguaje) es ejecucion especifica, lo utilizan host, providers, drivers, bridges. ej: cuando tu lanzas un script python para que haga algo, tambien puede ser un watchdog, etc.*
- **Wire**: *api completa de comunicacion de la plataforma, opera con transports usando TransportProvider/TransportDriver*
- **Bridge**: *similar a TransportDriver pero especifico, permite a un lenguaje o platafroma traducir a Wire*
- **Host**: *Api de la plataforma, contiene la logica del pipeline, es wrapper de asp.net, puede ser master y/o slave*
- **Identity**: *es un host construido con los elementos de la plataforma y es responzable del manejo de account/credentials, authentica, autoriza y mantiene session* — *es un host completo y autonomo, con la funcionalidad de host (master/slave) puede tener replicas para redundancia*
- **Data**: *es un Provider/Driver/Bridge especializado en databases, es logica completa de negocio database, drivers pueden ser tipo sql/no-sql, server/serverless, permite bridge por ejemplo para msaccess netframework com interop*
- **Scope**: *es arbol de namespace, basado en nodos, nodos pueden ser solo namespace o con un context, el context no es responzabilidad del scope, pero si es referencia al context y permite resolver, funciona en conjunto con Router para resolucion typo query*
- **Router**: *es un pattern + service para resolver (agnostico)*
- **Capability**: *es lo que el provider espera que el driver implemente o declare sin capacidad*
- **Extension**: *sistema de plugins, pueden ser dentro del bundle o en caliente* — *Extension es el conjunto ui/backend en secciones contributables*

### Base
- *El uso de Provider/Driver es casi universal en la platafroma.*
- *Wire es comunicacion, pueden implementarse host/clients en otros lenguajes y platafromas, principal es .Net, crear hosts en otros lenguajes es muy acotado y para casos especiales, pero los clients son normalmente necesarios en mas lenguages y platafromas.*

### UI
- *Esto es aun debatible entre usar angular vs framework propio o ambos.*
- *En ts existe common, core que contiene utilidades compatibles node/browser, las mas destacadas son atoms y di con decoradores.*
- *Theming: existe una lib especializada en style tokens, themes y presets, no es exclusiva de angular.*
- *Layout: vscode like, no es para desarrollo, pero contiene las secciones y funcionalidades de el layout de vscode, tambien el sistema de extensions para utilizar las secciones del layout y sus funcionalidades base.*

### Developer Experience
- *Atributos .net y decoradores ts son para simplificar al usuario developer implementar providers, drivers, agents, bridges, wire, host, data, etc.*
- *v-gen es el sistema de templates para generar codigo, json, xml, jsonschemas, sql, etc. (universal)*
- *LSP y plugin vscode son para diagnsotics, y todo lo demas de un lsp, pero con una particularidad especial: engañar al compiler y vscode para que el usuario escriba codigo que no compilaria, con el proposito de ahorrar escritura de codigo que luego se generaría correctamente para pasar la compilacion y sea integrado a la plataforma (tambien generaria los manifest, otros lenguages, etc.)*

### Casos de uso reales
- *Plugin mach4 en c++ con un WireBridge + CncProvider.*
- *Aplicacion cad/cam/cnc-control.*
- *Sistema de emision de documentos tributarios sii chile.*
- *Webscraping bancario para obtener movimientos.*
- *Aplicacion para administracion de pymes, tipo erp especializado en pymes.*
- *Aplicaciones inteligencia artificial, Mcp server/client, rag, chat, voice. para uso con apikey y self-hosted con contextos especificos.*
- *IoT: manejo de dispositivos.*
