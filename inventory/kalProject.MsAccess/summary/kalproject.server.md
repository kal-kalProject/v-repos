---
kind: package-summary
source_repo: kalProject.MsAccess
source_commit: a778b34a5adc8f184f0a73be194466036100a127
repo: kalProject.MsAccess
package_name: kalProject.Server
package_path: kalProject.Server
language: csharp
manifest: kalProject.Server.csproj
inventoried_at: 2026-04-24T20:00:00Z
inventoried_by: cursor-inventario-fase1
madurez: maduro-aparente
---

# kalProject.Server

## 1. Identidad

- **Path:** `kalProject.Server`
- **Lenguaje:** C# (net9, `Microsoft.AspNetCore.App`)
- **Publicado:** no

## 2. Propósito

### 2.1 Declarado

— (inferido: biblioteca de extensión para ASP.NET compartida por el host concreto)

### 2.2 Inferido

Agrupa `FrameworkReference` a ASP.NET Core; provee servicios, opciones, extensiones reutilizadas por `kalProject.MsAccess.Server` y `kalProject.Server.App`.

**Evidencia:**

- `kalProject.Server/kalProject.Server.csproj:1-16` — `TargetFramework` net9, `FrameworkReference` ASP.NET, `ProjectReference` a `kalProject.Common`
- `kalProject.Server/src/Sessions/BridgeWebSocketSession.cs:1` — manejo de sesión (LOC ~344)

## 3. Superficie pública

- Clases bajo `kalProject.Server` (espacios `Extensions`, `Options`, `Services`, `Sessions` según listado de directorio)

## 4. Dependencias

### 4.1 Internas

- `kalProject.Common`

### 4.2 Externas

- Plataforma ASP.NET (framework reference, sin lista NuGet de paquetes en el bloque leído)

## 5. Consumidores internos

- `kalProject.MsAccess.Server` y `kalProject.Server.App`

## 6. Estructura interna

```
kalProject.Server/
└── src/
    ├── Extensions/
    ├── Handlers/ (puede variar)
    ├── Options/
    ├── Services/
    └── Sessions/
```

## 7. Estado

- **Madurez:** `maduro-aparente` (biblioteca de plataforma clara, sin pruebas)
- **Build:** no ejecutado
- **Tests:** 0

## 8. Dominios

- `host` — integración con ASP.NET
- `wire` — `BridgeWebSocketSession` sugiere fan-out a WebSocket

## 9. Observaciones

Punto de extensión para lógica común de handshake y ruteo; conviene mapear dependencias cíclicas con `MsAccess.Server` con grafo de MSBuild en Fase 2

## 10. Hipótesis

- `?:` toda puesta en marcha pasa por registrar extensiones bajo un namespace estable (`BridgeServer*Extensions`)

## 11. Preguntas abiertas

- Ninguna estructural para Fase 1
