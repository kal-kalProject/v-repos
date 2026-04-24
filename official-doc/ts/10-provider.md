# Provider en TypeScript / frontend

> **Rol.** En el frontend, Provider tiene **dos clases**: proxies de Providers remotos del backend, y Providers locales del cliente. Misma forma de pensar; misma DI; misma inspección de Capabilities.
>
> **Espejo del backend:** [`../dotnet/10-provider.md`](../dotnet/10-provider.md).

---

## 1. Las dos clases de Provider en frontend

### 1.1 Provider remoto (proxy generado)

- Implementación generada por `v-gen` desde el contrato C#.
- Vive en `@vortech/sdk` o en sub-package por dominio (p. ej. `@vortech/sdk-inventory`).
- Cada operación del Provider C# se traduce a una llamada `IWireClient`.
- El consumidor lo inyecta como cualquier servicio; no ve Wire.

### 1.2 Provider local (escrito en TS)

- Vive en el frontend porque su dominio es del cliente.
- Ejemplos canónicos:
  - `INavigationProvider` — historial, deep-links, breadcrumbs.
  - `IThemeProvider` — tema activo derivado de Identity + preferencia.
  - `ILayoutProvider` — estado del Workbench (sidebar abierto, panel posición, vista activa).
  - `IShellPreferencesProvider` — atajos, settings UI.
  - `ICacheProvider` / `ILocalStateProvider` — estado offline, optimistic updates.
  - `IClipboardProvider`, `INotificationProvider` (toasts), `IDialogProvider`.
- Tienen **Drivers reales** ([`11-driver.md`](11-driver.md)) y **Capabilities declaradas** ([`12-capability.md`](12-capability.md)).

---

## 2. Forma del contrato

### 2.1 Provider remoto (vista del consumidor)

```ts
// Generado por v-gen desde C# IInventoryProvider
export interface IInventoryProvider {
  getSku(id: SkuId): Promise<Sku>;
  upsertSku(sku: Sku): Promise<Sku>;
  watchStock(id: SkuId): AsyncIterable<StockChange>;
}

export const IInventoryProvider = createToken<IInventoryProvider>('IInventoryProvider');
```

```ts
// Componente
class SkuView {
  private readonly inv = inject(IInventoryProvider);
  readonly sku = derivedAsync(() => this.inv.getSku(this.skuId()));
}
```

El componente **nunca** ve Wire. La interfaz es la misma que vio el dev backend en C#.

### 2.2 Provider local (definición a mano)

```ts
@Provider({ domain: 'shell.theme' })
export interface IThemeProvider {
  readonly active: Atom<Theme>;
  setActive(theme: ThemeId): Promise<void>;
  readonly available: Atom<readonly Theme[]>;
}

export const IThemeProvider = createToken<IThemeProvider>('IThemeProvider');
```

Convenciones fijadas:

- **Tokens tipados** vía `createToken<T>` — nunca strings sueltos.
- **Atoms en el contrato** cuando el estado es observable (típico en Providers locales).
- **Promesas + `AsyncIterable`** para operaciones async/streaming (típico en Providers remotos).
- **Sin `RxJS`**. Todo lo reactivo es atom.

---

## 3. Runtime

### 3.1 Resolución por DI

- El Injector de `@vortech/core/di` resuelve Providers por token.
- Scopes DI siguen el árbol del shell: shell-scope, view-scope, request-scope.
- Ciclo de vida: típicamente singleton para Providers locales globales (Theme, Navigation); scoped por vista o por extensión cuando aplica.

### 3.2 Resolución de Driver

- Para Provider local con múltiples Drivers, la selección sigue el modelo del backend: scope-match → capability-match → cost.
- Un `IPersistenceProvider` puede tener `IndexedDbDriver`, `LocalStorageDriver`, `MemoryDriver` — el runtime elige según Capabilities (`Persistent`, `CrossTab`, `Encrypted`, `Quota`).

### 3.3 Provider remoto: Scope embebido

- Cada llamada de un Provider remoto **lee el `ScopeContext` activo** ([`19-scope.md`](19-scope.md)) y lo embebe en el `WireRequest`.
- El componente no pasa el Scope manualmente.

---

## 4. Inspección y Capabilities

```ts
// Provider expone Capabilities consultables
if (this.inv.has(Caps.BulkUpsert)) {
  // mostrar botón "Importar CSV"
} else {
  // ocultar
}
```

- Para Providers remotos, las Capabilities vienen embebidas en el handshake Wire o en metadata del proxy.
- Para Providers locales, las Capabilities vienen del Driver activo.

---

## 5. Reglas invariantes

1. **Cero `fetch` / `WebSocket` / `axios` en componentes.** Solo se habla con Providers.
2. **Cero estado mutable suelto.** Todo estado expuesto por un Provider local es un atom.
3. **Cero Scope manual** en llamadas a Providers remotos. Lo gestiona el runtime Wire.
4. **Tokens tipados siempre.** No hay `inject('IInventory')`.
5. **Errores de dominio tipados.** Un Provider remoto entrega `DomainError` deserializado, no `Response.status`.

---

## 6. Qué no es

- **No es un servicio Angular.** No depende de framework externo.
- **No es un facade de `fetch`.** El Provider remoto **es** el dominio en TS; el transporte va por debajo.
- **No es un store global.** Un Provider puede exponer estado, pero su responsabilidad es el dominio, no el almacenamiento.

---

## 7. Inspiración

- **Angular services + DI tokens** — modelo de inyección por token tipado.
- **trpc** — patrón de cliente tipado-end-to-end derivado del backend.
- **MobX stores / Pinia stores** — exposición de estado reactivo desde una superficie de servicio.

Leídos como fuente; no adoptados como dependencia ([`01-cierre-decisiones-ts.md §6`](01-cierre-decisiones-ts.md)).
