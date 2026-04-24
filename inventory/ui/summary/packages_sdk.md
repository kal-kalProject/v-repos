---
kind: package-summary
repo: ui
package_name: "@vortech/sdk"
package_path: packages/sdk
language: ts
manifest: package.json
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: beta
---

# @vortech/sdk

## 1. Identidad

- **Nombre:** `@vortech/sdk`
- **Path:** `packages/sdk`
- **Manifest:** `packages/sdk/package.json`
- **Descripción en manifest:** no declarada
- **Lenguaje:** TypeScript

## 2. Propósito

### 2.1 Declarado

No hay descripción en `package.json`.

### 2.2 Inferido con Evidencia

SDK de manipulación y análisis de código fuente TypeScript/VTL. La API de exports (nodos AST: `AbstractableNode`, `ArrayBindingPattern`, `ArrowFunction`, `Block`, `CallExpression`, etc.) es análoga a la de `ts-morph`, una librería para trabajar con el AST de TypeScript de forma programática. La estructura interna indica:

- `compiler/` — integración con el compilador TypeScript
- `manipulation/` — transformación de nodos AST
- `structures/` — estructuras de datos de nodos (tipos inmutables)
- `structurePrinters/` — serialización de estructuras a texto
- `factories/` — factories de nodos AST
- `types.ts` / `typings.ts` — tipos públicos
- `Project.ts` / `project-context.ts` — gestión de proyectos TypeScript
- `fileSystem/` — abstracción del sistema de archivos (virtual FS para tests)
- `build-tools/` — herramientas de build integradas
- `devtools/` — integración con herramientas de desarrollo
- `vscode/` — integración con VS Code
- `code-block-writer.ts` — escritura de bloques de código con indentación
- `options/` — opciones de configuración
- `utils/` — utilidades internas
- `common/` — código compartido

## 3. Superficie pública

Exports representativos (vía `packages/sdk/src/index.ts`):

| Símbolo | Categoría |
|---|---|
| `AbstractableNode` | Nodo AST base |
| `ArrayBindingPattern` | Nodo: destructuring de array |
| `ArrowFunction` | Nodo: función flecha |
| `Block` | Nodo: bloque de código |
| `CallExpression` | Nodo: llamada a función |
| `Project` | Gestión de proyecto TypeScript |
| (muchos más nodos AST) | — |

## 4. Dependencias

### 4.1 Internas

Probable dependencia de `@vortech/lang` (compilador VTL) y `@vortech/utils`.

### 4.2 Externas

Posible dependencia de `typescript` (compilador) y posiblemente `code-block-writer`. No determinado sin instalación de deps.

## 5. Consumidores internos

- `packages/lang` — posiblemente usa el SDK para generar código de salida
- `packages/lang-vscode` — extensión VS Code
- `packages/language-server` — servidor de lenguaje

## 6. Estructura interna

```
packages/sdk/
├── package.json
└── src/
    ├── build-tools/
    ├── code-block-writer.ts
    ├── common/
    ├── compiler/
    ├── devtools/
    ├── factories/
    ├── fileSystem/
    ├── index.ts
    ├── manipulation/
    ├── options/
    ├── Project.ts
    ├── project-context.ts
    ├── structurePrinters/
    ├── structures/
    ├── types.ts
    ├── typings.ts
    ├── utils/
    └── vscode/
```

## 7. Estado

- **Madurez:** beta
- **Justificación:** API AST muy completa con múltiples categorías de nodos, similar en alcance a `ts-morph`. Presencia de `fileSystem/` (virtual FS) indica diseño para testabilidad. Integración con VS Code y devtools implementada.
- **Build:** no ejecutado
- **Tests:** no detectados directamente
- **Último cambio:** no determinado (requiere `git log`)

## 8. Dominios que toca

- Manipulación de AST TypeScript
- Code generation / code transformation
- Herramientas de desarrollo (VS Code, LSP)
- Sistema de archivos virtual

## 9. Observaciones

- La similitud con `ts-morph` es marcada: `Project`, `factories`, `structurePrinters`, `fileSystem` son patrones idénticos. Puede ser un fork, un wrapper o una reimplementación.
- `code-block-writer.ts` como archivo standalone sugiere que puede ser una versión integrada de la librería `code-block-writer` de npm.
- `vscode/` dentro del SDK sugiere que las funcionalidades del SDK están adaptadas para el contexto de extensiones VS Code.

## 10. Hipótesis (?:)

- ?: `@vortech/sdk` puede ser un fork o reescritura de `ts-morph` adaptado para soportar VTL además de TypeScript puro.
- ?: `build-tools/` puede exponer APIs para integrar el SDK en pipelines de build (webpack/rollup plugins).

## 11. Preguntas abiertas

- ¿`@vortech/sdk` es un wrapper de `ts-morph` o una reimplementación independiente?
- ¿`Project.ts` usa la API `ts.Program` del compilador TypeScript directamente?
- ¿`fileSystem/` tiene una implementación en memoria para tests unitarios?
