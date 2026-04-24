# Capability en TypeScript / frontend

> **Rol.** Identificadores tipados que describen propiedades no funcionales que un Driver (local o transport) ofrece o no ofrece. Idéntico al modelo backend.
>
> **Espejo del backend:** [`../dotnet/12-capability.md`](../dotnet/12-capability.md).

---

## 1. Qué es en concreto

Una Capability en TS es una **constante tipada** que ambos lados (Provider y Driver) referencian.

```ts
export interface Capability {
  readonly id: string;
  readonly category?: string;
}

export const Caps = {
  // Persistencia
  Persistent:     { id: 'persistent' } as const,
  CrossTab:       { id: 'cross-tab' } as const,
  LargeQuota:     { id: 'large-quota' } as const,
  Encrypted:      { id: 'encrypted' } as const,

  // Wire
  Streaming:      { id: 'wire.streaming' } as const,
  Bidirectional:  { id: 'wire.bidi' } as const,
  OfflineQueue:   { id: 'wire.offline-queue' } as const,
  AutoReconnect:  { id: 'wire.auto-reconnect' } as const,

  // UI
  TouchInput:     { id: 'ui.touch' } as const,
  PointerEvents:  { id: 'ui.pointer' } as const,
  HighContrast:   { id: 'ui.high-contrast' } as const,
} as const;
```

---

## 2. Origen de las Capabilities visibles

| Origen | Quién las consume |
|---|---|
| **Provider remoto** | Embebidas en handshake Wire o en metadata del proxy. El componente puede preguntar qué soporta el Driver activo del backend (p. ej. `Caps.BulkUpsert`, `Caps.ChangeStream`). |
| **TransportDriver de Wire** | Reflejan lo que el transporte activo soporta (`Streaming`, `Bidirectional`, `OfflineQueue`). Un componente puede degradar de subscripción a polling si Streaming no está disponible. |
| **Driver de Provider local** | Reflejan lo que el almacenamiento o servicio del cliente ofrece (`Persistent`, `CrossTab`, `Quota`). |
| **Plataforma del navegador** | Capabilities derivadas de feature detection (`TouchInput`, `WebGpu`, `OffscreenCanvas`) — expuestas por un `IPlatformProvider` local. |

---

## 3. Consumo desde componente

```ts
class InventoryToolbar {
  private readonly inv = inject(IInventoryProvider);

  readonly canBulkImport = derived(() => this.inv.has(Caps.BulkUpsert));
  readonly canSubscribeStock = derived(() =>
    this.inv.has(Caps.ChangeStream) && this.wire.has(Caps.Streaming));
}
```

Convenciones:

- `provider.has(cap)` y `transport.has(cap)` son **atoms derivados** — la UI reacciona si cambian.
- Capabilities **nunca** se hardcodean a falso; siempre se consultan.
- La consulta es barata (lookup en mapa) — se puede usar libremente en derivaciones.

---

## 4. Degradación graceful

Mismos dos patrones que en backend:

### 4.1 Obligatoria
Si un componente declara una Capability como requerida y no está disponible, se renderiza un placeholder/error explícito ("Esta vista requiere XYZ que tu navegador no soporta").

### 4.2 Opcional
La UI ofrece ruta alternativa: en lugar de stream tiempo real, polling cada N segundos; en lugar de drag-and-drop, botón clásico.

---

## 5. Reglas invariantes

1. **Identificadores estables.** Una Capability publicada no cambia de nombre.
2. **Granularidad razonable.** No una por método; una por propiedad significativa.
3. **Categorías** opcionales para agrupar (`wire.*`, `ui.*`, `persistence.*`).
4. **Atoms derivados, no booleanos sueltos.** La UI debe reaccionar a cambios.

---

## 6. Qué no es

- **No es un feature flag de aplicación.** Eso vive en `IFeatureFlagProvider` (Provider remoto, normalmente).
- **No es un polyfill flag.** Polyfill es estrategia de bundle; Capability es estado runtime.
- **No es un permiso de usuario.** Permisos viven en Identity ([`17-identity.md`](17-identity.md)).

---

## 7. Inspiración

- **Modula.io / `Modernizr`** — feature detection del navegador.
- **Backend Capability del propio Vortech** — espejo conceptual.
