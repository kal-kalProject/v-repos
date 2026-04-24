---
kind: package-summary
source_repo: kalProject.MsAccess
source_commit: a778b34a5adc8f184f0a73be194466036100a127
repo: kalProject.MsAccess
package_name: kalProject.MsAccess.Bridge
package_path: kalProject.MsAccess.Bridge
language: csharp
manifest: kalProject.MsAccess.Bridge.csproj
inventoried_at: 2026-04-24T20:00:00Z
inventoried_by: cursor-inventario-fase1
madurez: maduro-aparente
---

# kalProject.MsAccess.Bridge

## 1. Identidad

- **Path:** `kalProject.MsAccess.Bridge`
- **Lenguaje:** C# (net48, exe, gRPC, Protobuf, Grpc.Tools, Grpc.Core)
- **Publicado:** no

## 2. Propósito

### 2.1 Declarado

`README.md` del repo: escenario con app .NET Framework, cliente, y acceso a lib COM (texto a nivel repositorio, no de este `README` local).

### 2.2 Inferido

Proceso host Windows que publica un servicio gRPC generado desde `proto/access_bridge.proto` y enlaza a Office/ADODB para responder operaciones de catálogo de tablas, etc., mientras mantiene referencia a `kalProject.MsAccess`.

**Evidencia:**

- `kalProject.MsAccess.Bridge/kalProject.MsAccess.Bridge.csproj:30-38` — `Google.Protobuf`, `Grpc.Core`, `Grpc.Tools`, `Protobuf Include` a `../proto/access_bridge.proto` con `GrpcServices="Server"`
- `kalProject.MsAccess.Bridge/src/Program.cs:7-27` — arranque de `BridgeHost` y enlace a host/puerto
- `kalProject.MsAccess.Bridge/src/Services/AccessBridgeService.cs:1` (ubicación aprox. por estructura) — implementación de servicio (LOC elevadas constatadas en exploración de tamaño de archivo, ver status Deuda)

## 3. Superficie pública

- No es librería: salida `Exe`; API de red: contrato gRPC (servicio generado)

## 4. Dependencias

### 4.1 Internas

- `kalProject.MsAccess` (`ProjectReference`)

### 4.2 Externas

- gRPC/Protobuf (NuGet)
- referencias COM idénticas a `Extensions` hacia `Libs/`

## 5. Consumidores internos

- `kalProject.MsAccess.Server` (cliente gRPC) — evidencia: `Program.cs:21-23` (constantes de host/puente) y wiring en el servidor (ver resumen de Server)

## 6. Estructura interna

```
kalProject.MsAccess.Bridge/
├── Generated/      ← gRPC/Protobuf
├── src/
│   ├── Program.cs
│   └── Services/   AccessBridgeService
```

## 7. Estado

- **Madurez:** `maduro-aparente` (código de servicio y arranque explícito; sin validación de runtime)
- **Build:** no ejecutado
- **Tests:** 0

## 8. Dominios

- `transport` — gRPC
- `interop` — Office/COM
- `ms_access` — operaciones sobre el motor

## 9. Observaciones

Código `Generated/` duplicado semánticamente con el de `kalProject.MsAccess.Server/Generated` (misma fuente proto; riesgo de divergencia al regenerar)

## 10. Hipótesis

- `?:` requiere coincidencia de versiones de `Grpc.Tools` entre Bridge (net48) y Server (net9) vía alineación manual de `PackageReference`

## 11. Preguntas abiertas

- Política de despliegue (servicio local vs. elevación) — no verificable estáticamente
