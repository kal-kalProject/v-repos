# Agent en .NET

> **Rol.** Tarea ejecutable invocable desde Providers, Drivers o Host, que puede vivir en **cualquier runtime**. La escotilla polyglot oficial de la plataforma.
>
> **Relacionado:** [`14-wire.md`](14-wire.md) — cómo se invoca; [`15-bridge.md`](15-bridge.md) — cómo se traduce si el runtime ajeno no habla Wire nativo.

---

## 1. Qué es en concreto en .NET

Desde la perspectiva .NET, un Agent tiene **dos representaciones**:

1. **Agents implementados en .NET** — clases C# que ejecutan tareas dentro del proceso Host o en procesos .NET adyacentes.
2. **Agents implementados en otros lenguajes** — Python, Rust, Node, shell, etc. — que el Host invoca como ciudadanos de primera clase. Desde .NET se ven como **proxies tipados**.

En ambos casos, la superficie consumida por el código .NET es idéntica: un contrato `IAgent<TInput, TOutput>` (o variantes streaming) resuelto por DI.

---

## 2. Forma del contrato

```csharp
[VortechAgent(
    Name = "pricing.optimizer",
    Runtime = AgentRuntime.External,          // .NET | External | InProcessNet
    Language = AgentLanguage.Python,          // informativo; se usa para codegen del stub
    Transport = AgentTransport.Wire)]         // Wire sobre Bridge si aplica
public interface IPricingOptimizerAgent
    : IAgent<PricingJob, PricingPlan>
{
}

// Invocación
var plan = await _agents.Get<IPricingOptimizerAgent>()
                        .RunAsync(job, ct);
```

Convenciones fijadas:

- **`IAgent<TIn, TOut>`** — ejecución unaria.
- **`IStreamingAgent<TIn, TOut>`** — `IAsyncEnumerable<TOut>`.
- **`ISubscribingAgent<TIn, TEvent>`** — eventos disparados por el Agent.
- **Entrada/salida POCOs inmutables**, proyectables a cualquier lenguaje.
- **Invocación siempre async + cancellable.**

---

## 3. Runtime

El Host mantiene un `AgentRuntime` que:

- Conoce el **runtime físico** de cada Agent (in-proc .NET, proceso externo, contenedor, máquina remota).
- Gestiona su **ciclo de vida** — inicio, reinicio, watchdog, timeout, kill.
- Enruta la invocación vía el transporte apropiado: llamada directa si .NET in-proc, Wire si fuera, Wire-sobre-Bridge si el runtime ajeno no habla Wire.
- Aplica **políticas de ejecución**: retries, circuit breaker, quotas, concurrencia máxima, presupuesto de tiempo.

Los Agents externos se describen con un `AgentManifest` (YAML o C# declarativo) que detalla: binario/script de arranque, variables de entorno, healthcheck, puerto Wire si aplica, recursos.

---

## 4. Proyección vía codegen

Desde el contrato C#, `v-gen` emite:

- **Stub del lado del Agent** en el lenguaje declarado (`Language = Python` → módulo Python con función tipada, serialización, y arnés Wire).
- **Cliente .NET tipado** para invocar el Agent como si fuera local.
- **Manifest esqueleto** con los metadatos necesarios.
- **Documentación** que describe la tarea, inputs/outputs, capabilities.

El desarrollador del Agent externo solo implementa la función de negocio; todo el arnés (serialización, manejo de errores, reintentos, logging estructurado) viene generado.

---

## 5. Diferencia Agent vs Provider

| | Provider | Agent |
|---|---|---|
| Cardinalidad | Dominio completo, muchas operaciones | Tarea única o pequeño conjunto cohesivo |
| Lógica de negocio | Sí, completa | No — ejecuta, no decide |
| Estado | Puede mantener (vía Driver) | Idealmente stateless |
| Runtime | .NET canónico | Cualquiera |
| Invocación | Vía interfaz del dominio | Vía `IAgent<,>` |

Un Provider **usa** Agents; un Agent no implementa Providers.

---

## 6. Casos típicos (genéricos, no verticales)

- Pipelines de procesamiento (imagen, audio, texto) en Python.
- Tareas numérico-críticas en Rust.
- Scripts de integración one-shot (shell, Node).
- Watchdogs y daemons.
- Invocación de modelos IA/ML.
- Tools expuestos a MCP servers.
- Agents de scraping, parsing, normalización.

---

## 7. Reglas invariantes

1. **Cualquier lenguaje permitido.** Restringir al polyglot va contra el propósito.
2. **Siempre tipado por codegen.** No existe "invocación libre de string" desde .NET.
3. **Siempre invocado vía Wire** (directo o vía Bridge). No hay pipes ad-hoc entre Host y Agent.
4. **Aislamiento de fallo.** Un Agent que muere no tumba el Host.
5. **Observable.** Telemetría por invocación: duración, tamaño input/output, resultado, errores.

---

## 8. Qué no es

- **No es un Driver.** Driver sirve a un Provider del dominio; Agent ejecuta una tarea independiente.
- **No es un worker genérico** tipo `BackgroundService`. `BackgroundService` de ASP.NET puede ser el *hospedador* de un Agent .NET in-proc, pero la primitiva conceptual es el Agent.
- **No es un microservicio.** Un microservicio típicamente es Host propio; un Agent es tarea invocable.
