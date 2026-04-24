---
kind: package-summary
repo: ui
package_name: "@vortech/agent-extension"
package_path: ai/agent-extension
language: ts
manifest: package.json
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: experimental
---

## 1. Identidad

- **Nombre de paquete:** `@vortech/agent-extension`
- **Ruta:** `ai/agent-extension/`
- **Manifest:** `ai/agent-extension/package.json`
- **Descripción declarada:** "Local-first coding agent for VS Code — in-process core with React webview"
- **Tipo:** extensión VS Code (TypeScript)

## 2. Propósito

Extensión VS Code que integra el agente IA de Vortech directamente en el editor. Ejecuta el core del agente en proceso (in-process) dentro de VS Code, monta la GUI React como webview en el panel lateral, y actúa como puente entre las APIs de VS Code y el ecosistema `agent-*`. Es el punto de entrada final del sistema de agente para el usuario.

## 3. Superficie pública

La extensión no tiene surface de librería; su "surface" son los comandos y contribuciones VS Code registradas. Archivos fuente clave:

- **`extension.ts`** — punto de entrada de la extensión: función `activate()` y `deactivate()`; registra comandos, monta el webview
- **`extension-messenger.ts`** — puente de mensajería entre la extensión (proceso principal VS Code) y la GUI React (webview)
- **`ide-bridge.ts`** — implementa la interfaz de bridge IDE para `@vortech/agent-server`, usando las APIs de VS Code (workspace, editor, FileSystem)
- **`index.ts`** — re-export o barrel para uso interno
- **`config/`** — gestión de configuración de la extensión (settings de VS Code, contribuciones de `package.json`)

## 4. Dependencias

- `@vortech/agent-core` — instancia el `AgentCore` en proceso dentro de la extensión
- `@vortech/agent-protocol` — tipos de mensajería y sesión para comunicación webview ↔ extensión
- `@vortech/agent-gui` — empaquetado como assets del webview
- `@vortech/agent-service` — consume el store de estado del agente
- `@vortech/agent-tools` — registra herramientas adicionales específicas de VS Code
- `vscode` (API de VS Code, peer dependency)

## 5. Consumidores internos

Ninguno. Es el artefacto final del sub-sistema AI; no es una librería sino el producto deployable.

## 6. Estructura interna

```
ai/agent-extension/
├── package.json         # manifest de extensión VS Code (contribuciones, activation events)
└── src/
    ├── config/              # gestión de settings y configuración de la extensión
    ├── extension.ts         # activate() / deactivate() — punto de entrada VS Code
    ├── extension-messenger.ts  # mensajería webview ↔ extensión
    ├── ide-bridge.ts        # implementación del bridge IDE con APIs de VS Code
    └── index.ts             # barrel interno
```

## 7. Estado

Experimental. La descripción declarada ("local-first coding agent") indica una visión clara del producto. La presencia de `ide-bridge.ts` y `extension-messenger.ts` como archivos separados denota una arquitectura pensada, pero experimental en ejecución.

## 8. Dominios que toca

- Extensión VS Code (extensibility API)
- Integración de agente IA en IDE
- Comunicación webview ↔ extensión (VS Code message passing)
- Bridge entre APIs de VS Code y el sistema de agente

## 9. Observaciones

- "Local-first" en la descripción declarada indica que el agente funciona sin dependencias de servidor externo: todo corre en proceso dentro de VS Code.
- `ide-bridge.ts` es el adaptador que permite al `@vortech/agent-server` usar APIs de VS Code (workspace folders, edit operations, file watching) sin conocer los detalles de la API de VS Code.
- La separación de `extension-messenger.ts` e `ide-bridge.ts` mantiene la comunicación de webview desacoplada del bridge de IDE, lo que facilita testing y reutilización del bridge en el modo standalone.

## 10. Hipótesis

- `extension.ts` probablemente usa `vscode.window.createWebviewPanel()` para montar la GUI React de `@vortech/agent-gui`.
- `extension-messenger.ts` implementa el protocolo `postMessage` de VS Code entre el webview y la extensión, adaptándolo a los tipos de `@vortech/agent-protocol`.
- El `package.json` de la extensión registra comandos como `vortech.agent.start`, `vortech.agent.stop`, `vortech.agent.openPanel`.

## 11. Preguntas abiertas

- ¿La extensión requiere conexión a internet o funciona completamente offline con un modelo local (e.g., Ollama)?
- ¿Hay un `contributes.configuration` en `package.json` para settings de usuario (modelo, política de ejecución)?
- ¿`ide-bridge.ts` es intercambiable con `standalone-ide-bridge.ts` de `@vortech/agent-server` mediante una interfaz común?
- ¿La extensión está publicada en el VS Code Marketplace o solo para uso interno?
