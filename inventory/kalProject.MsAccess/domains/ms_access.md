---
kind: domain-inventory
source_repo: kalProject.MsAccess
source_commit: a778b34a5adc8f184f0a73be194466036100a127
repo: kalProject.MsAccess
domain: ms_access
inventoried_at: 2026-04-24T20:00:00Z
inventoried_by: cursor-inventario-fase1
implementations_count: 4
languages_involved: [csharp]
---

# Dominio — `ms_access`

## 1. Definición operativa

Modelado del **dominio de Microsoft Access** (aplicación, base de datos, relaciones, consultas, documentos) con implementaciones in-memory o ligadas a DAO/COM, más capa de datos genérica bajo `kalProject.Data`.

## 2. Implementaciones encontradas

| # | Package | Path | Lenguaje | Madurez | Rol |
|---|---------|------|----------|---------|-----|
| 1 | kalProject.MsAccess | `kalProject.MsAccess` | C# (netstandard2) | maduro-aparente | Núcleo de abstracción y fachada del modelo |
| 2 | kalProject.MsAccess.Extensions | `kalProject.MsAccess.Extensions` | C# (net48) | maduro-aparente | Enlace DAO y Office/ADODB hacia concretaciones |
| 3 | kalProject.Data | `kalProject.Data` | C# (netstandard2) | maduro-aparente | Conexión y abstracciones (interfaces bajo `Abstractions/`) |
| 4 | kalProject.MsAccess.Client | `kalProject.MsAccess.Client` | C# (net48) | beta | Fachada cliente hacia el modelo + extensiones |

## 3. Responsabilidades cubiertas

- **Catálogo y modelado de estructura** alineado con mensajes del `.proto` (dominio `transport`) para el canal remoto
- **Manejo in-memory y rutas aún `NotSupported`** (evidencia: `kalProject.MsAccess/src/Database/Relations/Relation.cs:60` y archivos bajo `QueryDefinition*.cs` en búsqueda estática)
- **Extensión DAO** con propiedades de solo lectura (patrón `set => throw` en múltiples clases, ver búsqueda de `NotSupportedException` bajo `kalProject.MsAccess.Extensions` en inventario de grep)

## 4. Contratos y tipos clave

- `IAccessApplication` y otras bajo `kalProject.MsAccess/src/Abstractions/Access/`
- Mensajes y tablas bajo el espacio de nombres `kalProject.MsAccess.Proto` (por generación) — ver `summary/kalproject.msaccess.server.md`

## 5. Flujos observados

Aplicación de consola `MsAccess.Console.Examples` referencia el cliente hacia el modelo — `MsAccess.Console.Examples/MsAccess.Console.Examples.csproj:52-55`.

## 6. Duplicaciones internas al repo

- **Doble vía hacia el motor Access**: pila in-memory del núcleo vs. pila con COM en `Extensions`; componen en cliente y bridge respectivamente, no conclusión de reemplazo

## 7. Observaciones cross-language (si aplica)

No: dominio 100% C# en el clon

## 8. Estado global del dominio en este repo

- **Completitud:** parcial: la cobertura de abstracción es ancha; implementaciones faltan para numerosas rutas
- **Consistencia interna:** múltiples excepciones con texto homogéneo "in-memory" sugieren fases de relleno aún en curso
- **Justificación:** densidad de `NotSupportedException` bajo búsqueda de texto, sin contador exacto requerido en Fase 1

## 9. Sospechas para Fase 2

- `?:` priorizar matriz "API abstracta" vs. "DAO concreto" para reducir confusión en nombres de clases (Document vs. Dao*)
