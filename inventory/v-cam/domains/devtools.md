---
source_repo: v-cam
source_commit: b220eefe852d7b3dc0db141aed3f46126c486db0
domain: devtools
implementations_count: 3
languages_involved: [rust, ts, python]
---

# Dominio — `devtools`

## 1. Definición operativa
Provee herramientas para el desarrollo, depuración y validación de la plataforma CAM. Incluye suites de conformidad, demos de visualización y scripts de generación de datos sintéticos.

## 2. Implementaciones encontradas

| # | Package                 | Path                                     | Lenguaje | Madurez       | Rol                           |
|---|-------------------------|------------------------------------------|----------|---------------|-------------------------------|
| 1 | `conformance-runner`    | `v-converters/ir/conformance-runner`     | Rust     | maduro-aparente | Integration Testing          |
| 2 | `@v-cam/viewer-demo`    | `v-cam-ts/viewer-demo`                   | TS       | experimental  | Visualization Playground     |
| 3 | `cam-parser-dxf` (tests)| `v-converters/parsers/parser-dxf/tests`  | Python   | beta          | Parser verification          |

## 3. Responsabilidades cubiertas

- **Validación de Regresión de Parsers** → `conformance-runner`
- **Validación Visual de IR** → `@v-cam/viewer-demo`
- **Generación de IR sintético** → `@v-cam/viewer-demo/scripts/emit-cotizacion-ir.mjs`

## 4. Contratos y tipos clave
- "Golden Files" en `v-converters/ir/golden/` — Archivos IR de referencia que actúan como contrato de salida esperado para los parsers.

## 5. Flujos observados
```
[conformance-runner] -> [Subprocess: parser-dxf] -> [Compare Output with Golden] -> [Report Success/Fail]
```

## 6. Duplicaciones internas al repo
- Ninguna significativa. El dominio está bien distribuido por lenguaje.

## 7. Observaciones cross-language (si aplica)
- `conformance-runner` (Rust) es el orquestador que garantiza que el código Python (`parser-dxf`) sea correcto.

## 8. Estado global del dominio en este repo
- **Completitud:** completo
- **Consistencia interna:** consistente
- **Justificación:** Existe una cultura de "conformidad" clara en el repo, con carpetas dedicadas a archivos "golden".

## 9. Sospechas para Fase 2
- `?:` El sistema de "Golden Files" podría extenderse para validar no solo JSON, sino también capturas de pantalla del renderizado en `viewer-demo`.
