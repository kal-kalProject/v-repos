---
kind: domain-inventory
source_repo: kalProject.MsAccess
source_commit: a778b34a5adc8f184f0a73be194466036100a127
repo: kalProject.MsAccess
domain: host
inventoried_at: 2026-04-24T20:00:00Z
inventoried_by: cursor-inventario-fase1
implementations_count: 4
languages_involved: [csharp]
---

# Dominio — `host`

## 1. Definición operativa

Alojamiento **ASP.NET Core** bajo .NET 9: biblioteca `kalProject.Server` y las aplicaciones `kalProject.Server.App` (demo web) y `kalProject.MsAccess.Server` (integración gRPC+bridge+controladores) que arrancan vía `WebApplication.CreateBuilder` o equivalente.

## 2. Implementaciones encontradas

| # | Package | Path | Lenguaje | Madurez | Rol |
|---|---------|------|----------|---------|-----|
| 1 | kalProject.Server | `kalProject.Server` | C# | maduro-aparente | Extiende y configura el host (extensions, servicios) |
| 2 | kalProject.Server.App | `kalProject.Server.App` | C# | beta | App de demostración |
| 3 | kalProject.MsAccess.Server | `kalProject.MsAccess.Server` | C# | maduro-aparente | App que integra bridge + Swagger + WebSocket (constante de path) |
| 4 | (puente) kalProject.MsAccess.Bridge | `kalProject.MsAccess.Bridge` | C# | maduro-aparente | Proceso host gRPC aunque no sea ASP.NET (rol de “host de proceso” hermano) |

## 3. Responsabilidades cubiertas

- **Pipeline HTTP/HTTPS** bajo Kestrel (referencia framework en `kalProject.Server/kalProject.Server.csproj:9-10`)
- **Exposición de controladores y Swagger** (paquetes Swashbuckle en el servidor de Access, `kalProject.MsAccess.Server/kalProject.MsAccess.Server.csproj:10-15`)
- **Punto de extensión común** para lógica de WebSocket a través de `BridgeWebSocketSession` en `kalProject.Server/src/Sessions/BridgeWebSocketSession.cs:1` (navegación del explorador, sin lectura de todo el cuerpo)

## 4. Contratos y tipos clave

- `WebApplication` + registro de servicios en el arranque del servidor (patrón Microsoft.Extensions.Hosting) — `kalProject.MsAccess.Server/src/Program.cs:30-40` (números aproximados, ver cuerpo del archivo)
- Extensiones bajo `kalProject.Server/Extensions/`

## 5. Flujos observados

`kalProject.MsAccess.Server` consolida referencias a `kalProject.MsAccess` (modelo) y a `kalProject.Server` (host común) — `ProjectReference` en `kalProject.MsAccess.Server/kalProject.MsAccess.Server.csproj:17-18`.

## 6. Duplicaciones internas al repo

- **Dos “servidores”** conceptuales: `Server.App` (demo) vs. `MsAccess.Server` (integrado). No se afirma duplicación de código sin diff; riesgo de solapar plantillas (observación)

## 7. Observaciones cross-language (si aplica)

No: solo C# en el dominio de host en este repositorio

## 8. Estado global del dominio en este repo

- **Completitud:** parcial a nivel de documentación; los puntos de entrada existen
- **Consistencia interna:** nombres `kalProject.Server` vs. `MsAccess.Server` requieren glosario para nuevos colaboradores
- **Justificación:** manifestos y `Program` presentes, sin prueba de puesta en marcha

## 9. Sospechas para Fase 2

- `?:` unificar en una sola plantilla de `Program.cs` compartida si ambos hosts convergen, reduciendo divergencia de arranque
