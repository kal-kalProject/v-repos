---
source_repo: v-gen
source_type: clone
source_commit: b7bfd02cc94b7417068e5fd3465225a41b466575
path: src/vGen.Engine
name: vGen.Engine
type: proyecto .NET
language: C# (net10.0)
---

# Summary - vGen.Engine

## Propósito
Motor core de generación de texto basado en componentes. Implementa el parseo de plantillas `*.v-gen`, evaluación de expresiones y el renderizado contra modelos de datos. Sigue una filosofía de componentes similar a Angular 17.

## Clasificación de Madurez
`maduro-aparente`
- **Justificación:** Código estructurado con patrones claros (Recursive descent parser en `Parser/`), tests presentes (12 suites), documentación detallada en `docs/vgen-engine.md` y actividad reciente (hace 2 días). Uso de C# idiomático.

## Observaciones de Código
- **Parser:** Implementación manual en `vGenParser.cs` (~994 LOC), lo que indica una gramática propia del lenguaje de plantillas vGen.
- **Complejidad:** Alta densidad lógica en `Evaluator.cs` y `vGenEngine.cs`.
- **Incompletitud:** No se detectaron `TODO` explícitos por grep, aunque la arquitectura de herencia de plantillas (`Inheritance/`) parece estar en desarrollo temprano.

## Uso y Dependencias
- **Consumidores internos:** `vGen.Engine.Roslyn`, `vGen.Cli`, `vGen.LanguageServer`.
- **Dependencias externas:** `Microsoft.CodeAnalysis.CSharp` (Roslyn) para análisis/compilación.

## Tests
- **Presencia:** Sí.
- **Conteo:** 12 archivos de test detectados en `test/vGen.Engine.Tests`.
- **Estado verificado:** No ejecutados.
