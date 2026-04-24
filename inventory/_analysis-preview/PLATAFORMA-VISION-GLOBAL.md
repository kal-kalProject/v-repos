---
kind: vision-consolidada
scope: cross-repo
status: draft-v0-discussion
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
user_decisions_captured:
  - codegen_scope: v-gen como motor universal (C# + TS + Rust + cualquier texto)
  - ui_wire: UI habla Wire directo (WS/TCP), mismo contrato que C#
  - ui_canonical: indeciso — documentar ambos (vortech/platform y repo ui), decidir en Fase 2
  - lsp_scope: un LSP para atributos Vortech (C#) + plantillas v-gen. TTM queda aparte si sobrevive.
---

# Plataforma Vortech — Visión consolidada (draft v0)

> **Estado:** borrador discutible. No sustituye artefactos formales de Fase 2 (`analysis/comparisons/`, `canonical-proposals/`, `migration-plan/`). Sirve como **insumo** de esos artefactos: una vez validado por el autor, las piezas se derivan mecánicamente.
>
> **Regla de lectura:** cada afirmación marcada `[H]` es hecho (citable al inventario); `[O]` es observación agregada; `[V]` es valoración; `[?]` es pregunta abierta.

---

## 0. Alcance y no-alcance

### Alcance
- Unificar en **un solo relato** las cinco visiones dispersas: `VISION-v3.md` (.NET), `vision-y-problema.md` (Feature model), `v-gen/docs/vgen-engine.md` (codegen), `LanguageServer/vision.md` (LSP), y los `VC_*.md` + `vortech/platform/.doc` (UI shell).
- Fijar **glosario único** para resolver homónimos (Feature≠Feature, core≠core, wire≠wire).
- Declarar el **rol objetivo** de cada repo actual sin decidir aún migraciones concretas.

### No-alcance
- No es plan de migración (eso va a `v-mono/analysis/migration-plan/`).
- No resuelve las 11 decisiones de `DECISIONES-PENDIENTES.md` — las cataloga y amplía.
- No decide qué código se tira: eso lo determina Fase 2 tras aplicar `.docs/post-inventario/02-criterios-unificacion.md`.

---

## 1. Un solo producto, cinco capas

La plataforma es **un único producto** que hoy vive fragmentado en 6 repos. Las cinco capas siguientes son **ortogonales por propósito** y **acopladas por contratos** (no por implementación).

### 1.1 Capa de infraestructura distribuida — **.NET**

**Fuente canónica:** `repos/v-rust/vortech-dotnet/docs/v-platform/VISION-v3.md`. [H]

Define los 5 roles primitivos:

| Rol | Responsabilidad |
|-----|----------------|
| **Provider** | Nodo que aloja lógica de dominio (StoreProvider, IdentityProvider…). Raíz del grafo. |
| **Driver** | Plugin de Provider: añade capacidades manteniendo el contrato. |
| **Host** | Proceso que orquesta Providers locales + remotos. Único por máquina/deploy. |
| **Agent** | Actor delegado con identidad propia (humano o máquina). |
| **Client** | Consumidor externo del grafo (UI, CLI, otro Host). |

5 pilares arquitectónicos (de VISION-v3):
1. **Provider/Driver universal** — todo se modela así.
2. **Atributos + v-gen** como DSL de configuración.
3. **LSP + VSCode** como superficie de desarrollo.
4. **SDKs por rol** (Provider SDK, Driver SDK, Client SDK…).
5. **Interceptors + Hosting** pipeline único.

**Repos actuales que implementan esta capa:**
- `v-rust/vortech-dotnet/` (referencia vigente — código C# reciente). [H]
- `vortech/` paquetes TS `@vortech/core`, `@vortech/host`, `@vortech/wire`, `@vortech/sdk` (proyecciones TypeScript). [H]
- `vortech/` `vortech-2026/` (tentativa paralela de reescritura). [O]

### 1.2 Capa de codegen — **v-gen**

**Fuente canónica:** `repos/v-gen/docs/vgen-engine.md`. [H] (README: *"generates any text (C#, TypeScript, SQL, YAML, and more) from `.v-gen` templates paired with C# components"*). [H]

**Decisión del autor:** v-gen es **motor universal de texto** (C# + TS + Rust + cualquier formato). No se limita a C#.

Modelo Angular-like:
- **Template `.v-gen`** no sabe de dónde viene el dato.
- **Componente C#** no sabe cómo se renderiza.
- Inversión de responsabilidades idéntica a Angular → explica por qué el autor escogió Angular como UI stack.

**Acoplamiento con capa 1.1:** los **atributos** del pilar 2 de VISION-v3 *son* la entrada de v-gen. Atributo C# → template → código generado (C# de runtime, binding TS, FFI Rust, …).

**Repos actuales:** `v-gen/` único. Relación con `v-rust/vortech-dotnet/SourceGenerators/` pendiente de clarificar. [?]

### 1.3 Capa de tooling de lenguaje — **LSP + VSCode**

**Decisión del autor:** **un LSP** para atributos Vortech (C#) + plantillas v-gen. Único plugin VSCode que lo consume.

**Situación actual (fragmentada):** [H]
| Implementación | Repo | Propósito real | Destino objetivo |
|---------------|------|----------------|------------------|
| `Vortech.LanguageServer` (C#) | `v-rust/vortech-dotnet/LanguageServer/` | Atributos Vortech | ✅ base canónica |
| `@vortech/lsp`, `vortech-language-server` (TS) | `vortech/packages/` | Tooling dev TS | evaluar absorber en plugin VSCode |
| `v-ttm-lsp` (Rust) | `v-rust/crates/` | Lenguaje TTM (no Vortech) | fuera de alcance de este LSP (separado si TTM sobrevive) |
| `vortech/devtools/vscode` | `vortech/` | Plugin VSCode experimental | merge con plugin del LSP canónico |

### 1.4 Capa de UI shell — **Angular "VSCode-clone"**

**Objetivo declarado:** clon visual y funcional de VSCode en Angular, con sistema de extensiones análogo al de VSCode. [H citables: `COPILOT_AGENT_HANDOFF.md`, `VC_EXECUTIVE_SUMMARY.md`, `vortech/platform/.doc/`]

**Dos implementaciones paralelas** [H]:
- `vortech/platform/` — 15 subpaquetes TS: `core` (DI propia + atoms/signals), `layout`, `theming`, `v-ui`, `v-components`, `v-runtime`, `v-api-factory`, `v-lsp`, `sdk`, `v-collections`, `v-common`, `di-demo`, `v-components-playground`, `v-layout`, `v-theming`. Alto detalle en tests.
- `ui/` — monorepo Angular + `devtools/` (analyzer Babel+ts-morph) + `dotnet/` + `crates/` + `rust-ts-runtime/`. Enfoque integrador (contiene también interop nativo).

**Característica diferenciadora:** `vortech/platform/core` reimplementa DI, signals (atoms) y lifecycle **sin depender de Angular runtime en ese package** — pensado como base compartible. [O]

**Decisión del autor:** indeciso, documentar ambos y decidir en Fase 2. Hipótesis de trabajo: híbrido `core+atoms+DI` de `vortech/platform` + `shell/layout/devtools` de `ui`.

### 1.5 Capa de runtime cross-lenguaje — **Wire**

**Decisión del autor:** la UI habla Wire directo (WS/TCP), **mismo contrato** que los clientes C#.

**Situación actual (fragmentada):** [H]
| Implementación | Repo | Stack | Destino |
|---------------|------|-------|---------|
| `vortech-wire` (C#) | `v-rust/vortech-dotnet/Wire/` | .NET | base canónica server-side |
| `vortech-wire-2026` (C#) | `v-rust/vortech-dotnet/` | .NET | reescritura — evaluar convergencia |
| `v-wire` (Rust) | `v-rust/crates/` | Rust | binding FFI/performance |
| `@vortech/wire` (TS) | `vortech/packages/` | TS | cliente UI — debe proyectar el contrato C# |
| `sokectio/` (TS) | `vortech/` | TS | transporte WS — candidato a fusionar con `@vortech/wire` |
| `vortech-wire` (C) | `v-rust/` | C | interop embebidos — mantener aparte |

**Invariante:** todos hablan el mismo protocolo. El contrato vive junto a `Wire/` C# y se proyecta a TS/Rust con **v-gen** (cierra el círculo con capa 1.2). [V]

---

## 2. Glosario canónico (propuesta)

Estos términos hoy tienen 2–3 significados distintos entre repos. Propongo fijar:

| Término | Significado canónico | Conflictos actuales |
|---------|---------------------|---------------------|
| **Provider** | Nodo-raíz del grafo (VISION-v3) | — (solo aparece en v-rust) |
| **Driver** | Plugin de Provider (VISION-v3) | — |
| **Feature** | **Retirado** como término de arquitectura. Se reemplaza por Provider/Driver. | `vortech/.vortech/doc/feature/*` usa "Feature" con otra semántica |
| **Core** | Kernel TS de UI (`vortech/platform/core`: DI+atoms) | `v-rust/crates/v-core` (kernel Rust) → renombrar a `v-kernel` o similar |
| **Wire** | Protocolo único cross-stack | hoy 6 implementaciones, ver §1.5 |
| **Atom** | Signal reactiva de `vortech/platform/core/atoms` | — |
| **Host** | Proceso orquestador (VISION-v3) | `@vortech/host` TS = proyección cliente del mismo concepto, OK |
| **SDK** | Fachada pública **por rol** (Provider SDK, Driver SDK, Client SDK, UI SDK) | `ui/` SDK vs `vortech/platform/sdk` vs `v-rust/vortech-dotnet/SDK` — fusionar bajo esta taxonomía |
| **Scope** | **Retirado**. Se reemplaza por "Tabla de acciones" (VISION-v3). | `ScopeTree` en código TS legacy |
| **Plugin** | Sinónimo de Driver cuando el anfitrión es un Host (backend) o el Shell (UI) | — |

---

## 3. Mapa de reconciliación

### 3.1 "Feature" vs "Provider/Driver" → una semántica
`vortech/.vortech/doc/feature/vision-y-problema.md` describe "Feature" como unidad con 3 responsabilidades (lógica / contrato SDK / implementación plugin). Ese modelo **es** Provider+SDK+Driver de VISION-v3 con nombres distintos.

**Propuesta:** retirar "Feature" del vocabulario oficial. Retagear los docs.

### 3.2 DI de `vortech/platform/core` vs DI de .NET
Hoy `platform/core/di/injector/injector.ts` (≈1057 LOC [H]) reimplementa un container propio. .NET usa MS.DI. Ambos resuelven lo mismo cross-stack.

**Propuesta:** documentar que son **proyecciones del mismo contrato** (servicio, scope, lifetime). v-gen genera los registros desde atributos → fuente única de verdad.

### 3.3 Tres LSPs → uno
Ver §1.3. Canónico: `Vortech.LanguageServer` (C#). TTM queda fuera (lenguaje distinto).

### 3.4 Seis Wires → uno (con proyecciones)
Ver §1.5. Canónico: `vortech-wire` C# como contrato. Resto = proyecciones generadas por v-gen.

### 3.5 `v-core` Rust vs `v-core` TS
Son kernels distintos de capas distintas. **Renombrar uno** (propuesta: el Rust pasa a `v-kernel` o `vortech-runtime`).

### 3.6 `vortech` vs `vortech-2026`
Dos intentos de reescritura conviven. [O] Requiere decisión binaria en Fase 2: ¿2026 es branch experimental abandonable, o es el nuevo `main` lógico? [?]

### 3.7 `vortech/platform` vs `ui` (UI shell)
Pendiente de decisión del autor. Ambos sobreviven en el draft; Fase 2 elige.

---

## 4. Arquitectura objetivo

```
┌─────────────────────────────────────────────────────────────┐
│  UI Shell (Angular "VSCode-clone")                          │  capa 1.4
│  - Activity bar, Side bar, Editor, Panel, Command palette   │
│  - Extension host (plugins tipo VSCode)                     │
│  - Usa core+atoms+DI de platform/core (TS)                  │
└────────────────────────┬────────────────────────────────────┘
                         │ Wire (WS/TCP) — mismo contrato C#
                         │ contrato proyectado por v-gen
┌────────────────────────▼────────────────────────────────────┐
│  Host process (.NET)                                        │  capa 1.1
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐        │
│  │ Provider A   │  │ Provider B   │  │ IdentityProv │       │
│  │ ├─Driver 1   │  │ ├─Driver 1   │  │              │       │
│  │ └─Driver 2   │  │ └─Driver 2   │  │              │       │
│  └──────────────┘  └──────────────┘  └──────────────┘        │
│  Interceptor pipeline │ Hosting │ SDKs por rol              │
└────────────────────────┬────────────────────────────────────┘
                         │ Wire remoto (opcional)
                         ▼
                    Otros Hosts

┌─────────────────────────────────────────────────────────────┐
│  v-gen (build-time)                                         │  capa 1.2
│  Atributos C# + templates .v-gen → C#/TS/Rust/cualquier txt │
│  Alimenta: contratos Wire, DI registros, SDKs, plantillas   │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│  LSP + plugin VSCode (dev-time)                             │  capa 1.3
│  Sabe de: atributos Vortech, plantillas v-gen               │
└─────────────────────────────────────────────────────────────┘
```

---

## 5. Principios no-negociables (heredados)

1. **Provider/Driver es la única forma de modelar un nodo.** No hay servicios "sueltos".
2. **Los atributos son el DSL.** Configuración = atributos + v-gen, no XML/YAML ad-hoc.
3. **Un solo Wire.** Múltiples lenguajes, un único contrato.
4. **Dogfooding.** La UI, el LSP y el plugin VSCode son Hosts/Clients del mismo sistema que construyen.
5. **Identity es un Provider más.** No es un caso especial.
6. **Host único por proceso.** No hay "sub-hosts" anidados — se expresa con Providers upstream/downstream.
7. **Tabla de acciones, no ScopeTree.** Las capacidades se expresan como acciones enumerables.

---

## 6. Decisiones pendientes que bloquean oficialización

Heredadas de `DECISIONES-PENDIENTES.md` + nuevas surgidas del cruce cross-repo:

| # | Tema | Opciones | Estado |
|---|------|----------|--------|
| 1 | Topología Provider (in-proc vs out-of-proc) | A/B/**C(default A)** | recomendada C (VISION-v3) |
| 2 | Scheduler | simple vs avanzado | abierto |
| 3 | Capability estricto vs laxo | — | abierto |
| 4 | Nombre de "tabla de acciones" | ActionTable, CapabilityMap, … | abierto |
| **X1** | **`vortech/platform` vs `ui` canónico** | híbrido / uno gana / merge | **bloqueado por decisión autor** |
| **X2** | **`vortech-2026` destino** | abandonar / nuevo main / branch experimental | **abierto** |
| **X3** | **v-gen targets concretos** | C#-only hoy, TS cuándo, Rust cuándo | abierto (autor confirma: universal largo plazo) |
| **X4** | **TTM language** dentro o fuera del producto | producto / lab / retirar | abierto |
| **X5** | **`@vortech/wire` + sokectio** fusión | fusionar ya / después | abierto |
| **X6** | **Extensiones UI** comparten modelo con Drivers | sí / no | recomendada SÍ (dogfooding) |

---

## 7. Matriz legado → destino

| Repo / Área | Rol objetivo | Acción sugerida (discutible) |
|-------------|-------------|------------------------------|
| `v-rust/vortech-dotnet/` (Wire, Host, SDK, LanguageServer) | **Canónico** capa 1.1 + 1.3 | Preservar; alinear namespaces |
| `v-rust/crates/` (v-wire, v-core, v-alloy, v-ttm-lsp) | Runtime Rust + TTM | Renombrar `v-core` → `v-kernel`; TTM aparte |
| `vortech/platform/*` | Base capa 1.4 (candidato) | Preservar; decisión X1 |
| `vortech/packages/@vortech/*` (wire, core, host, sdk, lsp) | Proyecciones TS de capa 1.1 | Regenerar con v-gen desde contratos C# |
| `vortech/sokectio/` | Transporte WS | Fusionar con `@vortech/wire` (X5) |
| `vortech/vortech-2026/` | Tentativa paralela | Decisión X2 |
| `vortech/devtools/vscode` | Plugin VSCode | Fusionar con plugin del LSP canónico |
| `ui/` | Monorepo integrador (candidato capa 1.4) | Preservar; decisión X1 |
| `ui/devtools/` (analyzer babel+ts-morph) | Tooling dev TS | Conservar; integrar al LSP unificado como worker auxiliar |
| `ui/crates/`, `ui/rust-ts-runtime/`, `ui/dotnet/` | Interop experimental | Evaluar duplicidad con `v-rust/crates/` |
| `v-gen/` | **Canónico** capa 1.2 | Preservar; ampliar targets (TS/Rust) según X3 |
| `v-cam/` | Producto accesorio (cámara) | Evaluar relación con plataforma — puede ser primer Provider dogfood |
| `kalProject.MsAccess/` | Legacy fuera de la plataforma | Fuera de alcance (ya inventariado) |

---

## 8. Qué sigue

1. **Autor revisa este draft** y marca cada `[?]` / decisión X con su preferencia o duda concreta.
2. Una vez validado, cada sección se convierte en insumo de los artefactos formales de Fase 2:
   - §3 → `v-mono/analysis/comparisons/`
   - §4 + §5 → `v-mono/analysis/canonical-proposals/`
   - §6 + §7 → `v-mono/analysis/migration-plan/`
3. El glosario (§2) se promueve a `v-mono/analysis/glossary.md` como **fuente única** antes de redactar cualquier propuesta canónica.
