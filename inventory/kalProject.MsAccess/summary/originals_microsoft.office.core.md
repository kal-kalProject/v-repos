---
kind: package-summary
source_repo: kalProject.MsAccess
source_commit: a778b34a5adc8f184f0a73be194466036100a127
repo: kalProject.MsAccess
package_name: office
package_path: Originals/Microsoft.Office.Core
language: csharp
manifest: office.csproj
inventoried_at: 2026-04-24T20:00:00Z
inventoried_by: cursor-inventario-fase1
madurez: indeterminado
---

# office (Originals/Microsoft.Office.Core)

## 1. Identidad

- **Path:** `Originals/Microsoft.Office.Core`
- **Lenguaje:** C# (TargetFramework `net2.0` en el manifest, `AllowUnsafe`, LangVersion 12)
- **Publicado:** no

## 2. Propósito

### 2.1 Declarado

— (código generado o portado, sin README individual en resumen de inventario)

### 2.2 Inferido

Conjunto mínimo de shims/declaraciones para el ensamblado `office` (nombre de ensamblado en `PropertyGroup`), referencia `stdole` — típico de interop TLB.

**Evidencia:**

- `Originals/Microsoft.Office.Core/office.csproj:1-16` — `AssemblyName` office, TFM `net2.0`, `GenerateAssemblyInfo` false
- `Originals/Microsoft.Office.Core/PropertyTests.cs:1` — archivo cuyo nombre contiene "Tests" (ver conteo de tests en status)

## 3. Superficie pública

- Tipos bajo el ensamblado `office` según múltiples `*.cs` bajo el directorio (listado: `IMsoChart.cs` y cientos de archivos vinculados a Office Core)

## 4. Dependencias

### 4.1 Internas

- No (`ItemGroup` vacío de `ProjectReference` en el head del `.csproj` leído)

### 4.2 Externas

- `stdole` (GAC/PIA según plataforma)

## 5. Consumidores internos

- Posible carga vía `HintPath` a `OFFICE.DLL` en otros paquetes (no analizado vía resolución de carga, solo referencias de proyecto en otros `.csproj` listan `../Libs/OFFICE.DLL`, no a este subárbol de `Originals` directo — hipótesis: coexistencia con binarios bajo `Libs/`)

## 6. Estructura interna

`Originals/Microsoft.Office.Core/*.cs` — interop (gran volumen de archivos, ver dominio `interop`)

## 7. Estado

- **Madurez:** `indeterminado` (TFM mínimo, utilidad concreta acoplada a un flujo de build Office no reconstruible en Fase 1)
- **Build:** no ejecutado
- **Tests:** 1 archivo con sufijo de nombre `*Tests.cs` bajo el árbol de interop, no concluido su rol sin ejecutar (ver status)

## 8. Dominios

- `interop` — PIA/Office Core

## 9. Observaciones

El árbol `Originals/Microsoft.Office.Interop.Access` contiene múltiples miles de LOC por archivo, fuera del `office.csproj` aislado; atención en Fase 2 para mapeo completo TLB vs. fuentes

## 10. Hipótesis

- `?:` repositorio mantiene fuentes para facilitar depuración y búsqueda, no reemplazando necesariamente las DLLs comerciales oficiales

## 11. Preguntas abiertas

- Licenciamiento de redistribución de PIA/TLB: fuera de alcance
