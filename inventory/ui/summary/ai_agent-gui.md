---
kind: package-summary
repo: ui
package_name: "@vortech/agent-gui"
package_path: ai/agent-gui
language: ts
manifest: package.json
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: experimental
---

## 1. Identidad

- **Nombre de paquete:** `@vortech/agent-gui`
- **Ruta:** `ai/agent-gui/`
- **Manifest:** `ai/agent-gui/package.json`
- **Tipo:** librería TypeScript — aplicación React/TSX (webview)

## 2. Propósito

Interfaz gráfica (GUI) del agente IA de Vortech, implementada como una aplicación React para webview. Se renderiza dentro del panel de la extensión VS Code o en un navegador standalone. Permite al usuario interactuar con el agente: ver el historial de conversación, revisar planes y propuestas de cambios, aprobar o rechazar acciones, y configurar el agente.

## 3. Superficie pública

Es una aplicación React (no una librería); su "surface pública" es el webview en sí. Componentes y páginas inferidos:

- **`App.tsx`** — componente raíz de la aplicación React
- **`main.tsx`** — punto de entrada: monta `<App />` en el DOM del webview
- **`components/`** — componentes React de la GUI (chat, plan viewer, diff viewer, etc.)
- **`pages/`** — páginas de la aplicación (chat principal, configuración, historial)
- **`messenger/`** — cliente del protocolo de mensajería — se comunica con `@vortech/agent-server` vía WebSocket o vía la API de mensajería de la extensión VS Code

## 4. Dependencias

- `@vortech/agent-protocol` — tipos de eventos, snapshots y sesiones para renderizado
- `@vortech/agent-service` — consume el store de estado del agente
- Probable: React, React DOM
- Posible: `@vortech/ui` o `@vortech/ui-core` para componentes UI de Vortech

## 5. Consumidores internos

- `@vortech/agent-extension` — empaqueta la GUI como webview de la extensión VS Code

## 6. Estructura interna

```
ai/agent-gui/
├── package.json
└── src/
    ├── App.tsx            # componente raíz React
    ├── main.tsx           # punto de entrada (mount)
    ├── components/        # componentes de la GUI
    ├── pages/             # páginas de la aplicación
    └── messenger/         # cliente de comunicación con el servidor del agente
```

## 7. Estado

Experimental. Es una aplicación React completa con estructura de páginas y componentes, lo que indica un nivel de desarrollo mayor que un stub. Sin embargo, la madurez experimental sugiere que la UX está en iteración activa.

## 8. Dominios que toca

- Interfaz de usuario para agente IA
- React / webview development
- Comunicación cliente-servidor en tiempo real (WebSocket)
- Visualización de planes, diffs y herramientas del agente

## 9. Observaciones

- El directorio `messenger/` dentro de la GUI indica que la GUI gestiona su propia conexión al servidor del agente, en lugar de delegar toda la comunicación a la extensión.
- La presencia de `pages/` sugiere una navegación multi-pantalla (e.g., chat principal, configuración, historial de sesiones).
- Al ser una aplicación React (TSX), el lenguaje efectivo es TypeScript con JSX, aunque el manifest declara `ts`.

## 10. Hipótesis

- `messenger/` implementa un cliente WebSocket que se conecta al `ws-messenger.ts` de `@vortech/agent-server`.
- Los componentes en `components/` pueden incluir: `ChatMessage`, `PlanViewer`, `DiffViewer`, `ToolCallCard`, `ApprovalDialog`.
- La GUI puede estar construida con Vite como bundler, compatible con el ecosistema del monorepo.

## 11. Preguntas abiertas

- ¿La GUI usa componentes de `@vortech/ui` (Angular) o componentes React propios?
- ¿Hay soporte para modo oscuro/claro integrado con el tema de VS Code?
- ¿El `messenger/` de la GUI usa el mismo protocolo que `@vortech/agent-protocol` o tiene una capa de adaptación?
- ¿La GUI puede ejecutarse como aplicación web standalone fuera de VS Code?
