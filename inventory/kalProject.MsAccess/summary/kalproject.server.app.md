---
kind: package-summary
source_repo: kalProject.MsAccess
source_commit: a778b34a5adc8f184f0a73be194466036100a127
repo: kalProject.MsAccess
package_name: kalProject.Server.App
package_path: kalProject.Server.App
language: csharp
manifest: kalProject.Server.App.csproj
inventoried_at: 2026-04-24T20:00:00Z
inventoried_by: cursor-inventario-fase1
madurez: beta
---

# kalProject.Server.App

## 1. Identidad

- **Path:** `kalProject.Server.App`
- **Lenguaje:** C# (net9, `Microsoft.NET.Sdk.Web`, OutputType web app implícita)
- **Publicado:** no

## 2. Propósito

### 2.1 Declarado

— (inferida aplicación de host web que consume el backend compartido)

### 2.2 Inferido

Aplicación web mínima que coloca lógica de manejador de demostración (`SampleBridgeMessageHandler`) y arranca el `WebHost` a través de `kalProject.Server`.

**Evidencia:**

- `kalProject.Server.App/kalProject.Server.App.csproj:8-10` — `ProjectReference` a `kalProject.Server`
- `kalProject.Server.App/src/Handlers/SampleBridgeMessageHandler.cs:1` — manejador de mensajes de demostración

## 3. Superficie pública

- No es una librería: punto de despliegue; endpoints gestionados por el stack ASP.NET (detalle en Fase 2 con lectura de `Program` si existe bajo `src/`)

## 4. Dependencias

### 4.1 Internas

- `kalProject.Server` únicamente (según el `.csproj` leído)

### 4.2 Externas

- (ninguna adicional en el fragmento de manifest)

## 5. Consumidores internos

- No aplica; es terminal en la cadena de dependencias hacia abajo (salvo orquestación externa)

## 6. Estructura interna

```
kalProject.Server.App/
└── src/
    └── Handlers/   (SampleBridgeMessageHandler, etc.)
```

## 7. Estado

- **Madurez:** `beta` (app de demostración; pocos archivos, sin pruebas)
- **Build:** no ejecutado
- **Tests:** 0

## 8. Dominios

- `host` — entrypoint web
- `wire` (indirecto) — handlers conectan al mecanismo de bridge/sesión

## 9. Observaciones

Diferenciar de `kalProject.MsAccess.Server`: este paquete es un host de ejemplo genérico; el otro combina gRPC+bridge Access

## 10. Hipótesis

- `?:` pensado para pruebas locales sin tocar lógica Access nativa a menos que se importe `MsAccess.Server` en otra ruta

## 11. Preguntas abiertas

- Si existe un `Program.cs` compartido o plantilla, confirmar (listado de archivos: posible; inventario de árbol)
