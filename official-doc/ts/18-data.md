# Data en TypeScript / frontend

> **Rol.** El frontend **consume** dominios de datos vía Provider proxies. No implementa Data; usa proyecciones generadas desde el contrato C#.
>
> **Espejo del backend:** [`../dotnet/18-data.md`](../dotnet/18-data.md).

---

## 1. Cómo aparece en el frontend

### 1.1 Tipos de entidad

Para cada `[VortechEntity]` C#, `v-gen` emite tipo TS:

```ts
// Generado
export interface Sku {
  readonly id: SkuId;
  readonly code: string;
  readonly price: Money;
  readonly categoryId: CategoryId;
  readonly audit: AuditStamp;
}
```

- **Inmutables.** `readonly` por campo.
- **Branded keys.** `SkuId`, `CategoryId` son tipos opacos, no `string` sueltos.
- **Validador / type guard** opcional, también generado.

### 1.2 Provider proxy

```ts
export interface IInventoryDataProvider {
  find(id: SkuId): Promise<Sku | null>;
  upsert(sku: Sku): Promise<Sku>;
  query(filter: SkuFilter): AsyncIterable<Sku>;
  bulkUpsert(skus: readonly Sku[]): Promise<number>;
  beginTx(): Promise<IDataTransaction>;
}
```

Mismo modelo que [`10-provider.md §1.1`](10-provider.md). Detrás va Wire.

---

## 2. Patrones típicos en componente

### 2.1 Lectura reactiva

```ts
class SkuDetail {
  private readonly data = inject(IInventoryDataProvider);
  readonly id = input<SkuId>();
  readonly sku = derivedAsync(() => this.data.find(this.id()));
}
```

### 2.2 Lista paginada

```ts
class SkuList {
  private readonly data = inject(IInventoryDataProvider);
  readonly filter = atom<SkuFilter>({ category: null });
  readonly skus = atomCollectionFromAsyncIterable(() =>
    this.data.query(this.filter()));
}
```

### 2.3 Mutación con optimistic update

```ts
async save(sku: Sku) {
  this.cache.put(sku);                           // optimistic
  try {
    const saved = await this.data.upsert(sku);
    this.cache.put(saved);
  } catch (e) {
    this.cache.revert(sku.id);
    this.notify.error(e);
  }
}
```

El cache es un Provider local (`ICacheProvider`) con su Driver — separado del Provider de datos remoto.

---

## 3. Capabilities visibles

El Provider proxy expone Capabilities del Driver activo del backend:

```ts
if (this.data.has(Caps.BulkUpsert))     // mostrar "Importar CSV"
if (this.data.has(Caps.ChangeStream))   // mostrar live indicator
if (this.data.has(Caps.Transactions))   // habilitar batch edit
```

Si el backend está sirviendo desde un Bridge MSAccess que no tiene `Caps.ChangeStream`, la UI de "actualización en vivo" se oculta automáticamente.

---

## 4. Cache local

`ICacheProvider` es Provider local con Drivers ([`11-driver.md`](11-driver.md)):

- `MemoryCacheDriver` — sesión actual.
- `IndexedDbCacheDriver` — persistente entre sesiones.
- `LruCacheDriver` — bound por tamaño.

Política de invalidación:

- Por **evento de dominio** que emite el backend (Provider remoto puede streamear cambios).
- Por **TTL** declarado por entidad.
- Por **Scope change** — al cambiar tenant, se invalida lo que dependa del tenant anterior.

El cache **no es** parte de Data; es Provider separado consumido por componentes que necesitan optimismo o offline.

---

## 5. Reglas invariantes

1. **Cero SQL en frontend.** El frontend no construye queries SQL ni formula filtros como strings.
2. **Cero acceso directo a DB.** Aunque IndexedDB exista localmente, su uso vive detrás de un Provider local (cache, draft, offline queue), no como sustituto del Provider remoto.
3. **Tipos branded.** Nunca `string` para llaves.
4. **Mutaciones tipadas.** El Provider proxy garantiza la forma; el componente no construye payloads ad-hoc.
5. **Errores de dominio tipados.** `ConcurrencyConflictError`, `ValidationError`, `NotFoundError` — no `Response.status`.

---

## 6. Qué no es

- **No es un ORM cliente.** No mantiene grafo, no traquea cambios al estilo EF.
- **No es un cache global.** Hay cache, pero es una primitiva separada.
- **No es la vista de tabla.** La UI tabular vive en `@vortech/components`; Data es el contrato de dominio.

---

## 7. Inspiración

- **trpc + zod** — modelo de tipos compartidos cliente/servidor.
- **TanStack Query / SWR** — patrones de stale-while-revalidate, invalidation, optimistic.
- **Apollo Client** — modelo de cache normalizado (idea, no se adopta).

Leídos como fuente; no adoptados como dependencia.
