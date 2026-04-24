---
source_repo: v-gen
source_type: clone
source_commit: b7bfd02cc94b7417068e5fd3465225a41b466575
---

# Domain Inventory - Code Generation (Compiler & Roslyn)

## Propósito
Dominio encargado de la compilación de lógica C# asociada a plantillas y el análisis estático de código fuente del usuario para facilitar la generación de código context-aware.

## Componentes Clave (Evidence pointers)
- **Compilador de Componentes:** `src/vGen.Compiler/ComponentCompiler.cs` — Utiliza Roslyn para generar assemblies en memoria.
- **Caché de Assemblies:** `src/vGen.Compiler/CompiledComponentCache.cs` — Evita recompilaciones costosas de lógica de scaffold.
- **Extensión Roslyn:** `src/vGen.Engine.Roslyn/RoslynRenderContext.cs` — Injecta el objeto `ITypeSymbol` en el contexto de renderizado de la plantilla.
- **Carga de Proyectos:** `src/vGen.Cli/CsprojCompilationLoader.cs` — Lógica para analizar archivos `.csproj` del usuario y cargar sus tipos en el motor de vGen.

## Observaciones Técnicas
- **Uso de Roslyn:** Dependencia crítica de `Microsoft.CodeAnalysis`.
- **Reflexión dinámica:** El sistema carga assemblies generados dinámicamente, lo que requiere un manejo cuidadoso de los contextos de carga (`AssemblyLoadContext`).

## Riesgos y Deuda
- **Versioning de .NET:** El uso de `net10.0` (o versiones de vanguardia) en los proyectos indica que la infraestructura debe ser muy reciente.
- **Overhead de Memoria:** La compilación dinámica y el mantenimiento de grafos de símbolos de Roslyn en el LSP pueden consumir recursos significativos en proyectos grandes.
