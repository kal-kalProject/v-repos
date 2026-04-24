# Driver en TypeScript / frontend

> **Rol.** Implementación oculta que sirve a un Provider local del frontend, o transporte oculto que sirve a Wire. Invisible al consumidor.
>
> **Espejo del backend:** [`../dotnet/11-driver.md`](../dotnet/11-driver.md).

---

## 1. Dos sentidos legítimos en frontend

### 1.1 Driver de Provider local

Implementa un Provider local ([`10-provider.md §1.2`](10-provider.md)) sobre un mecanismo concreto del navegador o del runtime cliente.

Ejemplos canónicos:

| Provider local | Drivers posibles |
|---|---|
| `IPersistenceProvider` | `IndexedDbDriver`, `LocalStorageDriver`, `SessionStorageDriver`, `MemoryDriver`, `OpfsDriver` |
| `INavigationProvider` | `HistoryRouteDriver`, `HashRouteDriver`, `MemoryRouteDriver` |
| `INotificationProvider` | `ToastDomDriver`, `OsNotificationDriver` (Electron/Tauri), `NoopDriver` |
| `IClipboardProvider` | `AsyncClipboardDriver`, `LegacyExecCommandDriver` |
| `IThemeProvider` | `SystemMediaQueryDriver`, `UserPreferenceDriver` |
| `ICryptoProvider` | `WebCryptoSubtleDriver`, `JsFallbackDriver` (no recomendable) |

### 1.2 TransportDriver de Wire

Implementa el transporte físico de mensajes Wire. Detallado en [`14-wire.md §4`](14-wire.md):

- `WebSocketTransportDriver`
- `HttpTransportDriver`
- `InProcessTransportDriver` (Electron/Tauri/dev local)

---

## 2. Forma del contrato

```ts
// Driver de Provider local
@Driver({ provides: 'persistence', name: 'persistence.indexeddb' })
export class IndexedDbPersistenceDriver implements IPersistenceDriver {
  static readonly capabilities = [
    Caps.Persistent,
    Caps.CrossTab,
    Caps.LargeQuota,
  ] as const;

  static readonly lacks = [
    Caps.Encrypted,
  ] as const;

  async get<T>(key: string, ctx: DriverContext): Promise<T | null> { /* ... */ }
  async set<T>(key: string, value: T, ctx: DriverContext): Promise<void> { /* ... */ }
  // ...
}
```

Convenciones fijadas:

- **Decorador `@Driver`** declara qué Provider sirve y nombre canónico.
- **`capabilities` / `lacks`** estáticos — declaración explícita.
- **`DriverContext`** parámetro obligatorio igual que en backend.
- **Sin lógica de dominio** dentro del Driver.

---

## 3. Runtime

### 3.1 Selección de Driver

Misma política que el backend ([`../dotnet/11-driver.md §4`](../dotnet/11-driver.md)):

1. Scope-match (un perfil/preferencia puede pinear un driver).
2. Capability-match.
3. Cost / preferencia.
4. Fallback explícito o error.

Implementado en `@vortech/core` como parte del `ProviderRuntime` cliente.

### 3.2 Hot-swap

A diferencia del backend, en frontend el cambio de Driver puede ocurrir **en caliente** por eventos del usuario:

- El usuario marca "no recordar mi sesión" → `IPersistenceProvider` deja de usar `IndexedDbDriver`, pasa a `MemoryDriver`.
- La app pierde permisos de notificaciones del SO → `INotificationProvider` cae de `OsNotificationDriver` a `ToastDomDriver`.

El `ProviderRuntime` cliente expone un atom con el Driver activo; los componentes que dependen de Capabilities reaccionan automáticamente.

---

## 4. Reglas invariantes

1. **Cero consumidor directo.** Componentes y otros Providers nunca importan un Driver concreto.
2. **Cero lógica de dominio.** Un Driver con validación de negocio está mal modelado.
3. **Errores nativos se traducen.** `DOMException`, `QuotaExceededError`, etc., se convierten a `DomainError` antes de salir del Driver.
4. **Capabilities no declaradas = no soportadas.**
5. **Idempotente bajo hot-swap.** Cambiar Driver no debe corromper estado del Provider.

---

## 5. Qué no es

- **No es un wrapper de `fetch`.** Para hablar con servidor está Wire.
- **No es un store.** Un store es un patrón de Provider; el Driver es el sustrato físico (almacén, canal, servicio del navegador).
- **No se inyecta como dependencia.** Solo se conoce vía DI interno del `ProviderRuntime`.

---

## 6. Inspiración

- **Angular `HttpClient` interceptors** — patrón de capa intercambiable detrás de la fachada.
- **Service Worker storage strategies** — modelos de Driver intercambiable según contexto de red.
- **Modelo Provider/Driver de ADO.NET** vía el espejo del backend.
