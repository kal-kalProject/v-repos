---
kind: domain-inventory
source_repo: vortech
source_commit: f55e8e0202c3ef2486d845bb87601c7366d76b90
repo: vortech
domain: lsp
inventoried_at: 2026-04-24T20:00:00Z
inventoried_by: cursor-inventario-fase1
implementations_count: 2
languages_involved: [ts]
---

# Dominio — `lsp`

## 1. Definición operativa
Lenguaje y protocolo LSP: paquetes `platform/v-lsp` (LSP) y `devtools/ts-server` (`vortech-language-server` en `package.json`).

## 2. Implementaciones encontradas

| # | Package | Path | Lenguaje | Madurez | Rol |
|---|---------|------|----------|---------|-----|
| 1 | @vortech/lsp | `platform/v-lsp` | ts | beta | núcleo LSP |
| 2 | vortech-language-server | `devtools/ts-server` | ts | beta | servidor lenguaje |

## 3. Responsabilidades cubiertas
- **Protocolo y tooling editor** — enlazado a extensión `devtools/vscode`.

## 4. Contratos y tipos clave
- `platform/v-lsp/src`, `devtools/ts-server/src` (nombres a validar con listado de directorio).

## 5. Flujos observados
```
VS Code ext → language server → v-lsp (inferido)
```

## 6. Duplicaciones internas al repo
- Dos paquetes con vocación LSP; no se demostró superposición de código sin lectura detallada.

## 7. Observaciones cross-language
- Ninguna.

## 8. Estado global del dominio en este repo
- **Completitud:** parcial
- **Consistencia interna:** desconocida sin análisis de exports cruzados

## 9. Sospechas para Fase 2
- Documentar protocolo y versión soportada de LSP en un solo lugar.
