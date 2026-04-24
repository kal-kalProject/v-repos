---
kind: domain-inventory
source_repo: vortech
source_commit: f55e8e0202c3ef2486d845bb87601c7366d76b90
repo: vortech
domain: devtools
inventoried_at: 2026-04-24T20:00:00Z
inventoried_by: cursor-inventario-fase1
implementations_count: 8
languages_involved: [ts]
---

# Dominio — `devtools`

## 1. Definición operativa
Herramientas de desarrollo: CLI, servidores de análisis, extensión VS Code, MCP, SDK, dev-server.

## 2. Implementaciones encontradas

| # | Package | Path | Lenguaje | Madurez | Rol |
|---|---------|------|----------|---------|-----|
| 1 | @vortech/cli | `devtools/cli` | ts | beta | CLI |
| 2 | @vortech/dev-server | `devtools/dev-server` | ts | beta | servidor de desarrollo |
| 3 | @vortech/devtools | `devtools/devtools` | ts | beta | tareas de análisis de deps |
| 4 | @vortech/devtools-sdk | `devtools/devtools-sdk` | ts | beta | SDK |
| 5 | @vortech/mcp | `devtools/mcp` | ts | beta | MCP |
| 6 | vortech-language-server | `devtools/ts-server` | ts | beta | LSP (solapa dominio lsp) |
| 7 | vortech-platform-vscode | `devtools/vscode` | ts | beta | extensión |
| 8 | (incl. scripts raíz) | `package.json` (scripts) | — | — | orquesta `ng serve` etc. |

## 3. Responsabilidades cubiertas
- **Catálogos, generación de exports, análisis** — evidencia: carpetas bajo `devtools/devtools/src/`.

## 4. Contratos y tipos clave
- Cada `package.json` bajo `devtools/` con nombre scope `@vortech/*` o similar.

## 5. Flujos observados
```
Dev → CLI / devtools → madge/ts-prune/typedoc (declarado en `package.json` raíz pnpm)
```

## 6. Duplicaciones internas al repo
- Posible solapamiento “devtools” (meta) vs `devtools-sdk`; Fase 2.

## 7. Observaciones cross-language
- Ninguna.

## 8. Estado global del dominio en este repo
- **Completitud:** rico en entradas; riesgo de complejidad operativa
- **Consistencia interna:** parcial (varios subproductos)

## 9. Sospechas para Fase 2
- Inventariar qué partes de `devtools` son requeridas en CI frente a locales.
