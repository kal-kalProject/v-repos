---
kind: package-summary
source_repo: kalProject.MsAccess
source_commit: a778b34a5adc8f184f0a73be194466036100a127
repo: kalProject.MsAccess
package_name: MsAccess.Console.Examples
package_path: MsAccess.Console.Examples
language: csharp
manifest: MsAccess.Console.Examples.csproj
inventoried_at: 2026-04-24T20:00:00Z
inventoried_by: cursor-inventario-fase1
madurez: experimental
---

# MsAccess.Console.Examples

## 1. Identidad

- **Path:** `MsAccess.Console.Examples`
- **Lenguaje:** C# (net48, `ToolsVersion` 15, MSBuild clásico)
- **Publicado:** no

## 2. Propósito

### 2.1 Declarado

— (código mínimo bajo estructura de proyecto heredada)

### 2.2 Inferido

Aplicación de consola de ejemplo que referencia a `kalProject.MsAccess.Client` para probar el stack Access sin el pipeline moderno gRPC+ASP.NET.

**Evidencia:**

- `MsAccess.Console.Examples/MsAccess.Console.Examples.csproj:50-59` — `ProjectReference` a `kalProject.MsAccess.Client`
- `MsAccess.Console.Examples/Program.cs:1` — (presente) punto de lógica de ejemplo

## 3. Superficie pública

- Ejecutable; sin API de reutilización hacia terceros

## 4. Dependencias

### 4.1 Internas

- `kalProject.MsAccess.Client`

### 4.2 Externas

- BCL (referencias de framework .NET 4.8 en el `ItemGroup` del `.csproj` clásico: `System`, `System.Core`, etc.)

## 5. Consumidores internos

- No (terminal de demo)

## 6. Estructura interna

```
MsAccess.Console.Examples/
├── App.config
├── Program.cs
└── Properties/AssemblyInfo.cs
```

## 7. Estado

- **Madurez:** `experimental` (pocos archivos, depende de pila entera Access/COM, sin pruebas)
- **Build:** no ejecutado
- **Tests:** 0

## 8. Dominios

- `ms_access` — demostración de acceso
- `interop` (indirecto) — vía el cliente y extensiones

## 9. Observaciones

Listado en `kalProject.MsAccess.slnx:6-7`, coherente con el resto de la solución

## 10. Hipótesis

- `?:` útil en desplazamiento gradual desde escenarios lega-legacy a la arquitectura gRPC/ASP.NET

## 11. Preguntas abiertas

- Si continúa siendo requisito soportar MSBuild clásico frente a SDK-style, decisión de Fase 2
