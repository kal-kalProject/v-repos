# Router en .NET

> **Rol.** Servicio transversal que resuelve rutas sobre el Scope. No es Provider; es infraestructura del Host.
>
> **Par operativo:** [`19-scope.md`](19-scope.md).

---

## 1. Qué es en concreto

Router es un **servicio del Host** que, dado un Scope (o un patrón de Scope) y una operación, resuelve:

1. **Qué Provider** atiende la operación.
2. **Qué Driver** es el activo según Capabilities + Scope.
3. **En qué nodo del cluster** se ejecuta si la topología es distribuida.
4. **Qué transporte** (in-proc, HTTP, IPC) se usa para invocar.

Una consulta al Router es tipo **query sobre el grafo de Providers**, análoga conceptual al `IEndpointRouter` de ASP.NET Core pero sobre el dominio, no sobre HTTP.

---

## 2. Forma del contrato

```csharp
public interface IRouter
{
    // Resolución síncrona (sin invocar)
    RouteResolution Resolve(Scope scope, string operation);

    // Query por patrón
    IReadOnlyList<RouteResolution> Query(ScopePattern pattern, string? operation = null);

    // Invocación tipada (delegada a ProviderRuntime)
    Task<TOut> InvokeAsync<TIn, TOut>(
        Scope scope,
        string operation,
        TIn input,
        CancellationToken ct);
}

public sealed record RouteResolution(
    Scope                 TargetScope,
    ProviderRegistration  Provider,
    DriverRegistration    Driver,
    NodeRef?              Node,
    TransportRef          Transport);
```

Convenciones fijadas:

- **Query separada de Invoke.** Se puede preguntar "qué resolvería esto" sin ejecutar.
- **Patrones de Scope** — `inventory.skus.byCode(?)` para buscar coincidencias.
- **Resultados inspeccionables** — el dev puede ver la ruta elegida en tooling.

---

## 3. Runtime

- Construido en arranque del Host desde el grafo descubierto por atributos.
- Mantiene índices: `{scopePath → providers}`, `{operation → handlers}`, `{capabilities → drivers}`.
- En cluster, consulta al Master o a un registro compartido para `NodeRef`.
- Resolución típica O(log n) sobre el índice, sin reflection en camino caliente.

El Router es consultado por:

- El pipeline del Host en la etapa **Routing** ([`16-host.md §3`](16-host.md)).
- Agents o Providers que necesitan invocar otros Providers dinámicamente.
- Tooling de desarrollo y admin UI para explorar el grafo.

---

## 4. Relación con Scope y con Provider

```
Consumidor
   │ scope + operation
   ▼
 Router
   │ encuentra Provider registrado para (scope, operation)
   │ consulta ProviderRuntime por Driver activo según Capabilities
   │ decide nodo y transporte
   ▼
Provider.Operation(input)
   └─ Driver.Execute(...)
```

El consumidor **no** sabe qué Provider, qué Driver ni qué nodo se resolvió. Solo ve la respuesta.

---

## 5. Proyección vía codegen

- El cliente .NET tipado puede invocar vía Router con autocompletado del Scope y de las operaciones.
- Los clientes TS/Rust reciben una API Router paralela con los mismos índices proyectados, ajustados al protocolo Wire.
- `v-gen` puede emitir un **mapa estático** del grafo (qué operaciones existen, qué scopes las soportan) para tooling offline.

---

## 6. Reglas invariantes

1. **Router no decide lógica de negocio.** Solo localiza.
2. **Idempotente.** La misma consulta resuelve lo mismo dentro de un estado de cluster dado.
3. **Reproducible.** La resolución elegida es log-eable y reproducible en diagnóstico.
4. **Transparente al consumidor.** Nunca se expone el `RouteResolution` al dominio.
5. **Extensible vía Extensions.** Una Extension puede introducir nuevos Providers/operaciones que el Router absorbe en caliente.

---

## 7. Qué no es

- **No es un Provider.** Es infraestructura.
- **No es un router HTTP.** Un router HTTP es detalle del driver HTTP de Wire; Router opera sobre dominio.
- **No es un service mesh.** Un mesh es la capa de red sobre la que corre Wire; Router es semántica de dominio.
- **No es configurable con reglas de negocio.** Si empiezan a aparecer reglas de negocio en Router, el dominio está mal modelado.

---

## 8. Casos de uso

- **Invocación dinámica.** Un Provider orquestador llama operaciones en un conjunto de Providers que conoce por Scope pattern.
- **Admin explorer.** Un panel en el shell ([`21-extension.md`](21-extension.md)) que muestra el grafo completo de Providers/operaciones/drivers/nodos.
- **Diagnóstico.** "Por qué esta operación fue a este Driver" — Router devuelve la cadena de decisión.
- **Tests end-to-end.** Validan que una operación declarada resuelve a lo esperado en un deploy configurado.
