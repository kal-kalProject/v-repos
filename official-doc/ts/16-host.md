# Host en TypeScript / frontend

> **Rol.** El concepto Host **no existe en el frontend**. Host es runtime de plataforma con pipeline de operaciones, identidad, persistencia, cluster — eso es el Host .NET ([`../dotnet/16-host.md`](../dotnet/16-host.md)).
>
> Lo más cercano que existe en el lado TS es el **Workbench** ([`23-workbench.md`](23-workbench.md)), que es **shell de UI**, no Host de plataforma. La distinción se mantiene clara y deliberada.

---

## 1. Por qué no hay Host TS

- Host = pipeline de dominio + DI + lifecycle + cluster + transportes Wire **server-side**.
- El navegador no es servidor, no monta cluster, no enruta a otros nodos, no aloja Identity, no aloja Providers de dominio.
- Asignar el rol "Host" a algo del frontend confundiría dos cosas con responsabilidades incompatibles.

---

## 2. Qué cumple roles análogos en el frontend

Las funciones internas que un Host .NET cumple, en el frontend están repartidas entre piezas distintas:

| Rol del Host .NET | Equivalente conceptual en frontend |
|---|---|
| Pipeline de operación | `@vortech/wire` cliente: pipeline de envoltura → encode → send → decode → policies. Limitado al cliente. |
| DI container | `@vortech/core/di` Injector. Es contenedor de objetos del frontend, no de Providers de dominio remotos. |
| Lifecycle de Providers | `ProviderRuntime` cliente (de `@vortech/core`). Solo orquesta Providers locales y proxies remotos. |
| Pipeline de extensiones | Sistema de slots de `@vortech/core/extensions`. |
| Shell de UI | `@vortech/workbench`. Es **UI**; no es Host. |
| Discovery / cluster | No existe en frontend. El cliente conecta a un endpoint, no participa del cluster. |
| Identity (server) | Inexistente. Solo se consume ([`17-identity.md`](17-identity.md)). |
| Configuration | `IConfigProvider` local (Provider de configuración del cliente). |
| Logging / telemetría | `ILogProvider` local + emisión Wire al backend cuando aplica. |

---

## 3. Lo que esto implica

1. **Un componente nunca arranca un Host.** El equivalente al `host.RunAsync()` del backend es la inicialización del shell (`createWorkbench(...).start()`), pero eso es UI.
2. **No hay configuración de cluster en el frontend.** Toda topología es responsabilidad de quien despliega los Hosts .NET.
3. **No hay "modo embebido" donde el frontend hospede dominios.** Aunque `InProcessTransportDriver` permita hablar con un Host en el mismo proceso (Electron/Tauri), ese Host sigue siendo .NET.
4. **El "ciclo de vida" del frontend se mide por la sesión del shell**, no por arranque/apagado de servicios distribuidos.

---

## 4. Riesgo de confusión y cómo evitarlo

Un dev nuevo puede llamar "Host" a:

- El proceso main de Electron / Tauri → es un proceso adyacente con Wire in-process; **no es Host de plataforma**.
- El Workbench → es **shell de UI**.
- El Service Worker → es runtime del navegador.
- El backend Node de un BFF → si existe (decisión operativa, no canónica), sería sustrato no-canónico y debería re-hacerse en .NET o desaparecer; nunca se llama Host.

Regla léxica: **"Host" en cualquier doc Vortech significa Host .NET**. Cualquier otra cosa lleva otro nombre.

---

## 5. Qué documentar aquí está cerrado

- No habrá `@vortech/host` package en TS.
- No habrá pipeline de operaciones de dominio en el frontend.
- No habrá registro de Providers remotos servido desde el frontend.

Cualquier intento de mover responsabilidades de Host hacia el frontend reabre la línea "TS-everything" archivada en [`../../inventory/_analysis-preview/DECISION-CLOSURE.md §2.2`](../../inventory/_analysis-preview/DECISION-CLOSURE.md). No se reabre.
