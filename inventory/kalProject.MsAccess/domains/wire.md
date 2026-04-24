---
kind: domain-inventory
source_repo: kalProject.MsAccess
source_commit: a778b34a5adc8f184f0a73be194466036100a127
repo: kalProject.MsAccess
domain: wire
inventoried_at: 2026-04-24T20:00:00Z
inventoried_by: cursor-inventario-fase1
implementations_count: 5
languages_involved: [csharp, javascript, typescript, embedded-cpp]
---

# Dominio — `wire`

## 1. Definición operativa

Comunicación en **tiempo real** sobre **WebSocket** (y, en el borde, JSON por mensajes) compartiendo DTOs en `kalProject.Common` y clientes de ejemplo en Node, TypeScript, PlatformIO, .NET Framework 4.8, y .NET 9, además de la sesión bajo `kalProject.Server` (`BridgeWebSocketSession`).

## 2. Implementaciones encontradas

| # | Package | Path | Lenguaje | Madurez | Rol |
|---|---------|------|----------|---------|-----|
| 1 | kalProject.Client | `kalProject.Client` | C# (netstandard2) | beta | `BridgeWebSocketClient` hacia el servidor |
| 2 | kalProject.Common | `kalProject.Common` | C# | maduro-aparente | DTOs compartidos |
| 3 | kalproject-nodejs-client | `Clients/nodejs-client` | JavaScript | beta | `KalProjectClient` con `ws` |
| 4 | (firmware) | `Clients/platformio-client` | C++/Arduino | beta | `main.cpp` y WebSocket lib (PlatformIO) |
| 5 | KalProject.NetFramework48.Client | `Clients/netframework48-client` | C# (net48) | beta | BCL `System.Net.WebSockets` |

## 3. Responsabilidades cubiertas

- **Carga útil y envelope de protocolo** análogos a los tipos C# reutilizados o espejados bajo `Clients/angular-client/src/kalproject-client.ts:6-21` (interfaces TypeScript) frente a `kalProject.Common` en C# (ver comparación en Fase 2)
- **Manejo de reconexión y canales lógicos** (README del cliente Node y constructor en `client.js`, fragmentos bajo `Clients/nodejs-client/client.js:8-18`)

## 4. Contratos y tipos clave

- `ProtocolEnvelope` y `BroadcastPayload` en el cliente TypeScript (interfaz) — `Clients/angular-client/src/kalproject-client.ts:6-21` y correlatos en C#: `kalProject.Common/src/Protocols/BroadcastPayload.cs:1` (cita aproximada; ver cuerpo del archivo C#)
- DTOs comunes: `using kalProject.Common.Protocols` en el servidor: `kalProject.MsAccess.Server/src/Program.cs:3`

## 5. Flujos observados

`kalProject.Server` mantiene `BridgeWebSocketSession` (sesión) y hace de fan-out frente a clientes; consumidores: `Server.App` y servicios registrados. Clientes múltiples lenguaje hablan a la misma semántica de tópico (README `REALTIME_PLATFORM_README.md` a nivel repositorio, no expandido aquí por brevedad).

## 6. Duplicaciones internas al repo

- **Cinco** pilas cliente potencialmente divergentes en detalles de JSON/WebSocket. Sin diff exhaustivo, se deja como observación de riesgo de desalineación (ver `summary/clients_*.md`)

## 7. Observaciones cross-language (si aplica)

TypeScript, JavaScript, C# y C++ tocan el mismo protocolo; la fuente C# bajo `kalProject.Common` debería ser ancla, aún a validar (hipótesis, no conclusión)

## 8. Estado global del dominio en este repo

- **Completitud:** parcial: abundan clientes de ejemplo; falta prueba de consistencia
- **Consistencia interna:** README y código TS/C# coherentes a alto nivel, sin verificación
- **Justificación:** alineación de nombres `BroadcastPayload` y `ProtocolEnvelope` entre TS y C# a primera vista, sin merge de tipos

## 9. Sospechas para Fase 2

- `?:` generar contrato de wire una sola vez (OpenAPI, JSON schema o protobuffer secundario) y derivar C#/TS/JS desde ahí, reduciendo riesgo de drift entre cinco runtimes
