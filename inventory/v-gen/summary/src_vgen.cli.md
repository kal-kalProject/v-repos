---
source_repo: v-gen
source_type: clone
source_commit: b7bfd02cc94b7417068e5fd3465225a41b466575
path: src/vGen.Cli
name: vGen.Cli
type: proyecto .NET
language: C# (net10.0)
---

# Summary - vGen.Cli

## Propósito
Herramienta de línea de comandos (`dotnet tool`) para interactuar con el ecosistema vGen. Permite renderizar plantillas desde la terminal, crear scaffolds de componentes, y lanzar el servidor de lenguaje.

## Clasificación de Madurez
`maduro-aparente`
- **Justificación:** Configurada como `PackAsTool` con comando `vgen`. Implementa múltiples subcomandos (`CliRenderContext.cs`, `Commands/`). Orquestador principal que integra todos los módulos del repo. Actividad reciente.

## Observaciones de Código
- **Funcionalidad:** Incluye lógica de compilación dinámica (`CsprojCompilationLoader.cs`) para cargar componentes C# asociados a plantillas.
- **Interconectividad:** Depende de prácticamente todos los demás proyectos del workspace.

## Uso y Dependencias
- **Consumidores:** Usuario final (developer), scripts de CI/CD.
- **Dependencias internas:** `vGen.Engine`, `vGen.Engine.Roslyn`, `vGen.Compiler`, `vGen.LanguageServer`.

## Tests
- **Presencia:** Sí.
- **Conteo:** 1 suite de tests detectada en `test/vGen.Cli.Tests` y una suite de tests de integración en `test/vGen.Integration.Tests`.
- **Estado verificado:** No ejecutados.
