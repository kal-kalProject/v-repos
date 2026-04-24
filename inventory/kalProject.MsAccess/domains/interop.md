---
kind: domain-inventory
source_repo: kalProject.MsAccess
source_commit: a778b34a5adc8f184f0a73be194466036100a127
repo: kalProject.MsAccess
domain: interop
inventoried_at: 2026-04-24T20:00:00Z
inventoried_by: cursor-inventario-fase1
implementations_count: 4
languages_involved: [csharp]
---

# Dominio — `interop`

## 1. Definición operativa

Integración con **automatización Office / ADODB / Access** a través de ensamblados bajo `Libs/*.dll`, referencias `COM` en proyectos, y un árbol extenso de fuentes de **Primary Interop Assemblies o equivalentes** bajo `Originals/**`.

## 2. Implementaciones encontradas

| # | Package o artefacto | Path | Lenguaje | Madurez | Rol |
|---|--------------------|------|----------|---------|-----|
| 1 | kalProject.MsAccess.Extensions | `kalProject.MsAccess.Extensions` | C# | maduro-aparente | Pistas `HintPath` a `Libs\adodb*.dll` y pares Office — `kalProject.MsAccess.Extensions/kalProject.MsAccess.Extensions.csproj:24-35` |
| 2 | kalProject.MsAccess.Bridge | `kalProject.MsAccess.Bridge` | C# | maduro-aparente | Mismas referencias COM, más gRPC hacia el exterior (dominio `transport`) |
| 3 | office (proyecto) | `Originals/Microsoft.Office.Core` | C# (net2.0) | indeterminado | Ensamblado mínimo `office` (shim) — `Originals/Microsoft.Office.Core/office.csproj:1-16` |
| 4 | (árbol) | `Originals/Microsoft.Office.Interop.Access`, `Originals/ADODB`, `Originals/.../Access.Dao` | C# | n/a (vendor-like) | Miles de clases, archivos con LOC muy alto, para descubrimiento y búsqueda — evidencia: listado y LOC en búsqueda de árbol (no cita de línea única) |

## 3. Responsabilidades cubiertas

- **Acceder a servicios y tipos de Office/ADODB/DAO** desde C# 4.8+ en los proyectos de extensión y bridge, sin redeclarar manualmente toda la superficie en el código de negocio (usa PIA/TLB a través de referencias o fuentes bajo `Originals`)
- **Alojar fuentes o copias** de interop para facilitar búsqueda y, potencialmente, build sin TLB local (no verificable sin MSBuild y Office instalado)

## 4. Contratos y tipos clave

- Referencia `ADODB` y `office` bajo nombres de ensamblado — `HintPath` en el `.csproj` de `Extensions` y de `Bridge` (líneas citadas en resúmenes de package)
- Proyecto `office` bajo TFM mínimo — `Originals/Microsoft.Office.Core/office.csproj:2-4`

## 5. Flujos observados

Código bajo `kalProject.MsAccess.Extensions` instancia o delega a tipos concretos DAO (engine, tablas) que finalmente consumen los tipos PIA, sin expandir pila de llamadas completa en Fase 1.

## 6. Duplicaciones internas al repo

- **Duplicación de referencias hacia el mismo juego de DLLs** entre `Extension` y `Bridge` (mismo bloque de `ItemGroup` de referencias) — riesgo de desalineación de versiones de `HintPath` si las DLLs cambian en un solo `Libs`

## 7. Observaciones cross-language (si aplica)

Solo C#; sin bindings Rust/Node hacia el mismo TLB

## 8. Estado global del dominio en este repo

- **Completitud:** esquemático en documentación, fuerte en artefacto (DLL + fuentes masivas bajo `Originals`)
- **Consistencia interna:** riesgo de mezclar TFM mínimo (`net2.0` en `office`) con consumidores `net48` o `net9` a través de referencias a binario (coherente con PIA, no validado)
- **Justificación:** presencia de `HintPath` y de árbol `Originals` con miles de clases, evidencia de dependencia dura a Office en Windows

## 9. Sospechas para Fase 2

- `?:` inventariar bajo un inventario de licenciamiento qué PIA/TLB pueden redistribuirse con el repositorio y cuáles son generadas localmente a partir de tlbimp en máquina de build
