---
titulo: "Cierre arquitectónico de la plataforma Vortech"
tipo: decision-closure
alcance: cross-repo
fecha: 2026-04-24
estado: draft-para-firma
supersede: ninguno
firmado_por: pendiente
complementa:
  - inventory/_analysis-preview/PLATAFORMA-VISION-GLOBAL.v2.md
  - inventory/_analysis-preview/FINDINGS-TS-PLATFORM.md
  - inventory/_analysis-preview/PROPUESTA-UI-SHELL.md
resuelve_v2_decisiones:
  - X1 (vortech/platform vs ui canónico)
  - X2 (vortech vs vortech-2026)
  - X4 (TTM destino)
  - X7 (v-gen Rust vs C#)
difiere_a_operativo:
  - X3 (orden de targets v-gen)
  - X5 (wire + socketio fusión)
  - X6 (UIProvider drivers default)
---

# Cierre arquitectónico — Plataforma Vortech

> Este documento **cierra** 4 de las 7 decisiones abiertas de la visión v2 y declara el núcleo de la plataforma en piedra. Está diseñado para **firmarse** y **releerse cada vez que reaparezca el impulso de rehacer todo en otro stack**.

---

## 0. Por qué este documento existe

1. Tres intentos previos de unificación (TS-first en `ui/`, Rust-TTM en `v-rust`+`v-ttm`, .NET-first en `kalProject.MsAccess`) han convergido a **las mismas 12 primitivas** del v2 §1. El modelo mental está **resuelto**.
2. El bloqueo no es conceptual — es de **sustrato**: ningún documento anterior eligió "dónde vive el núcleo".
3. Sin cierre, cada iteración futura arranca con la pregunta "¿y si reescribo todo en X?", quemando 6-18 meses de momentum.
4. Este cierre **no es elección** — es **compromiso**. Incluye una cláusula de reapertura con criterios estrictos (§6) precisamente para que no se reabra por impulso.

---

## 1. El cierre

### 1.1 Sustrato del núcleo: **.NET (C#)**

Queda declarado que el **núcleo de la plataforma** se implementa en **.NET moderno** (net9+):

- **Host** (v2 §1.6) — ASP.NET Core extendido. No se reimplementa en otro stack.
- **Identity** (v2 §1.7) — Host .NET autónomo (Duende / OpenIddict / IdentityServer evaluables como base).
- **Provider / Driver** (v2 §1.1-1.2) — Contratos nacen como interfaces C# con atributos Vortech. Es **la fuente de verdad**.
- **Wire** (v2 §1.4) — Contrato canónico en C#. Otros lenguajes obtienen **proyección generada**, no reimplementación manual.
- **Bridge** (v2 §1.5) — C# para COM / MSAccess / Mach4 / .NET Framework interop (es donde C# es literalmente el mejor del mundo). **Rust** solo donde gane objetivamente (firmware, signing perf-crítico, procesado nativo).
- **Data** (v2 §1.8) — Provider .NET + Drivers (SQL Server / PostgreSQL / MongoDB / SQLite…) + Bridges (MSAccess COM, etc.).
- **Scope / Router / Capability** (v2 §1.9-1.11) — Implementación canónica en C#.

### 1.2 Codegen universal: **v-gen en .NET**

- `v-gen` vive en **C#**.
- Lee atributos Vortech sobre código C# (fuente de verdad) y emite: C# adicional, TS, Rust, SQL, JSON/XML schemas, OpenAPI/AsyncAPI, cualquier texto.
- **No hay** "v-gen en Rust". TTM queda archivado (§2.1).
- Puede ser invocado por MSBuild, CLI, o desde un LSP.

### 1.3 LSP único: **.NET**

- Un solo LSP: `Vortech.LanguageServer` (C#).
- Reconoce atributos Vortech en C# y muestra "tipos proyectados" (el truco "engañar al compiler" del v2 §9) — el dev ve el contrato TS/Rust/SQL como si existiera, aunque se genere en build.
- Los LSPs duplicados (`@vortech/lsp`, `vortech-language-server` TS, `v-ttm-lsp` Rust) quedan archivados como research.

### 1.4 UI: **TS sobre contrato C#**

La UI **no es un stack paralelo** — es **el cliente oficial**:

- **Shell**: `v-layout` (port VSCode ya existente en TS, ver [FINDINGS §2.6](FINDINGS-TS-PLATFORM.md#26-shell-vscode--v-layoutsrc)) — refactorizado para usar `v-core/extensions` como sistema de contribución único.
- **Layout primitives**: `@vortech/layout` (Sash/SplitView/GridView limpiamente extraídas).
- **Reactivo + DI + Extension model**: `v-core` (atoms + DI + `defineExtension`). **Es núcleo TS real y se queda**.
- **Drivers UI** (responde X6 operativamente, ver §5):
  - *Default hoy*: **Angular + `@vortech/ui`** (PrimeNG fork con ~100 componentes maduros) sobre `ui/packages/platform/platform-angular`.
  - *Premium futuro*: **`v-components`** (framework Angular-like propio sobre atoms) — cuando la DX de atributos Vortech + v-gen esté madura.
  - Coexisten vía contrato `IViewFactory` ([PROPUESTA §3](PROPUESTA-UI-SHELL.md)).
- **Theming**: `theming/` produce tokens CSS consumidos por **ambos** drivers.

### 1.5 Rust: **escalpelo quirúrgico**

Rust **no es ciudadano del núcleo**. Rust vive como:

- **Agents** (v2 §1.3) — micro-servicios polyglot invocados por Wire (firmware, hot-path signing, TTS/STT, vision pipelines, scraping perf-crítico).
- **Bridges específicos** — donde la ganancia objetiva sobre C# justifique el coste (ej. firmware IoT, perf-crítico cripto).
- **Librerías nativas** consumibles vía FFI desde C#.

Rust **no** es sustrato del LSP, **no** es host de v-gen, **no** tiene un "core" plataforma propio. El crate `v-rust/crates/v-core` se **renombra** a `v-kernel` (para liberar el nombre `core` al núcleo TS UI) y su alcance se limita a utilidades Rust.

### 1.6 Agent polyglot: **libre**

Los **Agents** (v2 §1.3) son explícitamente **cualquier lenguaje**: Python (IA / ML / scripting), Rust (perf), Node/TS (scripts web), shell, C++ (legacy), PHP, Go. Invocados siempre vía Wire.

---

## 2. Lo que queda archivado (no borrado — read-only)

### 2.1 TTM como lenguaje (resuelve X4)

- TTM **queda archivado** como research arqueológico en `repos/v-rust/` (read-only).
- La idea que lo motivó — "un lenguaje para generar backend + frontend desde una sola definición" — **está resuelta** por la combinación **atributos C# + v-gen + LSP que proyecta tipos**. No se necesita un lenguaje nuevo.
- El trabajo de tree-sitter/AST/symbols de `v-ttm-lsp` se cita como referencia si algún día se decide reabrir (§6). No se continúa.

### 2.2 Intento "TS-everything"

- El período en que `ui/packages/core` + `ui/packages/common` reimplementaban atoms/DI/common paralelamente al C# queda declarado **deuda de transición**.
- Esos packages **no se borran**: se **reconvierten** en la Ronda 1 de consolidación ([PROPUESTA §7](PROPUESTA-UI-SHELL.md#7-camino-6--consolidación-de-duplicaciones-consecuencia-de-findings-§3)) a clientes del contrato C# (re-exports desde `v-core` + extras UI-específicos en `@vortech/common-ui`, `@vortech/wire` TS, `@vortech/host-pipeline` TS).

### 2.3 `vortech-wire-2026` (resuelve X2)

- `vortech-wire-2026` **se archiva** salvo que exista una razón documentada para preferirlo sobre `vortech-wire`.
- Si el diff arquitectónico es no-trivial, migrarlo a `vortech-wire` como rama experimental antes de archivar.
- Decisión por defecto: **canónico = `vortech-wire` (el original)**.

### 2.4 "Una plataforma puramente TS" y "una plataforma puramente Rust"

- Ambas narrativas quedan **explícitamente cerradas**.
- Futuras reorganizaciones internas (ej. refactors en `ui/`, en `v-rust/`) **no pueden** usar como justificación "vamos hacia un modelo puramente X".

### 2.5 Feature (como primitiva)

- Ya retirado por v2. Confirmado: no reaparece.

---

## 3. Lo que queda **cerrado** en la v2

| Decisión v2 | Resolución en este cierre |
|---|---|
| **X1** — vortech/platform vs ui canónico | **Roles complementarios, no competencia.** `vortech/platform/*` es framework research TS (núcleo UI: atoms + DI + extensions + shell + v-components). `ui/` es el monorepo integrador donde viven verticales. Los duplicados de `ui/packages/core`+`common` se reconvierten (§2.2). |
| **X2** — vortech vs vortech-2026 | **Canónico: `vortech` original.** `vortech-2026` se archiva salvo razón documentada (§2.3). |
| **X4** — TTM destino | **TTM archivado** (§2.1). Lenguaje único sustituido por atributos + v-gen + LSP. |
| **X7** — v-gen Rust vs C# | **v-gen en C#** (§1.2). LSP en C# (§1.3). Rust no hostea generador ni LSP. |

---

## 4. Lo que queda **diferido** (operativo, no arquitectónico)

Estas son decisiones que **no afectan el sustrato** y se resuelven en el curso normal de implementación. Documentadas para completitud:

### 4.1 X3 — orden de targets v-gen

Prioridad sugerida (no vinculante):
1. C# (self-targets adicionales: DTOs, registros DI, proxies Provider→Wire).
2. TS (SDK cliente + tipos para UI).
3. SQL (DDL desde entidades Data).
4. JSON/OpenAPI/AsyncAPI (documentación + schemas).
5. Rust (proyecciones FFI para Agents/Bridges).

### 4.2 X5 — Wire TS + socketio

- Fusionar `sokectio/` con `@vortech/wire` (TS) como **transporte** del Wire TS.
- La fusión es transport-level, no cambia contrato.

### 4.3 X6 — UIDriver default

- **Hoy: Angular + `@vortech/ui`**. Producción-ready, 100 componentes.
- **Futuro: `v-components`** cuando la DX + theming + extension decorators + v-gen TS estén maduros.
- Contrato `IViewFactory` ([PROPUESTA §3](PROPUESTA-UI-SHELL.md)) permite migración incremental view-a-view.

---

## 5. Consecuencias inmediatas

1. **Los docs `FINDINGS-TS-PLATFORM.md` y `PROPUESTA-UI-SHELL.md` se releen bajo esta lente.** Algunas secciones dejan de ser "a decidir" y pasan a ser "consecuencia del cierre":
   - `FINDINGS §6` (verticales en `ui/packages/`) → confirma X1 complementario.
   - `PROPUESTA §7` (consolidación) → deja de ser "ronda opcional" y pasa a ser deuda planificada.
   - `QUESTIONS-TS-SHELL Q1/Q2` → se responden: `v-components` es apuesta futura como driver premium; `v-layout` es shell canónico para apps "tipo IDE" y para cualquier app que lo quiera (coexiste con layouts ligeros).
2. **El análisis de `kalProject.MsAccess`** (recién clonado) pasa a ser **crítico** — es el repo .NET nuclear bajo esta decisión. Merece inventario prioritario antes que más exploración TS.
3. **Fase 2 formal** puede arrancar con base estable: `post-inventario` ya no tiene que re-resolver X1/X2/X4/X7.

---

## 6. Cláusula de reapertura (criterios estrictos)

Este cierre **no se reabre por impulso**. Se puede reabrir *parcialmente* **solo** si se cumple **al menos una** de las condiciones siguientes, documentada con evidencia:

### Reapertura de §1.1 (sustrato .NET)
- **Obsolescencia material** del ecosistema .NET (ej. Microsoft descontinúa ASP.NET Core — evento de probabilidad ~0 en la próxima década).
- **Bloqueo comercial real** (ej. licencia, regulatorio específico) que impida usar .NET en un cliente concreto. En ese caso la reapertura es *por cliente*, no global.

### Reapertura de §2.1 (TTM archivado)
- Demostrar con **PoC medible** (code-gen + LSP + ejemplo end-to-end) que TTM resuelve *algo que atributos+v-gen+LSP C# no puedan*, con un coste de adopción aceptable.
- Hasta entonces: prohibido iniciar trabajo nuevo en TTM como lenguaje.

### Reapertura de §1.5 (Rust limitado a Agent/Bridge)
- Perfilado real de un subsistema del núcleo (Host/Wire/Data) mostrando ganancia de ≥ 5× en métrica crítica frente a C# moderno compilado AOT.
- Hasta entonces: Rust solo donde ya está justificado.

### Reapertura de §1.4 (UI en TS)
- Aparición de un stack UI nativo .NET (Blazor, MAUI, .NET for iOS/Android/macOS/Windows) con **paridad real** en un IDE-shell tipo VSCode, **y** madurez superior a la del ecosistema TS actual para este caso de uso. Hoy esa condición no se cumple.

### Prohibición explícita
Se prohíben expresamente las siguientes narrativas como motivo de reapertura:
- "Y si lo hago todo en X (lenguaje de moda del momento)".
- "Ganaría tiempo reescribiéndolo".
- "El otro approach es más elegante".
- "Vi un framework nuevo".

Si alguien (incluido el firmante) siente ese impulso, **la acción correcta es releer este documento**, no reabrir.

---

## 7. Lo que no cambia

- Las 12 primitivas del v2 §1 siguen siendo la fuente de verdad léxica.
- La arquitectura de 4 capas del v2 §4 se mantiene.
- Los 7 verticales del portfolio (v2 §8) guían la priorización.
- Los artefactos actuales de `inventory/` son válidos y no se reescriben.

---

## 8. Firma

**Firmado por:** _______________________________________

**Fecha:** _______________________________________

**Condición:** este documento pasa a ser normativo en el momento de la firma y solo puede modificarse vía enmienda formal (nuevo documento que cite explícitamente este por path + fecha).

---

## 9. Qué sigue (operativo)

1. **Inventario prioritario de `kalProject.MsAccess`** — es el núcleo .NET bajo este cierre.
2. **Inventario de `vortech/` (raíz .NET)** — confirmar estado de Host/Wire/Identity/Data reales.
3. **Apertura de Fase 2 formal** (`post-inventario`) con base estable.
4. **Relectura de FINDINGS y PROPUESTA bajo lente de cierre** — producir v2 de ambos si es necesario.
5. **Plan operativo** para X3, X5, X6 (diferidas) en el momento apropiado.
