# Cierre de decisiones — .NET en la plataforma Vortech

> **Estado.** Normativo. Este documento consolida las decisiones finales sobre el uso de .NET en la plataforma, reemplazando cualquier versión intermedia de documentos anteriores que haya sugerido lo contrario.
>
> **Fuente.** Consolida y finaliza lo debatido en `inventory/_analysis-preview/DECISION-CLOSURE.md`, `DECISION-CLOSURE-DEBATE.md`, `FINDINGS-TS-PLATFORM.md` y las iteraciones posteriores. Donde este documento contradice un intermedio previo, **manda este**.
>
> **Complementa a** [`00-responsabilidad-de-dotnet.md`](00-responsabilidad-de-dotnet.md): aquel describe el **rol** de .NET; éste fija las **decisiones** sobre cómo se materializa ese rol.

---

## 1. Regla madre

> **El código .NET de la plataforma es 100% propio. Las únicas dependencias permitidas son lo nativo del runtime .NET y de ASP.NET Core. Cualquier otra librería queda fuera del núcleo.**

Esto es decisión cerrada, no aspiración. Se explica en §2–§4.

---

## 2. Qué es "propio" y qué es "nativo"

### 2.1 Se permite — sin discusión

Forma parte del sustrato y se usa directamente:

- **BCL / Core libraries** de .NET (colecciones, IO, threading, reflection, text, linq, memory, sockets, crypto básico, json del runtime, etc.).
- **ASP.NET Core** completo: Kestrel, pipeline de middleware, routing, endpoints, model binding, DI container, configuration, logging, hosting, OpenAPI mínimo, autenticación/autorización base, data protection.
- **Runtime features**: Source Generators, Roslyn APIs (para `v-gen` y el LSP), AOT, P/Invoke, COM interop, `System.Reflection` + `System.Reflection.Emit` cuando aplique.
- **Herramientas oficiales del SDK**: MSBuild, `dotnet` CLI, NuGet como protocolo (no como sustituto de decisiones de dependencia).

### 2.2 Se considera "propio"

Todo lo demás se escribe en Vortech. Incluye, sin ser exhaustivo:

- Cliente HTTP especializado si se necesita algo más que `HttpClient`.
- Acceso a datos (equivalentes a lo que hacen ORMs / micro-ORMs).
- Servidor de identidad (emisión de tokens, sesiones, cuentas, federación).
- Wire runtime (codec, framing, correlación, reintentos, idempotencia).
- Scope/Router/Capability runtime.
- Codegen (`v-gen`).
- Language Server.
- Extension backend.
- Health, telemetría propia, configuración extendida, serialización canónica.

### 2.3 Excluido — no entra al núcleo

Librerías externas de uso general quedan fuera del núcleo de la plataforma como dependencia. Esto incluye, entre otras:

- **Dapper**
- **OpenIddict** (y análogos: IdentityServer, Duende)
- **EF Core** como ORM adoptado
- Librerías de mapeo, validación, mediator, resiliencia, IoC alternativos
- Frameworks web alternativos sobre ASP.NET

La plataforma **no las referencia** desde el núcleo. Esto no las "rechaza" — las coloca fuera del sustrato.

---

## 3. Qué rol juegan Dapper, OpenIddict y similares

Las librerías maduras que resuelven problemas equivalentes a los de la plataforma juegan un rol **informativo**, no de dependencia:

### 3.1 Fuente de inspiración por lectura del fuente

- Se estudia su **código fuente** para entender decisiones de diseño, trade-offs, soluciones a casos límite, estructura interna.
- Se extraen patrones, se replican en código propio cuando son superiores a lo que se haría a ciegas.
- Se cita la inspiración en comentarios o ADRs cuando corresponde, por trazabilidad intelectual.

### 3.2 Registro vivo de referencias

Hasta la fecha, las referencias consolidadas son:

| Librería | Dominio que informa | Qué se aprovecha |
|---|---|---|
| **Dapper** | Acceso a datos / mapeo SQL → objetos | Filosofía de micro-ORM, manejo de parámetros, expansión de listas, tipos dinámicos, costes de reflection, patrones de extensión. |
| **OpenIddict** | Servidor OIDC / emisión de tokens | Modelo de flujos, gestión de clientes, almacenamiento de tokens, integración con ASP.NET Core, patrones de revocación. |

La lista **crece** conforme se identifican dominios concretos (cada nuevo dominio que se implementa puede añadir una o dos librerías como referencia). Se mantiene en este documento, sin crear uno nuevo por cada referencia.

### 3.3 Reglas del uso-como-inspiración

1. **No copiar literalmente.** Replicar entendiendo; reescribir en el estilo y con los invariantes de la plataforma (atributos Vortech, contratos Provider/Driver/Wire).
2. **No adoptar su modelo completo.** Se toman ideas discretas, no filosofías enteras.
3. **Respetar licencia.** Para cualquier tramo que sí se quiera portar literalmente, verificar la licencia de la librería original y atribuir explícitamente.
4. **No generar acoplamiento.** Si un cambio upstream de la librería hiciera que "nuestra versión" quedara obsoleta, eso es señal de que se copió demasiado — el código propio debe tener vida y evolución independientes.

---

## 4. Por qué esta decisión

Se fija por razones que ya se debatieron y se dan por acordadas:

1. **Estabilidad del sustrato.** Una plataforma cuyo núcleo depende de la salud de N librerías de terceros no es un sustrato, es un ensamblaje. Decisiones externas (cambios breaking, abandonos, cambios de licencia, fusiones) impactarían directamente.
2. **Coherencia de modelo.** Las primitivas de la plataforma (Provider/Driver/Capability/Wire/Bridge/…) se ajustan mal a las abstracciones de librerías de propósito general. Adoptarlas obliga a envolverlas, lo cual paga el coste dos veces: uso + adaptación.
3. **Codegen y LSP.** El flujo canónico — definición en C# con atributos → generación a TS/Rust/SQL — funciona mejor cuando el tipo C# es propio y estable. Tipos venidos de una librería externa suelen no estar diseñados para ser proyectados.
4. **Interop sin barreras.** El terreno donde .NET es especialmente valioso (COM/MSAccess/legacy Microsoft) rara vez tiene librerías externas maduras; la plataforma ya vive ahí sin ellas.
5. **Trazabilidad.** Cada línea del núcleo se explica desde los principios de la plataforma, no desde "así lo hace la librería X".
6. **Experimentado.** Ya se probaron parcialmente integraciones con librerías maduras — sirven *en parte* pero no en otra parte, y el coste de adaptar supera al de construir. Este documento formaliza esa experiencia como política.

---

## 5. Cómo se construye entonces

El camino operativo queda:

1. **Cada dominio identifica su librería-referencia.** Antes de escribir código no trivial, se leen 1–3 proyectos maduros del dominio y se anotan los patrones útiles.
2. **Se diseña el contrato en términos Vortech.** Provider / Driver / Capability / Data / Wire según corresponda. No se toma prestada la API de la librería estudiada.
3. **Se implementa contra BCL + ASP.NET.** El código usa únicamente el sustrato permitido.
4. **Se añade al registro §3.2** la referencia consultada.
5. **Se documenta** (comentario/ADR) cualquier decisión no obvia que derive de lo aprendido.

---

## 6. Excepciones

Existe exactamente **una** excepción permitida a la regla madre:

- **Proyectos piloto o research** internos que *no son parte del núcleo publicable* pueden usar librerías externas para acelerar exploración.
- Cualquier componente que aspire a promoverse del piloto al núcleo **debe** reescribirse bajo la regla §1 antes de la promoción.
- Un piloto no es "núcleo con librerías"; es un banco de pruebas descartable.

---

## 7. Qué esto cierra de los documentos previos

Para evitar ambigüedad con lecturas anteriores:

| Documento / Ítem | Estado final (este doc) |
|---|---|
| `DECISION-CLOSURE.md` §1.1 — *"Identity Host .NET autónomo (Duende / OpenIddict / IdentityServer evaluables como base)"* | **Superado.** Identity se construye propio. Duende/OpenIddict/IdentityServer son referencias (§3), no bases. |
| `DECISION-CLOSURE.md` §1.2–1.3 — v-gen y LSP en .NET | **Confirmado.** Sin cambios. Se construye propio sobre Roslyn (que es nativo del SDK). |
| `DECISION-CLOSURE-DEBATE.md` ítem 2 — *"Duende / OpenIddict como base madura"* | **Superado.** Solo inspiración. |
| `DECISION-CLOSURE-DEBATE.md` ítem 6 — *"EF Core / Dapper / drivers maduros como plantilla ejemplar"* | **Precisado.** Dapper y EF Core son referencias de lectura; no se adoptan como dependencia. Los drivers nativos de proveedor (ADO.NET) sí son sustrato permitido si cuentan como nativo del runtime del proveedor. |
| `FINDINGS-TS-PLATFORM.md` observaciones sobre integración con librerías .NET concretas | **Obsoleto.** La integración no ocurre en el núcleo. |

---

## 8. Cláusula de reapertura

Esta decisión se revisa solo si se cumplen **todas** las siguientes condiciones:

1. Aparece un problema técnico **imposible** de resolver con BCL + ASP.NET + código propio en un horizonte razonable.
2. La solución requiere una capacidad no existente en el runtime y no alcanzable por código propio.
3. Existe una librería externa que la aporta de forma estable, con licencia compatible, sin acoplamiento transversal al modelo Vortech.

No se reabre por:

- "Es más rápido de escribir si uso X".
- "X ya lo tiene resuelto".
- "Todo el mundo usa X".
- "Aparecieron novedades en X".

Si aparece el impulso de reabrir por una de esas razones, la acción correcta es releer §4.

---

## 9. Resumen operativo

- **Dependencias permitidas:** .NET (BCL + runtime) + ASP.NET Core.
- **Código de dominio plataforma:** propio.
- **Librerías maduras externas:** inspiración vía lectura de fuente; registro vivo en §3.2; sin adopción.
- **Excepción única:** pilotos/research no publicables.
- **Actualización del registro:** cada dominio nuevo suma su referencia aquí, no en un doc paralelo.
