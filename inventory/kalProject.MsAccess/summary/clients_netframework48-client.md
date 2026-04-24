---
kind: package-summary
source_repo: kalProject.MsAccess
source_commit: a778b34a5adc8f184f0a73be194466036100a127
repo: kalProject.MsAccess
package_name: KalProject.NetFramework48.Client
package_path: Clients/netframework48-client
language: csharp
manifest: NetFramework48Client.csproj
inventoried_at: 2026-04-24T20:00:00Z
inventoried_by: cursor-inventario-fase1
madurez: beta
---

# KalProject.NetFramework48.Client (Clients/netframework48-client)

## 1. Identidad

- **Path:** `Clients/netframework48-client`
- **Lenguaje:** C# (net48, MSBuild clásico, `System.Net.WebSockets*`)
- **Publicado:** no

## 2. Propósito

### 2.1 Declarado

— (código bajo `Program.cs` y `KalProjectClient.cs`)

### 2.2 Inferido

Cliente de escritorio o consola bajo .NET Framework que usa `Newtonsoft.Json` del árbol `packages/` y WebSockets, paralelo a `kalProject.Client` (netstandard/9) pero con stack legado de restauración de paquetes.

**Evidencia:**

- `Clients/netframework48-client/NetFramework48Client.csproj:30-40` — referencias a `System.Net.WebSockets*`, `Newtonsoft.Json` con `HintPath` a `packages\...`
- `Clients/netframework48-client/Program.cs:1` — (presente)

## 3. Superficie pública

- Ejecutable, sin paquete NuGet reutilizable

## 4. Dependencias

### 4.1 Internas

- Ninguna de proyecto (el `.csproj` no importa `kalProject.*` vía `ProjectReference` en el bloque de lectura)

### 4.2 Externas

- `Newtonsoft.Json` 13.0.3 (ruta a `lib/net45` en el `.csproj`)
- BCL y WebSocket del framework 4.8

## 5. Consumidores internos

- No; cliente final de prueba; puede hablar con el servidor vía el mismo wire protocolo (no verificado estáticamente en profundidad)

## 6. Estructura interna

```
Clients/netframework48-client/
├── NetFramework48Client.csproj
├── Program.cs
├── KalProjectClient.cs
└── packages.config
```

## 7. Estado

- **Madurez:** `beta` (mantiene dos stacks cliente en paralelo con el ecosistema moderno, riesgo de desalineación)
- **Build:** no ejecutado; restauración de `packages/` bajo Fase 2
- **Tests:** 0

## 8. Dominios

- `wire` — WebSocket
- (puente) con `host` vía el servidor

## 9. Observaciones

No listado en `kalProject.MsAccess.slnx` en el clon: desarrollo o mantenimiento como proyecto aparte; convivencia con C# 9+ en otros paquetes

## 10. Hipótesis

- `?:` puede ser el punto de conexión para equipos aún restringidos a .NET Framework 4.8

## 11. Preguntas abiertas

- Paridad con `kalProject.Client` en el protocolo: comparación línea a línea en Fase 2
