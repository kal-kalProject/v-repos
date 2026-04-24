---
kind: package-summary
source_repo: kalProject.MsAccess
source_commit: a778b34a5adc8f184f0a73be194466036100a127
repo: kalProject.MsAccess
package_name: kalProject.MsAccess.Server
package_path: kalProject.MsAccess.Server
language: csharp
manifest: kalProject.MsAccess.Server.csproj
inventoried_at: 2026-04-24T20:00:00Z
inventoried_by: cursor-inventario-fase1
madurez: maduro-aparente
---

# kalProject.MsAccess.Server

## 1. Identidad

- **Path:** `kalProject.MsAccess.Server`
- **Lenguaje:** C# (net9, ASP.NET Web SDK, Swagger, gRPC client)
- **Publicado:** no

## 2. Propósito

### 2.1 Declarado

`Program.cs` documenta: servidor ASP.NET Core que consume el bridge vía gRPC

### 2.2 Inferido

Host HTTP que ofrece controladores, Swagger, y canal hacia el Bridge en `DefaultBridgeHost` / `DefaultBridgePort`, expone ruta `WebSocket` para puentes con clientes ligeros.

**Evidencia:**

- `kalProject.MsAccess.Server/kalProject.MsAccess.Server.csproj:20-22` — `Protobuf` con `GrpcServices="Client"` hacia el mismo `access_bridge.proto`
- `kalProject.MsAccess.Server/src/Program.cs:16-24` — constantes y `WebApplication.CreateBuilder`
- `kalProject.MsAccess.Server/src/Program.cs:17-18` — `ProjectReference` lógicamente: depende de `kalProject.Server` y `kalProject.MsAccess` (ver `csproj:17-19`)

## 3. Superficie pública

- App ejecutable: endpoints, handlers bajo `src/`

## 4. Dependencias

### 4.1 Internas

- `kalProject.MsAccess`, `kalProject.Server` (según `kalProject.MsAccess.Server.csproj:17-19`)

### 4.2 Externas

- Grpc.Net.Client*, Google.Protobuf, Swashbuckle (según `csproj:10-15`)

## 5. Consumidores internos

- Operadores humanos; servicio final en arquitectura; clientes de ejemplo Node/PlatformIO conectan vía el stack `kalProject.Server` + WebSocket o rutas publicadas (inferencia, ver README del repo en raíz `REALTIME_PLATFORM_README.md:1` si se requiere detalle de flujo en Fase 2)

## 6. Estructura interna

```
kalProject.MsAccess.Server/
├── Generated/
└── src/
    ├── Controllers/
    ├── Handlers/
    └── Program.cs
```

## 7. Estado

- **Madurez:** `maduro-aparente` (Kestrel + gRPC + proto integrados; sin prueba)
- **Build:** no ejecutado
- **Tests:** 0

## 8. Dominios

- `host` — orquestación ASP.NET
- `transport` — cliente gRPC hacia el Bridge
- `wire` — WebSocket (constante de path)

## 9. Observaciones

El mismo `.proto` genera cliente aquí y servidor en el Bridge: duplicación de modelos bajo `Generated/` (ver `status`)

## 10. Hipótesis

- `?:` el puente WebSocket reutiliza serialización alineada con `kalProject.Common`

## 11. Preguntas abiertas

- Topología de despliegue (proceso Bridge y Server en el mismo host) — documentar en Fase 2
