---
kind: package-summary
repo: ui
package_name: "Vortech.Utils.CsvReader"
package_path: dotnet/Vortech.Utils.CsvReader
language: csharp
manifest: Vortech.Utils.CsvReader.csproj
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: experimental
---

## 1. Identidad

- **Nombre publicado:** `Vortech.Utils.CsvReader`
- **Ruta en el repo:** `dotnet/Vortech.Utils.CsvReader`
- **Manifiesto:** `Vortech.Utils.CsvReader.csproj`
- **Lenguaje principal:** C#

## 2. Propósito

Utilidad de lectura de CSV para .NET 10 — librería de clase para leer y parsear archivos CSV en el contexto del ecosistema Vortech. Proporciona una API de lectura de CSV tipada, aprovechando las características de C# moderno (`Nullable` habilitado).

## 3. Superficie pública

- Librería de clase .NET (Class Library).
- API de lectura de CSV: probablemente una clase `CsvReader` o similar con métodos de lectura y mapeo a tipos C#.
- Tipos nullable habilitados — la API es segura ante nulos.
- Target: `net10.0`.

## 4. Dependencias

- Sin dependencias externas detectadas para una utilidad de lectura CSV básica.
- Posiblemente usa solo APIs del BCL (Base Class Library) de .NET: `StreamReader`, `Span<T>`, `System.IO.Pipelines`.
- `Nullable: enable` como configuración del proyecto.

## 5. Consumidores internos

- Posiblemente consumido por otros proyectos .NET del workspace (si los hay más allá de `ScriptingDemo`).
- Puede ser usado por `ScriptingDemo` u otras herramientas .NET de Vortech para leer datos de configuración en CSV.
- Candidato a ser consumido por `kalProject.MsAccess` si hay integración entre los repos del workspace `v-repos`.

## 6. Estructura interna

```
dotnet/Vortech.Utils.CsvReader/
├── Vortech.Utils.CsvReader.csproj
└── (clase(s) de lectura CSV)
```

## 7. Estado

- **Madurez:** experimental
- Librería utilitaria pequeña; el estado experimental puede reflejar que la API no está estabilizada.
- Target `net10.0` (versión preview/futura) — uso consistente con el otro proyecto .NET del directorio.

## 8. Dominios que toca

- **Utilidades .NET** — lectura y parsing de CSV.
- **Datos / Importación** — ingesta de datos desde archivos de texto estructurado.
- **C# / .NET 10** — librería de clase moderna.

## 9. Observaciones

- El hecho de implementar un `CsvReader` propio (vs usar una librería establecida como `CsvHelper`) puede indicar:
  1. Necesidad de una API específica que las librerías existentes no proveen.
  2. Control sobre dependencias (zero-dependency).
  3. Exploración de las nuevas APIs de .NET 10 para procesamiento de texto.
- La convención de nombres `Vortech.Utils.*` sugiere que puede existir o planearse una familia de utilidades bajo este namespace.
- El uso de `Nullable: enable` es una buena práctica de seguridad de tipos en C# moderno.

## 10. Hipótesis

- El `CsvReader` probablemente usa `System.IO.Pipelines` o `Span<T>`/`ReadOnlySpan<T>` de .NET moderno para parsing eficiente sin allocations.
- Puede ser un candidato para publicarse como paquete NuGet si la calidad lo justifica.

## 11. Preguntas abiertas

1. ¿Por qué implementar un CsvReader propio en lugar de usar `CsvHelper` o `Microsoft.VisualBasic.FileIO.TextFieldParser`?
2. ¿Soporta CSV con comillas, escapado, delimitadores personalizados?
3. ¿Hay un proyecto de tests asociado (`Vortech.Utils.CsvReader.Tests`)?
4. ¿Hay plan de publicarlo como paquete NuGet?
