# Data en .NET

> **Rol.** Aplicación ejemplar del modelo universal Provider/Driver/Bridge a un dominio: la persistencia.
>
> **Propósito doble.** Resuelve la persistencia real de la plataforma **y** sirve como plantilla para construir cualquier otro dominio.

---

## 1. Qué es en concreto

Data en .NET es:

1. **Un Provider** — `IDataProvider<TEntity>` por entidad o agregado, con lógica de dominio de persistencia (transacciones lógicas, unidad de trabajo, invariantes de persistencia, cache).
2. **Múltiples Drivers** — SQL Server, PostgreSQL, SQLite, MongoDB, filesystem, S3/Blob, memoria.
3. **Bridges** cuando el backend vive en runtime ajeno — MSAccess COM, bases propietarias vía SDK nativo.
4. **Entidades** — POCOs C# con atributos Vortech que describen campos, llaves, relaciones, validaciones.

Desde Data se proyecta a SQL (DDL), TS (DTOs), Rust (FFI), JSON Schema (validación), OpenAPI (superficie HTTP).

---

## 2. Forma del contrato

```csharp
[VortechEntity(Table = "skus")]
public sealed record Sku
{
    [VortechKey]
    public required SkuId Id { get; init; }

    [VortechColumn(MaxLength = 64)]
    public required string Code { get; init; }

    [VortechColumn]
    public required Money Price { get; init; }

    [VortechRelation(To = typeof(Category))]
    public required CategoryId CategoryId { get; init; }

    [VortechAudit]
    public AuditStamp Audit { get; init; } = default!;
}

[VortechProvider(Domain = "inventory.data")]
public interface IInventoryDataProvider
{
    Task<Sku?> FindAsync(SkuId id, CancellationToken ct);
    Task<Sku>  UpsertAsync(Sku sku, CancellationToken ct);
    IAsyncEnumerable<Sku> QueryAsync(SkuFilter filter, CancellationToken ct);
    Task<int> BulkUpsertAsync(IReadOnlyList<Sku> skus, CancellationToken ct);
    Task<IDataTransaction> BeginTxAsync(CancellationToken ct);
}
```

Convenciones fijadas:

- **Entidades son `record` inmutables.** Mutación vía `with`.
- **Keys tipadas** (`SkuId`, `CategoryId`) — nunca `Guid`/`int` crudos en contratos de dominio.
- **Query tipada.** `SkuFilter` es un DTO; nunca se expone LINQ crudo del ORM, nunca SQL string.
- **Transacciones explícitas** cuando se requieren — el Provider coordina, el Driver provee la primitiva.

---

## 3. Runtime

- Los Drivers de Data son los más diversos de la plataforma. Cada uno conoce su backend.
- El Provider orquesta: cache L1 por scope, invalidación por eventos, composición transaccional entre entidades de un mismo Provider.
- Cambio de Driver de SQL Server a PostgreSQL (para un tenant dado) es configuración; el código del Provider y el consumidor no cambia.
- Bulk, streaming y subscripción se exponen como Capabilities ([`12-capability.md`](12-capability.md)).

---

## 4. Código propio, no ORM adoptado

Data se implementa en **código propio** sobre:

- **ADO.NET** nativo para drivers relacionales — `DbConnection`, `DbCommand`, `DbDataReader`.
- **Drivers oficiales del proveedor** de la base (`Microsoft.Data.SqlClient`, `Npgsql`, `MongoDB.Driver`, `System.Data.Sqlite`) — se consideran sustrato porque son "lo nativo" del backend, no librerías-abstracción.
- **System.Linq.Expressions** para traducción de `SkuFilter` tipado a SQL paramétrico.

No se adopta EF Core ni Dapper como dependencia. Dapper es **inspiración de lectura** para: manejo de parámetros, mapeo eficiente, expansión de listas, reflection mínimo. EF Core es inspiración de lectura para: modelo de tracking y cambio, inclusión de grafos, migraciones. Ver [cierre §3](01-cierre-decisiones-dotnet.md).

---

## 5. Proyección vía codegen

Desde una entidad `[VortechEntity]`, `v-gen` emite:

| Target | Qué se genera |
|---|---|
| **SQL DDL** | Tabla, índices, constraints, FKs, migración incremental vs versión previa. |
| **DTO TS** | Interfaz + type guard. |
| **DTO Rust** | Struct + serde. |
| **JSON Schema** | Validador para Wire. |
| **Mapping Driver** | Reader → entidad para cada Driver relacional, sin reflection runtime. |
| **Builder de query** | Traducción tipada `Filter → SQL/Mongo pipeline`. |
| **Admin UI** | Vistas CRUD básicas en el shell, si el vertical lo marca. |

Cambiar un campo de entidad recompila cliente, servidor, SDK, migración y admin UI a la vez.

---

## 6. Patrón plantilla para otros dominios

Cualquier otro dominio de la plataforma copia la estructura de Data:

1. Define **entidades** + atributos.
2. Define **Provider** con operaciones de dominio.
3. Implementa uno o más **Drivers**.
4. Añade **Bridges** si el backend es runtime ajeno.
5. Expone **Capabilities**.
6. Deja que codegen haga el resto.

Cuando un nuevo dominio (p.ej. pagos, inventario físico, firmas digitales, scraping) aparece, su estructura es reconocible porque replica Data.

---

## 7. Reglas invariantes

1. **La entidad es la fuente de verdad del schema.** DDL es derivado.
2. **Las migraciones son deterministas** desde el diff de entidades entre commits.
3. **Nada de SQL string en dominio.** Queries se expresan por filtros tipados.
4. **Transacciones explícitas.** No hay `autocommit` en el modelo.
5. **Audit trail opt-in por entidad.** `[VortechAudit]` añade `createdAt`, `createdBy`, `updatedAt`, `updatedBy`, `version`.
6. **Claves tipadas siempre.** Sin `Guid` sueltos en firmas públicas.

---

## 8. Qué no es

- **No es un ORM.** Un ORM mapea entre objetos y tablas; Data mapea entre **dominio** y **cualquier backend capaz**, incluyendo NoSQL, filesystem y runtimes ajenos vía Bridge.
- **No es un Repository.** Un Repository es IX de acceso a una colección; Data Provider es dominio con lógica.
- **No es un generador de schema únicamente.** Genera, pero también provee runtime completo.

---

## 9. Inspiración

- **Dapper** — patrón `DbCommand` + parámetros + mapping reflection-light.
- **EF Core** — tracking, change detection, query translator, modelo de migraciones.
- **MongoDB C# driver** — API de proyección tipada.
- **LiteDB / Marten** — modelos NoSQL sobre relacional.

Leídos como fuente; no adoptados.
