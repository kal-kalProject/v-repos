---
source_repo: v-gen
source_type: clone
source_commit: b7bfd02cc94b7417068e5fd3465225a41b466575
path: src/vGen.Engine.Roslyn
name: vGen.Engine.Roslyn
type: proyecto .NET
language: C# (net10.0)
---

# Summary - vGen.Engine.Roslyn

## Propósito
Extensión del motor de vGen que integra el SDK de Roslyn. Proporciona contextos de renderizado enriquecidos (`IRoslynRenderContext`) que permiten a las plantillas "inspeccionar" tipos de C# reales del proyecto del usuario (`ITypeSymbol`).

## Clasificación de Madurez
`maduro-aparente`
- **Justificación:** Código de alta especialización técnica. Uso avanzado de extensiones de símbolos de Roslyn. Fundamental para el valor diferencial de vGen (plantillas que "entienden" el código C# circundante).

## Observaciones de Código
- **Interoperabilidad:** Ofrece helpers para convertir metadatos de Roslyn en estructuras consumibles por el motor de plantillas.
- **Abstracción:** Actúa como un bridge opcional entre el motor base y el análisis estático de código C#.

## Uso y Dependencias
- **Consumidores:** `vGen.Cli`, `vGen.LanguageServer`.
- **Dependencias internas:** `vGen.Engine`.
- **Dependencias externas:** `Microsoft.CodeAnalysis.CSharp`.

## Tests
- **Presencia:** Sí.
- **Conteo:** 1 suite de tests detectada en `test/vGen.Engine.Roslyn.Tests`.
- **Estado verificado:** No ejecutados.
