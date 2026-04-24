---
kind: package-summary
source_repo: kalProject.MsAccess
source_commit: a778b34a5adc8f184f0a73be194466036100a127
repo: kalProject.MsAccess
package_name: kalproject-nodejs-client
package_path: Clients/nodejs-client
language: javascript
manifest: package.json
inventoried_at: 2026-04-24T20:00:00Z
inventoried_by: cursor-inventario-fase1
madurez: beta
---

# kalproject-nodejs-client

## 1. Identidad

- **Path:** `Clients/nodejs-client`
- **Lenguaje:** JavaScript (Node.js)
- **Versión declarativa:** 0.1.0 en `package.json:2`
- **Publicado:** no (uso interno; sin campo `private` forzado en el fragmento leído)

## 2. Propósito

### 2.1 Declarado

`package.json:4` descripción: cliente WebSocket para la plataforma en tiempo real

### 2.2 Inferido

Provee `KalProjectClient` con reconexión, topics y manejo de peticiones, sobre la librería `ws` (declarada en el manifest, sin `node_modules` instalado en el clon).

**Evidencia:**

- `Clients/nodejs-client/package.json:12-14` — `dependencies: { "ws": "^8.18.0" }`
- `Clients/nodejs-client/client.js:8-18` — constructor con nombre/versión de cliente
- `Clients/nodejs-client/client.js:23-25` — `this.ws = new WebSocket(this.endpoint);`

## 3. Superficie pública

- Módulo que exporta (según estructura) el cliente; punto de prueba: script `package.json:7` (`node client.js`)

## 4. Dependencias

### 4.1 Internas

- Ninguna a otros paquetes del repositorio (JS puro, sin `workspace` npm)

### 4.2 Externas

- `ws@^8.18.0` (declarada; resolución no verificada sin `node_modules`)

## 5. Consumidores internos

- Operador humano vía `npm` si instala; no se referencia en proyectos C#

## 6. Estructura interna

```
Clients/nodejs-client/
├── package.json
└── client.js
```

## 7. Estado

- **Madurez:** `beta` (código estructurado, sin pruebas listadas, sin `package-lock` en clon; `.gitignore` puede omitir el lock, ver `README.md:59-60` a nivel repositorio)
- **Build:** no ejecutado
- **Tests:** 0 (sin `*.test.js` bajo búsqueda de nombre)

## 8. Dominios

- `wire` — WebSocket
- (puente) con el servidor bajo el mismo esquema que `kalProject.Client`

## 9. Observaciones

`client.js:2` carga de `uuid` o `randomUUID` condicional: revisar compatibilidad con versiones mínimas de Node (no verificada en Fase 1)

## 10. Hipótesis

- `?:` el handshake y frames JSON siguen un contrato común con `kalProject.Common` en el host C#

## 11. Preguntas abiertas

- Alineación exacta con el payload del servidor: comparación cruzada en Fase 2
