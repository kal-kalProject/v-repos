---
kind: package-summary
repo: ui
package_name: "vc-language-py"
package_path: packages/vc-language-py
language: python
manifest: requirements.txt
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: experimental
---

## 1. Identidad

- **Nombre publicado:** `vc-language-py` (paquete Python)
- **Descripción declarada:** "Experimental Python implementation for comparison with Rust version. Purpose: Evaluate Python vs Rust trade-offs for VCatalyst Language compiler."
- **Ruta en el repo:** `packages/vc-language-py`
- **Manifiesto:** `requirements.txt`
- **Lenguaje principal:** Python

## 2. Propósito

Implementación experimental del compilador VCatalyst Language en Python — sirve como prototipo de referencia para evaluar el trade-off Python vs Rust en la implementación del compilador. Permite iterar rápidamente sobre el diseño del lenguaje antes de comprometerse con la implementación definitiva en Rust (`crates/vc-language`).

## 3. Superficie pública

- `demo.py` — demostración del compilador Python: parsing y análisis de código VCatalyst.
- `src/` — implementación del compilador (lexer, parser, AST, posiblemente análisis semántico).
- `tests/` — suite de tests del compilador Python.
- `examples/` — ejemplos de código en el lenguaje VCatalyst para probar el compilador.

## 4. Dependencias

- `lark-parser` — parser PEG/EBNF para Python (equivalente a `pest` en Rust).
- `pydantic` — validación de datos tipados (posiblemente para el AST o configuración del compilador).
- `pytest` — framework de tests.
- `click` — CLI para el compilador desde línea de comandos.
- `dataclasses-json` — serialización de dataclasses a JSON (posiblemente para el AST).
- `colorama` — salida de color en consola (diagnósticos/errores del compilador).

## 5. Consumidores internos

- No es consumida por otros paquetes; es un prototipo de investigación.
- Su salida informa el diseño de `crates/vc-language` (implementación Rust de producción).
- Los `examples/` pueden migrarse como casos de test a `crates/vc-language`.

## 6. Estructura interna

```
packages/vc-language-py/
├── requirements.txt
├── demo.py
├── src/
│   └── (compilador Python: lexer, parser con Lark, AST, análisis)
├── tests/
│   └── (suite pytest del compilador)
└── examples/
    └── (ejemplos de código VCatalyst)
```

## 7. Estado

- **Madurez:** experimental — **explícitamente declarado como "experimental" en el README del paquete.**
- Propósito declarado de comparación; no es el compilador de producción.
- La implementación Python es más fácil de iterar para explorar el diseño del lenguaje.

## 8. Dominios que toca

- **Compiladores / Lenguajes** — prototipo del compilador VCatalyst en Python.
- **Python / Scripting** — implementación de referencia ágil.
- **Investigación / R&D** — evaluación de trade-offs entre implementaciones.

## 9. Observaciones

- La elección de `lark-parser` (PEG en Python) como equivalente de `pest` (PEG en Rust) indica coherencia en la estrategia de parsing entre ambas implementaciones.
- `colorama` en las dependencias confirma que el compilador produce mensajes de diagnóstico con colores — característica de compiladores modernos (estilo Rust, Clang).
- La estructura `src/ + tests/ + examples/` es más madura de lo esperado en un "prototipo" — sugiere que hay inversión real en esta implementación Python.
- La existencia de tests pytest indica que la corrección del compilador se verifica de forma automatizada.

## 10. Hipótesis

- El proceso de desarrollo es: diseñar en Python → validar con tests → portar a Rust; el Python actúa como spec ejecutable del lenguaje.
- Los `examples/` son el contrato de comportamiento del lenguaje VCatalyst y deben compilar correctamente en ambas implementaciones.
- `dataclasses-json` sugiere que el AST se serializa a JSON, posiblemente para debugging o para comunicación con otras herramientas.

## 11. Preguntas abiertas

1. ¿Qué fases del compilador están implementadas en Python (solo parser, o también semántico y backend)?
2. ¿Los tests pytest se ejecutan contra los mismos `examples/` que se usarán en la implementación Rust?
3. ¿Hay un proceso de sincronización formal entre la implementación Python y la Rust cuando el diseño del lenguaje cambia?
4. ¿Se planea mantener ambas implementaciones a largo plazo o deprecar la Python cuando Rust madure?
