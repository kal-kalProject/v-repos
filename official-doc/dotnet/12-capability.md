# Capability en .NET

> **Rol.** Contrato dinámico entre Provider y Driver. El Provider declara lo que **necesita**; el Driver declara lo que **ofrece**.
>
> **Contrapartes:** [`10-provider.md`](10-provider.md), [`11-driver.md`](11-driver.md).

---

## 1. Qué es en concreto

Una Capability es un **identificador tipado** — típicamente una constante `static readonly` de tipo `Capability` — que nombra una **propiedad no funcional** que un Driver puede o no poseer.

Ejemplos canónicos:

- `Caps.Transactions`
- `Caps.OptimisticConcurrency`
- `Caps.PessimisticLocks`
- `Caps.BulkInsert`, `Caps.BulkUpsert`, `Caps.BulkDelete`
- `Caps.ChangeStream`
- `Caps.ReadReplicas`
- `Caps.StrongConsistency`, `Caps.EventualConsistency`
- `Caps.GeoReplication`

Las Capabilities no son métodos, no son flags booleanos sueltos, no son interfaces adicionales — son **identificadores** que ambas partes comparten.

---

## 2. Forma del contrato

```csharp
public readonly record struct Capability(string Id, string? Category = null);

public static class Caps
{
    public static readonly Capability Transactions = new("tx");
    public static readonly Capability OptimisticConcurrency = new("tx.optimistic");
    public static readonly Capability BulkUpsert = new("bulk.upsert");
    public static readonly Capability ChangeStream = new("stream.change");
}

// En el Provider: declara capabilities requeridas por operación.
[VortechOperation(Kind = OperationKind.Command,
    RequiredCapabilities = new[] { nameof(Caps.Transactions) })]
Task<Sku> UpsertSkuAsync(Sku sku, CancellationToken ct);

// En el Driver: declara lo que ofrece.
[VortechDriverImpl(
    Provides      = new[] { Caps.Transactions, Caps.BulkUpsert },
    LacksExplicit = new[] { Caps.ChangeStream })]
```

---

## 3. Runtime

- El `ProviderRuntime` construye en arranque la **matriz `{driver × capability}`**.
- Cada invocación del Provider valida las Capabilities requeridas contra la matriz y elige Driver.
- Si **ningún Driver activo** cumple todas las requeridas, error estructurado (`CapabilityMismatchException`) con diagnóstico: qué faltó, qué Drivers había, qué tenía cada uno.
- Las Capabilities son observables: se exponen como metadato vía Wire para que clientes puedan descubrir qué soporta el Provider en el deploy actual.

---

## 4. Degradación graceful

Capabilities habilitan dos patrones distintos:

### 4.1 Obligatoria

Operación marcada con `Required`. Si no hay driver que la ofrezca, la operación **falla** en arranque (validación) o en invocación (runtime) — nunca silencia.

### 4.2 Opcional

Operación marcada con `Optional` + camino alternativo:

```csharp
[VortechOperation(
    OptionalCapabilities = new[] { nameof(Caps.BulkUpsert) })]
Task<int> UpsertManyAsync(IReadOnlyList<Sku> skus, CancellationToken ct);
```

El Provider implementa la lógica:

```csharp
if (driver.Has(Caps.BulkUpsert))
    return await driver.BulkUpsertAsync(skus, ctx, ct);
else
    return await UpsertOneByOneAsync(skus, ctx, ct);
```

Este patrón sale del código del Provider — el runtime solo expone `driver.Has(cap)`.

---

## 5. Proyección vía codegen

- `v-gen` emite para cada cliente (TS, Rust, …) la **matriz de Capabilities disponibles** por deploy.
- Un cliente TS puede preguntar `provider.supports(Caps.ChangeStream)` y actuar distinto — p.ej. subscribirse a stream si sí, hacer polling si no.
- La documentación auto-generada lista Capabilities por Provider y por Driver — compliance/auditoría natural.

---

## 6. Reglas invariantes

1. **Identificadores estables.** Una Capability publicada no cambia de nombre ni de significado; si cambia su significado, es una Capability nueva.
2. **Granularidad razonable.** No una Capability por método; una Capability por propiedad no funcional significativa.
3. **Declaración explícita en ambos lados.** Provider dice qué necesita; Driver dice qué ofrece. El Host valida.
4. **Categorías** (opcional) para agrupar (`tx.*`, `stream.*`, `bulk.*`) — ayuda al codegen y la documentación.

---

## 7. Qué no es

- **No es feature flag.** Feature flags controlan lógica de aplicación; Capabilities describen propiedades del Driver.
- **No es una interfaz adicional.** Poner `ITransactional`, `IBulkWrite`, `IStreamable` y hacer down-cast es el anti-patrón; Capability sustituye esto con declaración de datos.
- **No es un tag libre.** Se define centralizado para evitar explosion de nombres idiosincráticos.
