# Plataforma Vortech

> *Una sola plataforma para construir software distribuido, dueño de sus propias primitivas, que trata la interoperabilidad entre lenguajes, protocolos y runtimes como un derecho — no como un accidente.*

---

## 1. El problema

Construir software serio hoy significa elegir entre dos caminos malos:

- **Framework monolítico por lenguaje** — te da productividad dentro de su jaula, pero cada vez que sales (un device embebido, un runtime COM, un lenguaje ajeno, un protocolo nuevo) el ecosistema se derrumba y toca pegar con cinta adhesiva.
- **Stack artesanal** — ensamblas librerías, vives actualizando breaking changes ajenos, y tu arquitectura termina siendo el mínimo común divisor de lo que esas librerías permiten.

Ambas opciones dejan fuera **el escenario real de la industria**: sistemas donde conviven C# moderno, .NET Framework legacy, C++ de máquinas industriales, Python de modelos IA, Rust de firmware, TypeScript de UI, SQL de cincuenta dialectos, y un universo de transportes (HTTP, WebSocket, gRPC, MQTT, serie, COM, archivos planos, colas propietarias).

Vortech nace de aceptar ese escenario **como punto de partida**, no como excepción.

---

## 2. Qué es Vortech

Vortech es **una plataforma de aplicación de propósito general** cuyas primitivas están diseñadas para:

1. Describir un **dominio de negocio** una vez, con su lógica completa, **independientemente del lenguaje y del runtime** donde vaya a ejecutarse.
2. Exponerlo automáticamente por cualquier **transporte** (HTTP, WS, gRPC, COM, IPC, procesos, pipes, colas), con **proyecciones cliente** en los lenguajes que el proyecto necesite.
3. Conectarlo **a runtimes ajenos** — tu propio C++ antiguo, un .NET Framework de 2004, un dispositivo empotrado, una base de datos propietaria — sin perder el modelo.
4. Componerlo en **aplicaciones completas** con identidad, autorización, pipeline, extensibilidad, UI tipo VSCode, y observabilidad, todo hablando el mismo vocabulario.

Donde otras plataformas **imponen un runtime** o **imponen un protocolo**, Vortech **desacopla la descripción del dominio de ambos**.

---

## 3. Las 12 primitivas

El vocabulario de Vortech es pequeño a propósito. Doce conceptos, ortogonales, cubren el 100% de la superficie:

### 3.1 Provider — fachada de dominio

La API pública de un dominio, con **lógica de negocio completa**, agnóstica del driver que la implementa. El consumidor **nunca** ve otra cosa. Es el único contrato que importa.

### 3.2 Driver — implementación oculta

La implementación concreta de un Provider. Existe para servirlo. **No se inyecta, no se invoca directamente, no se expone.** Múltiples drivers pueden competir bajo el mismo Provider; el Provider elige según capabilities.

### 3.3 Capability — contrato Driver ↔ Provider

Los **atributos** de lo que un driver puede o no puede hacer. El Provider declara lo que necesita; el Driver declara lo que ofrece. Habilita **degradación graceful** y matrices de compatibilidad automáticas: este driver sí soporta transacciones, aquel otro no; este stream, aquel bulk.

### 3.4 Agent — ejecución polyglot

Una tarea ejecutable en **cualquier lenguaje** (Python, Rust, shell, Node, C++, Go, lo que haga falta), invocable desde Providers/Drivers/Hosts. Es la escotilla polyglot: cuando la herramienta correcta para un trabajo vive fuera del runtime principal, Agent la trae al ecosistema sin forzarla a reescribirse.

### 3.5 Wire — API de comunicación

Una **API unificada** para comunicación entre partes de la plataforma, independiente del transporte. Habla por HTTP, WebSocket, gRPC, pipes, COM o lo que corresponda, **sin cambiar el contrato**. Wire opera sobre TransportProvider / TransportDriver — la misma primitiva Provider/Driver aplicada a sí misma.

### 3.6 Bridge — traducción cross-runtime

Un TransportDriver **especializado en traducir** entre Wire y un runtime ajeno. Un componente C++ industrial, una librería COM de 32 bits, un firmware embebido, un servicio legacy — Bridge los convierte en ciudadanos de primera clase de Vortech, hablando Wire como si fueran nativos.

**Esta es la primitiva diferenciadora real de Vortech.** Los frameworks genéricos no la tienen: asumen que todo corre en su runtime. Vortech no lo asume.

### 3.7 Host — plataforma + pipeline

El contenedor runtime con **pipeline de ejecución** (equivalente al middleware de una app moderna). Soporta topología **master/slave nativamente**, orquesta Providers/Drivers/Agents, y expone el ciclo de vida completo de una aplicación Vortech.

### 3.8 Identity — Host autónomo de identidad

Un Host **completo y autónomo** dedicado a gestión de cuentas, credenciales, autenticación, autorización y sesión. Siempre proceso propio; siempre replicable (master/slave) para alta disponibilidad. Construido **con** las primitivas de Vortech, demostrando dogfooding desde el día uno.

### 3.9 Data — Provider+Driver+Bridge de datos

La **aplicación ejemplar** del modelo universal: un dominio de persistencia expresado como Provider (lógica de datos), múltiples Drivers (SQL, NoSQL, server, serverless, embebido) y Bridges (COM, formatos legacy). Los demás dominios verticales se construyen copiando este patrón.

### 3.10 Scope — árbol de namespaces con contexto

Un **grafo jerárquico** donde cada nodo es namespace puro o namespace con contexto. Permite direccionar cualquier cosa en la plataforma con rutas naturales (`identity.accounts.byEmail("x").sessions.active`), habilitando un sistema de direccionamiento universal sobre el grafo de Providers.

### 3.11 Router — resolución agnóstica

Servicio transversal que **resuelve rutas** sobre el Scope. No es un Provider — es infraestructura del Host. Habilita consultas tipo query sobre el grafo de dominios, sin acoplar el consumidor al tipo concreto de destino.

### 3.12 Extension — unidad dual UI + backend

Una **extensión contributable** que aporta partes de UI (vistas, comandos, paneles, status) y partes de backend (handlers, Agents, Providers) como un paquete único. Modelo inspirado en extensiones VSCode, pero con **backend real adosado**. Soporta instalación fría (bundle) y caliente (hot-load).

---

## 4. Las cuatro capas

Las 12 primitivas se organizan en capas con responsabilidades claras:

```
┌──────────────────────────────────────────────────────────────┐
│  CAPA 4 · UI Shell                                           │
│  Shell tipo VSCode · componentes · theming · extensions UI   │
├──────────────────────────────────────────────────────────────┤
│  CAPA 3 · Runtime                                            │
│  Host · pipeline · master/slave · extension loader           │
├──────────────────────────────────────────────────────────────┤
│  CAPA 2 · Primitivas                                         │
│  Provider · Driver · Agent · Wire · Bridge · Scope · Router  │
│  Identity · Data · Capability · Extension                    │
├──────────────────────────────────────────────────────────────┤
│  CAPA 1 · Developer Experience                               │
│  Atributos · codegen universal · LSP con proyección de tipos │
└──────────────────────────────────────────────────────────────┘
```

**La capa que cambia la experiencia de construir** es la Capa 1:

- **Atributos** sobre el código declaran el contrato.
- El **generador universal** lee los atributos y emite automáticamente: proyecciones cliente en múltiples lenguajes, registros DI, proxies Wire, esquemas SQL, DTOs, documentación, OpenAPI/AsyncAPI, stubs de bridge.
- El **LSP** lee los mismos atributos y **proyecta los tipos generados al IDE antes del build** — el desarrollador ve el SDK cliente, el stub Rust, el DTO SQL, con autocompletado completo, aunque físicamente aún no existan como archivos.

El efecto práctico: **describes el dominio una vez, y todo lo demás — lado cliente, lado servidor, múltiples lenguajes, múltiples transportes — se materializa solo**. No hay sincronización manual. No hay contratos duplicados. No hay "¿actualicé el DTO en las ocho capas?"

---

## 5. El flujo de construir algo en Vortech

Tomemos un ejemplo abstracto: un dominio nuevo, *"Inventario"*.

1. **Defines el Provider** en código, con atributos Vortech que describen operaciones, capabilities requeridas y contratos Wire.
2. **El LSP te muestra en tiempo real** cómo se verá el SDK cliente en los lenguajes configurados, el esquema SQL inferido, el DTO Wire, como si ya existieran.
3. **El generador emite** en build: el cliente TS para la UI, el cliente Rust si algún Agent lo necesita, los DTOs, los registros DI, los proxies Wire, la migración SQL inicial.
4. **Implementas uno o más Drivers** — uno sobre una base SQL moderna, otro puente a un sistema legacy vía Bridge. El Provider elige según capabilities declaradas por cada driver.
5. **Lo hosteas** — el Host ASP.NET lo arranca, lo expone por los transportes configurados, participa del pipeline global.
6. **Opcionalmente escribes una Extension** — añade una vista al shell VSCode, un par de comandos, un status bar item. La extensión trae su backend propio (handlers, Agents) empaquetado.
7. **La UI lo consume** — el driver UI por defecto renderiza componentes que hablan Wire directo contra los Providers. Los tipos están sincronizados vía generación; los cambios del contrato rompen el build, no producción.

**El tiempo que normalmente gastas reconciliando capas, lenguajes, y contratos duplicados, Vortech lo elimina por diseño.**

---

## 6. Qué hace distinto a Vortech

No es cada primitiva por separado — otras plataformas tienen DI, tienen pipeline, tienen extensions. Lo distintivo es **la combinación completa bajo un mismo vocabulario**:

### 6.1 Bridge como primitiva de primera clase

Nadie más trata el runtime ajeno como ciudadano nativo. En la mayoría de frameworks, COM interop, FFI, o proceso cross-lang son escapes de emergencia. En Vortech son **componentes declarables**, con contrato Wire, con capabilities, con lifecycle gestionado por el Host.

### 6.2 Codegen universal gobernado por LSP

El truco de "ver tipos generados antes de que existan" elimina el ciclo edit → build → ver-errores → corregir que consume la mayoría del tiempo de desarrollo real en sistemas polyglot.

### 6.3 Extensions con backend real

El modelo VSCode popularizó extensions UI. Vortech lo completa: una Extension es **feature end-to-end** — botón en el sidebar + comando + servicio backend + migración DB + Agent opcional — todo versionado y distribuido como unidad.

### 6.4 Scope + Router como grafo uniforme

Direccionas cualquier cosa — una cuenta, una sesión, un registro, un dispositivo, un job en curso — con la **misma sintaxis de resolución**. Eliminas la diferencia conceptual entre "endpoints", "rutas", "entities" y "resources": todo son nodos del grafo.

### 6.5 Dogfooding estructural

Identity, Data, Wire, y el propio Host **están construidos con las primitivas de Vortech**. No hay dos mundos — el que usas y el que está por debajo. Lo que ves es lo que hay.

### 6.6 Agnóstico de transporte por diseño

Un Provider no sabe si se consume por HTTP o por COM. Un Driver no sabe si está hablando con un cliente web o con un dispositivo serie. **Los transportes se conectan como drivers más**. Cambiarlos es configuración, no refactor.

---

## 7. Principios no negociables

Vortech sostiene un puñado de principios que cualquier decisión concreta respeta:

1. **Contrato único, proyecciones múltiples.** Definir algo dos veces en dos lenguajes es un bug en la plataforma, no una necesidad del dominio.
2. **El driver es invisible.** Si un consumidor tiene que saber qué driver hay abajo, la plataforma falló.
3. **La herramienta correcta para el trabajo correcto.** Agents existen para que cada tarea use el runtime que le conviene — no para empujar todo al runtime dominante.
4. **Composición sobre herencia.** Provider+Driver+Bridge+Extension componen; no hay jerarquías profundas.
5. **Lo distribuido es normal.** No hay "modo monolito" y "modo distribuido" — hay un Host que puede estar solo o en cluster, y eso no cambia el código.
6. **Observable por construcción.** Wire, pipeline y Scope generan trazabilidad sin intervención del desarrollador.
7. **Evolución sin breaking.** Capabilities declaradas permiten agregar sin romper: un driver nuevo aparece, uno viejo deprecia gradualmente, el Provider negocia.
8. **La DX es parte de la plataforma.** No es "nice to have" — atributos, codegen y LSP son tan núcleo como Host o Wire.

---

## 8. Qué resuelve para quien construye con Vortech

Para el desarrollador individual:
- Deja de escribir boilerplate de integración entre lenguajes.
- Deja de mantener contratos duplicados entre cliente y servidor.
- Deja de elegir entre "framework monolítico rígido" y "stack artesanal frágil".

Para el arquitecto:
- Un vocabulario estable que sobrevive a cambios de moda tecnológica.
- Capacidad declarada de absorber runtimes nuevos vía Bridge, sin rediseñar.
- Separación limpia entre lo que evoluciona rápido (UI, features, verticales) y lo que evoluciona lento (primitivas, Wire, Host).

Para la organización:
- Verticales de negocio shipeables como Extensions — cada una un ciclo propio.
- Identity centralizada pero replicable.
- Inventario de capabilities por driver → compliance y auditoría natural.
- Polyglot sin caos: cada lenguaje entra por Agent o por Bridge, con el contrato auditado.

---

## 9. Identidad del proyecto

Vortech es **una plataforma construida desde la convicción** de que la industria merece herramientas diseñadas para el mundo real — donde los sistemas son heterogéneos, los lenguajes conviven, los runtimes viejos no se jubilan, y la UI, el dato, el dispositivo, y el modelo IA **tienen que hablar entre sí sin ceremonias**.

No intenta ser "otro framework más". Intenta ser **la capa sobre la cual los frameworks siguientes se construyen**, proporcionando lo que ninguno de ellos ha querido asumir: **la unificación del vocabulario, del contrato, y de la interoperabilidad, desde abajo**.

---

*Documento oficial — descripción de plataforma. No contiene decisiones operativas, planes de implementación, ni elecciones de stack. Esos viven en documentos separados.*
