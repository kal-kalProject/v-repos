Leído. Las respuestas cierran mucho y la sección nueva de **atributos/decoradores + LSP** cambia la arquitectura de tooling de forma material. Te doy inferencia afinada.

---

## F. Lo que las respuestas a D resuelven

### F.1 Router = **pattern + service agnóstico**
Confirmado: no es un Provider. Es **servicio transversal** que resuelve rutas sobre Scope. → Vive al nivel del Host (como ASP.NET routing), no del dominio. Similar a `IEndpointRouter` de ASP.NET pero operando sobre el árbol de Providers.

### F.2 "Tabla de acciones" **se elimina**
Decisión limpia. Scope asume su función. → **Correcto retirar** de VISION-v3 y del draft. Aviso: esto invalida partes de `VISION-v3.md`. Habrá que emitir un `VISION-v3.1` o similar cuando toque.

### F.3 Capability = **contrato Driver↔Provider**
Nueva precisión importante: **Capability no es "acción disponible"**, es lo que el **Provider declara como requerido/opcional** y cada **Driver declara qué cumple o NO cumple**. → Esto es el equivalente de "feature flags" **al nivel de contrato**. Un Driver puede decir "implemento el Provider X pero SIN capacidad `streaming`", y el runtime lo sabe.

Inferencia: esto habilita **degradación graceful** y **matrices de compatibilidad** generables automáticamente (x-ref con v-gen + LSP).

### F.4 Agent vs Driver = **axis de responsabilidad, no de lifecycle**
Reformulo mi hipótesis anterior (era incorrecta):
- **Driver**: existe **solo** para implementar un Provider. Sin Provider, no hay Driver.
- **Agent**: unidad de **ejecución autónoma**. Cualquier lenguaje, cualquier anfitrión. Ejemplos: script Python, watchdog, tarea programada, tool MCP.

→ Agent es la **respuesta de la plataforma a "todo lo que no encaja en Provider/Driver"**: tareas, workers, scripts externos, automatizaciones puntuales. Es la **escotilla de escape polyglot**. Muy potente conceptualmente.

### F.5 Extension = **par UI+backend en secciones contributables**
Clave: Extension **NO es Driver con hot-reload**. Es una **unidad de contribución dual** (frontend + backend) que se engancha a "secciones contributables" del layout/shell. Modelo **VSCode literal**: `contributes.views`, `contributes.commands`, pero con backend adosado.

→ Extension es el **mecanismo de feature-by-feature shipping** del producto final. Un ERP pyme básico es Host+Identity+Data. Cada módulo adicional (facturación SII, inventario, RRHH) es una **Extension**.

### F.6 UI = Provider/Driver también
"Encaja como Provider/Driver". → `UIProvider` con drivers Angular / Vanilla / Blazor (hipotético). Eso desbloquea lo de §B.3: los 3 stacks conviven legítimamente bajo el modelo universal. La decisión es **cuándo invertir en cada Driver**, no "cuál sobrevive".

### F.7 `common` duplicado = problema real a resolver
Confirmado. Tres candidatos (`@vortech/common`, `@vortech/core`, `platform/v-common`) deben converger. → Entra a Fase 2 como ítem de `analysis/comparisons/`.

### F.8 Identity = Host autónomo **con replicación master/slave**
Siempre proceso separado. Puede tener réplicas. → Esto es **requisito de producto** (no optimización opcional). Implica: el Host wrapper ASP.NET debe soportar replicación nativa desde el inicio. Similar a **identidad distribuida tipo Keycloak/Dex/Ory**, pero construida con las primitivas de Vortech.

---

## G. Lo grande que aporta la sección nueva de **atributos/decoradores + codegen + LSP**

Esta sección **cambia cualitativamente** el valor técnico del proyecto. Antes parecía "framework .NET con codegen". Ahora veo algo más ambicioso.

### G.1 Atributos/decoradores son **la API de usuario real**
El usuario developer **no escribe** `class MyProvider : IProvider { ... 200 LOC boilerplate ... }`. Escribe:

```csharp
[Provider("cnc")]
public partial class CncProvider { ... }
```

…y **v-gen** genera el resto (registro DI, proyección Wire, cliente TS, manifest de Extension, jsonschema de config, documentación). → **Atributos son el DSL**. v-gen es **el compilador del DSL**. Eso ya lo intuía, pero ahora es explícito.

### G.2 v-gen es **motor universal** — confirmado no es C#-only
Lista que das: *C#, JSON, XML, JSON Schemas, SQL, etc.* → Confirma la decisión previa (universal). Y da la pista de que la plataforma **genera sus propios manifests** y **sus propios jsonschemas de configuración**. Autodescripción por codegen.

### G.3 LSP + plugin VSCode con **truco de "engañar al compiler"**

**Esta es la pieza más original del diseño.** Te lo parafraseo para confirmar entendimiento:

> El developer escribe código **que no compilaría** (falta clase, falta miembro, falta partial, falta implementación). El **LSP + plugin VSCode** hacen creer a Roslyn/TypeScript que **sí compila** — proveyendo symbol info sintetizada, autocompletes, hovers, go-to — **como si el código generado ya existiera**. El developer avanza. Luego, **al guardar/compilar**, v-gen **sí genera** el código faltante y el build real pasa.

Esto es **transparent source generation con IDE-side stub synthesis**. Es lo que Angular Language Service intenta (parcialmente) con plantillas HTML. Es lo que Roslyn Source Generators **no logra** porque el IDE ve el código generado con retraso y errores intermedios.

Técnicamente exige:
- **LSP proxy** que intercepta requests del cliente antes de llegar al servidor real de lenguaje (Roslyn / ts-server) y **inyecta símbolos ficticios**.
- Un **modelo de proyección** donde atributo → símbolos esperados, resuelto en memoria.
- Sincronización con **v-gen** para que cuando genere real, los símbolos ficticios desaparezcan sin romper la experiencia.

→ Es **altamente no-trivial** pero diferenciador radical. Justifica **tener LSP propio** (no solo extension VSCode sobre Roslyn estándar). Y justifica los 3+ intentos de LSP que encontraste en los repos: estabas buscando la forma de hacer esto.

### G.4 Esto reorganiza las capas del draft
La sección 1.3 ("Tooling de lenguaje") deja de ser periferia y pasa a **core product experience**. Sin el truco LSP, los atributos + v-gen son "otro Source Generator más". **Con** el truco LSP, son una **nueva experiencia de desarrollo**.

→ **Inferencia fuerte**: el valor comercial/competitivo de Vortech **depende materialmente** de que este LSP funcione. Es tan crítico como Wire o Provider/Driver.

---

## H. Refinamiento del mapa mental global

```
┌──────────────────────────────────────────────────────────────┐
│  DEVELOPER EXPERIENCE  (capa de autoría)                     │
│  ┌──────────────┐   ┌──────────────┐   ┌──────────────┐      │
│  │  Atributos   │──▶│    v-gen     │──▶│  código real │      │
│  │  Decoradores │   │  (universal) │   │  multi-lang  │      │
│  └───────▲──────┘   └──────────────┘   └──────────────┘      │
│          │                                                    │
│  ┌───────┴──────────────────────────────────┐                │
│  │  LSP + VSCode plugin                     │                │
│  │  "engaña al compiler" con stubs sintét.  │                │
│  └──────────────────────────────────────────┘                │
└──────────────────────────────────────────────────────────────┘
                         │ (código generado)
                         ▼
┌──────────────────────────────────────────────────────────────┐
│  PRIMITIVAS  (capa conceptual)                               │
│  Provider ─ Driver ─ Agent ─ Extension                       │
│      │         │        │        │                           │
│      ▼         ▼        ▼        ▼                           │
│   lógica   impl.    ejec.    UI+BE                           │
│   pública  (oculta) autónoma contrib.                        │
│                                                              │
│  Capability (contrato Provider↔Driver)                       │
│  Scope + Router (direccionamiento)                           │
└──────────────────────────────────────────────────────────────┘
                         │
                         ▼
┌──────────────────────────────────────────────────────────────┐
│  RUNTIME  (capa de proceso)                                  │
│  ┌───────────────────────────────────────────────┐           │
│  │  Host (ASP.NET wrapper, master/slave)         │           │
│  │  └─ Identity Host (autónomo, replicable)      │           │
│  │  └─ [Host de producto: CNC / ERP / SII / IA]  │           │
│  └───────────────────────────────────────────────┘           │
│                        ▲                                     │
│                        │ Wire (TransportProvider/Driver)     │
│                        │ Bridge (cross-language/platform)    │
│                        ▼                                     │
│  Clients: C#, TS, Rust, C++, Python, …                       │
└──────────────────────────────────────────────────────────────┘
                         │
                         ▼
┌──────────────────────────────────────────────────────────────┐
│  UI SHELL  (capa de presentación)                            │
│  UIProvider → Driver Angular / Vanilla / Blazor              │
│  Layout (VSCode-like, no-Angular-dep)                        │
│  Theming (tokens, no-Angular-dep)                            │
│  core (DI + atoms, node/browser)                             │
│  Extensions VSCode-like (UI + backend)                       │
└──────────────────────────────────────────────────────────────┘
```

Cuatro capas horizontales, no cinco. **Developer Experience queda en su propia capa — no es tooling auxiliar, es parte del producto.**

---

## I. Riesgos técnicos que emergen de este refinamiento

1. **LSP-que-miente** es alto riesgo: desincronización entre stubs y código real = "funciona en mi IDE, falla al compilar". Exige telemetría interna y tests E2E del plugin.
2. **v-gen universal multi-target** es alto esfuerzo: cada target (C#/TS/Rust/SQL/JSON Schema) necesita su backend de emisión. Decidir orden.
3. **Extension hot-reload** + **Identity Host replicado** + **Host master/slave** = el runtime server **debe resolver** live code loading, state sync y leader election desde temprano. Es mucho para la v1.
4. **UIProvider con N drivers** puede convertirse en parálisis: si abres Angular+Vanilla+Blazor simultáneo, ningún driver madura. Recomendación: **un driver canónico v1** (Angular), drivers adicionales cuando haya tracción.
5. **Bridge** requiere SDK per-lenguaje-host (C++, Python, COM…). Cada uno es un mini-producto.

---

## J. Lo que hago a continuación

Aplico lo propuesto en E.(c):
1. Agrego **§9 Casos de uso objetivo** (portfolio verticales).
2. Agrego **§10 Developer Experience** con los 3 conceptos juntos: atributos+v-gen+LSP-que-miente.
3. Agrego **§11 Conceptos del autor (verbatim)** para preservar tus definiciones sin reinterpretar.
4. Dejo §1–§8 **intactas** (ya sé que hay cosas a corregir: Identity=Host, Scope vivo, Bridge primitivo…) y añado al principio de cada una una **nota de deprecación** apuntando a §11 como fuente.

Luego, cuando valides §9–§11, hago el rework grande (v1 del doc con §1–§8 rehechas).

¿Procedo con (c) ahora, o prefieres saltar directo a v1 con todo integrado de una vez?You've used 77% of your weekly rate limit. Your weekly rate limit will reset on April 26 at 8:00 PM. [Learn More](https://aka.ms/github-copilot-rate-limit-error)
