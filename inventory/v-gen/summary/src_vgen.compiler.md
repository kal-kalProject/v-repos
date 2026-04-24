---
source_repo: v-gen
source_type: clone
source_commit: b7bfd02cc94b7417068e5fd3465225a41b466575
path: src/vGen.Compiler
name: vGen.Compiler
type: proyecto .NET
language: C# (net10.0)
---

# Summary - vGen.Compiler

## Propósito
Compilador específico para los "componentes" C# (archivos `.v-gen.cs`) que actúan como code-behind de las plantillas. Transforma el código C# en assemblies ejecutables en memoria.

## Clasificación de Madurez
`maduro-aparente`
- **Justificación:** Implementa caché de compilación (`CompiledComponentCache.cs`) y gestión de errores detallada (`CompileResult.cs`). Encapsula el uso complejo de `Microsoft.CodeAnalysis.CSharp` (Roslyn) para el resto del sistema.

## Observaciones de Código
- **Especialización:** No compila la plantilla `.v-gen` en sí, sino su lógica acompañante en C#.
- **Rendimiento:** El uso de caché interno sugiere optimización para escenarios de edición frecuente (IDE/Watch).

## Uso y Dependencias
- **Consumidores:** `vGen.Cli`, `vGen.LanguageServer`.
- **Dependencias internas:** `vGen.Engine`.
- **Dependencias externas:** `Microsoft.CodeAnalysis.CSharp`.

## Tests
- **Presencia:** No se detectó una suite de tests dedicada en `test/`, probablemente testeado vía integración en `vGen.Cli.Tests` o `vGen.Integration.Tests`.
- **Estado verificado:** No ejecutados.
