---
kind: package-summary
repo: ui
package_name: "ai-workspace-root"
package_path: ai
language: ts
manifest: package.json
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: indeterminado
---

## 1. Identidad

- **Nombre de paquete:** ai-workspace-root (workspace root, sin nombre npm propio)
- **Ruta:** `ai/`
- **Manifest:** `ai/package.json`
- **Tipo:** pnpm sub-workspace root

## 2. Propósito

Raíz del sub-workspace pnpm que agrupa todos los paquetes del sistema de agente IA (`agent-*`). No contiene lógica propia de negocio; su función es declarar los workspaces miembros y centralizar scripts de arranque compartidos del sub-sistema AI.

## 3. Superficie pública

Ninguna. No exporta símbolos propios. Actúa exclusivamente como punto de entrada para la gestión de dependencias y scripts del sub-workspace.

## 4. Dependencias

- Hereda la configuración del workspace raíz de `ui/`.
- Los paquetes miembro (`agent-core`, `agent-protocol`, `agent-models`, `agent-runtime`, `agent-server`, `agent-service`, `agent-tools`, `agent-memory`, `agent-indexer`, `agent-gui`, `agent-extension`) se declaran como workspaces hijos.

## 5. Consumidores internos

Ninguno directo. Los consumidores referencian los sub-paquetes `@vortech/agent-*` individualmente.

## 6. Estructura interna

```
ai/
├── package.json          # declara workspaces: ["agent-*"]
├── agent-core/
├── agent-protocol/
├── agent-models/
├── agent-runtime/
├── agent-server/
├── agent-service/
├── agent-tools/
├── agent-memory/
├── agent-indexer/
├── agent-gui/
└── agent-extension/
```

## 7. Estado

Sin versión npm publicable. Sirve como scaffolding de organización para el sub-sistema AI. No contiene tests propios ni lógica que pueda fallar.

## 8. Dominios que toca

- Gestión de monorepo / workspace
- Infraestructura de agente IA (indirectamente, como contenedor)

## 9. Observaciones

- El hecho de separar el sub-workspace `ai/` del root principal sugiere intención de aislar las dependencias pesadas del agente del resto de la UI.
- No tiene lógica propia; cualquier análisis funcional debe dirigirse a los sub-paquetes `agent-*`.

## 10. Hipótesis

- Es probable que `ai/` tenga su propio `pnpm-lock.yaml` o use el lock del workspace raíz mediante `shared-workspace-lockfile`.
- Podría haberse separado para facilitar un despliegue independiente del backend AI sin arrastrar dependencias Angular.

## 11. Preguntas abiertas

- ¿El sub-workspace `ai/` comparte el lockfile con el root `ui/` o tiene uno propio?
- ¿Existen scripts en `ai/package.json` para arrancar todos los `agent-*` en paralelo?
- ¿Hay CI separado para este sub-workspace?
