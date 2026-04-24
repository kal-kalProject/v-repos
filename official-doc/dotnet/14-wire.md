# Wire en .NET

> **Rol.** API unificada de comunicación entre partes de la plataforma. Agnóstica del transporte.
>
> **Relacionado:** [`15-bridge.md`](15-bridge.md) — cómo Wire atraviesa runtimes ajenos.

---

## 1. Qué es en concreto

Wire es una **API**, no un transporte. En .NET se materializa como:

1. **Contrato canónico** — tipos C# que describen mensajes (request, response, event, stream frame), correlación, headers, errores, metadatos de operación.
2. **Runtime** — infraestructura que codifica mensajes, los entrega por un transporte concreto, recibe respuestas, correlaciona, maneja timeouts, retries, idempotencia, backpressure.
3. **Drivers de transporte** — implementaciones sobre HTTP, WebSocket, gRPC-style pipes, colas, IPC, in-process, cualquier medio físico.

El contrato es **el mismo** cruce cliente↔servidor, Provider↔Agent, Host↔Host, incluyendo cruces cross-lenguaje vía proyección generada.

---

## 2. Forma del contrato

```csharp
public readonly record struct WireMessageId(Guid Value);

public abstract record WireEnvelope
{
    public required WireMessageId Id { get; init; }
    public WireMessageId? CorrelationId { get; init; }
    public required string Operation { get; init; }
    public required IReadOnlyDictionary<string, string> Headers { get; init; }
    public DateTimeOffset CreatedAt { get; init; }
    public WireScope? Scope { get; init; }
}

public sealed record WireRequest<T>  : WireEnvelope { public required T Payload { get; init; } }
public sealed record WireResponse<T> : WireEnvelope { public required WireResult<T> Result { get; init; } }
public sealed record WireFrame<T>    : WireEnvelope { public required T Payload { get; init; } public required bool IsLast { get; init; } }
public sealed record WireError       : WireEnvelope { public required DomainError Error { get; init; } }
```

Convenciones fijadas:

- **Codificación canónica** — serialización binaria + JSON fallback; elegida por transporte.
- **Correlación mediante `CorrelationId`** — obligatoria en respuestas y stream frames.
- **Headers** — cadena-cadena, reservados con prefijo `v-` (`v-tenant`, `v-trace`, `v-retry-count`).
- **Scope embebido** — cada request transporta el Scope activo ([`19-scope.md`](19-scope.md)).
- **Errores tipados** — `DomainError` canónico, no excepciones crudas del runtime.

---

## 3. Runtime

El runtime Wire en .NET expone dos superficies:

### 3.1 Superficie servidor
- Se integra con el pipeline de ASP.NET Core del Host como conjunto de endpoints (HTTP, WS, gRPC-like).
- Enruta cada mensaje a la operación del Provider correspondiente.
- Aplica middleware Wire: auth, scope, rate-limit, idempotencia, trace.

### 3.2 Superficie cliente
- `IWireClient` tipado, consumido desde C# cliente, Agents .NET, o como base para proxies auto-generados.
- Gestiona conexión, reconexión, backoff, timeout, retries según políticas.

Ambas superficies son **código propio** sobre BCL + ASP.NET Core ([ver cierre §1](01-cierre-decisiones-dotnet.md)).

---

## 4. Drivers de transporte

Wire aplica la misma primitiva Provider/Driver a sí mismo. `ITransportProvider` es la fachada; `ITransportDriver` la implementación:

| Driver | Uso típico |
|---|---|
| HTTP | Cross-proceso estándar, internet, serverless. |
| WebSocket | Streams, eventos push, conexiones persistentes. |
| gRPC-style sobre HTTP/2 | Alto throughput, stream bidireccional. |
| IPC (named pipes / unix sockets) | Host ↔ Agent local. |
| In-process | Host ↔ Agent in-proc .NET sin overhead. |
| Queue | Entrega asíncrona durable. |

Elegir transporte es **configuración**, no refactor. El mismo Provider responde al mismo mensaje sin importar qué driver lo entregó.

---

## 5. Proyección vía codegen

- **Clientes TS, Rust, Python**, con tipos proyectados desde los contratos del Provider, son generados.
- Los clientes hablan exactamente el mismo protocolo binario/JSON que el Host; no hay dos especificaciones.
- El stub generado para un Agent no-.NET incluye el arnés Wire completo (codificación, correlación, errores).

---

## 6. Reglas invariantes

1. **Un contrato, múltiples transportes.** Cambiar transporte no debe tocar código de dominio.
2. **Errores atraviesan Wire como `DomainError` serializado**, no como excepciones.
3. **Correlación obligatoria** para responses y streams.
4. **Scope viaja en el sobre**, no como parámetro de operación.
5. **Idempotencia declarada** por operación; el runtime deduplica cuando aplica.
6. **Observabilidad por construcción** — cada mensaje genera evento de pipeline.

---

## 7. Qué no es

- **No es HTTP.** HTTP es solo un transporte posible.
- **No es JSON-RPC.** Toma ideas del patrón pero la forma es propia.
- **No es gRPC.** gRPC puede ser transporte; el contrato no es proto.
- **No es una librería de red.** Es el contrato de comunicación de la plataforma.

---

## 8. Inspiración

- **ASP.NET Core Minimal APIs y middleware** — modelo de pipeline.
- **MassTransit / NServiceBus** — ideas sobre correlación, sagas, sobres.
- **SignalR** — patrones de stream y reconexión.

Todo leído; nada adoptado como dependencia.
