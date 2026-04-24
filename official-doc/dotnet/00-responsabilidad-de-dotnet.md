# Responsabilidad de .NET en la plataforma Vortech

> **Alcance de este documento.** Describe **qué rol cumple .NET** dentro de la plataforma Vortech y **qué no** hace. No es guía de implementación, no es roadmap, no es comparativa de frameworks. Es la declaración oficial del papel que juega el ecosistema .NET en el todo.

---

## 1. En una línea

> **.NET es el sustrato del núcleo de la plataforma: donde viven los contratos, la identidad, el runtime del Host, la persistencia, y el generador de código que proyecta todo hacia el resto de lenguajes.**

No es "el backend". No es "un stack más". Es **el lugar físico donde las primitivas canónicas existen** y desde el cual el resto del ecosistema se deriva.

---

## 2. Por qué .NET

Esta sección no compara .NET contra otros stacks — explica las propiedades que hicieron que la plataforma lo adopte como sustrato del núcleo:

1. **Sistema de tipos rico + atributos de primera clase.** Los contratos Vortech se expresan como interfaces + atributos. .NET permite decorar tipos con metadatos consumibles en tiempo de build, tiempo de carga y tiempo de ejecución sin acrobacia.
2. **Reflexión + Source Generators + Roslyn.** El codegen que proyecta el núcleo hacia otros lenguajes (TS, Rust, SQL, schemas) puede leer el contrato sin parsear archivos — lo lee como árbol semántico real.
3. **Interop excelente con mundos hostiles.** COM, OLE/ActiveX, Win32, P/Invoke, WMI, PowerShell, .NET Framework legacy. La plataforma Vortech necesita hablar con sistemas que ningún stack moderno quiere tocar; .NET es de los pocos que lo hace bien.
4. **Host HTTP industrial.** ASP.NET Core ofrece un servidor de producción maduro, extensible, con pipeline de middleware explícito — encaja con la forma canónica en que la plataforma define el **Host**.
5. **Ecosistema de identidad maduro.** Autenticación, autorización, federación, emisión de tokens, cuentas, RBAC, multitenancy — son territorio resuelto en .NET.
6. **Runtime único, múltiples lenguajes.** C# es el lenguaje primario, pero F# y VB.NET comparten CLR. La frontera no es el lenguaje, es el runtime.
7. **Estabilidad política del ecosistema.** La cadencia de releases LTS, el versionado, la compatibilidad hacia atrás y el rumbo técnico son predecibles — una propiedad deseable para un **núcleo** que pretende ser estable por años.

Ninguno de estos argumentos descalifica otros stacks. Se listan porque juntos forman **la razón por la que este rol se asigna a .NET y no se redistribuye**.

---

## 3. Qué vive en .NET (las responsabilidades canónicas)

Las siguientes primitivas de la plataforma tienen su implementación **canónica** en .NET. Esto significa: la definición normativa del contrato y su runtime oficial están en .NET; cualquier otra representación en otro lenguaje es **proyección**, no re-implementación.

### 3.1 Contratos (Provider / Driver / Capability)

- Las interfaces que definen **qué es un Provider**, **qué es un Driver**, **qué es una Capability** son C#.
- Un `IDataProvider`, un `IFileProvider`, un `IAuthProvider` (y equivalentes por dominio) son **tipos C#** decorados con atributos Vortech.
- Los Drivers concretos (SQL Server, PostgreSQL, SQLite, MongoDB, S3, Azure Blob, filesystem, COM/MSAccess, …) son clases C# que implementan esos contratos.
- Las Capabilities son marcadores C# adjuntos al contrato; es desde aquí donde viajan a otros lenguajes vía codegen.

### 3.2 Host

- El **Host** de la plataforma — el runtime que expone Providers, monta pipeline HTTP, resuelve DI, gestiona ciclo de vida, registra extensiones — es un proceso .NET (ASP.NET Core o consola, según despliegue).
- No hay un "Host en otro lenguaje" equivalente. Si un deploy concreto necesita exponer HTTP desde otro runtime (ej. un Agent en Python que expone un endpoint), lo hace como **Agent**, no como **Host**.

### 3.3 Identity

- Autenticación, emisión de tokens, sesiones, cuentas, perfiles, federación OIDC/SAML, MFA, recuperación, RBAC/ABAC.
- Se despliega como Host independiente (Identity Host) o montado dentro de un Host de aplicación, según escala.
- Las decisiones sobre qué bases usar (OpenIddict, Duende, IdentityServer, ASP.NET Core Identity, Keycloak externo) son **operativas** y no pertenecen a este documento.

### 3.4 Data

- El Provider de datos y sus Drivers viven aquí.
- Las entidades canónicas (lo que la plataforma llama **Data primitive**) son tipos C# con atributos que describen campos, llaves, relaciones, proyecciones, validaciones.
- Desde esa definición se derivan: DDL SQL, DTOs en TS, tipos Rust, esquemas JSON, documentación — todo vía codegen.

### 3.5 Wire (contrato)

- El **contrato canónico** de Wire — qué mensajes existen, con qué forma, qué códigos de error, qué semánticas de idempotencia/retry — se declara en C#.
- Las implementaciones concretas de Wire en TS (cliente UI), Rust (Agents nativos), Python (Agents ML) consumen proyecciones generadas del contrato C#, no lo reescriben.
- El transporte real (HTTP, WebSocket, gRPC, queue, in-process) es **driver de Wire** — puede estar en C# o en otros lenguajes según dónde corra el endpoint.

### 3.6 Bridge (hacia legacy + hacia Microsoft)

- Los Bridges que hablan con **COM, OLE, MSAccess, Office, ActiveX, Mach4, drivers Windows, .NET Framework antiguo** son C#.
- Esto no es dogma — es reconocimiento de que C# es **literalmente el mejor lenguaje del mundo** para hablar con esas plataformas. Forzar un Bridge en otro stack cuando existe uno nativo en .NET es trabajo contra el ecosistema.

### 3.7 Scope / Router

- La resolución de **Scope** (tenant, organización, usuario, request, contexto) y el **Router** (cómo una capability se enruta al Driver correcto según scope) son implementación canónica en .NET.
- Son parte del runtime del Host — por tanto viven donde vive el Host.

### 3.8 Extension (backend)

- La contraparte servidor del sistema de extensiones — registros, descriptores, activación, resolución de dependencias, aislamiento — es .NET.
- El lado UI del mismo sistema de extensiones vive en el shell TS; ambos lados hablan contra el mismo contrato canónico.

### 3.9 Codegen (v-gen)

- El generador de código que lee los atributos Vortech sobre tipos C# y emite código para TS, Rust, SQL, JSON schemas, OpenAPI/AsyncAPI, Rust FFI, etc., es una herramienta .NET.
- Puede invocarse desde MSBuild (en build de proyectos .NET), CLI (para regenerar artefactos en otros repos), o desde el Language Server.

### 3.10 Language Server

- El LSP oficial de la plataforma — el que entiende los atributos Vortech, proyecta tipos cruzados (mostrar a un dev TS el tipo C# detrás de un endpoint Wire, por ejemplo), valida coherencia multi-lenguaje — es .NET.
- Es **uno solo**. No hay LSPs paralelos por lenguaje; hay un LSP que habla el modelo canónico y sabe proyectarlo.

---

## 4. Qué **no** es responsabilidad de .NET

La plataforma evita que .NET colonice dominios donde no aporta. Las siguientes áreas **no** viven en .NET (aunque .NET las soporte técnicamente):

- **UI / shell / componentes / theming.** La capa UI vive en TypeScript sobre el shell Vortech. No hay Blazor, no hay WinForms, no hay WPF en el núcleo de la plataforma. Un deploy específico puede elegir UI en .NET si quiere — pero no es el camino canónico ni es lo que la plataforma ofrece como producto.
- **Agents perf-crítico / firmware / hot-path nativo.** Rust (u otros runtimes nativos) es el hogar natural de estos Agents. Forzarlos a .NET sería ignorar por qué se inventaron.
- **Agents de ML / ciencia de datos / scripting.** Python es el hogar natural. Puede invocarse vía Wire sin fricción.
- **Scripts de build, automatización web, tooling misceláneo.** Cualquier runtime razonable sirve; no es territorio de la plataforma.
- **Definiciones de dominio puramente textuales** (documentación, specs, ADRs). Viven en Markdown, no en C#.

La regla es clara: **.NET es sustrato del núcleo, no monopolio del ecosistema.**

---

## 5. Cómo se relaciona .NET con el resto

```
                    ┌──────────────────────────────────────┐
                    │   Contratos + atributos Vortech       │  ← C# (fuente de verdad)
                    │   (Provider/Driver/Capability/Data/…) │
                    └──────────────┬───────────────────────┘
                                   │  v-gen (C# tool)
         ┌─────────────┬───────────┼───────────┬──────────────┐
         ▼             ▼           ▼           ▼              ▼
       TS types     Rust FFI     SQL DDL    JSON schemas   OpenAPI
       (UI shell    (Agents      (Data       (docs,         (HTTP
        + clients)   + Bridges)   provider)   validators)    surface)

                    ┌──────────────────────────────────────┐
                    │           Host (.NET)                │
                    │   ASP.NET Core + DI + pipeline +     │
                    │   Scope/Router + Extension backend    │
                    └──────────────┬───────────────────────┘
                                   │  Wire (contrato C#, transportes múltiples)
         ┌─────────────┬───────────┼───────────┬──────────────┐
         ▼             ▼           ▼           ▼              ▼
       UI shell    Agent Rust   Agent Py    Agent Node    Bridge COM
        (TS)       (firmware,   (IA/ML)     (scripts)     (C#, legacy)
                   signing)
```

Puntos clave del diagrama:

- **Flecha hacia abajo desde contratos**: la fuente de verdad se proyecta; no se duplica a mano.
- **Wire es un contrato, no un transporte**: el mismo contrato se habla por HTTP, WebSocket, gRPC, cola, o llamada local según driver.
- **Bridges COM/MSAccess** son .NET no por dogma sino por adecuación técnica (§3.6).
- **Agents son polyglot**: .NET no intenta absorberlos.

---

## 6. Qué esto significa para quien construye

- Si estás definiendo **una nueva entidad, un nuevo Provider, una nueva capability** → se declara en C# con atributos Vortech, y el resto del ecosistema lo recibe por generación.
- Si estás implementando **un Driver para un backend concreto** (una nueva base de datos, un nuevo storage, un nuevo sistema externo "normal") → vive en C#.
- Si estás construyendo **UI, vistas, componentes, shell, paneles** → TypeScript, no .NET.
- Si estás construyendo **un Agent** (procesamiento, firmware, IA, scripting) → el lenguaje que mejor sirva a ese Agent; .NET no está forzado.
- Si estás construyendo **un Bridge hacia algo Microsoft/legacy** → casi siempre C#.
- Si estás escribiendo **código de aplicación final** (un vertical concreto, un SaaS sobre la plataforma) → lo que te pida el dominio; típicamente el Host es .NET y la UI es TS, pero el vertical puede incluir Agents en cualquier lenguaje.

---

## 7. Cláusula de estabilidad

La responsabilidad de .NET como **sustrato del núcleo** de la plataforma Vortech se considera estable por diseño. No se revisa por impulso, por modas, ni por la aparición de un lenguaje nuevo atractivo. Se revisa únicamente bajo condiciones estrictas de obsolescencia verificable del ecosistema, y siempre contra evidencia, no contra narrativa.

Esta cláusula existe porque una plataforma cuyo núcleo se reescribe cada 18 meses no es una plataforma — es un borrador permanente.

---

> **Qué no contiene este documento.** No menciona nombres concretos de librerías a adoptar, no fija versiones, no decide entre alternativas dentro de .NET (OpenIddict vs Duende, EF vs Dapper vs micro-ORM propio, …), no fija topología de despliegue, no decide en qué repos vive el código. Esas son decisiones operativas que viven en otros documentos.
