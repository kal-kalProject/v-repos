# Wire en TypeScript / frontend

> **Rol.** Cliente Wire del lado frontend. Habla el mismo contrato canónico que el Host .NET, sobre transportes intercambiables.
>
> **Espejo del backend:** [`../dotnet/14-wire.md`](../dotnet/14-wire.md). **Package:** `@vortech/wire`.

---

## 1. Qué es en concreto

`@vortech/wire` es:

1. Implementación cliente del **contrato canónico Wire** — los mismos sobres `WireRequest`/`WireResponse`/`WireFrame`/`WireError` que define el backend, expresados como tipos TS.
2. Runtime que **codifica/decodifica** mensajes, mantiene **correlación**, gestiona **timeouts/retries/idempotencia**.
3. Conjunto de **TransportDrivers** — WebSocket, HTTP, in-process — intercambiables por configuración.
4. Inyectable como `IWireClient` por DI; consumido por los Provider proxies generados.

**Es código propio sobre Web Platform APIs.** Sin Axios, sin SignalR client, sin trpc. Ver [`01-cierre-decisiones-ts.md §2.3`](01-cierre-decisiones-ts.md).

---

## 2. Forma del contrato

```ts
export interface IWireClient {
  request<TIn, TOut>(
    operation: string,
    payload: TIn,
    options?: WireOptions): Promise<TOut>;

  stream<TIn, TFrame>(
    operation: string,
    payload: TIn,
    options?: WireOptions): AsyncIterable<TFrame>;

  subscribe<TIn, TEvent>(
    operation: string,
    payload: TIn,
    options?: WireOptions): Subscription<TEvent>;
}

export interface WireOptions {
  scope?: Scope;                  // override; por defecto se lee de ScopeContext
  signal?: AbortSignal;
  idempotencyKey?: string;
  headers?: Record<string, string>;
  timeout?: number;
}
```

Convenciones:

- **Tres formas únicas**: request unaria, stream finito, subscripción durable.
- **Scope automático.** Si no se pasa explícito, se lee del `ScopeContext` activo ([`19-scope.md`](19-scope.md)).
- **Errores tipados.** `DomainError` deserializado, nunca `Response.status`.
- **Reactivo opcional** vía helpers (`wire.requestAtom()`, `wire.subscribeAtom()` que devuelven atoms directamente).

---

## 3. Drivers de transporte (v1: los tres)

### 3.1 WebSocketTransportDriver — default cuando hay sesión persistente

- Conexión persistente bidi.
- Reconexión con backoff exponencial.
- Cola offline cuando se declara `Caps.OfflineQueue`.
- Streams y subscripciones nativos sobre frames Wire.
- Es el default cuando el shell corre como app larga (lo típico en shell-tipo-IDE).

### 3.2 HttpTransportDriver — para llamadas one-shot

- Una llamada Wire = una petición HTTP.
- Streams emulados con SSE o chunked transfer cuando aplica.
- Subscripciones no soportadas (declarar `Caps.Streaming` ausente).
- Útil para integraciones simples, scripting, contextos sin WS posible.

### 3.3 InProcessTransportDriver — Electron / Tauri / dev local

- Sin serialización: punteros directos a las funciones del Host cuando ambos viven en el mismo proceso.
- Latencia mínima.
- El componente no nota la diferencia; cambia solo el driver activo.
- Habilita modo "todo en proceso" para deployments tipo desktop app.

Los tres están en alcance v1.

---

## 4. Runtime

### 4.1 Inicialización

```ts
const wire = createWireClient({
  endpoint: 'wss://host.example.com/wire',
  transports: [WebSocketTransport, HttpTransport],
  scope: shellScopeContext,        // atom<Scope>
  identity: principalContext,      // atom<Principal | null>
  retries: { max: 3, backoff: 'exponential' },
});
```

### 4.2 Pipeline cliente

Cada llamada atraviesa:

1. **Build envelope** — embebe Scope, headers (incluido token de Identity), correlation id.
2. **Apply policies** — idempotencia, timeout, retries.
3. **Encode** — JSON o binary según transporte.
4. **Send** vía TransportDriver activo.
5. **Decode** respuesta.
6. **Lift error** — `DomainError` tipado o success.
7. **Telemetry** — emitir evento por hook.

### 4.3 Token / refresh

- El `IWireClient` lee el token del `IPrincipalProvider` ([`17-identity.md`](17-identity.md)).
- Detecta `401` y dispara refresh transparente; reintenta la operación.
- Si el refresh falla, emite evento `unauthorized` al shell.

---

## 5. Atoms y derivaciones

`@vortech/wire` integra con atoms para usos reactivos:

```ts
// Un atom que cambia con el resultado de la operación
const sku = wire.requestAtom(() =>
  ({ op: 'inventory.getSku', input: { id: skuId() } }));

// Un atom que es una colección que se llena con frames
const stock = wire.subscribeAtomCollection(() =>
  ({ op: 'inventory.watchStock', input: { id: skuId() } }));
```

Esto evita boilerplate `useEffect`/`subscribe` en componentes; el componente lee el atom como cualquier otro.

---

## 6. Reglas invariantes

1. **Un contrato, varios transportes.** Cambiar transporte no toca código de dominio.
2. **Errores como `DomainError`**, nunca como `Response`.
3. **Correlación obligatoria.**
4. **Scope embebido**, nunca pasado a mano por el componente.
5. **Cero `fetch` directo en componentes.**
6. **Observabilidad por construcción.**

---

## 7. Qué no es

- **No es un wrapper de `fetch`.** Es el contrato Wire materializado en cliente.
- **No es JSON-RPC ni gRPC-web.** Toma ideas; forma propia.
- **No es un store.** No mantiene cache de respuestas — el cache, si hace falta, vive en `ICacheProvider` local.

---

## 8. Inspiración

- **trpc** — patrón end-to-end tipado.
- **SignalR client** — modelo de reconexión + streams.
- **Apollo Client** — modelo de subscripción + cache (cache no se adopta).
- **GraphQL fragments** — selección de campos (no se adopta el modelo).

Leídos como fuente; no adoptados como dependencia.
