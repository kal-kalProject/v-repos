---
kind: package-summary
repo: ui
package_name: "vortech-vscode"
package_path: packages/vscode
language: ts
manifest: package.json
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: beta
---

## 1. Identidad

| Campo         | Valor                                                     |
|---------------|-----------------------------------------------------------|
| name          | `vortech-vscode`                                          |
| displayName   | `Vortech DevTools`                                        |
| version       | 0.0.1                                                     |
| directorio    | `packages/vscode`                                         |
| publisher     | `vortech`                                                 |
| license       | MIT                                                       |
| engine VS Code| ^1.95.0                                                   |
| entrypoint    | `dist/extension.js`                                       |
| tipo          | Extensión de Visual Studio Code                           |

## 2. Propósito

### 2.1 Declarado

> "Diagnostics, conventions analysis, and code actions for Vortech Platform projects — powered by @vortech/sdk"

### 2.2 Inferido + Evidencia

Extensión VS Code que integra el análisis estático de código Vortech directamente en el editor:

- **Diagnósticos**: análisis de archivos TypeScript/JavaScript con múltiples engines (`babel`, `language-service`, `ts-morph`).
- **Análisis de convenciones**: detecta violaciones de convenciones del platform Vortech.
- **Code actions**: acciones de corrección automática sobre diagnósticos.
- **Export provider**: `export-action-provider.ts` — acciones sobre exports.
- **File name analyzer**: `file-name-adapter.ts` — convenciones de nombrado de archivos.
- **Dev server**: `dev-server-client.ts`, `dev-server-launcher.ts`, `dev-server-tree.ts` — integración con el dev server de Vortech directamente en el panel lateral de VS Code.
- **TypeScript server plugins**: integra `@vortech/language-server` y `@vortech/dev-server/ts-server` como plugins del servidor TypeScript de VS Code.

Evidencia: `packages/vscode/package.json` — `contributes`, `typescriptServerPlugins`, `activationEvents`, `configuration`.

## 3. Superficie pública

### Contribution points VS Code

**Comandos** (5):

| Command                       | Título                              |
|-------------------------------|-------------------------------------|
| `vortech.analyzeFile`         | Vortech: Analyze Current File       |
| `vortech.analyzeWorkspace`    | Vortech: Analyze Workspace          |
| `vortech.clearCache`          | Vortech: Clear Analysis Cache       |
| `vortech.showReport`          | Vortech: Show Analysis Report       |
| `vortech.toggleGroupMode`     | Vortech: Toggle Group Mode          |

**Views** (en activity bar "Vortech DevTools"):

| View ID                 | Nombre           |
|-------------------------|------------------|
| `vortechDiagnostics`    | Diagnostics      |
| `vortechDevServer`      | DevServer        |

**TypeScript Server Plugins** (2):

| Plugin                          | Función                                      |
|---------------------------------|----------------------------------------------|
| `@vortech/language-server`      | Análisis estático en tiempo real en el editor|
| `@vortech/dev-server/ts-server` | Dev server integrado en TS server            |

**Activation events**: `onLanguage:typescript`, `onLanguage:typescriptreact`, `onLanguage:javascript`, `onLanguage:javascriptreact`.

### Settings configurables

| Setting                           | Tipo     | Default      | Propósito                                     |
|-----------------------------------|----------|--------------|-----------------------------------------------|
| `vortech.enable`                  | boolean  | true         | Habilitar/deshabilitar diagnósticos           |
| `vortech.engines`                 | string[] | `["babel"]`  | Engines de análisis activos                   |
| `vortech.severity.error`          | string[] | `[]`         | Códigos de diagnóstico → error                |
| `vortech.severity.warning`        | string[] | `[]`         | Códigos de diagnóstico → warning              |
| `vortech.severity.off`            | string[] | `[]`         | Códigos de diagnóstico desactivados           |
| `vortech.analyzeOnSave`           | boolean  | true         | Re-analizar al guardar                        |
| `vortech.analyzeOnType`           | boolean  | false        | Re-analizar al escribir (con debounce)        |
| `vortech.debounceMs`              | number   | 500          | Debounce para on-type analysis                |
| `vortech.fileName.namingConvention`| string  | `kebab-case` | Convención de nombrado (kebab/camel/Pascal/snake) |
| `vortech.fileName.severity`       | string   | `warning`    | Severidad de diagnósticos de nombre de archivo|
| `vortech.fileName.fixMode`        | string   | `suggest`    | Cómo aplicar correcciones (fix-on-save/confirm/suggest) |
| `vortech.fileName.updateRelatedFiles`| boolean| true        | Actualizar archivos relacionados al renombrar |

## 4. Dependencias

### 4.1 Internas

| Paquete                    | Tipo    | Propósito                                       |
|----------------------------|---------|-------------------------------------------------|
| `@vortech/apis`            | runtime | APIs base de la plataforma                      |
| `@vortech/dev-server`      | runtime | Dev server de Vortech (cliente + tree view)     |
| `@vortech/language-server` | runtime | Servidor de lenguaje para análisis estático     |
| `@vortech/sdk`             | runtime | SDK de análisis del platform Vortech            |

### 4.2 Externas

| Paquete      | Versión   | Propósito                              |
|--------------|-----------|----------------------------------------|
| `ws`         | ^8.19.0   | WebSocket client para dev-server-client|
| `typescript` | >=5.0.0   | peerDep — TypeScript del workspace     |

## 5. Consumidores internos

Esta extensión **no es consumida** por otros paquetes — es el producto final de consumo para desarrolladores de proyectos Vortech.

## 6. Estructura interna

```
packages/vscode/src/
├── code-action-adapter.ts      # Adaptador de code actions
├── code-action-provider.ts     # Provider de VS Code code actions
├── commands.ts                 # Registro de comandos
├── dev-server-client.ts        # Cliente WebSocket al dev server
├── dev-server-launcher.ts      # Lanzamiento del dev server
├── dev-server-tree.ts          # Tree view del dev server en panel
├── diagnostics-adapter.ts      # Adaptador diagnósticos SDK → VS Code
├── export-action-provider.ts   # Code actions para exports
├── extension.ts                # Entry point de la extensión
├── file-name-adapter.ts        # Análisis de convenciones de nombre
└── [otros archivos]            # (src/ no inspeccionado completamente)
```

Scripts:
- `package`: `npx @vscode/vsce package --no-dependencies` → genera `.vsix`
- `install:ext`: `code --install-extension vortech-vscode-0.0.1.vsix` → instala localmente

## 7. Estado

| Campo          | Valor                                                                                     |
|----------------|-------------------------------------------------------------------------------------------|
| Madurez        | beta                                                                                      |
| Justificación  | Extensión bien estructurada con settings detallados, múltiples engines de análisis, integración completa (views + commands + TS plugins + code actions), soporte para empaquetado `.vsix` |
| Build          | no ejecutado (inventario estático)                                                        |
| Tests          | No detectados (`scripts` no incluye `test`)                                              |
| Último cambio  | desconocido (no se accedió a git log)                                                     |

## 8. Dominios que toca

- Extensibilidad VS Code
- Análisis estático de código TypeScript
- Convenciones de plataforma (diagnósticos, naming)
- Integración con dev server de Vortech
- TypeScript Language Service plugins

## 9. Observaciones

- Es el único paquete del inventario con madurez **beta** — la riqueza de contribution points y la configuración detallada de settings indican una extensión lista para uso interno.
- Los tres engines (`babel`, `language-service`, `ts-morph`) dan flexibilidad: `babel` para velocidad, `language-service` para precisión semántica, `ts-morph` para análisis de AST profundo.
- El uso de `ws` (no socket.io) indica que el dev-server-client usa WebSocket nativo — diferente del protocolo de `@vortech/ai-server` que usa socket.io.
- El flag `--no-dependencies` en el empaquetado `.vsix` implica que las dependencias internas deben estar bundleadas en `dist/extension.js` por tsup.
- `categories: ["Linters", "Programming Languages"]` — publicada en el Marketplace con estas categorías.

## 10. Hipótesis

- `@vortech/sdk` es el motor principal de análisis — contiene la lógica de diagnósticos que `vortech-vscode` consume como adaptador.
- El `@vortech/language-server` plugin permite que los diagnósticos aparezcan inline en el editor sin necesidad de ejecutar análisis manual.
- `dev-server-tree.ts` muestra el árbol de features/módulos activos en el dev server — permite navegación visual de la arquitectura de la aplicación.
- `vortech.analyzeOnType` con debounce sugiere un análisis incremental eficiente.

## 11. Preguntas abiertas

1. ¿`@vortech/sdk` está inventariado? ¿Es el paquete más importante del workspace?
2. ¿Los diagnósticos de `babel` engine son más rápidos pero menos precisos que los de `language-service`?
3. ¿El dev server panel muestra el árbol de `@vortech/app` (features, services) en tiempo real?
4. ¿La extensión funciona con workspaces multi-root o solo con un único folder?
5. ¿Está publicada en el VS Code Marketplace o es solo de uso interno?
