# Provider en .NET

> **Rol.** Fachada pública de un dominio. Contiene lógica de negocio completa, agnóstica del driver que la sirve.
>
> **Primitiva canónica:** [`00-responsabilidad-de-dotnet.md §3.1`](00-responsabilidad-de-dotnet.md). Sustrato: [§1 del cierre](01-cierre-decisiones-dotnet.md).

---

## 1. Qué es en concreto

Un Provider en .NET es una **clase C#** que:

1. Expone la **superficie pública completa** del dominio (operaciones, consultas, eventos).
2. Contiene **lógica de negocio real** — validación, orquestación, invariantes, transacciones lógicas.
3. Delega operaciones físicas en uno o varios **Drivers** que cumplen sus Capabilities requeridas.
4. **Nunca** expone el Driver ni su tipo concreto.

La interfaz pública va en una assembly contratos (`*.Contracts`); la implementación Provider va en una assembly runtime (`*.Providers`). Cliente y transporte consumen únicamente la assembly de contratos.

---

## 2. Forma del contrato

```csharp
// *.Contracts
[VortechProvider(Domain = "inventory")]
public interface IInventoryProvider
{
    [VortechOperation(Kind = OperationKind.Query)]
    Task<Sku> GetSkuAsync(SkuId id, CancellationToken ct);

    [VortechOperation(Kind = OperationKind.Command, Idempotent = true)]
    Task<Sku> UpsertSkuAsync(Sku sku, CancellationToken ct);

    [VortechOperation(Kind = OperationKind.Stream)]
    IAsyncEnumerable<StockChange> WatchStockAsync(SkuId id, CancellationToken ct);
}
```

Convenciones fijadas:

- **Un atributo `VortechProvider`** marca la interfaz como contrato de Provider.
- **`VortechOperation`** describe la naturaleza de cada operación (query / command / stream / subscription) y metadatos (idempotencia, autenticación requerida, scope requerido, capabilities requeridas).
- **Tipos expuestos son POCOs inmutables** con `record` o `readonly record struct` — proyectables a TS/Rust/SQL sin ambigüedad.
- **Async por defecto.** `Task<T>`, `ValueTask<T>`, `IAsyncEnumerable<T>`. Versiones sync solo si el dominio lo exige.
- **`CancellationToken` obligatorio** en toda operación no trivial.

---

## 3. Runtime

El Provider vive en el contenedor DI del Host:

- Registro único por interfaz de contrato.
- Ciclo de vida típico: **singleton** para lógica stateless; **scoped** si depende de unidad de trabajo por request.
- Inyecta sus Drivers vía DI: el `ProviderRuntime` (infraestructura del Host) elige el Driver según Capabilities declaradas, scope activo, y política de selección — ver [`12-capability.md`](12-capability.md).
- Publica eventos al pipeline del Host ([`16-host.md`](16-host.md)) para telemetría, auditoría y trazas.

---

## 4. Proyección vía codegen

Desde la interfaz marcada, `v-gen` emite:

| Target | Qué se genera |
|---|---|
| **TS cliente** | Interfaz + cliente Wire tipado. |
| **Rust FFI** | Trait + proxy Wire si algún Agent lo requiere. |
| **OpenAPI** | Endpoint por operación cuando el driver HTTP de Wire está montado. |
| **AsyncAPI** | Streams y subscripciones. |
| **Docs** | Referencia auto-generada. |
| **C# adicional** | Proxies Wire, registros DI, handlers de pipeline. |

La interfaz C# es la **única fuente de verdad**. Cualquier ajuste al contrato se hace aquí; todo lo demás se regenera.

---

## 5. Reglas invariantes

1. **Un Provider no importa tipos de Driver.** Solo ve sus Capabilities abstractas y los POCOs del dominio.
2. **La validación del dominio vive en el Provider**, no en el Driver. El Driver ejecuta; el Provider decide si procede.
3. **Las transacciones lógicas se coordinan en el Provider.** El Driver provee la primitiva transaccional vía Capability si la tiene; el Provider orquesta.
4. **Errores del dominio son tipos** — `Result<T, DomainError>` o jerarquía de excepciones de dominio. Nunca se propagan errores crudos del Driver.

---

## 6. Qué no es

- **No es un servicio CRUD.** Un Provider con solo getters y setters es señal de que el dominio aún no se modeló.
- **No es una interfaz de repositorio.** Repositorio es concepto de persistencia; Provider es concepto de dominio.
- **No es un facade de múltiples servicios.** Si un Provider coordina varios dominios, falta un dominio padre o falta un Agent orquestador.
- **No se instancia manualmente.** Solo vía DI del Host.

---

## 7. Inspiración

- **MediatR** — modelo de operación tipada con handler dedicado. Tomado el patrón mental; implementado propio sin dependencia.
- **ASP.NET Core Endpoints** — el estilo de metadatos declarativos por operación.

Ver política completa en [`01-cierre-decisiones-dotnet.md §3`](01-cierre-decisiones-dotnet.md).
