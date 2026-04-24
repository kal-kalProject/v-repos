---
kind: package-summary
source_repo: kalProject.MsAccess
source_commit: a778b34a5adc8f184f0a73be194466036100a127
repo: kalProject.MsAccess
package_name: kalProject.MsAccess.Client
package_path: kalProject.MsAccess.Client
language: csharp
manifest: kalProject.MsAccess.Client.csproj
inventoried_at: 2026-04-24T20:00:00Z
inventoried_by: cursor-inventario-fase1
madurez: beta
---

# kalProject.MsAccess.Client

## 1. Identidad

- **Nombre:** kalProject.MsAccess.Client
- **Path:** `kalProject.MsAccess.Client`
- **Lenguaje:** C# (net48, unsafe permitido, x64, LangVersion 12)
- **Versión:** interna
- **Publicado:** no

## 2. Propósito

### 2.1 Declarado

— (sin README local en resumen de inventario Fase 1)

### 2.2 Inferido

Capa de cliente de escritorio/bridge que reutiliza `kalProject.MsAccess` y extensiones con COM para hablar con Access, consumido por el ejemplo de consola.

**Evidencia:**

- `kalProject.MsAccess.Client/kalProject.MsAccess.Client.csproj:20-22` — referencias a `kalProject.MsAccess.Extensions` y `kalProject.MsAccess`
- `MsAccess.Console.Examples/MsAccess.Console.Examples.csproj:52-59` — `ProjectReference` a este proyecto

## 3. Superficie pública

- Clases en `src/` (p. ej. `Client` en `Client.cs` según estructura de directorio)

## 4. Dependencias

### 4.1 Internas

- `kalProject.MsAccess`, `kalProject.MsAccess.Extensions` (vía `.csproj`)

### 4.2 Externas

- (declarado en el fragmento) ningún `PackageReference` en el bloque leído

## 5. Consumidores internos

- `MsAccess.Console.Examples` — ejecutable de prueba

## 6. Estructura interna

```
kalProject.MsAccess.Client/
└── src/   ← API de cliente
```

## 7. Estado

- **Madurez:** `beta` (enlaza extensiones y core; pocos productos de prueba, sin tests)
- **Build:** no ejecutado
- **Tests:** 0

## 8. Dominios

- `ms_access` — orquesta uso del modelo
- `interop` — depende vía `Extensions` de interop Office

## 9. Observaciones

Necesita alineación con el Bridge gRPC (otro proyecto) en despliegues reales (observación, no requisito verificado)

## 10. Hipótesis

- `?:` funciona como fachada local sincrónica frente a flujo remoto del Bridge

## 11. Preguntas abiertas

- Experiencia de despliegue (Win x64) — fuera de alcance de inventario estático
