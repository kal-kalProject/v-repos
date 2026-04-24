---
kind: domain-inventory
source_repo: vortech
source_commit: f55e8e0202c3ef2486d845bb87601c7366d76b90
repo: vortech
domain: di
inventoried_at: 2026-04-24T20:00:00Z
inventoried_by: cursor-inventario-fase1
implementations_count: 4
languages_involved: [ts]
---

# Dominio — `di`

## 1. Definición operativa
Inyección de dependencias, árboles de scopes e integración con hosting: `platform/core` (tests `di/`), `packages/hosting`, `platform/di-demo`.

## 2. Implementaciones encontradas

| # | Package | Path | Lenguaje | Madurez | Rol |
|---|---------|------|----------|---------|-----|
| 1 | v-core / plataforma | `platform/core` | ts | maduro-aparente | DI, tests extensos |
| 2 | di-demo | `platform/di-demo` | ts | maduro-aparente | demostración |
| 3 | @vortech/hosting | `packages/hosting` | ts | maduro-aparente | integración servidor |
| 4 | @vortech/core | `packages/core` | ts | maduro-aparente | middleware / builder |

## 3. Responsabilidades cubiertas

- **Scope tree / injector** → `platform/core/tests/di/*`
- **Decoradores y builders** → `platform/core/tests/builders/*`

## 4. Contratos y tipos clave

- Patrones documentados bajo `platform/core/propuestas/*` y `.doc` local (muchos `.md` de diseño).

## 5. Flujos observados

```
Componente → @vortech/core ApplicationBuilder → hosting → pipeline DI (inferido)
```

## 6. Duplicaciones internas al repo

- **platform/core vs packages/core**: ambos tocan “core” y DI; requieren análisis de fronteras (Fase 2).

## 7. Observaciones cross-language
- Ninguna en este dominio (solo TypeScript en el snapshot).

## 8. Estado global del dominio en este repo
- **Completitud:** parcial a rica (muchos tests).
- **Consistencia interna:** riesgo de solapamiento package `platform/core` y `packages/core`.
- **Justificación:** densidad de archivos `platform/core/tests/di/*`.

## 9. Sospechas para Fase 2
- `?:` Consolidar `packages/core` y `platform/core` bajo un único mapa de dependencias.
