---
source_repo: v-rust
source_commit: dfb2bdc3ace105d04d66c6439bd2aa8818919629
kind: domain-inventory
repo: v-rust
domain: devtools
inventoried_at: 2026-04-24T16:20:00Z
inventoried_by: cursor-agent
implementations_count: 3
languages_involved: [typescript, angular]
---

# Dominio — `devtools`

## 1. Definición operativa
Herramientas de edición/IDE: extensiones de VS Code y workspace Angular (cliente) para Vortech y TTM.

## 2. Implementaciones encontradas
| # | Package | Path | Lenguaje | Madurez | Rol |
|---|---------|------|----------|---------|-----|
| 1 | ng-workspace | `ng-workspace` | TypeScript, Angular | maduro-aparente | `ng-workspace/package.json:1` (Angular 21) |
| 2 | vscode-vortech | `editors/vscode-vortech` | TypeScript (Node) | maduro-aparente | `editors/vscode-vortech/package.json:1` |
| 3 | vscode-ttm | `editors/vscode-ttm` | TypeScript (Node) | maduro-aparente | `editors/vscode-ttm/package.json:1` |

## 3. Responsabilidades cubiertas
- **Interfaz web** (ng-workspace) y **extensiones** para conectar a servicios del monorepo (LSP, wire, etc., por confirmar en Fase 2).

## 4. Contratos y tipos clave
- Extensiones VS Code: ver `package.json` contribs / activation events en Fase 2 (no requerido estáticamente aquí).

## 5. Flujos observados
```
Desarrollador → VS Code / navegador → invocación de herramientas o backend del monorepo
```

## 6. Duplicaciones internas al repo
- Dos extensiones (Vortech vs TTM) pueden compartir utilidades; sin evidencia de paquete compartido en Fase 1.

## 7. Observaciones cross-language
- Conecta capa **TS/Node** con dominios **LSP** y **codegen TTM** (Rust) vía integración; no resuelto estáticamente.

## 8. Estado global del dominio en este repo
- **Completitud:** parcial (herramientas presentes, integración a backend no verificada).
- **Consistencia interna:** coherente con ecosistema VS Code/Angular.
- **Justificación:** tres manifest `package.json` bajo `ng-workspace` y `editors/`.

## 9. Sospechas para Fase 2
- `?:` Reutilizar paquetes internos para evitar duplicar lógica de protocolo de editor entre `vscode-ttm` y `vscode-vortech`.
