---
kind: package-summary
repo: ui
package_name: "@vortech/dev-server"
package_path: packages/dev-server
language: ts
manifest: package.json
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: experimental
---

# @vortech/dev-server

## 1. Identidad

- **Nombre:** `@vortech/dev-server`
- **Path:** `packages/dev-server`
- **Manifest:** `packages/dev-server/package.json`
- **Descripción en manifest:** no declarada
- **Lenguaje:** TypeScript

## 2. Propósito

### 2.1 Declarado

No hay descripción en `package.json`.

### 2.2 Inferido con Evidencia

Servidor de desarrollo para el ecosistema VTL. Basado en la estructura `src/`:

- `broker/` — broker de mensajes (probable conexión con editor/IDE durante desarrollo)
- `protocol/` — definición del protocolo de comunicación entre cliente y servidor
- `ts-server.ts` — servidor TypeScript (wrapping del servidor de lenguaje TypeScript)
- `cli.ts` — interfaz de línea de comandos para arrancar el servidor
- `index.ts` — punto de entrada del paquete

## 3. Superficie pública

Exports (vía `packages/dev-server/src/index.ts`): superficie pública reducida. Probablemente expone la función de arranque del servidor y tipos de configuración. El uso principal es a través de la CLI (`cli.ts`).

## 4. Dependencias

### 4.1 Internas

- `@vortech/lang` — compilador VTL (para transpilación en tiempo real)
- `@vortech/hosting` — probable uso del `StandaloneBroker`

### 4.2 Externas

No determinado sin instalación de deps. Posible dependencia de `vscode-languageserver` o `typescript`.

## 5. Consumidores internos

- `packages/lang-vscode` — la extensión VS Code puede comunicarse con el dev-server
- Herramientas de desarrollo del workspace

## 6. Estructura interna

```
packages/dev-server/
├── package.json
└── src/
    ├── broker/
    ├── cli.ts
    ├── index.ts
    ├── protocol/
    └── ts-server.ts
```

## 7. Estado

- **Madurez:** experimental
- **Justificación:** Surface pública mínima; propósito de tooling de desarrollo. La presencia de `broker/` tanto aquí como en `@vortech/hosting` sugiere deuda técnica o refactoring pendiente.
- **Build:** no ejecutado
- **Tests:** no detectados
- **Último cambio:** no determinado (requiere `git log`)

## 8. Dominios que toca

- Tooling de desarrollo
- Servidor de lenguaje (LSP / TypeScript server)
- Protocolo de comunicación IDE-servidor
- CLI

## 9. Observaciones

- `ts-server.ts` puede ser un wrapper del TypeScript Language Server que añade soporte para VTL.
- La presencia de `protocol/` sugiere un protocolo propietario (no necesariamente LSP estándar) para la comunicación entre la extensión VS Code y el servidor.
- La duplicación de `broker/` en `@vortech/hosting` y aquí merece revisión de arquitectura.

## 10. Hipótesis (?:)

- ?: El dev-server puede actuar como intermediario entre el compilador VTL y la extensión VS Code, gestionando la caché de compilación y los diagnósticos.
- ?: `protocol/` puede definir mensajes propietarios sobre websockets o IPC.

## 11. Preguntas abiertas

- ¿El dev-server implementa el protocolo LSP completo o un subconjunto propietario?
- ¿Cuál es la diferencia entre el `broker/` de `@vortech/dev-server` y el de `@vortech/hosting`?
- ¿Se distribuye como binario npm (`bin` en `package.json`)?
