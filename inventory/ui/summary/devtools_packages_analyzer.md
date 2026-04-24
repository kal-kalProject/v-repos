---
kind: package-summary
repo: ui
package_name: "@devtools/analyzer"
package_path: devtools/packages/analyzer
language: ts
manifest: package.json
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: experimental
---

## 1. Identidad

- **Nombre publicado:** `@devtools/analyzer`
- **Ruta en el repo:** `devtools/packages/analyzer`
- **Manifiesto:** `package.json`
- **Lenguaje principal:** TypeScript

## 2. Propósito

Analizador de código para el ecosistema de devtools de Vortech — provee tipos compartidos (`types.d.ts`) y lógica de análisis estático del codebase. Diseñado para ser consumido por herramientas de developer experience que necesiten introspección del código TypeScript/Angular del workspace.

## 3. Superficie pública

- `index.ts` — punto de entrada que expone la API del analizador.
- `types.d.ts` — definiciones de tipos públicas para consumidores del analizador.
- Surface mínima: dos ficheros de entrada indican un paquete muy focalizado o en etapa inicial.

## 4. Dependencias

- TypeScript Compiler API (`typescript` package) para análisis estático de código.
- Posiblemente `@vortech/devtools` como paquete padre del ecosistema.
- Sin dependencias de runtime pesadas esperadas dado el perfil de analizador estático.

## 5. Consumidores internos

- `projects/devtools` (`@vortech/devtools`) — el paquete devtools principal puede usar el analyzer para introspección.
- `projects/mcp-servers/vortech-common` o `vortech-docs` — los MCP servers pueden usar el analyzer para responder preguntas sobre el codebase.

## 6. Estructura interna

```
devtools/packages/analyzer/
├── package.json
└── src/
    ├── index.ts
    └── types.d.ts
```

## 7. Estado

- **Madurez:** experimental
- **Surface mínima:** solo dos ficheros en `src/` indica que está en fase muy inicial o que es deliberadamente minimalista.
- Sin suite de tests detectada en la información disponible.

## 8. Dominios que toca

- **Análisis Estático** — introspección y análisis del código TypeScript.
- **Developer Tooling** — soporte a herramientas de desarrollo.
- **Metaprogramación** — lectura y comprensión del propio codebase.

## 9. Observaciones

- La existencia de `types.d.ts` como fichero separado de `index.ts` sugiere que los tipos se exportan de forma independiente de la implementación — patrón útil para consumidores que solo necesitan los tipos sin la lógica.
- La surface mínima puede ser intencional (principio de mínima superficie pública) o puede reflejar estado de desarrollo temprano.

## 10. Hipótesis

- `@devtools/analyzer` probablemente usa el TypeScript Compiler API para extraer información de tipos, importaciones y exports del workspace.
- Puede ser el componente que alimenta a los MCP servers con contexto del codebase para que los LLMs puedan responder preguntas sobre el código.

## 11. Preguntas abiertas

1. ¿El analyzer usa el TypeScript Compiler API, ts-morph, o una solución propia?
2. ¿Qué tipos de análisis soporta: dependencias, exports, tipos, complejidad ciclomática?
3. ¿`types.d.ts` es la interfaz pública que los consumidores deben implementar o son tipos de utilidad?
4. ¿Hay planes de ampliar la surface pública o se mantiene deliberadamente mínima?
