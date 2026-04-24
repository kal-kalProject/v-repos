---
source_repo: v-gen
source_type: clone
source_commit: b7bfd02cc94b7417068e5fd3465225a41b466575
---

# Domain Inventory - Templating Engine

## Propósito
Núcleo de procesamiento de vGen encargado de transformar plantillas `.v-gen` en texto de salida, gestionando el ciclo de vida del parsing, evaluación de expresiones C# e hilos de herencia.

## Componentes Clave (Evidence pointers)
- **Tokenización:** `src/vGen.Engine/Parser/Tokenizer/vGenTokenizer.cs` — El punto de entrada del stream de caracteres.
- **Parsing:** `src/vGen.Engine/Parser/vGenParser.cs` — Orquestador de la construcción del AST (Abstract Syntax Tree).
- **Modelo de Nodos (AST):** Carpeta `src/vGen.Engine/Parser/Nodes/` — Incluye nodos como `ForNode.cs`, `IfNode.cs`, `IncludeNode.cs`, etc.
- **Evaluador de Expresiones:** `src/vGen.Engine/Evaluation/ExpressionEvaluator.cs` — Ejecuta la lógica C# incrustada.
- **Renderizado:** `src/vGen.Engine/Engine/vGenEngine.cs` — Fachada principal para consumidores externos.
- **Sistema de Herencia:** `src/vGen.Engine/Inheritance/InheritanceGraph.cs` — Gestiona relaciones `extends` y `fill`.

## Observaciones Técnicas
- **Independencia de Roslyn:** El motor base (`vGen.Engine`) parece tener un evaluador manual o ligeras dependencias, mientras que la integración profunda con tipos C# se delega a `vGen.Engine.Roslyn`.
- **Extensibilidad:** Sistema de filtros ajustable vía `FilterRegistry.cs`.
- **Performance:** Implementación de caché de AST en `TemplateCache.cs`.

## Riesgos y Deuda
- **Complejidad del Parser:** El mantenimiento de un parser manual para directivas personalizadas mezcladas con C# requiere suites de tests de regresión extensas.
- **Seguridad:** Uso de `PathValidator.cs` sugiere precaución con los `include/extends` relativos.
