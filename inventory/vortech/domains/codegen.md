---
kind: domain-inventory
source_repo: vortech
source_commit: f55e8e0202c3ef2486d845bb87601c7366d76b90
repo: vortech
domain: codegen
inventoried_at: 2026-04-24T20:00:00Z
inventoried_by: cursor-inventario-fase1
implementations_count: 3
languages_involved: [ts]
---

# Dominio — `codegen`

## 1. Definición operativa
Motor y demos de plantillas, análisis de código: `packages/templates`, `packages/template-demo`, `packages/code-analysis`.

## 2. Implementaciones encontradas

| # | Package | Path | Lenguaje | Madurez | Rol |
|---|---------|------|----------|---------|-----|
| 1 | @vortech/templates | `packages/templates` | ts | maduro-aparente | engine de templates |
| 2 | @vortech/template-demo | `packages/template-demo` | ts | maduro-aparente | demostración |
| 3 | @vortech/code-analysis | `packages/code-analysis` | ts | maduro-aparente | análisis estático |

## 3. Responsabilidades cubiertas
- **Generación / evaluación de plantillas, pipelines de carga (loaders)**, y tooling de análisis — evidencia: `packages/templates/tests/*`, `platform/v-api-factory` (dominio adyacente).

## 4. Contratos y tipos clave
- Tests en `packages/templates/tests/engine/*`

## 5. Flujos observados
```
Template provider → engine → runtime de aplicación
```

## 6. Duplicaciones internas al repo
- `code-analysis` podría solapar `devtools` (analyzers) — Fase 2

## 7. Observaciones cross-language
- Ninguna.

## 8. Estado global del dominio en este repo
- **Completitud:** mediana (tests y carpetas de propuestas en `.vortech/doc`)
- **Consistencia interna:** a validar

## 9. Sospechas para Fase 2
- Relacionar con `v-api-factory` para operaciones y plantillas de API (dos vertientes de “definición programática”).
