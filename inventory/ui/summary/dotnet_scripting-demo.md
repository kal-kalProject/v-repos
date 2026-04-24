---
kind: package-summary
repo: ui
package_name: "ScriptingDemo"
package_path: dotnet/scripting-demo
language: csharp
manifest: ScriptingDemo.csproj
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: experimental
---

## 1. Identidad

- **Nombre publicado:** `ScriptingDemo` (proyecto .NET)
- **Ruta en el repo:** `dotnet/scripting-demo`
- **Manifiesto:** `ScriptingDemo.csproj`
- **Lenguaje principal:** C#

## 2. Propósito

Demo de scripting .NET con motor V8 (ClearScript) — prototipo que embebe el motor JavaScript V8 de Google dentro de una aplicación .NET 10 para ejecutar código JavaScript y TypeScript desde C#. Evalúa la viabilidad de usar ClearScript como motor de scripting extensible en aplicaciones .NET de Vortech.

## 3. Superficie pública

- No tiene API pública exportada; es una aplicación ejecutable de demostración.
- Punto de entrada: `Program.cs` (aplicación de consola .NET).
- Ejecuta scripts JS/TS via el motor V8 embebido.

## 4. Dependencias

- `Microsoft.ClearScript.V8 7.4.*` — binding .NET para el motor V8 de Chrome/Node.
- `Microsoft.ClearScript.V8.Native.win-x64` — binarios nativos de V8 para Windows x64.
- Target framework: `net10.0` (versión preview de .NET).
- `LangVersion: preview` — usa características de C# en preview.
- `Nullable: enable` — tipos nullable habilitados.

## 5. Consumidores internos

- No es consumida por otros paquetes; es un artefacto de investigación/demo.
- Informa la decisión de adoptar ClearScript como motor de scripting en apps .NET de Vortech.
- Relacionado conceptualmente con `rust-ts-runtime` (mismo problema, diferente stack).

## 6. Estructura interna

```
dotnet/scripting-demo/
├── ScriptingDemo.csproj
└── (Program.cs y scripts de demo)
```

## 7. Estado

- **Madurez:** experimental (demo de concepto)
- Usa `.NET 10` con `LangVersion: preview` — tecnologías en preview activo, no para producción.
- Solo binarios para `win-x64`; sin soporte multi-plataforma en esta demo.

## 8. Dominios que toca

- **Scripting / Extensibilidad** — motor JS/V8 embebido en .NET.
- **.NET / C#** — aplicación de consola con motor de scripting.
- **Interoperabilidad JS-.NET** — puente entre código JavaScript y C#.

## 9. Observaciones

- ClearScript con V8 es la solución más completa para embeber JS en .NET (V8 completo, soporte TypeScript via transpilación), pero tiene un footprint pesado (los binarios nativos de V8 son grandes).
- El uso de `.NET 10` (versión futura/preview en la fecha de inventario) indica que el proyecto sigue las últimas versiones de .NET.
- La dependencia `win-x64` exclusiva limita la portabilidad; en producción se necesitarían paquetes para otras plataformas.
- Paralelo conceptual interesante: `rust-ts-runtime` usa QuickJS (ligero), `ScriptingDemo` usa V8 (completo) — evaluación de dos extremos del espectro de motores JS.

## 10. Hipótesis

- La motivación puede ser habilitar scripting extensible por usuarios en una app .NET de Vortech (ej. scripts de automatización en CNC, reglas de negocio configurables en Studio).
- ClearScript puede ser la solución elegida si el ecosistema Vortech necesita un motor JS más completo que QuickJS para el lado .NET.

## 11. Preguntas abiertas

1. ¿Qué problema concreto de Vortech motiva explorar scripting JS en .NET?
2. ¿ClearScript comparte casos de uso con `rust-ts-runtime` o son para stacks diferentes?
3. ¿Se considera agregar soporte para Linux/macOS (paquetes nativos adicionales de V8)?
4. ¿El target `net10.0` indica que `.NET 10` ya está en uso activo en el equipo o es exploración?
