---
kind: discovery-tree
source_repo: kalProject.MsAccess
source_commit: a778b34a5adc8f184f0a73be194466036100a127
repo: kalProject.MsAccess
scanned_at: 2026-04-24T20:00:00Z
agent_id: cursor-inventario-fase1
root_path: repos/kalProject.MsAccess
---

# Árbol — `kalProject.MsAccess`

## Top-level

| Path | Tipo | Lenguajes / rol |
|------|------|-----------------|
| `.github` | CI / plantillas | YAML |
| `.nuget` | configuración feed NuGet | config |
| `.vscode` | ajustes editor | json |
| `Clients` | clientes de ejemplo (Node, .NET 4.8, PlatformIO, Angular parcial) | js, ts, c#, c++ (Arduino) |
| `docs` | documentación | markdown |
| `kalProject.*` (varios) | solución .NET (libs, servidores, puentes) | C# (net48 / net9 / netstandard2.0) |
| `Libs` | ensamblados COM / interop (DLL referenciadas) | binario |
| `MsAccess.Console.Examples` | consola .NET Framework ejemplo | C# |
| `Originals` | fuentes interop ADODB / Office (generadas o de referencia) | C# |
| `Originals\Microsoft.Office.Core` | proyecto .NET 2.0 mínimo `office` | C# |
| `packages` | caché NuGet local (legado) | nupkg (ignorar en análisis de fuente) |
| `proto` | contrato gRPC / Protobuf | proto3 |

**Manifest de solución:** `kalProject.MsAccess.slnx` — referencia 12 proyectos; existen dos proyectos adicionales bajo `Clients/netframework48-client` y `Originals/Microsoft.Office.Core` no listados en el `.slnx` (evidencia: listado de archivos bajo `repos/kalProject.MsAccess` frente a `kalProject.MsAccess.slnx:1-14`).

## Manifests detectados (expandidos)

- `kalProject.MsAccess.slnx` — solución SDK-style (proyectos listados en sección `Project`)
- `kalProject.MsAccess/kalProject.MsAccess.csproj`
- `kalProject.MsAccess.Bridge/kalProject.MsAccess.Bridge.csproj`
- `kalProject.MsAccess.Client/kalProject.MsAccess.Client.csproj`
- `kalProject.MsAccess.Extensions/kalProject.MsAccess.Extensions.csproj`
- `kalProject.MsAccess.Server/kalProject.MsAccess.Server.csproj`
- `kalProject.Data/kalProject.Data.csproj`
- `kalProject.Common/kalProject.Common.csproj`
- `kalProject.Client/kalProject.Client.csproj`
- `kalProject.Client.App/kalProject.Client.App.csproj`
- `kalProject.Server/kalProject.Server.csproj`
- `kalProject.Server.App/kalProject.Server.App.csproj`
- `MsAccess.Console.Examples/MsAccess.Console.Examples.csproj` (estilo clásico MSBuild)
- `Clients/netframework48-client/NetFramework48Client.csproj` (estilo clásico)
- `Originals/Microsoft.Office.Core/office.csproj`
- `Clients/nodejs-client/package.json`
- `Clients/platformio-client/platformio.ini`
- `proto/access_bridge.proto` (vinculado a proyectos gRPC; generación bajo `Generated/` en Bridge y Server)

**Sin `package.json` en raíz** de `Clients/angular-client` (solo `README.md` y `src/kalproject-client.ts` en el clon; sin manifest Node detectado vía lectura de directorio).

## Directorios excluidos del análisis (por convención / `.gitignore`)

- `bin/`, `obj/`, `Debug/`, `Release/` — salidas de build
- `node_modules/`, `dist/` — bajo `Clients` cuando apliquen
- `packages/` en cliente .NET 4.8 (NuGet restaurado) — ensamblados terceros
- `Clients/platformio-client/.pio/` — artefactos PlatformIO (ignorado)
