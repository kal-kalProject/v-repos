---
source_repo: v-cam
source_commit: b220eefe852d7b3dc0db141aed3f46126c486db0
domain: wire
implementations_count: 6
languages_involved: [ts, rust, python, csharp]
---

# Dominio — `wire`

## 1. Definición operativa
Define el contrato de intercambio de datos geométricos y de proceso entre los conversores (parsers) y los consumidores (visores/estudios). Se basa en un esquema JSON centralizado conocido como "CAM Neutral IR" (Intermediate Representation).

## 2. Implementaciones encontradas

| # | Package                 | Path                                     | Lenguaje | Madurez       | Rol                           |
|---|-------------------------|------------------------------------------|----------|---------------|-------------------------------|
| 1 | `@v-cam/common`         | `v-cam-ts/common`                        | TS       | maduro-aparente | Core types & interfaces       |
| 2 | `cam-ir-rust`           | `v-converters/ir/rust/cam-ir-rust`       | Rust     | maduro-aparente | Serde models & validation    |
| 3 | `cam-ir-python`         | `v-converters/ir/python/cam-ir-python`   | Python   | maduro-aparente | JSON Schema validation       |
| 4 | `Cam.Ir`                | `v-converters/ir/dotnet/Cam.Ir`          | C#       | maduro-aparente | .NET types & validation      |
| 5 | `cam-ir-ts`             | `v-converters/ir/typescript/cam-ir-ts`   | TS       | maduro-aparente | Schema validation (AJV)      |
| 6 | `cnc-studio` (duplicado)| `cnc-studio/src/app/core/ir`             | TS       | beta          | Local implementation         |

## 3. Responsabilidades cubiertas

- **Definición de Documento IR** → `@v-cam/common`, `cam-ir-rust`, `Cam.Ir`
- **Validación de Esquema (JSON Schema)** → `cam-ir-python`, `cam-ir-ts`, `cam-ir-rust`, `Cam.Ir`
- **Gestión de Versiones de Esquema** → `v-converters/ir/schema/v1.0.0.json`

## 4. Contratos y tipos clave
- `IRDocument` en `@v-cam/common/src/ir/document/ir-document.ts` — Estructura raíz que contiene capas, metadatos y estadísticas.
- `v1.0.0.json` en `v-converters/ir/schema/` — El esquema canónico que rige a todos los lenguajes.

## 5. Flujos observados
```
[DXF File] -> [parser-dxf (Python)] -> [IR JSON] -> [v-converters (Validation)] -> [cnc-studio / viewer (Rendering)]
```

## 6. Duplicaciones internas al repo
- **Detección Crítica:** `cnc-studio/src/app/core/ir` duplica casi íntegramente las interfaces de `@v-cam/common`. No hay evidencia de uso de la librería común en la aplicación principal.

## 7. Observaciones cross-language (si aplica)
- El modelado en Rust (`cam-ir-rust`) es mucho más estricto con los tipos `Result<T,E>` y el manejo de memoria que la implementación en TS.
- La validación en .NET y Python utiliza el archivo .json físico, mientras que en `@v-cam/common` se confía en el tipado de TypeScript.

## 8. Estado global del dominio en este repo
- **Completitud:** completo
- **Consistencia interna:** inconsistente (debido a la duplicación en `cnc-studio`).
- **Justificación:** El formato IR es omnipresente y está bien documentado, pero la implementación TS está fracturada en dos sitios.

## 9. Sospechas para Fase 2
- `?:` La duplicación en `cnc-studio` sugiere una migración incompleta hacia el workspace de pnpm o una divergencia para soportar features experimentales no presentes en `@v-cam/common`.
- `?:` El uso de SHA256 para `id` del documento en Rust debería estandarizarse como el método oficial de "V-ID" (Vortech Identity).
