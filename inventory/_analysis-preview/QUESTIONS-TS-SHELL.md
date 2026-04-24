---
titulo: "Preguntas abiertas — TS Shell / Plataforma"
tipo: analisis-preview
alcance: multi-repo
source_repos:
  - vortech
  - ui
fecha: 2025-11-06
complementa:
  - inventory/_analysis-preview/FINDINGS-TS-PLATFORM.md
  - inventory/_analysis-preview/PROPUESTA-UI-SHELL.md
estado: draft
---

# Preguntas abiertas — lado TS

> Cada pregunta tiene: **contexto** (qué vi), **opciones** (las razonables), **impacto** (qué cambia según la respuesta), **recomendación** (mi apuesta, sujeta a corrección).

---

## Q1 — ¿`v-components` es la apuesta futura o experimento?

**Contexto** — Es un framework Angular-like **real y avanzado**: `@Component`, `@Input`, `@Output`, `@Directive`, parser propio con control flow `@if`/`@for`/`@switch`, scoped styles, scheduler, ComponentRegistry. Conviven con `@vortech/ui` (Angular + PrimeNG fork, ~100 componentes maduros).

**Opciones**:
- (a) `v-components` es la apuesta → Angular queda como driver de transición.
- (b) Angular es el stack primario → `v-components` se congela/archiva.
- (c) **Coexisten** como drivers intercambiables (propuesta §3).

**Impacto** — define todo el resto del roadmap. Si (a), habrá que **replicar** los ~100 componentes de `@vortech/ui` en `v-components`. Si (b), hay que cerrar `v-components`. Si (c), hay que construir el contrato `IViewFactory`.

**Recomendación**: **(c)**. Angular driver es default hoy (producción); `v-components` es "premium, cuando la DX de atributos Vortech + v-gen esté madura".

---

## Q2 — ¿El Shell `v-layout` es canónico para toda la plataforma, o sólo "tipo IDE"?

**Contexto** — `v-layout` es puerto **completo** del shell VSCode (Workbench + 7 Parts). Pesado, ~100 archivos TS solo en `browser/common/`. Es overkill para una app tributaria (sii-dte-signer) o una app CNC dashboard.

**Opciones**:
- (a) Todas las apps Vortech usan Workbench → layout unificado.
- (b) Sólo apps "tipo IDE" (devtools, editor, studio, vscode, composer) usan Workbench → otras apps usan layouts más ligeros.
- (c) Workbench **es un componente más** — pueden coexistir sub-layouts (router, página plana, workbench) dentro de una misma app.

**Impacto** — si (a), el peso fijo del shell es ~200 KB gz; si (b)/(c) hay que definir el "mini-layout" ligero (¿basado en `@vortech/layout` primitives?).

**Recomendación**: **(c)**. El shell Workbench se expone como **driver de layout** (como UIProvider). Apps ligeras usan un driver "plain" que sólo compone con `@vortech/layout`.

---

## Q3 — ¿Las registries del Workbench se migran a `v-core/extensions`, o coexisten?

**Contexto** — Hoy `Workbench` tiene `IWorkbenchRegistries` (mapas mutables internos). `v-core/extensions` ofrece `defineExtension` tipado, deps, dispose reverso. La brecha D6 de FINDINGS.

**Opciones**:
- (a) Migración completa: registries desaparecen, Workbench sólo expone `Extensions<WorkbenchCaps>`.
- (b) Capa adapter: registries siguen como **detalle interno**; API pública es Extensions. ← Propuesta §2.
- (c) Coexisten dos APIs públicas por diseño.

**Impacto** — (a) es la más limpia pero rompe todo consumidor actual; (b) es migración gradual sin romper; (c) añade confusión.

**Recomendación**: **(b)**.

---

## Q4 — ¿`ui/packages/platform` con `platform-angular` + `platform-node` es la base del UIDriver de la visión?

**Contexto** — FINDINGS §2.8. Solo vi la estructura; no leí código. Pero la **organización** (split angular/node + `feature/`, `reactive/`, `scope/`, `app/`, `builder-toolkit/`, `context/`) es exactamente la forma que debería tener un "UIProvider multi-driver".

**Opciones**:
- (a) Sí, es el UIProvider — formalizar como tal, estabilizar sus APIs.
- (b) Es un intento previo → reescribir como parte de la consolidación §7 de PROPUESTA.
- (c) Es algo distinto (p.ej. solo para SSR/isomorfic) → no confundir con UIDriver.

**Impacto** — resuelve (o aplaza) §6 X6 de la visión.

**Recomendación**: hace falta **leer el código** antes. Propongo un ticket de triage dedicado.

---

## Q5 — ¿`ui/packages/core` y `ui/packages/common` se deprecan o se fusionan?

**Contexto** — Duplican a `vortech/platform/core` y `v-common` con adiciones propias (`communication/`, `pipeline/`, `translation/`, `tree-node/` en core; `coercion/`, `guards/`, `validation/` en common). Atoms duplicados (D1, D3).

**Opciones**:
- (a) Fusión plena → un único `@vortech/core` + `@vortech/common`, los extras migran a packages dedicados (`@vortech/wire`, `@vortech/host-pipeline`, `@vortech/i18n`).
- (b) Re-export + extras in-place → `ui/packages/core` queda como capa *integration* que agrega específicos UI encima del `@vortech/core` canónico.
- (c) Coexisten por diferencias de target → documentar explícitamente cuándo usar cuál.

**Impacto** — (a) máxima claridad, mayor esfuerzo; (b) bajo esfuerzo, deuda residual; (c) mantiene confusión.

**Recomendación**: **(a) a medio plazo**, **(b) transicional**.

---

## Q6 — ¿Qué hacer con `v-ui/` (parece subset de `v-layout`)?

**Contexto** — `platform/v-ui/src/` tiene `browser/`, `common/`, `global.d.ts`, `nls.ts`, `public-api.ts` — **mismas carpetas** que `v-layout/src/` pero sin `workbench/` ni `contributes/`. **Hipótesis**: es el "base layer" (VS base port) extraído.

**Opciones**:
- (a) Deprecar — la copia interna de `v-layout` es la fuente.
- (b) Formalizar como `@vortech/v-ui` base, y `v-layout` depende de él.
- (c) Fusionar con `@vortech/layout` (el package pequeño de Sash/SplitView/Grid).

**Impacto** — afecta el empaquetado y el tamaño de dependencias runtime.

**Recomendación**: leer `v-ui/src/public-api.ts` antes de decidir. Instinto: **(b)**.

---

## Q7 — ¿Qué contiene `ui/packages/core/communication/` y `ui/packages/core/pipeline/`?

**Contexto** — Los nombres sugieren **Wire** y **Host pipeline** del v2 §1.4 / §1.6. No leí código.

**Impacto** — afecta directamente **X5** (fusión con socketio) y la ubicación canónica del Wire TS.

**Recomendación**: ticket de triage dedicado. Si son sólidos, son candidatos a `@vortech/wire` y `@vortech/host-pipeline` en la Ronda 1 de consolidación.

---

## Q8 — ¿`sdk/` y `v-api-factory/` son productos finales o experimentos?

**Contexto** — `sdk/` tiene `demo/`. `v-api-factory/` tiene `ejemplo-storage-api.md`. Sugieren intención de SDK consumible externamente + factoría declarativa de APIs.

**Opciones**:
- (a) Son PoC — archivar.
- (b) Son futuro — priorizar.
- (c) Son "ejemplos vivos" de la DX objetivo con decoradores.

**Impacto** — si (c), son claves para validar el enfoque §6 de PROPUESTA.

**Recomendación**: leer sus READMEs/demo/ dedicadamente.

---

## Q9 — ¿Qué relación hay entre `vortech/platform/theming` y `ui/projects/ui/theming` y `ui/packages/theming`?

**Contexto** — Hay **tres** candidatos theming. Alto riesgo de divergencia.

**Recomendación**: triage — probablemente dos son legacy o específicos de PrimeNG-fork.

---

## Q10 — El "C# contrato compartido" de la UI (v2 §9): ¿cómo se refleja en el lado TS hoy?

**Contexto** — La visión dice: UI habla Wire directo contra C# con contrato compartido. No encuentro código TS que lea un `.proto`/`.ts` generado desde C#.

**Opciones**:
- (a) Aún no existe — el Wire contract compartido es **work TBD**, futuro hito.
- (b) Existe y no lo he localizado — posiblemente en `ui/packages/core/communication/`.
- (c) Se hace hoy ad-hoc con TypeScript definiciones a mano.

**Impacto** — bloquea la historia end-to-end de cualquier vertical.

**Recomendación**: leer `ui/packages/core/communication/` y algún consumidor (p.ej. `ai-assistant` llamando a `ai-server`).

---

## Resumen — orden propuesto de respuestas

| # | Pregunta | Urgencia | Bloquea |
|---|---|---|---|
| Q1 | `v-components` ¿futuro? | **Alta** | H2 de PROPUESTA, X6 |
| Q2 | `v-layout` ¿canónico? | **Alta** | H1 de PROPUESTA |
| Q3 | Registries → Extensions | **Alta** | H1 |
| Q4 | UIProvider en `ui/packages/platform` | Media | X6 |
| Q5 | Duplicaciones `ui/packages/core+common` | Media | Ronda 1 consolidación |
| Q6 | `v-ui` rol | Baja-media | Packaging |
| Q7 | `communication/` + `pipeline/` | Media | X5, Wire canónico |
| Q8 | `sdk/` + `v-api-factory/` | Baja | Validación DX objetivo |
| Q9 | Theming triple | Media | H3 |
| Q10 | Wire contract C#↔TS hoy | **Alta** | Story end-to-end |
