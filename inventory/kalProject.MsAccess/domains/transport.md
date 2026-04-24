---
kind: domain-inventory
source_repo: kalProject.MsAccess
source_commit: a778b34a5adc8f184f0a73be194466036100a127
repo: kalProject.MsAccess
domain: transport
inventoried_at: 2026-04-24T20:00:00Z
inventoried_by: cursor-inventario-fase1
implementations_count: 3
languages_involved: [csharp, protobuf]
---

# Dominio — `transport`

## 1. Definición operativa

Canales **gRPC** y contratos **Protocol Buffers** que enlazan un proceso `kalProject.MsAccess.Bridge` (net48) con `kalProject.MsAccess.Server` (net9) mediante `proto/access_bridge.proto` y clases bajo `Generated/`.

## 2. Implementaciones encontradas

| # | Package | Path | Lenguaje | Madurez | Rol |
|---|---------|------|----------|---------|-----|
| 1 | kalProject.MsAccess.Bridge | `kalProject.MsAccess.Bridge` | C# (net48) | maduro-aparente | Host gRPC servidor del contrato, implementación Acceso |
| 2 | kalProject.MsAccess.Server | `kalProject.MsAccess.Server` | C# (net9) | maduro-aparente | Cliente gRPC hacia el bridge + publicación Web (según resumen) |
| 3 | (contrato) | `proto` | Protobuf3 | n/a | Fuente de verdad; genera código en 1 y 2 |

## 3. Responsabilidades cubiertas

- **Mensajería de catálogo y metadatos de Access (tablas, campos, relaciones,…)** a través de los mensajes descritos bajo `proto/access_bridge.proto:1-50` (muestra de tipos) y extendidos en el cuerpo del archivo
- **Endpoint de proceso bridge en Windows (net48)** que escucha y enlaza a COM (interacción detallada en `interop`)
- **Consumo de bridge desde ASP.NET Core** (registro y dirección en el servidor) — evidencia: `kalProject.MsAccess.Server/kalProject.MsAccess.Server.csproj:16-22`

## 4. Contratos y tipos clave

- `ListTablesRequest` y mensajes correlativos bajo el package `kalproject.msaccess.bridge` (namespace C#: `proto` y `using` en el servidor) — `proto/access_bridge.proto:3-8`
- Clases gRPC en `*/Generated/AccessBridge*.cs` (código autogenerado, no se expande con diff manual aquí)

## 5. Flujos observados

```
(ASP.NET kalProject.MsAccess.Server) --gRPC/HTTP2 hacia 127.0.0.1:55051 (default)-->
(kalProject.MsAccess.Bridge) --COM/ADODB/Office interop-->
(Microsoft Access / DAO)
```

Valores de host/puerto: constantes iniciales en `kalProject.MsAccess.Server/src/Program.cs:21-23` (lectura de inventario estático, sin ejecución).

## 6. Duplicaciones internas al repo

- **Código gRPC/Protobuf autogenerado** duplicado bajo `kalProject.MsAccess.Bridge/Generated` y `kalProject.MsAccess.Server/Generated` por compartir el mismo `access_bridge.proto` (riesgo de divergencia al regenerar con versiones distintas de `Grpc.Tools` — ver `summary/kalproject.msaccess.server.md` y `summary/kalproject.msaccess.bridge.md`)

## 7. Observaciones cross-language (si aplica)

Solo C# y `.proto` en este clon; no hay stub Node/Rust hacia gRPC bajo el mismo repositorio

## 8. Estado global del dominio en este repo

- **Completitud:** parcial (gRPC+proto documentados; topología de despliegue operativa y seguridad mTLS, etc. no abordada)
- **Consistencia interna:** consistente en nombres de servicio, con la duplicación de `Generated` como riesgo
- **Justificación:** dos proyectos y un `.proto` compartido, con pistas alineadas en el `.csproj` (Bridge server vs. Server client)

## 9. Sospechas para Fase 2

- `?:` alinear en CI la regeneración de gRPC bajo un único `Directory.Build.props` o target compartido — evidencia: estructura actual de doble `OutputDir: Generated` en `kalProject.MsAccess.Bridge/kalProject.MsAccess.Bridge.csproj:38` y análogo en `kalProject.MsAccess.Server` (línea 21 del `.csproj` citada en summary)
