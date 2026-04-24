---
kind: package-summary
repo: ui
package_name: "@vortech/language-server"
package_path: packages/language-server
language: ts
manifest: package.json
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: experimental
---

# @vortech/language-server

## 1. Identidad

- **Nombre:** `@vortech/language-server`
- **Path:** `packages/language-server`
- **Manifest:** `packages/language-server/package.json`
- **Descripción en manifest:** no declarada
- **Lenguaje:** TypeScript

## 2. Propósito

### 2.1 Declarado

No hay descripción en `package.json`.

### 2.2 Inferido con Evidencia

Language Server Protocol (LSP) para el lenguaje VTL. Basado en la estructura `src/`:

- `features/` — implementación de features LSP (hover, completions, diagnostics, go-to-definition, etc.)
- `scanner/` — análisis léxico/tokenización para el servidor de lenguaje
- `plugin.ts` — plugin del servidor TypeScript (TypeScript server plugin)
- `index.ts` — punto de entrada

## 3. Superficie pública

Exports (vía `packages/language-server/src/index.ts`): probablemente expone el plugin TypeScript y las funciones de inicialización del servidor LSP. La surface pública es reducida; el consumidor principal es `packages/lang-vscode`.

## 4. Dependencias

### 4.1 Internas

- `@vortech/lang` — compilador VTL para análisis y diagnósticos
- `@vortech/dev-server` — posible uso del servidor de desarrollo

### 4.2 Externas

Posible dependencia de `vscode-languageserver` / `vscode-languageserver-textdocument`. No determinado sin instalación de deps.

## 5. Consumidores internos

- `packages/lang-vscode` — extensión VS Code que activa este servidor de lenguaje

## 6. Estructura interna

```
packages/language-server/
├── package.json
└── src/
    ├── features/
    ├── index.ts
    ├── plugin.ts
    └── scanner/
```

## 7. Estado

- **Madurez:** experimental
- **Justificación:** Estructura mínima; LSP incompleto (no se conocen las features implementadas sin leer `features/`). La presencia de `scanner/` puede indicar que el análisis léxico está separado del compilador principal (`@vortech/lang`), lo que sugiere implementación parcial o en progreso.
- **Build:** no ejecutado
- **Tests:** no detectados
- **Último cambio:** no determinado (requiere `git log`)

## 8. Dominios que toca

- Language Server Protocol (LSP)
- TypeScript server plugin
- Análisis de código VTL en tiempo real
- Tooling de IDE

## 9. Observaciones

- `plugin.ts` (TypeScript server plugin) y el servidor LSP (`features/`) pueden ser dos mecanismos complementarios: el plugin TS opera dentro del proceso `tsserver`, mientras que el LSP opera como proceso separado.
- `scanner/` sugiere que el servidor de lenguaje hace su propio lexing, posiblemente más rápido que invocar el compilador completo para operaciones como coloración sintáctica.

## 10. Hipótesis (?:)

- ?: `plugin.ts` es el mismo artefacto que `packages/lang/src/ts-plugin.ts` o lo consume.
- ?: `features/` puede implementar solo un subconjunto de LSP: diagnostics y completions básicos.

## 11. Preguntas abiertas

- ¿El servidor LSP corre como proceso separado o embebido en la extensión VS Code?
- ¿`scanner/` comparte código con `packages/lang/src/preprocessor/` o `parser/`?
- ¿Cuántas features LSP están implementadas en `features/`?
