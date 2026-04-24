# Bridge en TypeScript / frontend

> **Rol.** El frontend **no aloja Bridges**. Bridge es traducción cross-runtime hacia sistemas legacy/nativos, lo cual es trabajo del Host .NET o de un Agent — no del navegador.
>
> **Espejo del backend:** [`../dotnet/15-bridge.md`](../dotnet/15-bridge.md).

---

## 1. Cómo aparece Bridge en el frontend

El frontend solo nota Bridges **indirectamente**:

1. **Capabilities limitadas.** Un Provider remoto que está sirviéndose de un Bridge (p. ej., `IDataProvider` sobre MSAccess COM) puede no soportar `Caps.ChangeStream` o `Caps.BulkUpsert`. La UI lee la Capability y adapta su superficie.
2. **Latencia y errores característicos.** Un Bridge a un dispositivo físico puede tener timeouts más largos, errores específicos (`device-disconnected`, `serial-port-busy`). Los `DomainError` traen el código; la UI puede mostrar mensajes precisos.
3. **Telemetría.** El devtools del shell puede mostrar la cadena `Provider → Driver → Bridge → runtime ajeno` cuando se inspecciona una operación, gracias al `RouteResolution` que devuelve el Router ([`20-router.md`](20-router.md)).

---

## 2. Excepción: Electron / Tauri

Cuando el "frontend" corre **dentro de un proceso con runtimes nativos accesibles** — Electron (main + renderer), Tauri (core + webview), o equivalente — pueden existir **Bridges en el proceso main** que el shell consume vía Wire in-process.

Casos típicos:

- Acceso al sistema de archivos local fuera de la sandbox del navegador.
- Hardware nativo (cámaras industriales con SDK propietario, lectores de tarjetas, escáneres).
- COM en Windows (firma SII Chile, Office, MSAccess local).
- Servicios del SO (registro, servicios Windows, daemons).

**Distinción importante:** el código del Bridge **no es código del frontend**, aunque corra en el mismo binario. Es código del proceso main (Node embebido, Rust, lo que provea el contenedor) que expone Wire al renderer. El componente sigue viendo solo un Provider proxy.

```
┌───────────── Electron / Tauri shell ─────────────┐
│                                                  │
│   renderer (TS, browser)                         │
│     └─ @vortech/components                       │
│         └─ inject(IFileSystemProvider)           │
│             └─ proxy genera WireRequest          │
│                  │                               │
│           in-process WireDriver                  │
│                  │                               │
│   main process                                   │
│     └─ Bridge a runtime nativo                   │
│           └─ COM / FS nativo / SDK propietario   │
│                                                  │
└──────────────────────────────────────────────────┘
```

Para el componente: **idéntico** a cualquier otro Provider remoto. El transporte cambia (in-process vs WS/HTTP), nada más.

---

## 3. Reglas invariantes

1. **Cero código de Bridge en `@vortech/components`** ni en cualquier package frontend. Si aparece `WindowsCom.invoke(...)` en el frontend, está mal.
2. **Capabilities reflejan limitaciones.** Si el Bridge no soporta algo, el Provider lo expone como Capability ausente.
3. **El renderer nunca importa nativo.** En Electron/Tauri, el renderer habla por IPC con el main; el Bridge vive en el main.
4. **Errores del Bridge llegan tipados.** El frontend recibe `DomainError`, no `HRESULT`.

---

## 4. Qué no es

- **No es un polyfill.** Polyfill emula APIs del navegador; Bridge cruza al runtime nativo.
- **No es un plugin del navegador.** Plugins del navegador (extensiones cromium) son otro escenario, fuera del scope de Bridge.
- **No es un Service Worker.** SW es un runtime del propio navegador.

---

## 5. Cuándo un dev del frontend toca el tema Bridge

- **Diseñando UX de degradación.** "Si el Driver detrás del Provider es Bridge MSAccess, ¿qué hacemos cuando no hay Caps.Transactions?"
- **Mostrando información de diagnóstico.** Cadena de routing, métricas del Bridge, estado de reconexión.
- **Modelando errores específicos del runtime ajeno.** Catálogo de `DomainError` con códigos del Bridge.

Eso es todo el contacto. La implementación del Bridge no es del frontend.
