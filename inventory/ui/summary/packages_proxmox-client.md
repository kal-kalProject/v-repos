---
kind: package-summary
repo: ui
package_name: "proxmox-client"
package_path: packages/proxmox-client
language: ts
manifest: package.json
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: experimental
---

## 1. Identidad

| Campo         | Valor                                              |
|---------------|----------------------------------------------------|
| name          | `proxmox-client`                                   |
| version       | 0.0.1                                              |
| directorio    | `packages/proxmox-client`                          |
| type          | module (ESM)                                       |
| private       | no especificado                                    |
| entrypoint    | `dist/index.js`                                    |
| types         | `dist/index.d.ts`                                  |

> **Nota**: nombre sin scope (`proxmox-client`, no `@vortech/proxmox-client`), igual que `llama-client` — patrón consistente para paquetes de infraestructura muy específicos.

## 2. Propósito

### 2.1 Declarado

> "Typed TypeScript client and orchestration recipes for the Proxmox VE API."

### 2.2 Inferido + Evidencia

El paquete provee:

- **Cliente HTTP tipado** para la API REST de Proxmox VE (`ProxmoxClient`).
- **Recursos** tipados para los objetos de Proxmox: clúster, nodos, LXC containers, VMs QEMU, storage, tasks.
- **Recetas de orquestación**: flujos de alto nivel para crear, clonar y gestionar VMs — `cloneUbuntuVm`, `createAiVm`, `createEdgeNode`, `createInferenceVm`, `createProxyLxc`, `ensureVmRunning`.
- **Autenticación dual**: API token (`ProxmoxApiTokenAuth`) y ticket (`ProxmoxTicketAuth`).
- **Servidor Fastify**: gateway HTTP que expone la API de Proxmox con Swagger (`src/main/`).
- **Edge provider**: `createCaddyEdgeProvider` — integración con Caddy como proxy edge.

Evidencia: `packages/proxmox-client/src/index.ts:1-40`.

## 3. Superficie pública

Entry points (campo `exports`):

| Export    | Archivo dist          |
|-----------|-----------------------|
| `.`       | `dist/index.js`       |
| `./main`  | `dist/main.js`        |

Símbolos clave:

| Símbolo                         | Propósito                                        |
|---------------------------------|--------------------------------------------------|
| `ProxmoxClient`                 | Cliente HTTP principal                           |
| `createProxmoxClientFromEnv`    | Factory desde variables de entorno               |
| `ProxmoxClientError`            | Error tipado                                     |
| `ProxmoxClusterResource`        | API de clúster                                   |
| `ProxmoxLxcResource`            | API de LXC containers                            |
| `ProxmoxNodesResource`          | API de nodos                                     |
| `ProxmoxQemuResource`           | API de VMs QEMU                                  |
| `ProxmoxStorageResource`        | API de storage                                   |
| `ProxmoxTasksResource`          | API de tareas asíncronas                         |
| `cloneUbuntuVm`                 | Receta: clonar VM Ubuntu                         |
| `createAiVm`                    | Receta: crear VM para inferencia AI              |
| `createEdgeNode`                | Receta: crear nodo edge                          |
| `createInferenceVm`             | Receta: crear VM de inferencia                   |
| `createProxyLxc`                | Receta: crear LXC proxy                          |
| `ensureVmRunning`               | Receta: garantizar VM en estado running          |
| `createCaddyEdgeProvider`       | Provider edge con Caddy                          |
| `buildServer` / `startServer`   | Arranque del servidor Fastify                    |

## 4. Dependencias

### 4.1 Internas

Ninguna.

### 4.2 Externas

| Paquete               | Versión    | Propósito                                        |
|-----------------------|------------|--------------------------------------------------|
| `fastify`             | ^5.7.4     | HTTP server (gateway)                            |
| `@fastify/swagger`    | ^9.5.1     | Spec OpenAPI                                     |
| `@fastify/swagger-ui` | ^5.2.3     | UI Swagger                                       |
| `dotenv`              | ^17.2.3    | Carga de variables de entorno                    |
| `undici`              | ^7.18.2    | Cliente HTTP nativo Node.js (llamadas a Proxmox) |

## 5. Consumidores internos

No se detectaron dependencias directas desde otros paquetes del workspace. Las recetas (`createAiVm`, `createInferenceVm`) sugieren acoplamiento con `@vortech/ai-server` a nivel de infraestructura, pero no de código.

## 6. Estructura interna

```
packages/proxmox-client/src/
├── auth/         # Tipos y helpers de autenticación (API token, ticket)
├── client/       # ProxmoxClient + factory desde env
├── core/         # Errores, tipos base
├── index.ts      # Barrel público
├── main/         # Servidor Fastify gateway + CLI
├── recipes/      # Flujos de orquestación (clone, create, ensure)
├── resources/    # Recursos tipados (cluster, lxc, nodes, qemu, storage, tasks)
├── scripts/      # edge-smoke.ts — smoke test de edge
└── services/     # Edge provider (Caddy)
```

## 7. Estado

| Campo          | Valor                                                                        |
|----------------|------------------------------------------------------------------------------|
| Madurez        | experimental                                                                 |
| Justificación  | v0.0.1 sin scope, muy específico de infraestructura propia, sin tests configurados |
| Build          | no ejecutado (inventario estático)                                           |
| Tests          | No detectados (`scripts` no incluye `test`)                                 |
| Último cambio  | desconocido (no se accedió a git log)                                        |

## 8. Dominios que toca

- Orquestación de infraestructura (Proxmox VE)
- VMs QEMU / LXC containers
- Infraestructura AI (recetas `createAiVm`, `createInferenceVm`)
- Edge networking (Caddy)
- Automatización DevOps

## 9. Observaciones

- Las recetas revelan el stack de infraestructura de Vortech: Proxmox VE + VMs Ubuntu + LXC proxy + edge Caddy.
- `undici` como cliente HTTP es la opción moderna de Node.js — más eficiente que `node-fetch` o `axios`.
- Script `scripts/edge-smoke.ts` y tarea `smoke:edge` sugieren un entorno de edge activo.
- `createProxmoxServerClientFromEnv` en el export indica que el servidor también puede actuar como cliente de otro servidor Proxmox.

## 10. Hipótesis

- El clúster de Proxmox es la infraestructura física donde se despliegan los LLMs (`createInferenceVm`) y el servidor AI (`@vortech/ai-server`).
- `createEdgeNode` + `createCaddyEdgeProvider` implementan el routing edge para exponer los servicios AI al exterior.
- El gateway Fastify permite controlar Proxmox desde una API REST segura sin exponer la API nativa de Proxmox directamente.

## 11. Preguntas abiertas

1. ¿`undici` hace las llamadas directamente al API de Proxmox VE (HTTPS con certificado self-signed)?
2. ¿El Caddy edge provider es para TLS termination o también para routing de modelos?
3. ¿Las recetas son idempotentes (pueden re-ejecutarse sin crear duplicados)?
4. ¿Existe un cluster Proxmox real en producción o es todo desarrollo local?
