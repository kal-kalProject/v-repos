# Driver en .NET

> **Rol.** Implementación oculta que sirve a un Provider. No se expone, no se inyecta al consumidor, no se invoca directamente.
>
> **Contraparte:** [`10-provider.md`](10-provider.md). Contrato dinámico con el Provider: [`12-capability.md`](12-capability.md).

---

## 1. Qué es en concreto

Un Driver es una **clase C#** que:

1. Implementa la **interfaz-Driver** correspondiente a un Provider (no la interfaz pública del Provider).
2. Declara **qué Capabilities ofrece** y **cuáles no**.
3. Ejecuta operaciones físicas sobre un backend concreto (SQL Server, PostgreSQL, MongoDB, filesystem, COM, HTTP API externa, …).
4. Es **intercambiable**: múltiples Drivers pueden servir al mismo Provider; el `ProviderRuntime` elige en cada operación.

---

## 2. Forma del contrato

```csharp
// Interfaz de driver (no confundir con interfaz del Provider)
[VortechDriver(Provider = typeof(IInventoryProvider))]
public interface IInventoryDriver
{
    Task<Sku?> FetchSkuAsync(SkuId id, DriverContext ctx, CancellationToken ct);
    Task<Sku>  PersistSkuAsync(Sku sku, DriverContext ctx, CancellationToken ct);
    IAsyncEnumerable<StockChange> SubscribeStockAsync(SkuId id, DriverContext ctx, CancellationToken ct);
}

// Implementación concreta
[VortechDriverImpl(
    Name = "inventory.sqlserver",
    Provides = new[] { Caps.Transactions, Caps.OptimisticConcurrency, Caps.BulkUpsert },
    LacksExplicit = new[] { Caps.ChangeStream })]
public sealed class SqlServerInventoryDriver : IInventoryDriver
{
    // ...
}
```

Convenciones fijadas:

- **Par interfaz-Driver + implementación.** La interfaz vive en `*.Contracts`; la implementación en un package `*.Drivers.<backend>`.
- **`DriverContext`** es parámetro obligatorio — transporta scope, tenant, tx activa, telemetría, cancellation fallback.
- **Capabilities declaradas explícitamente.** Lo no declarado se considera no soportado; no hay suposiciones.
- **Sin lógica de dominio.** Si un Driver valida reglas de negocio, la validación está mal colocada.

---

## 3. Runtime

- **Se registra por DI del Host**, pero nunca se resuelve por el consumidor.
- El `ProviderRuntime` mantiene el registro `{providerInterface → driversDisponibles}` y, para cada operación invocada en el Provider, aplica la política de selección (ver §4).
- Un Host puede tener **múltiples Drivers del mismo Provider activos simultáneamente** — por ejemplo SQL Server para tenants A/B, PostgreSQL para tenants C/D, MongoDB para tenants perf-críticos.
- El Driver puede declarar preferencias de scope (tenant-X solo, regional, fallback).

---

## 4. Selección de Driver

Política estándar implementada en el runtime:

1. **Scope-match.** Si el scope activo especifica driver explícito (p.ej. por tenant), se usa ese.
2. **Capability-match.** De los Drivers elegibles, se filtran los que declaran las Capabilities requeridas por la operación.
3. **Cost / preferencia.** Entre los restantes, política declarativa: el Driver con menor coste, o el designado como primario.
4. **Fallback.** Si ninguno encaja, error explícito de capability — no se degrada silenciosamente.

La política es configurable por Provider pero tiene default razonable.

---

## 5. Proyección vía codegen

- `v-gen` emite **scaffolding** para nuevos Drivers cuando se añade una operación al Provider (actualiza la interfaz-Driver).
- El desarrollador solo rellena la lógica física; la firma, la serialización de parámetros, el mapeo de errores a `DomainError` y la integración con `DriverContext` se generan.

---

## 6. Reglas invariantes

1. **Cero consumidores directos.** Nadie fuera del `ProviderRuntime` resuelve un Driver.
2. **Cero lógica de negocio.** Un Driver con `if (sku.Price < 0) throw …` está mal modelado.
3. **Errores se traducen** a `DomainError` en la frontera Driver→Provider. El Provider no conoce `SqlException`, `MongoException`, etc.
4. **Capabilities no declaradas = no soportadas.** No hay "puede que funcione".

---

## 7. Qué no es

- **No es un Repository.** Repository asume CRUD; Driver es más amplio (puede streamear, transaccionar, bulk, subscribir).
- **No es un gateway a una API externa.** Para API externas existen Bridges ([`15-bridge.md`](15-bridge.md)) cuando el sistema destino vive en runtime ajeno; un Driver es para backends donde el protocolo es directo desde .NET.
- **No se compone jerárquicamente.** Si un Driver necesita llamar a otro, lo hace vía Provider, no vía acoplamiento directo.

---

## 8. Inspiración

- **Dapper** — patrones de mapeo, parámetros, conversión tipada, reflection-minimal. Leído como código, no adoptado como dependencia.
- **ADO.NET provider model** — raíz histórica de la separación interfaz-abstracta / implementación concreta.
