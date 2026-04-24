---
kind: package-summary
repo: ui
package_name: "@vortech/agent-server"
package_path: ai/agent-server
language: ts
manifest: package.json
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: experimental
---

## 1. Identidad

- **Nombre de paquete:** `@vortech/agent-server`
- **Ruta:** `ai/agent-server/`
- **Manifest:** `ai/agent-server/package.json`
- **Tipo:** librería TypeScript (proceso servidor)

## 2. Propósito

Servidor del agente IA de Vortech. Expone el agente al mundo exterior mediante un WebSocket messenger, actúa como puente entre el IDE standalone y el core del agente, gestiona la persistencia de settings y aplica controles de seguridad sobre las comunicaciones entrantes/salientes.

## 3. Superficie pública

Exporta desde `src/index.ts`. Surface inferida:

- **`ws-messenger.ts`** — implementación del WebSocket messenger: serializa/deserializa eventos del protocolo del agente y los retransmite entre clientes (GUI, extensión) y el core
- **`standalone-ide-bridge.ts`** — bridge para uso del agente en modo IDE standalone (sin extensión VS Code activa)
- **`file-settings-store.ts`** — almacenamiento de settings del servidor en disco (configuración persistente)
- **`security/`** — módulo de seguridad: validación de origen, autenticación de conexiones WebSocket, sanitización de mensajes entrantes

## 4. Dependencias

- `@vortech/agent-protocol` — serializa/deserializa tipos del protocolo (eventos, snapshots, sesiones)
- `@vortech/agent-core` — instancia y controla el agente
- Probable: `ws` o `socket.io` (WebSocket server library)

## 5. Consumidores internos

- `@vortech/agent-extension` — puede arrancar el servidor en proceso o comunicarse con él externamente
- `@vortech/agent-gui` — se conecta al WebSocket para recibir eventos y enviar comandos

## 6. Estructura interna

```
ai/agent-server/
├── package.json
└── src/
    ├── security/                  # validación, autenticación, sanitización
    ├── file-settings-store.ts     # persistencia de settings en disco
    ├── standalone-ide-bridge.ts   # bridge para IDE standalone
    ├── ws-messenger.ts            # WebSocket messenger
    └── index.ts                   # barrel exports / punto de entrada del servidor
```

## 7. Estado

Experimental. La presencia de un módulo `security/` indica consciencia de los riesgos de seguridad en la comunicación del agente, pero la madurez experimental sugiere que esos controles aún no han pasado auditoría formal.

## 8. Dominios que toca

- Comunicación WebSocket en tiempo real
- Infraestructura de servidor del agente IA
- Seguridad de comunicaciones (autenticación, validación de origen)
- Persistencia de configuración
- Bridge entre modos de uso (extensión VS Code vs. standalone)

## 9. Observaciones

- La existencia de `standalone-ide-bridge.ts` implica que el agente puede funcionar sin VS Code, probablemente en un modo CLI o con un IDE alternativo.
- El módulo `security/` es una señal positiva de diseño consciente de seguridad en un servidor local que expone capacidades potencialmente destructivas (escritura de archivos, ejecución de herramientas).
- `file-settings-store.ts` sugiere configuración en JSON/YAML persistida en el filesystem, no en memoria.

## 10. Hipótesis

- El servidor probablemente escucha en `localhost` con un puerto configurable para minimizar exposición a red externa.
- `security/` puede incluir validación de tokens o secretos compartidos entre la extensión y el servidor para evitar conexiones no autorizadas.
- `standalone-ide-bridge.ts` puede implementar la misma interfaz que la extensión VS Code usa para comunicarse con el core, permitiendo sustituir VS Code por otro entorno.

## 11. Preguntas abiertas

- ¿El servidor usa TLS para conexiones WebSocket locales?
- ¿Cómo se autentica la extensión VS Code al conectarse al servidor?
- ¿`file-settings-store.ts` persiste en un path fijo o configurable?
- ¿El standalone bridge puede usarse con otros IDEs (JetBrains, Neovim)?
