---
titulo: "Cierre — Debate punto por punto"
tipo: decision-closure-debate
alcance: cross-repo
fecha: 2026-04-24
estado: pendiente-respuestas
complementa:
  - inventory/_analysis-preview/DECISION-CLOSURE.md
---

# Cierre — Debate punto por punto

> Un ítem por decisión del cierre. En cada uno:
> - **Yo (agente):** una línea con mi argumento.
> - **Tú (autor):** una línea para tu respuesta (acuerdo, rechazo, matiz, condición).
>
> Objetivo: que firmes o rechaces cada punto por separado. Nada implícito.

---

## 1. Sustrato del núcleo = .NET (C#)

- **Yo:** es tu lenguaje más rápido y nativo desde .NET 2.0, ASP.NET ya *es* Host (master/slave + pipeline + DI industrial), y C# tiene el mejor interop COM/P-Invoke del mundo — exactamente lo que Bridge necesita.
- **Tú:**

---

## 2. Identity sobre ASP.NET Host (no reimplementar en otro stack)

- **Yo:** Identity es un Host con reglas extra; reescribirlo en TS/Rust es heroísmo sin retorno medible, y ya hay bases maduras (Duende / OpenIddict) sobre las que construir.
- **Tú:**

---

## 3. Provider / Driver nacen en C# como fuente de verdad

- **Yo:** la plataforma necesita **una** fuente canónica del contrato; duplicar el contrato en TS+Rust+C# fue lo que te empujó a TTM — resolverlo con C# + generación colapsa la duplicación sin inventar lenguaje.
- **Tú:**

---

## 4. Wire canónico en C#, proyecciones generadas a TS/Rust/C

- **Yo:** todos los Wires de hoy (`vortech-wire` C#, `v-wire` Rust, `@vortech/wire` TS, `sokectio`, `vortech-wire` C) hablan el mismo protocolo — tener N fuentes manuales garantiza drift; una fuente + proyección lo elimina.
- **Tú:**

---

## 5. Bridge: C# para COM/.NET/MSAccess/Mach4; Rust solo donde gane objetivamente

- **Yo:** tu ventaja competitiva real es Bridge, y en COM/.NET-interop **C# no tiene rival**; Rust se mete solo cuando perfilado real muestra ≥ 5× ganancia (firmware, cripto hot-path).
- **Tú:**

---

## 6. Data (EF Core / Dapper / drivers maduros) como plantilla ejemplar

- **Yo:** `Data` es el patrón-plantilla que el resto de dominios copian (v2 §1.8); en .NET tienes el ecosistema más maduro del mercado para llevarlo — no hay que construirlo, solo vestirlo con Provider/Driver/Bridge.
- **Tú:**

---

## 7. Scope / Router / Capability canónicos en C#

- **Yo:** son primitivas del grafo de Providers — pertenecen al mismo stack donde viven los Providers; las proyecciones TS/Rust son consumidoras, no definidoras.
- **Tú:**

---

## 8. v-gen vive en .NET (archivar v-gen en Rust)

- **Yo:** v-gen necesita leer metadata y atributos C# — hacerlo desde C# es directo (Roslyn); hacerlo desde Rust implica reimplementar un parser de C# o depender de LSP externo, coste sin retorno.
- **Tú:**

---

## 9. Un único LSP: `Vortech.LanguageServer` (C#), con truco "engañar al compiler"

- **Yo:** mantener 3 LSPs (C#, TS, Rust) triplica trabajo sin triplicar valor; el LSP C# puede ofrecer completions "como si" el tipo TS/Rust existiera, aunque se genere en build — exactamente la experiencia que buscabas con TTM, sin inventar lenguaje.
- **Tú:**

---

## 10. TTM archivado como research arqueológico (resuelve X4)

- **Yo:** TTM es la idea correcta (isomorfismo definición→proyección) implementada con la palanca equivocada (lenguaje nuevo); atributos+v-gen+LSP te dan el 90% del valor con 5% del coste.
- **Tú:**

---

## 11. UI shell = TS, no stack paralelo sino cliente oficial del contrato C#

- **Yo:** Blazor/MAUI no compiten aún con un shell IDE-like; `v-layout` ya es port VSCode completo y funcional — usarlo consumiendo contrato C# aprovecha ambos mundos sin reescribir nada.
- **Tú:**

---

## 12. `v-core` (atoms + DI + extensions) se queda como núcleo TS real

- **Yo:** es producción-ready y ya consumido por `v-components` y `v-layout`; reemplazarlo por Angular signals / lit / SolidJS sería pérdida neta de capacidad (transactions, atom-family, glitch-free scheduler, DI con scopes).
- **Tú:**

---

## 13. Driver UI default = Angular + `@vortech/ui`; `v-components` como premium futuro

- **Yo:** `@vortech/ui` ya tiene ~100 componentes maduros (PrimeNG fork) y producción real en `ui/packages/*`; `v-components` es apuesta legítima pero requiere DX madura de atributos+v-gen — meterlo como default hoy frena verticales.
- **Tú:**

---

## 14. `v-layout` refactor para usar `v-core/extensions` como único sistema de contribución

- **Yo:** tener dos sistemas de plugin (registries internos del Workbench vs slots tipados) es deuda pura; el refactor es localizado (capa adapter) y unifica la historia de contribución.
- **Tú:**

---

## 15. Theming como tokens CSS compartidos por ambos drivers

- **Yo:** si ambos drivers consumen las mismas variables, la consistencia visual es automática; si cada driver tiene su propio theming, divergencia garantizada en 6 meses.
- **Tú:**

---

## 16. Rust limitado a Agents + Bridges específicos + librerías FFI

- **Yo:** Rust brilla donde perfilado real lo justifica; ponerlo en el núcleo te quema tiempo en refactors ceremoniales sin ganar capacidad que C# moderno AOT no dé.
- **Tú:**

---

## 17. `v-rust/crates/v-core` se renombra a `v-kernel`

- **Yo:** el nombre `core` está sobre-cargado (hay tres "core" en el monorepo); liberar ese nombre para el TS UI reduce ambigüedad cognitiva.
- **Tú:**

---

## 18. Agents polyglot, libres (Python/Rust/Node/shell/C++/PHP/Go)

- **Yo:** Agents son la escotilla polyglot por diseño (v2 §1.3); restringir su lenguaje va contra el propósito — cada tarea elige el runtime que le convenga, invocada vía Wire.
- **Tú:**

---

## 19. `vortech-wire-2026` se archiva salvo razón documentada (resuelve X2)

- **Yo:** sin diff arquitectónico explícito, mantener dos ramas de Wire garantiza drift y confusión; archivar es el default seguro.
- **Tú:**

---

## 20. `ui/packages/core` + `ui/packages/common` se reconvierten a clientes del contrato (no se borran)

- **Yo:** tienen trabajo útil (communication → Wire TS, pipeline → host pipeline TS, translation → i18n); se preservan como packages dedicados y se re-exportan desde `v-core`+`v-common` — cero pérdida, menos duplicación.
- **Tú:**

---

## 21. X1 (vortech/platform vs ui canónico) se cierra como roles complementarios

- **Yo:** `vortech/platform/*` es framework research (núcleo TS UI: atoms+DI+extensions+shell); `ui/` es integrador (verticales + Angular driver + verticales ai-*, cnc, sii, proxmox); no compiten, se complementan.
- **Tú:**

---

## 22. Narrativas prohibidas como motivo de reapertura

- **Yo:** "lo haría todo en X" / "ganaría tiempo reescribiéndolo" / "vi un framework nuevo" son exactamente las narrativas que te hicieron dar 3 vueltas completas — declararlas inválidas es lo único que corta el ciclo.
- **Tú:**

---

## 23. Reapertura de §1.1 (sustrato .NET) sólo por obsolescencia o bloqueo comercial

- **Yo:** cambiar el sustrato por preferencia es lo que te costó las 3 vueltas; atar la reapertura a eventos externos objetivos es la valla que protege el momentum.
- **Tú:**

---

## 24. Reapertura de §2.1 (TTM) sólo con PoC medible de valor diferencial

- **Yo:** si aparece un caso que atributos+v-gen+LSP genuinamente no cubren, se reabre; si no, no — la valla evita la reapertura romántica.
- **Tú:**

---

## 25. Reapertura de §1.5 (Rust al núcleo) sólo con ≥5× medido en métrica crítica

- **Yo:** promesas de perf no cuentan; perfilado real vs C# AOT sí — el umbral alto refleja el coste real de cambiar sustrato.
- **Tú:**

---

## 26. Reapertura de §1.4 (UI .NET) sólo con paridad real frente a TS para IDE-shell

- **Yo:** hoy Blazor/MAUI no tienen un equivalente a `v-layout` (shell VSCode); el día que lo tengan con madurez ≥ al ecosistema TS, se reabre — no antes.
- **Tú:**

---

## 27. El cierre pasa a ser normativo al firmarse y sólo se modifica por enmienda formal

- **Yo:** sin firma, es otra propuesta más; con firma + regla de enmienda, tienes un ancla contra tu propio impulso cíclico — el valor real está en el compromiso, no en el contenido.
- **Tú:**

---

## 28. Siguiente paso: inventario prioritario de `kalProject.MsAccess` (núcleo .NET bajo el cierre)

- **Yo:** si .NET es el núcleo y `kalProject.MsAccess` es tu .NET más reciente, su inventario detallado es lo primero que estabiliza la Fase 2; seguir leyendo TS hoy es procrastinación productiva.
- **Tú:**

---

## 29. Fase 2 formal (`post-inventario`) arranca con X1/X2/X4/X7 ya cerradas

- **Yo:** sin cerrar esas 4, Fase 2 re-debate lo mismo 3 veces y produce análisis ambiguo; con cierre, produce plan ejecutable.
- **Tú:**

---

## 30. Meta: este documento existe para releerse cuando sientas el impulso de reescribir todo

- **Yo:** el enemigo de tu plataforma no es C# vs Rust ni Angular vs v-components — es la 4ª vuelta completa; si esto te detiene *una* vez, ya pagó su coste.
- **Tú:**
