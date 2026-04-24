---
kind: package-summary
repo: ui
package_name: "@vortech/devtools"
package_path: projects/devtools
language: ts
manifest: package.json
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: experimental
---

## 1. Identidad

- **Nombre publicado:** `@vortech/devtools`
- **Ruta en el repo:** `projects/devtools`
- **Manifiesto:** `package.json`
- **Lenguaje principal:** TypeScript

## 2. Propósito

Devtools de Vortech — paquete de herramientas de desarrollo que centraliza la configuración del workspace, la integración con servidores MCP (Model Context Protocol) y el análisis de código del proyecto. Funciona como meta-herramienta de soporte al desarrollo del propio ecosistema Vortech.

## 3. Superficie pública

- `index.ts` — punto de entrada principal que reexporta utilidades de devtools.
- `config.ts` — configuración central del workspace de desarrollo.
- `configurtions/` — **nota:** nombre con typo detectado (debería ser `configurations/`); contiene configuraciones específicas.
- `mcp-servers/` — integración y configuración de servidores MCP.
- `workspace/` — utilidades de gestión del workspace.

## 4. Dependencias

- MCP SDK o protocolo Model Context Protocol para comunicación con LLMs.
- Herramientas del workspace (pnpm, scripts de análisis).
- Posiblemente `@devtools/analyzer` para análisis estático de código.
- Dependencias de Node.js/TypeScript para scripting.

## 5. Consumidores internos

- Consumido por el equipo de desarrollo directamente como herramienta de CLI o configuración.
- Los MCP servers en `projects/mcp-servers/` pueden referenciar configuraciones de este paquete.
- `devtools/packages/analyzer` puede ser un sub-paquete de este ecosistema.

## 6. Estructura interna

```
projects/devtools/
├── package.json
└── src/
    ├── index.ts
    ├── config.ts
    ├── configurtions/     ← typo: debería ser "configurations"
    ├── mcp-servers/
    └── workspace/
```

## 7. Estado

- **Madurez:** experimental
- **Typo activo:** el directorio `configurtions/` tiene un error tipográfico que podría dificultar importaciones o búsquedas.
- Paquete de soporte interno; no tiene SLA de estabilidad de API.

## 8. Dominios que toca

- **Developer Tooling** — configuración y gestión del workspace.
- **MCP / IA** — integración con servidores Model Context Protocol.
- **Análisis Estático** — introspección del codebase.

## 9. Observaciones

- El typo `configurtions` (en lugar de `configurations`) es un defecto técnico que debe corregirse para evitar inconsistencias en importaciones y referencias.
- La presencia de `mcp-servers/` dentro de devtools (además de `projects/mcp-servers/`) sugiere que hay dos niveles: configuración de los servers (aquí) y los servers en sí (en `projects/mcp-servers/`).

## 10. Hipótesis

- `@vortech/devtools` actúa como el "meta-paquete" que orquesta todas las herramientas de desarrollo del ecosistema Vortech.
- El módulo `workspace/` puede contener helpers para leer `pnpm-workspace.yaml` y navegar la estructura de proyectos.

## 11. Preguntas abiertas

1. ¿Hay plan de corregir el typo `configurtions/` → `configurations/`?
2. ¿El paquete se ejecuta como CLI, como librería importable o como ambos?
3. ¿Cuál es la relación exacta entre `projects/devtools/src/mcp-servers/` y `projects/mcp-servers/`?
4. ¿`@vortech/devtools` se publica a un registry privado o solo se usa desde el workspace?
